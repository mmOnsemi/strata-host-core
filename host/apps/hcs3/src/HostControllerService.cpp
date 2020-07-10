#include "HostControllerService.h"
#include "HCS_Client.h"
#include "StorageManager.h"
#include "ReplicatorCredentials.h"
#include "logging/LoggingQtCategories.h"

#include <rapidjson/document.h>
#include <rapidjson/stringbuffer.h>
#include <rapidjson/writer.h>

#include <QJsonObject>
#include <QJsonDocument>
#include <QJsonArray>

#include <QStandardPaths>
#include <QFile>
#include <QDir>
#include <QDebug>


HostControllerService::HostControllerService(QObject* parent) : QObject(parent)
    , dbLogAdapter_("strata.hcs.database")
    , clientsLogAdapter_("strata.hcs.clients")
    , db_(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation).toStdString())
{
    //handlers for 'cmd'
    clientCmdHandler_.insert( { std::string("request_hcs_status"), std::bind(&HostControllerService::onCmdHCSStatus, this, std::placeholders::_1) });
    clientCmdHandler_.insert( { std::string("unregister"), std::bind(&HostControllerService::onCmdUnregisterClient, this, std::placeholders::_1) } );
    clientCmdHandler_.insert( { std::string("platform_select"), std::bind(&HostControllerService::onCmdPlatformSelect, this, std::placeholders::_1) } );

    hostCmdHandler_.insert( { std::string("disconnect_platform"), std::bind(&HostControllerService::onCmdHostDisconnectPlatform, this, std::placeholders::_1) });
    hostCmdHandler_.insert( { std::string("download_files"), std::bind(&HostControllerService::onCmdHostDownloadFiles, this, std::placeholders::_1) });
    hostCmdHandler_.insert( { std::string("dynamic_platform_list"), std::bind(&HostControllerService::onCmdDynamicPlatformList, this, std::placeholders::_1) } );
}

HostControllerService::~HostControllerService()
{
    stop();
    delete storageManager_;
}

bool HostControllerService::initialize(const QString& config)
{
    if (parseConfig(config) == false) {
        return false;
    }

    db_.setLogAdapter(&dbLogAdapter_);
    clients_.setLogAdapter(&clientsLogAdapter_);

    dispatcher_.setMsgHandler(std::bind(&HostControllerService::handleMessage, this, std::placeholders::_1) );

    rapidjson::Value& db_cfg = config_["database"];

    if (!db_.open("strata_db")) {
        qCCritical(logCategoryHcs) << "Failed to open database.";
        return false;
    }

    // TODO: Will resolved in SCT-517
    //db_.addReplChannel("platform_list");

    storageManager_ = new StorageManager(this);

    connect(storageManager_, &StorageManager::downloadPlatformFilePathChanged, this, &HostControllerService::sendDownloadPlatformFilePathChangedMessage);
    connect(storageManager_, &StorageManager::downloadPlatformSingleFileProgress, this, &HostControllerService::sendDownloadPlatformSingleFileProgressMessage);
    connect(storageManager_, &StorageManager::downloadPlatformSingleFileFinished, this, &HostControllerService::sendDownloadPlatformSingleFileFinishedMessage);
    connect(storageManager_, &StorageManager::downloadPlatformFilesFinished, this, &HostControllerService::sendDownloadPlatformFilesFinishedMessage);
    connect(storageManager_, &StorageManager::platformListResponseRequested, this, &HostControllerService::sendPlatformListMessage);
    connect(storageManager_, &StorageManager::downloadPlatformDocumentsProgress, this, &HostControllerService::sendPlatformDocumentsProgressMessage);
    connect(storageManager_, &StorageManager::platformDocumentsResponseRequested, this, &HostControllerService::sendPlatformDocumentsMessage);

    /* We dont want to call these StorageManager methods directly
     * as they should be executed in the main thread. Not in dispatcher's thread. */
    connect(this, &HostControllerService::platformListRequested, storageManager_, &StorageManager::requestPlatformList, Qt::QueuedConnection);
    connect(this, &HostControllerService::platformDocumentsRequested, storageManager_, &StorageManager::requestPlatformDocuments, Qt::QueuedConnection);
    connect(this, &HostControllerService::downloadPlatformFilesRequested, storageManager_, &StorageManager::requestDownloadPlatformFiles, Qt::QueuedConnection);
    connect(this, &HostControllerService::cancelPlatformDocumentRequested, storageManager_, &StorageManager::requestCancelAllDownloads, Qt::QueuedConnection);

    connect(&boards_, &BoardController::boardConnected, this, &HostControllerService::platformConnected);
    connect(&boards_, &BoardController::boardDisconnected, this, &HostControllerService::platformDisconnected);
    connect(&boards_, &BoardController::boardMessage, this, &HostControllerService::sendMessageToClients);

    QUrl baseUrl = QString::fromStdString(db_cfg["file_server"].GetString());

    qCInfo(logCategoryHcs) << "file_server url:" << baseUrl.toString();

    if (baseUrl.isValid() == false) {
        qCCritical(logCategoryHcs) << "Provided file_server url is not valid";
        return false;
    }

    if (baseUrl.scheme().isEmpty()) {
        qCCritical(logCategoryHcs) << "file_server url does not have scheme";
        return false;
    }

    storageManager_->setBaseUrl(baseUrl);
    storageManager_->setDatabase(&db_);

    db_.initReplicator(db_cfg["gateway_sync"].GetString(), replicator_username, replicator_password);

    boards_.initialize();

    rapidjson::Value& hcs_cfg = config_["host_controller_service"];

    clients_.initialize(&dispatcher_, hcs_cfg);
    return true;
}

void HostControllerService::start()
{
    if (dispatcherThread_.get_id() != std::thread::id()) {
        return;
    }

    dispatcherThread_ = std::thread(&HCS_Dispatcher::dispatch, &dispatcher_);

    qCInfo(logCategoryHcs) << "Host controller service started.";
}

void HostControllerService::stop()
{
    if (dispatcherThread_.get_id() == std::thread::id()) {
        return;
    }

    dispatcher_.stop();

    dispatcherThread_.join();
    qCInfo(logCategoryHcs) << "Host controller service stoped.";
}

void HostControllerService::onAboutToQuit()
{
    stop();
}

void HostControllerService::sendDownloadPlatformFilePathChangedMessage(
        const QByteArray &clientId,
        const QString &originalFilePath,
        const QString &effectiveFilePath)
{
    QJsonDocument doc;
    QJsonObject message;
    QJsonObject payload;

    payload.insert("type", "download_platform_filepath_changed");
    payload.insert("original_filepath", originalFilePath);
    payload.insert("effective_filepath", effectiveFilePath);

    message.insert("hcs::notification", payload);

    doc.setObject(message);

    clients_.sendMessage(clientId, doc.toJson(QJsonDocument::Compact));
}

void HostControllerService::sendDownloadPlatformSingleFileProgressMessage(
        const QByteArray &clientId,
        const QString &filePath,
        qint64 bytesReceived,
        qint64 bytesTotal)
{
    QJsonDocument doc;
    QJsonObject message;
    QJsonObject payload;

    payload.insert("type", "download_platform_single_file_progress");
    payload.insert("filepath", filePath);
    payload.insert("bytes_received", bytesReceived);
    payload.insert("bytes_total", bytesTotal);

    message.insert("hcs::notification", payload);

    doc.setObject(message);

    clients_.sendMessage(clientId, doc.toJson(QJsonDocument::Compact));
}

void HostControllerService::sendDownloadPlatformSingleFileFinishedMessage(
        const QByteArray &clientId,
        const QString &filePath,
        const QString &errorString)
{
    QJsonDocument doc;
    QJsonObject message;
    QJsonObject payload;

    payload.insert("type", "download_platform_single_file_finished");
    payload.insert("filepath", filePath);
    payload.insert("error_string", errorString);

    message.insert("hcs::notification", payload);

    doc.setObject(message);

    clients_.sendMessage(clientId, doc.toJson(QJsonDocument::Compact));
}

void HostControllerService::sendDownloadPlatformFilesFinishedMessage(const QByteArray &clientId, const QString &errorString)
{
    QJsonDocument doc;
    QJsonObject message;
    QJsonObject payload;

    payload.insert("type", "download_platform_files_finished");
    if (errorString.isEmpty() == false) {
        payload.insert("error_string", errorString);
    }

    message.insert("hcs::notification", payload);

    doc.setObject(message);

    clients_.sendMessage(clientId, doc.toJson(QJsonDocument::Compact));
}

void HostControllerService::sendPlatformListMessage(
        const QByteArray &clientId,
        const QJsonArray &platformList)
{
    QJsonDocument doc;
    QJsonObject message;
    QJsonObject payload;

    payload.insert("type", "all_platforms");
    payload.insert("list", platformList);

    message.insert("hcs::notification", payload);
    doc.setObject(message);

    clients_.sendMessage(clientId, doc.toJson(QJsonDocument::Compact));
}

void HostControllerService::sendPlatformDocumentsProgressMessage(
        const QByteArray &clientId,
        const QString &classId,
        int filesCompleted,
        int filesTotal)
{
    QJsonDocument doc;
    QJsonObject message;
    QJsonObject payload;

    payload.insert("type", "document_progress");
    payload.insert("class_id", classId);
    payload.insert("files_completed", filesCompleted);
    payload.insert("files_total", filesTotal);

    message.insert("cloud::notification", payload);
    doc.setObject(message);

    clients_.sendMessage(clientId, doc.toJson(QJsonDocument::Compact));
}

void HostControllerService::sendPlatformDocumentsMessage(
        const QByteArray &clientId,
        const QString &classId,
        const QJsonArray &documentList,
        const QString &error)
{
    QJsonDocument doc;
    QJsonObject message;
    QJsonObject payload;

    payload.insert("type", "document");
    payload.insert("class_id", classId);

    if (error.isEmpty()) {
        payload.insert("documents", documentList);
    } else {
        payload.insert("error", error);
    }

    message.insert("cloud::notification", payload);
    doc.setObject(message);

    clients_.sendMessage(clientId, doc.toJson(QJsonDocument::Compact));
}

bool HostControllerService::parseConfig(const QString& config)
{
    QString filePath;
    if (config.isEmpty()) {
        filePath  = QDir(QStandardPaths::writableLocation(QStandardPaths::AppConfigLocation)).filePath("hcs.config");
    }
    else {
        filePath = config;
    }

    QFile file(filePath);
    if (file.open(QIODevice::ReadOnly) == false) {
        qCCritical(logCategoryHcs) << "Unable to open config file:" << filePath;
        return false;
    }

    QByteArray data = file.readAll();
    file.close();

    rapidjson::Document configuration;
    if (configuration.Parse<rapidjson::kParseCommentsFlag>(data.data()).HasParseError()) {
        qCCritical(logCategoryHcs) << "Parse error on config file!";
        return false;
    }

    if( ! configuration.HasMember("host_controller_service") ) {
        qCCritical(logCategoryHcs) << "ERROR: No Host Controller Configuration parameters.";
        return false;
    }

    config_ = std::move(configuration);
    return true;
}

void HostControllerService::handleMessage(const PlatformMessage& msg)
{
    switch(msg.msg_type)
    {
        case PlatformMessage::eMsgClientMessage:                handleClientMsg(msg); break;

        default:
            assert(false);
            break;
    }
}

void HostControllerService::platformConnected(const QString &classId, const QString &platformId)
{
    Q_UNUSED(platformId)

    if (classId.isEmpty()) {
        qCWarning(logCategoryHcs) << "Connected platform doesn't have class Id.";
        return;
    }

    //send update to all clients
    broadcastMessage(boards_.createPlatformsList());
}

void HostControllerService::platformDisconnected(const QString &classId, const QString &platformId)
{
    Q_UNUSED(classId)
    Q_UNUSED(platformId)

    //send update to all clients
    broadcastMessage(boards_.createPlatformsList());
}

void HostControllerService::sendMessageToClients(const QString &platformId, const QString &message)
{
    Q_UNUSED(platformId)
    HCS_Client* client = getSenderClient();
    if (client != nullptr) {
        clients_.sendMessage(client->getClientId(), message);
    }
}

// clients handler...
void HostControllerService::onCmdHCSStatus(const rapidjson::Value* )
{
    HCS_Client* client = getSenderClient();
    Q_ASSERT(client);

    rapidjson::Document doc;
    doc.SetObject();
    doc.AddMember("hcs::notification", "hcs_active", doc.GetAllocator() );

    rapidjson::StringBuffer strbuf;
    rapidjson::Writer<rapidjson::StringBuffer> writer(strbuf);
    doc.Accept(writer);

    clients_.sendMessage(client->getClientId(), strbuf.GetString() );
}

void HostControllerService::onCmdDynamicPlatformList(const rapidjson::Value * )
{
    emit platformListRequested(getSenderClient()->getClientId());
}

void HostControllerService::onCmdUnregisterClient(const rapidjson::Value* )
{
    HCS_Client* client = getSenderClient();
    Q_ASSERT(client);

    qCWarning(logCategoryHcs) << "Deprecated command: \"cmd\":\"unregister\", use \"hcs::cmd\":\"unregister\" instead.";
    onCmdHostUnregister(nullptr);
}

void HostControllerService::onCmdPlatformSelect(const rapidjson::Value* payload)
{
    HCS_Client* client = getSenderClient();
    if (client == nullptr) {
        qCCritical(logCategoryHcs) << "sender client is missing";
        return;
    }

    if (!payload->HasMember("class_id")) {
        qCCritical(logCategoryHcs) << "class_id key is missing";
        return;
    }

    QString classId = QString::fromStdString((*payload)["class_id"].GetString());
    if (classId.isEmpty()) {
        qCCritical(logCategoryHcs) << "class_id is empty";
        return;
    }

    QByteArray clientId = client->getClientId();
    emit platformDocumentsRequested(clientId, classId);
}

void HostControllerService::onCmdHostDisconnectPlatform(const rapidjson::Value* payload)
{
    if (!payload->HasMember("device_id")) {
        qCCritical(logCategoryHcs) << "device_id key is missing";
        return;
    }
    int device_id = (*payload)["device_id"].GetInt();
    boards_.clearClientId(device_id);
}

void HostControllerService::onCmdHostUnregister(const rapidjson::Value* )
{
    HCS_Client* client = getSenderClient();
    Q_ASSERT(client);

    QByteArray clientId = client->getClientId();

    boards_.clearClientIdFromAllDevices(clientId);
    emit cancelPlatformDocumentRequested(clientId);

    // Remove the client from the mapping
    current_client_ = nullptr;
    clientList_.remove(client);
    qCInfo(logCategoryHcs) << "Client unregistered: " << clientId.toHex();
}

void HostControllerService::onCmdHostDownloadFiles(const rapidjson::Value* payload)
{
    QByteArray clientId = getSenderClient()->getClientId();
    QStringList partialUriList;

    QString destinationDir = QString::fromStdString((*payload)["destination_dir"].GetString());
    if (destinationDir.isEmpty()) {
        qCWarning(logCategoryHcs) << "destinationDir attribute is empty";
        return;
    }

    const rapidjson::Value& files = (*payload)["files"];
    if (files.IsArray() == false) {
        qCWarning(logCategoryHcs) << "files attribute is not an array";
        return;
    }

    for (auto it = files.Begin(); it != files.End(); ++it) {
        partialUriList << QString::fromStdString((*it).GetString());
    }

    emit downloadPlatformFilesRequested(clientId, partialUriList, destinationDir);
}

HCS_Client* HostControllerService::getClientById(const QByteArray& client_id)
{
    auto findIt = std::find_if(clientList_.begin(), clientList_.end(),
                               [&](HCS_Client* val) { return client_id == val->getClientId(); }  );

    return (findIt != clientList_.end()) ? *findIt : nullptr;
}

void HostControllerService::handleClientMsg(const PlatformMessage& msg)
{
    QByteArray clientId = msg.from_client;

    //check the client's ID (dealer_id) is in list
    HCS_Client* client = getClientById(clientId);
    if (client == nullptr) {
        qCInfo(logCategoryHcs) << "new Client:" << clientId.toHex();

        client = new HCS_Client(clientId);
        clientList_.push_back(client);
    }

    current_client_ = client;

    rapidjson::Document service_command;
    if (service_command.Parse(msg.message.c_str()).HasParseError()) {
        qCWarning(logCategoryHcs) << "Client:" << clientId.toHex() << "parse error!";
        return;
    }

    auto firstIt = service_command.MemberBegin();
    std::string msg_type = firstIt->name.GetString();

    rapidjson::Value* payload = nullptr;
    if (service_command.HasMember("payload")) {
        payload = &(service_command["payload"]);
    }

    if (service_command.HasMember("device_id")) {
        if (service_command["device_id"].IsInt() == false) {
            qCCritical(logCategoryHcs) << "device_id is not integer";
            return;
        }

        boards_.sendMessage(service_command["device_id"].GetInt(), QByteArray::fromStdString(msg.message));
        return;
    }

    std::string cmd_name = firstIt->value.GetString();
    qCInfo(logCategoryHcs) << "Client:" << clientId.toHex() << "Type:" << QString::fromStdString(msg_type) << "cmd:" << QString::fromStdString(cmd_name);

    if (msg_type == "hcs::cmd") {

        auto findIt = hostCmdHandler_.find(cmd_name);
        if (findIt == hostCmdHandler_.end()) {
            //TODO: error handling...
            qCWarning(logCategoryHcs) << "Unhandled command" <<  "Client:" << clientId.toHex() << "Type:" << QString::fromStdString(msg_type) << "cmd:" << QString::fromStdString(cmd_name);
            return;
        }

        findIt->second(payload);
    }
    else if (msg_type == "cmd") {

        auto findIt = clientCmdHandler_.find(cmd_name);
        if (findIt == clientCmdHandler_.end()) {
            qCWarning(logCategoryHcs) << "Unhandled command" <<  "Client:" << clientId.toHex() << "Type:" << QString::fromStdString(msg_type) << "cmd:" << QString::fromStdString(cmd_name);
            return;
        }

        findIt->second(payload);
    }
    else {
        qCWarning(logCategoryHcs) << "Unhandled command type" <<  "Client:" << clientId.toHex() << "Type:" << QString::fromStdString(msg_type) << "cmd:" << QString::fromStdString(cmd_name);
        return;
    }
}

bool HostControllerService::broadcastMessage(const QString& message)
{
    qCInfo(logCategoryHcs) << "broadcast msg:" << message;
    for(auto item : clientList_) {
        QByteArray clientId = item->getClientId();
        clients_.sendMessage(clientId, message);
    }

    return false;
}

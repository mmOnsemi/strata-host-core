#include "HostControllerService.h"
#include "Client.h"
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

#include <functional>


HostControllerService::HostControllerService(QObject* parent)
    : QObject(parent),
      downloadManager_(&networkManager_),
      storageManager_(&downloadManager_)
{
}

HostControllerService::~HostControllerService()
{
    stop();
}

bool HostControllerService::initialize(const QString& config)
{
    if (parseConfig(config) == false) {
        return false;
    }

    // TODO: update config_ to use use QJson instead.
    rapidjson::Value& hcs_cfg = config_["host_controller_service"];

    if (hcs_cfg.HasMember("subscriber_address") == false) {
        return false;
    }

    strataServer_ = std::make_shared<strata::strataRPC::StrataServer>(hcs_cfg["subscriber_address"].GetString(), true, this);

    QString baseFolder{QStandardPaths::writableLocation(QStandardPaths::AppDataLocation)};
    if (config_.HasMember("stage")) {
        rapidjson::Value &devStage = config_["stage"];
        if (devStage.IsString()) {
            std::string stage(devStage.GetString(), devStage.GetStringLength());
            std::transform(stage.begin(), stage.end(), stage.begin(), ::toupper);
            qCInfo(logCategoryHcs, "Running in %s setup", qUtf8Printable(stage.data()));
            baseFolder += QString("/%1").arg(qUtf8Printable(stage.data()));
            QDir baseFolderDir{baseFolder};
            if (baseFolderDir.exists() == false) {
                qCDebug(logCategoryHcs) << "Creating base folder" << baseFolder << "-" << baseFolderDir.mkpath(baseFolder);
            }
        }
    }

    storageManager_.setBaseFolder(baseFolder);

    rapidjson::Value& db_cfg = config_["database"];

    if (db_.open(baseFolder, "strata_db") == false) {
        qCCritical(logCategoryHcs) << "Failed to open database.";
        return false;
    }

    // TODO: Will resolved in SCT-517
    //db_.addReplChannel("platform_list");

    // Register handlers in strataServer_
    strataServer_->registerHandler("request_hcs_status", std::bind(&HostControllerService::processCmdRequestHcsStatus, this, std::placeholders::_1));
    strataServer_->registerHandler("load_documents", std::bind(&HostControllerService::processCmdLoadDocuments, this, std::placeholders::_1));
    strataServer_->registerHandler("download_files", std::bind(&HostControllerService::processCmdDownloadFiles, this, std::placeholders::_1));
    strataServer_->registerHandler("dynamic_platform_list", std::bind(&HostControllerService::processCmdDynamicPlatformList, this, std::placeholders::_1));
    strataServer_->registerHandler("update_firmware", std::bind(&HostControllerService::processCmdUpdateFirmware, this, std::placeholders::_1));
    strataServer_->registerHandler("download_view", std::bind(&HostControllerService::processCmdDownlodView, this, std::placeholders::_1));

    connect(&storageManager_, &StorageManager::downloadPlatformFilePathChanged, this, &HostControllerService::sendDownloadPlatformFilePathChangedMessage);
    connect(&storageManager_, &StorageManager::downloadPlatformSingleFileProgress, this, &HostControllerService::sendDownloadPlatformSingleFileProgressMessage);
    connect(&storageManager_, &StorageManager::downloadPlatformSingleFileFinished, this, &HostControllerService::sendDownloadPlatformSingleFileFinishedMessage);
    connect(&storageManager_, &StorageManager::downloadPlatformFilesFinished, this, &HostControllerService::sendDownloadPlatformFilesFinishedMessage);
    connect(&storageManager_, &StorageManager::platformListResponseRequested, this, &HostControllerService::sendPlatformListMessage);
    connect(&storageManager_, &StorageManager::downloadPlatformDocumentsProgress, this, &HostControllerService::sendPlatformDocumentsProgressMessage);
    connect(&storageManager_, &StorageManager::platformDocumentsResponseRequested, this, &HostControllerService::sendPlatformDocumentsMessage);
    connect(&storageManager_, &StorageManager::downloadControlViewFinished, this, &HostControllerService::sendDownloadControlViewFinishedMessage);
    connect(&storageManager_, &StorageManager::downloadControlViewProgress, this, &HostControllerService::sendControlViewDownloadProgressMessage);
    connect(&storageManager_, &StorageManager::platformMetaData, this, &HostControllerService::sendPlatformMetaData);

    connect(&platformController_, &PlatformController::platformConnected, this, &HostControllerService::platformConnected);
    connect(&platformController_, &PlatformController::platformDisconnected, this, &HostControllerService::platformDisconnected);
    connect(&platformController_, &PlatformController::platformMessage, this, &HostControllerService::sendMessageToClients);

    connect(&updateController_, &FirmwareUpdateController::progressOfUpdate, this, &HostControllerService::handleUpdateProgress);

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

    storageManager_.setBaseUrl(baseUrl);
    storageManager_.setDatabase(&db_);

    db_.initReplicator(db_cfg["gateway_sync"].GetString(), 
        std::string(ReplicatorCredentials::replicator_username).c_str(),
        std::string(ReplicatorCredentials::replicator_password).c_str());

    platformController_.initialize();

    updateController_.initialize(&platformController_, &downloadManager_);

    return true;
}

void HostControllerService::start()
{
    strataServer_->initialize();    // TODO: handle failure signal!
    qCInfo(logCategoryHcs) << "Host controller service started.";
}

void HostControllerService::stop()
{
    db_.stop();             // db should be stopped last for it receives requests from dispatcher
}

void HostControllerService::onAboutToQuit()
{
    stop();
}

void HostControllerService::sendDownloadPlatformFilePathChangedMessage(
    const QByteArray &clientId, const QString &originalFilePath, const QString &effectiveFilePath)
{
    QJsonObject payload;

    payload.insert("original_filepath", originalFilePath);
    payload.insert("effective_filepath", effectiveFilePath);

    strataServer_->notifyClient(clientId, "download_platform_filepath_changed", payload,
                                strata::strataRPC::ResponseType::Notification);
}

void HostControllerService::sendDownloadPlatformSingleFileProgressMessage(
        const QByteArray &clientId,
        const QString &filePath,
        qint64 bytesReceived,
        qint64 bytesTotal)
{
    QJsonObject payload;

    payload.insert("filepath", filePath);
    payload.insert("bytes_received", bytesReceived);
    payload.insert("bytes_total", bytesTotal);

    strataServer_->notifyClient(clientId, "download_platform_single_file_progress", payload,
                                strata::strataRPC::ResponseType::Notification);
}

void HostControllerService::sendDownloadPlatformSingleFileFinishedMessage(
        const QByteArray &clientId,
        const QString &filePath,
        const QString &errorString)
{
    QJsonObject payload;

    payload.insert("filepath", filePath);
    payload.insert("error_string", errorString);

    strataServer_->notifyClient(clientId, "download_platform_single_file_finished", payload,
                                strata::strataRPC::ResponseType::Notification);
}

void HostControllerService::sendDownloadPlatformFilesFinishedMessage(const QByteArray &clientId,
                                                                     const QString &errorString)
{
    QJsonObject payload;

    payload.insert("type", "download_platform_files_finished");
    if (errorString.isEmpty() == false) {
        payload.insert("error_string", errorString);
    }

    strataServer_->notifyClient(clientId, "download_platform_files_finished", payload,
                                strata::strataRPC::ResponseType::Notification);
}

void HostControllerService::sendPlatformListMessage(
        const QByteArray &clientId,
        const QJsonArray &platformList)
{
    QJsonObject payload;

    payload.insert("list", platformList);

    strataServer_->notifyClient(clientId, "all_platforms", payload,
                                strata::strataRPC::ResponseType::Notification);
}

void HostControllerService::sendPlatformDocumentsProgressMessage(
        const QByteArray &clientId,
        const QString &classId,
        int filesCompleted,
        int filesTotal)
{
    QJsonObject payload;

    payload.insert("class_id", classId);
    payload.insert("files_completed", filesCompleted);
    payload.insert("files_total", filesTotal);

    strataServer_->notifyClient(clientId, "document_progress", payload,
                                strata::strataRPC::ResponseType::Notification);
}

void HostControllerService::sendControlViewDownloadProgressMessage(
        const QByteArray &clientId,
        const QString &partialUri,
        const QString &filePath,
        qint64 bytesReceived,
        qint64 bytesTotal)
{
    QJsonObject payload;

    payload.insert("url", partialUri);
    payload.insert("filepath", filePath);
    payload.insert("bytes_received", bytesReceived);
    payload.insert("bytes_total", bytesTotal);

    strataServer_->notifyClient(clientId, "control_view_download_progress", payload,
                                strata::strataRPC::ResponseType::Notification);
}

void HostControllerService::sendPlatformMetaData(const QByteArray &clientId, const QString &classId,
                                                 const QJsonArray &controlViewList,
                                                 const QJsonArray &firmwareList,
                                                 const QString &error)
{
    QJsonObject payload;

    payload.insert("class_id", classId);

    if (error.isEmpty()) {
        payload.insert("control_views", controlViewList);
        payload.insert("firmwares", firmwareList);
    } else {
        payload.insert("error", error);
    }

    strataServer_->notifyClient(clientId, "platform_meta_data", payload,
                                strata::strataRPC::ResponseType::Notification);
}

void HostControllerService::sendPlatformDocumentsMessage(
        const QByteArray &clientId,
        const QString &classId,
        const QJsonArray &datasheetList,
        const QJsonArray &documentList,
        const QString &error)
{
    QJsonObject payload;

    payload.insert("class_id", classId);

    if (error.isEmpty()) {
        payload.insert("datasheets", datasheetList);
        payload.insert("documents", documentList);
    } else {
        payload.insert("error", error);
    }

    strataServer_->notifyClient(clientId, "document", payload,
                                strata::strataRPC::ResponseType::Notification);
}

void HostControllerService::sendDownloadControlViewFinishedMessage(
        const QByteArray &clientId,
        const QString &partialUri,
        const QString &filePath,
        const QString &errorString)
{
    QJsonObject payload {
        {"url", partialUri},
        {"filepath", filePath},
        {"error_string", errorString}
    };

    strataServer_->notifyClient(clientId, "download_view_finished", payload,
                                strata::strataRPC::ResponseType::Notification);
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

    // TODO: use QJson
    rapidjson::Document configuration;
    if (configuration.Parse<rapidjson::kParseCommentsFlag>(data.data()).HasParseError()) {
        qCCritical(logCategoryHcs) << "Parse error on config file!";
        return false;
    }

    if ( ! configuration.HasMember("host_controller_service") ) {
        qCCritical(logCategoryHcs) << "ERROR: No Host Controller Configuration parameters.";
        return false;
    }

    config_ = std::move(configuration);
    return true;
}

void HostControllerService::platformConnected(const QByteArray& deviceId)
{
    Q_UNUSED(deviceId)

    //send update to all clients
    strataServer_->notifyAllClients("connected_platforms", platformController_.createPlatformsList());
}

void HostControllerService::platformDisconnected(const QByteArray& deviceId)
{
    Q_UNUSED(deviceId)

    //send update to all clients
    strataServer_->notifyAllClients("connected_platforms", platformController_.createPlatformsList());
}

void HostControllerService::sendMessageToClients(const QString &platformId, const QString &message)
{
    Q_UNUSED(platformId)
    // this forward message from the platfrom to the client, uses the only client, as a result this needs to be improved!

    // Client* client = getSenderClient();
    // if (client != nullptr) {
    //     // clients_.sendMessage(client->getClientId(), message);
    // }
}

void HostControllerService::handleUpdateProgress(const QByteArray& deviceId, const QByteArray& clientId, FirmwareUpdateController::UpdateProgress progress)
{
    QString operation;
    switch (progress.operation) {
    case FirmwareUpdateController::UpdateOperation::Download :
        operation = "download";
        break;
    case FirmwareUpdateController::UpdateOperation::Prepare :
        operation = "prepare";
        break;
    case FirmwareUpdateController::UpdateOperation::Backup :
        operation = "backup";
        break;
    case FirmwareUpdateController::UpdateOperation::Flash :
        operation = "flash";
        break;
    case FirmwareUpdateController::UpdateOperation::Restore :
        operation = "restore";
        break;
    case FirmwareUpdateController::UpdateOperation::Finished :
        operation = "finished";
        break;
    }

    QString status;
    switch (progress.status) {
    case FirmwareUpdateController::UpdateStatus::Running :
        status = "running";
        break;
    case FirmwareUpdateController::UpdateStatus::Success :
        status = "success";
        break;
    case FirmwareUpdateController::UpdateStatus::Unsuccess :
        status = "unsuccess";
        break;
    case FirmwareUpdateController::UpdateStatus::Failure :
        status = "failure";
        break;
    }

    QJsonObject payload;
    payload.insert("device_id", QLatin1String(deviceId));
    payload.insert("operation", operation);
    payload.insert("status", status);
    payload.insert("complete", progress.complete);
    payload.insert("total", progress.total);
    payload.insert("download_error", progress.downloadError);
    payload.insert("prepare_error", progress.prepareError);
    payload.insert("backup_error", progress.backupError);
    payload.insert("flash_error", progress.flashError);
    payload.insert("restore_error", progress.restoreError);

    strataServer_->notifyClient(clientId, "firmware_update", payload, strata::strataRPC::ResponseType::Notification);

    if (progress.operation == FirmwareUpdateController::UpdateOperation::Finished &&
            progress.status == FirmwareUpdateController::UpdateStatus::Success) {
        // If firmware was updated broadcast new platforms list
        // to indicate the firmware version has changed.
        strataServer_->notifyAllClients("connected_platforms", platformController_.createPlatformsList());
    }
}

void HostControllerService::processCmdRequestHcsStatus(const strata::strataRPC::Message &message)
{
    strataServer_->notifyClient(message, QJsonObject{{"status", "hcs_active"}},
                                strata::strataRPC::ResponseType::Response);
}

void HostControllerService::processCmdLoadDocuments(const strata::strataRPC::Message &message)
{
    QString classId = message.payload.value("class_id").toString();
    if (classId.isEmpty()) {
        qCWarning(logCategoryHcs) << "class_id attribute is empty or has bad format";
        strataServer_->notifyClient(message, QJsonObject{{"message", "Invalid request."}},
                                    strata::strataRPC::ResponseType::Error);
        return;
    }

    strataServer_->notifyClient(message, QJsonObject{{"message", "load documents requested."}},
                                strata::strataRPC::ResponseType::Response);

    storageManager_.requestPlatformDocuments(message.clientID, classId);
}

void HostControllerService::processCmdDownloadFiles(const strata::strataRPC::Message &message)
{
    QStringList partialUriList;
    QString destinationDir = message.payload.value("destination_dir").toString();
    if (destinationDir.isEmpty()) {
        strataServer_->notifyClient(
            message,
            QJsonObject{{"message", "destinationDir attribute is empty or has bad format"}},
            strata::strataRPC::ResponseType::Error);
        qCWarning(logCategoryHcs) << "destinationDir attribute is empty or has bad format";
        return;
    }

    QJsonValue filesValue = message.payload.value("files");
    if (filesValue.isArray() == false) {
        strataServer_->notifyClient(message,
                                    QJsonObject{{"message", "files attribute is not an array"}},
                                    strata::strataRPC::ResponseType::Error);
        qCWarning(logCategoryHcs) << "files attribute is not an array";
        return;
    }

    QJsonArray files = filesValue.toArray();
    for (const QJsonValueRef value : files) {
        if (value.isString()) {
            partialUriList << value.toString();
        }
    }

    storageManager_.requestDownloadPlatformFiles(message.clientID, partialUriList, destinationDir);

    strataServer_->notifyClient(message, QJsonObject{{"message", "File download requested."}},
                                strata::strataRPC::ResponseType::Response);
}

void HostControllerService::processCmdDynamicPlatformList(const strata::strataRPC::Message &message)
{
    strataServer_->notifyClient(message,
                                QJsonObject{{"message", "Dynamic platform list requested."}},
                                strata::strataRPC::ResponseType::Response);

    storageManager_.requestPlatformList(message.clientID);

    strataServer_->notifyClient(message.clientID, "connected_platforms",
                                platformController_.createPlatformsList(),
                                strata::strataRPC::ResponseType::Notification);
}

void HostControllerService::processCmdUpdateFirmware(const strata::strataRPC::Message &message) 
{
    qCCritical(logCategoryHcs) << "Handler not implemented yet";
    strataServer_->notifyClient(message, QJsonObject{{"message", "not implemented yet"}},
                                strata::strataRPC::ResponseType::Error);
}

void HostControllerService::processCmdRequestHcsStatus(const strata::strataRPC::Message &message) 
{
    qCCritical(logCategoryHcs) << "Handler not implemented yet";
    strataServer_->notifyClient(message, QJsonObject{{"message", "not implemented yet"}},
                                strata::strataRPC::ResponseType::Error);
}

#ifndef COREINTERFACE_H
#define COREINTERFACE_H

//----
// Core Framework
//
// WARNING : DO NOT EDIT THIS FILE UNLESS YOU ARE ON THE CORE FRAMEWORK TEAM
//
//  Platform Implementation is done in PlatformInterface/platforms/<type>/PlatformInterface.h/cpp
//
//


#include <QObject>
#include <iterator>
#include <QString>
#include <QKeyEvent>
#include <QDebug>
#include <QJsonObject>
#include <QJsonDocument>
#include <QVariant>
#include <QStringList>
#include <QString>
#include <QJsonArray>
#include <string>
#include <thread>
#include <map>
#include <functional>
#include <stdlib.h>
#include <string>
#include <HostControllerClient.hpp>

typedef std::function<void(QJsonObject)> NotificationHandler; // notification handler
typedef std::function<void(QJsonObject)> DataSourceHandler; // data source handler accepting QJsonObject

class CoreInterface : public QObject
{
    Q_OBJECT

    //----
    // Core Framework Properties
    //
    Q_PROPERTY(QString platform_id_ READ platformID NOTIFY platformIDChanged)                   // update platformID to switch control interface
    Q_PROPERTY(bool platform_state_ READ platformState NOTIFY platformStateChanged)  // TODO [ian] define core framework platform states
    Q_PROPERTY(QString platform_list_ READ platformList NOTIFY platformListChanged)
    Q_PROPERTY(QString hcs_token_ READ hcsToken NOTIFY hcsTokenChanged)
    Q_PROPERTY(QString remote_user_activity_ READ remoteActivity NOTIFY remoteActivityChanged)
    Q_PROPERTY(QString remote_user_ READ remoteUser NOTIFY remoteUserAdded)
    Q_PROPERTY(QString remote_user_ READ remoteUser NOTIFY remoteUserRemoved)
    Q_PROPERTY(bool remote_connection_result READ remoteConnectionResult NOTIFY remoteConnectionChanged)

public:
    explicit CoreInterface(QObject *parent = nullptr);
    virtual ~CoreInterface();

    // ---
    // Core Framework: Q_PROPERTY read methods
    QString platformID() { return platform_id_; }
    bool platformState() { return platform_state_; }
    QString platformList() { return platform_list_; }
    QString hcsToken() { return hcs_token_; }
    QString remoteActivity() { return remote_user_activity_; }
    bool remoteConnectionResult() { return remote_connection_result_; }
    QString remoteUser() { return remote_user_; }

    bool registerNotificationHandler(std::string notification, NotificationHandler handler);
    bool registerDataSourceHandler(std::string source, DataSourceHandler handler);

    Spyglass::HostControllerClient *hcc;
    std::thread notification_thread_;
    void notificationsThread();

    // Invokables
    //To send the selected platform and its connection status
    Q_INVOKABLE void sendSelectedPlatform(QString verbose, QString connection_status);
    Q_INVOKABLE void registerClient();
    Q_INVOKABLE void unregisterClient();
    Q_INVOKABLE void sendCommand(QString cmd);

signals:

    // ---
    // Core Framework Signals
    bool platformIDChanged(QString id);
    bool platformStateChanged(bool platform_connected_state);
    bool platformListChanged(QString list);
    bool hcsTokenChanged(QString token);
    bool remoteActivityChanged(QString remote_activity);
    bool remoteUserAdded(QString user_name);
    bool remoteUserRemoved(QString user_disconnected);
    bool remoteConnectionChanged(bool result);

    // Platform Framework Signals
    void notification(QString payload);

private:

    // ---
    // Core Framework
    QString platform_id_;
    bool platform_state_;         // TODO [ian] change variable name to platform_connected_state
    QString platform_list_;       // [TODO] [prasanth] change the name to more proper
    QString hcs_token_;
    QString remote_user_activity_;
    bool remote_connection_result_;
    QString remote_user_;
    bool notification_thread_running_;

    // ---
    // notification handling
    std::map<std::string, NotificationHandler > notification_handlers_;

    // Main Catagory Notification handlers
    void platformNotificationHandler(QJsonObject notification);
    void cloudNotificationHandler(QJsonObject notification);

    // Core Framework Notificaion Handlers
    void platformIDNotificationHandler(QJsonObject payload);
    void connectionChangeNotificationHandler(QJsonObject payload);
    void platformListHandler(QJsonObject payload);
    void remoteSetupHandler(QJsonObject payload);

    // attached Data Source subscribers
    std::map<std::string, DataSourceHandler > data_source_handlers_;

};

#endif // COREINTERFACE_H

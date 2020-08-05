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
    Q_PROPERTY(QString platform_list_ READ platformList NOTIFY platformListChanged)
    Q_PROPERTY(QString connected_platform_list_ READ connectedPlatformList NOTIFY connectedPlatformListChanged)
    Q_PROPERTY(QString hcs_token_ READ hcsToken NOTIFY hcsTokenChanged)

public:
    explicit CoreInterface(QObject *parent = nullptr);
    virtual ~CoreInterface();

    // ---
    // Core Framework: Q_PROPERTY read methods
    QString platformList() { return platform_list_; }
    QString connectedPlatformList() { return connected_platform_list_; }
    QString hcsToken() { return hcs_token_; }

    bool registerNotificationHandler(std::string notification, NotificationHandler handler);
    bool registerDataSourceHandler(std::string source, DataSourceHandler handler);

    strata::hcc::HostControllerClient *hcc;
    std::thread notification_thread_;
    void notificationsThread();

    // Invokables
    //To send the selected platform and its connection status
    Q_INVOKABLE void connectToPlatform(QString class_id);
    Q_INVOKABLE void unregisterClient();
    Q_INVOKABLE void sendCommand(QString cmd);

    void setNotificationThreadRunning(bool running);

signals:
    // ---
    // Core Framework Signals
    bool platformIDChanged(QString id);
    bool platformStateChanged(bool platform_connected_state);
    bool platformListChanged(QString list);
    bool connectedPlatformListChanged(QString list);
    bool hcsTokenChanged(QString token);

    void downloadPlatformFilepathChanged(QJsonObject payload);
    void downloadPlatformSingleFileProgress(QJsonObject payload);
    void downloadPlatformSingleFileFinished(QJsonObject payload);
    void downloadPlatformFilesFinished(QJsonObject payload);

    void firmwareProgress(QJsonObject payload);
    void downloadViewFinished(QJsonObject payload);
    void downloadControlViewProgress(QJsonObject payload);

    // Platform Framework Signals
    void notification(QString payload);

private:

    // ---
    // Core Framework
    QString platform_list_{"{ \"list\":[]}"};
    QString connected_platform_list_{"{ \"list\":[]}"};
    QString hcs_token_;
    std::atomic_bool notification_thread_running_;

    // ---
    // notification handling
    std::map<std::string, NotificationHandler > notification_handlers_;

    // Main Catagory Notification handlers
    void platformNotificationHandler(QJsonObject notification);
    void cloudNotificationHandler(QJsonObject notification);

    // Core Framework Notificaion Handlers
    void hcsNotificationHandler(QJsonObject payload);

    // attached Data Source subscribers
    std::map<std::string, DataSourceHandler > data_source_handlers_;

};

#endif // COREINTERFACE_H

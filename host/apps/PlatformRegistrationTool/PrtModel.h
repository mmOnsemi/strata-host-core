#pragma once

#include "Authenticator.h"
#include "RestClient.h"

#include <BoardManager.h>
#include <FlasherConnector.h>
#include <DownloadManager.h>

#include <QObject>
#include <QPointer>
#include <QNetworkAccessManager>


class PrtModel : public QObject
{
    Q_OBJECT
    Q_DISABLE_COPY(PrtModel)

    Q_PROPERTY(int deviceCount READ deviceCount NOTIFY deviceCountChanged)
    Q_PROPERTY(Authenticator* authenticator READ authenticator CONSTANT)
    Q_PROPERTY(RestClient* restClient READ restClient CONSTANT)

public:
    explicit PrtModel(QObject *parent = nullptr);
    virtual ~PrtModel();

    int deviceCount() const;
    Authenticator* authenticator();
    RestClient* restClient();

    Q_INVOKABLE QString deviceFirmwareVersion() const;
    Q_INVOKABLE QString deviceFirmwareVerboseName() const;
    Q_INVOKABLE QString programDevice(QString filePath);

signals:
    void boardReady(int deviceId);
    void boardDisconnected(int deviceId);
    void deviceCountChanged();
    void flasherProgress(
            strata::FlasherConnector::Operation operation,
            strata::FlasherConnector::State state,
            QString errorString);

    void flasherFinished(strata::FlasherConnector::Result result);

private slots:
    void boardReadyHandler(int deviceId, bool recognized);
    void boardDisconnectedHandler(int deviceId);
    void flasherFinishedHandler(strata::FlasherConnector::Result result);
    void downloadFinishedHandler(QString groupId, QString errorString);

private:
    strata::BoardManager boardManager_;
    QList<strata::device::DevicePtr> platformList_;
    QPointer<strata::FlasherConnector> flasherConnector_;
    QNetworkAccessManager networkManager_;
    strata::DownloadManager downloadManager_;
    RestClient restClient_;
    Authenticator authenticator_;

    QString downloadJobId_;
    QPointer<QTemporaryFile> bootloaderFile_;
    QPointer<QTemporaryFile> firmwareFile_;


    void downloadBinaries(
            const QString &bootloaderUrl,
            const QString &bootloaderChecksum,
            const QString &firmwareUrl,
            const QString &firmwareChecksum);

};

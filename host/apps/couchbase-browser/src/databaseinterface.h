#ifndef DATABASEINTERFACE_H
#define DATABASEINTERFACE_H

#include <QObject>
#include <QCoreApplication>
#include <QDir>
#include <QQmlProperty>
#include <QDebug>

#include "SGCouchBaseLite.h"

class DatabaseInterface : public QObject
{
    Q_OBJECT

public:
    explicit DatabaseInterface(QObject *parent = nullptr);

    DatabaseInterface(const int &id);

    ~DatabaseInterface();

    QString getDBName();

    QString getJSONResponse();

    bool createNewDoc(const QString &id, const QString &body);

    QString rep_init(const QString &url, const QString &username, const QString &password,
        const Spyglass::SGReplicatorConfiguration::ReplicatorType &rep_type = Spyglass::SGReplicatorConfiguration::ReplicatorType::kPull);

    void rep_stop();

    QString setFilePath(QString file_path);

    QString editDoc(const QString &id, const QString &body);

    QString deleteDoc(const QString &id);

private:
    QString file_path_, db_path_, db_name_, JSONResponse_, url_, username_, password_;

    int id_;

    bool DBstatus_, Repstatus_;

    std::vector<std::string> document_keys_;

    Spyglass::SGDatabase *sg_db_{nullptr};

    Spyglass::SGReplicatorConfiguration *sg_replicator_configuration_{nullptr};

    Spyglass::SGURLEndpoint *url_endpoint_{nullptr};

    Spyglass::SGReplicator *sg_replicator_{nullptr};

    Spyglass::SGBasicAuthenticator *sg_basic_authenticator_{nullptr};

    Spyglass::SGReplicatorConfiguration::ReplicatorType rep_type_;

    void emitUpdate();

    QString getFilePath();

    void setDBPath(QString db_path);

    QString getDBPath();

    void setDBName(QString db_name);

    bool parseFilePath();

    bool db_init();

    bool setDocumentKeys();

    void setJSONResponse();

    void rep_init();

    bool getDBstatus();

    bool getRepstatus();

    void setDBstatus(bool status);

    void setRepstatus(bool status);

    bool createNewDoc_(const QString &id, const QString &body);

    QString rep_init_();

    bool parseExistingFile();

    bool parseNewFile();

    QString editDoc_(Spyglass::SGMutableDocument &doc, const QString &body);

    QString deleteDoc_(Spyglass::SGDocument &doc);

signals:
    void newUpdate(int i);

};

#endif // DATABASEINTERFACE_H

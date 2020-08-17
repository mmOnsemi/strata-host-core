#ifndef VERSIONED_LIST_MODEL_H
#define VERSIONED_LIST_MODEL_H

#include <QAbstractListModel>
#include <QJsonArray>
#include <PlatformInterface/core/CoreInterface.h>
#include <QUrl>
#include <QList>

struct VersionedItem {

    VersionedItem(
            const QString &uri,
            const QString &md5,
            const QString &name,
            const QString &timestamp,
            const QString &version,
            const QString &filepath = "")
    {
        this->uri = uri;
        this->md5 = md5;
        this->name = name;
        this->timestamp = timestamp;
        this->version = version;
        this->installed = !filepath.isEmpty();
    }

    QString uri;
    QString md5;
    QString name;
    QString timestamp;
    QString version;
    bool installed;
};

class VersionedListModel: public QAbstractListModel
{
    Q_OBJECT
    Q_DISABLE_COPY(VersionedListModel)

    Q_PROPERTY(int count READ count NOTIFY countChanged)

public:
    VersionedListModel(QObject *parent = nullptr);
    virtual ~VersionedListModel() override;

    Q_INVOKABLE QString version(int index);
    Q_INVOKABLE void setInstalled(int index, bool installed);

    enum {
        UriRole = Qt::UserRole,
        VersionRole,
        NameRole,
        TimestampRole,
        Md5Role,
        InstalledRole
    };

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    int count() const;
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    void populateModel(const QList<VersionedItem*> &list);
    void clear(bool emitSignals=true);

signals:
    void countChanged();

protected:
    virtual QHash<int, QByteArray> roleNames() const override;

private:
    QList<VersionedItem*>data_;
};


#endif //VERSIONED_LIST_MODEL_H
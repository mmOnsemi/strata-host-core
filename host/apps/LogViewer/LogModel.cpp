#include "LogModel.h"

#include <QFile>
#include <QDebug>


LogModel::LogModel(QObject *parent)
    : QAbstractListModel(parent)
{
}

LogModel::~LogModel()
{
    data_.clear();
}

QString LogModel::populateModel(const QString &path)
{
    beginResetModel();
    clear();
    QFile file(path);

    if (file.open(QIODevice::ReadOnly | QIODevice::Text) == false) {
        qWarning() << "cannot open " + path + " " + file.errorString();
        emit countChanged();
        endResetModel();
        return file.errorString();
    }

    while (file.atEnd() == false) {
        QByteArray line = file.readLine();
        LogItem *item = parseLine(line);

        if (item->timestamp.isValid()) {
            data_.append(item);
        } else {
            if (data_.isEmpty()) {
                data_.append(item);
                continue;
            } else {
                data_.last()->message += "\n" + item->message;
            }
        }
    }
    emit countChanged();
    endResetModel();
    return "";
}

void LogModel::clear()
{
    beginResetModel();
    for (int i = 0; i < data_.length(); i++) {
        delete data_[i];
    }
    data_.clear();
    endResetModel();
}

int LogModel::rowCount(const QModelIndex &) const
{
    return data_.length();
}

QVariant LogModel::data(const QModelIndex &index, int role) const
{
    int row = index.row();
    if (row < 0 || row >= data_.count()) {
        return QVariant();
    }

    LogItem *item = data_.at(row);

    if (item == nullptr) {
        return QVariant();
    }

    switch (role) {
    case TimestampRole:
        return item->timestamp.toString(Qt::ISODateWithMs);
    case PidRole:
        return item->pid;
    case TidRole:
        return item->tid;
    case LevelRole:
        return item->level;
    case MessageRole:
        return item->message;
    }
    return QVariant();
}

QHash<int, QByteArray> LogModel::roleNames() const
{
    QHash<int, QByteArray> names;
    names[TimestampRole] = "timestamp";
    names[PidRole] = "pid";
    names[TidRole] = "tid";
    names[LevelRole] = "level";
    names[MessageRole] = "message";
    return names;
}

int LogModel::count() const
{
    return data_.length();
}

LogItem *LogModel::parseLine(const QString &line)
{
    QStringList splitIt = line.split('\t');
    LogItem *item = new LogItem;
    if (splitIt.length() >= 5) {

        item->timestamp = QDateTime::fromString(splitIt.takeFirst().trimmed(), Qt::DateFormat::ISODateWithMs);
        item->pid = splitIt.takeFirst().trimmed().replace("PID:","");
        item->tid = splitIt.takeFirst().trimmed().replace("TID:","");
        item->level = splitIt.takeFirst().trimmed();
        item->message = splitIt.join('\t').trimmed();

        return item;
    }
    item->message = line.trimmed();
    return item;
}

#ifndef SGNEWCONTROLVIEW_H

#include <QDir>
#include <QDebug>
#include <QString>
#include <QFileInfo>
#include <QUrl>
#include <QResource>

class SGNewControlView: public QObject
{
    Q_OBJECT
    Q_DISABLE_COPY(SGNewControlView)

public:
    SGNewControlView(QObject *parent=nullptr);
    Q_INVOKABLE QUrl createNewProject(const QString &filepath, const QString &originPath);

private:
    bool copyFiles(QDir &oldDir, QDir &newDir, bool resolve_conflict);

    QString qrcpath_;
    QString rootpath_;
};

#endif // SGNEWCONTROLVIEW_H

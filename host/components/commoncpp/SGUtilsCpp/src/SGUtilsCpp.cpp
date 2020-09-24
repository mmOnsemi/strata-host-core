#include "SGUtilsCpp.h"
#include "logging/LoggingQtCategories.h"

#include <QFileInfo>
#include <QUrl>
#include <QSaveFile>
#include <QTextStream>
#include <QDebug>
#include <QDir>
#include <QDateTime>
#include <cmath>

SGUtilsCpp::SGUtilsCpp(QObject *parent)
    : QObject(parent),
      fileSizePrefixList_(QStringList() <<"B"<<"KB"<<"MB"<<"GB"<<"TB"<<"PB"<<"EB")
{
}

SGUtilsCpp::~SGUtilsCpp()
{
}

QString SGUtilsCpp::urlToLocalFile(const QUrl &url)
{
    return QDir::toNativeSeparators(QUrl(url).toLocalFile());
}

bool SGUtilsCpp::isFile(const QString &file)
{
    QFileInfo info(file);
    return info.isFile();
}

bool SGUtilsCpp::createFile(const QString &filepath)
{
    QFile file(filepath);
    if (file.exists()) {
        file.close();
        return false;
    }

    bool success = file.open(QIODevice::WriteOnly);
    file.close();
    return success;
}

bool SGUtilsCpp::removeFile(const QString &filepath)
{
    return QFile::remove(filepath);
}

bool SGUtilsCpp::copyFile(const QString &fromPath, const QString &toPath)
{
    return QFile::copy(fromPath, toPath);
}

QString SGUtilsCpp::fileSuffix(const QString &filename)
{
    return QFileInfo(filename).suffix();
}

bool SGUtilsCpp::isExecutable(const QString &file)
{
    QFileInfo info(file);
    return info.isExecutable();
}

QString SGUtilsCpp::fileName(const QString &file)
{
    QFileInfo fi(file);
    return fi.fileName();
}

QString SGUtilsCpp::fileAbsolutePath(const QString &file)
{
    QFileInfo fi(file);
    return fi.absolutePath();
}

QString SGUtilsCpp::dirName(const QString &path)
{
    QDir dir(path);
    return dir.dirName();
}

QString SGUtilsCpp::parentDirectoryPath(const QString &filepath)
{
    QFileInfo fi(filepath);
    if (fi.isDir()) {
        return fi.absolutePath();
    }
    return fi.dir().absolutePath();
}

QUrl SGUtilsCpp::pathToUrl(const QString &path, const QString &scheme)
{
    QUrl url;
    url.setScheme(scheme);
    url.setPath(path);

    return url;
}

bool SGUtilsCpp::atomicWrite(const QString &path, const QString &content)
{
    QSaveFile file(path);

    bool ret = file.open(QIODevice::WriteOnly | QIODevice::Text);
    if (ret == false) {
        qCCritical(logCategoryUtils) << "cannot open file" << path << file.errorString();
        return false;
    }

    QTextStream out(&file);

    out << content;

    return file.commit();
}

bool SGUtilsCpp::fileIsChildOfDir(const QString &filePath, const QString &dirPath)
{
    if (filePath.startsWith(dirPath)) {
        return true;
    } else {
        return false;
    }
}

QString SGUtilsCpp::readTextFileContent(const QString &path)
{
    QFile file(path);
    if (file.open(QFile::ReadOnly | QFile::Text) == false) {
        qCCritical(logCategoryUtils) << "cannot open file" << path << file.errorString();
        return QString();
    }

    return file.readAll();
}

QByteArray SGUtilsCpp::toBase64(const QByteArray &text)
{
    return text.toBase64();
}

QByteArray SGUtilsCpp::fromBase64(const QByteArray &text)
{
    return QByteArray::fromBase64(text);
}

QString SGUtilsCpp::joinFilePath(const QString &path, const QString &fileName)
{
    QDir dir(path);
    return dir.filePath(fileName);
}

QString SGUtilsCpp::formattedDataSize(qint64 bytes, int precision)
{
    if (bytes == 0) {
        return "0 "+ fileSizePrefixList_.at(0);
    }

    int base, power = 0;

    #ifdef Q_OS_MACOS
    base = 1000;
    power = int(log10(qAbs(bytes)) / 3);
    #else
    base = 1024;
    //compute log2(bytes) / 10
    power = int((63 - qCountLeadingZeroBits(quint64(qAbs(bytes)))) / 10);
    #endif

    if (power < 0 || power >= fileSizePrefixList_.length()) {
        //no support for sizes larger than exabytes as they would not fit into qint64
        return QString();
    }

    QString number = QString::number(bytes / (pow(double(base), power)), 'f', precision);

    return number + " " + fileSizePrefixList_.at(power);
}

QString SGUtilsCpp::formatDateTimeWithOffsetFromUtc(const QDateTime &dateTime, const QString &format)
{
    return dateTime.toOffsetFromUtc(dateTime.offsetFromUtc()).toString(format);
}

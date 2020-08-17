#include "Authenticator.h"
#include "RestClient.h"
#include "logging/LoggingQtCategories.h"

#include <QJsonDocument>
#include <QJsonObject>
#include <QNetworkReply>
#include <QSettings>
#include <QCoreApplication>


Authenticator::Authenticator(RestClient *restClient, QObject *parent)
        : QObject(parent),
          restClient_(restClient)
{
    readSettings();
}

Authenticator::~Authenticator()
{
}

void Authenticator::renewSession()
{
    emit renewSessionStarted();

    Deferred *deferred = restClient_->get(QUrl("session/init"));

    connect(deferred, &Deferred::finishedSuccessfully, [this] (int status, QByteArray data) {
        Q_UNUSED(status)

        bool isOk = parseRenewSessionReply(data);
        if (isOk) {
            qCInfo(logCategoryPrtAuth) << "session renew success as" << username_;
        } else {
            qCInfo(logCategoryPrtAuth) << "session renew failed";
        }

        emit renewSessionFinished(isOk);
        writeSettings();
    });

    connect(deferred, &Deferred::finishedWithError, [this] (int status, QString errorString) {
        qCInfo(logCategoryPrtAuth) << "session renew failed" << username_ << status << errorString;

        setSessionId(QByteArray());
        setXAccessToken(QByteArray());

        emit renewSessionFinished(false);
    });
}

void Authenticator::login(const QString &username, const QString &password)
{
    QJsonDocument doc;
    QJsonObject data;
    data.insert("username", username);
    data.insert("password", password);
    doc.setObject(data);

    emit loginStarted();

    Deferred *deferred = restClient_->post(
                QUrl("login"),
                QVariantMap(),
                doc.toJson(QJsonDocument::Compact));

    connect(deferred, &Deferred::finishedSuccessfully, [this] (int status, QByteArray data) {
        Q_UNUSED(status)

        bool isOk = parseLoginReply(data);
        if (isOk) {
            qCInfo(logCategoryPrtAuth) << "login success as" << username_;
            emit loginFinished(isOk, "");
        } else {
            qCInfo(logCategoryPrtAuth) << "login failed. Cannot parse reply.";
            emit loginFinished(isOk, "Cannot parse reply.");
        }

        writeSettings();
    });

    connect(deferred, &Deferred::finishedWithError, [this] (int status, QString errorString) {
        qCInfo(logCategoryPrtAuth) << "login failed" << status << errorString;

        setSessionId(QByteArray());
        setXAccessToken(QByteArray());

        QString newErrorString = errorString;
        if (status >= 400 && status < 500) {
            newErrorString = "Username or password is wrong";
        }

        emit loginFinished(false, newErrorString);
    });
}

void Authenticator::logout()
{
    emit logoutStarted();

    Deferred *deferred = restClient_->get(QUrl("logout?session="+sessionId_));

    connect(deferred, &Deferred::finishedSuccessfully, [this] (int status, QByteArray data) {
        Q_UNUSED(status)
        Q_UNUSED(data)

        qCInfo(logCategoryPrtAuth) << "logout success";
        emit logoutFinished(true);

        setSessionId(QByteArray());
        setXAccessToken(QByteArray());
    });

    connect(deferred, &Deferred::finishedWithError, [this] (int status, QString errorString) {
        qCCritical(logCategoryPrtAuth) << "logout failed" << status << errorString;
        emit logoutFinished(false);

        setSessionId(QByteArray());
        setXAccessToken(QByteArray());
    });
}

QByteArray Authenticator::sessionId() const
{
    return sessionId_;
}

QByteArray Authenticator::xAccessToken() const
{
    return xAccessToken_;
}

QString Authenticator::username() const
{
    return username_;
}

QString Authenticator::firstname() const
{
    return firstname_;
}

QString Authenticator::lastname() const
{
    return lastname_;
}

void Authenticator::writeSettings()
{
    QSettings settings;

    settings.beginGroup("authentication");
    settings.setValue("x-access-token", xAccessToken_);
    settings.setValue("username", username_);
    settings.setValue("firstname", firstname_);
    settings.setValue("lastname", lastname_);
    settings.endGroup();
}

void Authenticator::readSettings()
{
    QSettings settings;

    settings.beginGroup("authentication");
    setXAccessToken(settings.value("x-access-token").toByteArray());
    setUsername(settings.value("username").toString());
    setFirstname(settings.value("firstname").toString());
    setLastname(settings.value("lastname").toString());
    settings.endGroup();
}

void Authenticator::setSessionId(const QByteArray &sessionId)
{
    if (sessionId_ != sessionId) {
        sessionId_ = sessionId;
        emit sessionIdChanged();
    }
}

void Authenticator::setXAccessToken(const QByteArray &xAccessToken)
{
    if (xAccessToken_ != xAccessToken) {
        xAccessToken_ = xAccessToken;
        emit xAccessTokenChanged();
    }
}

void Authenticator::setUsername(const QString &username)
{
    if (username_ != username) {
        username_ = username;
        emit usernameChanged();
    }
}

void Authenticator::setFirstname(const QString &firstname)
{
    if (firstname_ != firstname) {
        firstname_ = firstname;
        emit firstnameChanged();
    }
}

void Authenticator::setLastname(const QString &lastname)
{
    if (lastname_ != lastname) {
        lastname_ = lastname;
        emit lastnameChanged();
    }
}

bool Authenticator::parseLoginReply(const QByteArray &data)
{
    QJsonParseError parseError;
    QJsonDocument doc = QJsonDocument::fromJson(data, &parseError);

    if (parseError.error != QJsonParseError::NoError) {
        qCCritical(logCategoryPrtAuth) << "cannot parse reply" << parseError.errorString();
        return false;
    }

    if (doc.object().contains("session") == false
            || doc.object().contains("token") == false
            || doc.object().contains("user") == false
            || doc.object().contains("firstname") == false
            || doc.object().contains("lastname") == false) {

        qCCritical(logCategoryPrtAuth) << "wrong reply format, some field is missing";
        return false;
    }

    setSessionId(doc.object().value("session").toString().toUtf8());
    setXAccessToken(doc.object().value("token").toString().toUtf8());
    setUsername(doc.object().value("user").toString());
    setFirstname(doc.object().value("firstname").toString());
    setLastname(doc.object().value("lastname").toString());

    return true;
}

bool Authenticator::parseRenewSessionReply(const QByteArray &data)
{
    QJsonParseError parseError;
    QJsonDocument doc = QJsonDocument::fromJson(data, &parseError);

    if (parseError.error != QJsonParseError::NoError) {
        qCCritical(logCategoryPrtAuth) << "cannot parse reply" << parseError.errorString();
        return false;
    }

    if (doc.object().contains("session") == false
            || doc.object().contains("token") == false
            || doc.object().contains("user") == false) {

        qCCritical(logCategoryPrtAuth) << "wrong reply format, some field is missing" << data;
        return false;
    }

    setSessionId(doc.object().value("session").toString().toUtf8());
    setXAccessToken(doc.object().value("token").toString().toUtf8());
    setUsername(doc.object().value("user").toString());

    return true;
}
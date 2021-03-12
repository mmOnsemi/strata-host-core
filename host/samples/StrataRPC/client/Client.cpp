#include "Client.h"
#include <QDebug>

using namespace strata::strataRPC;

Client::Client(QObject *parent)
    : QObject(parent), strataClient_(new StrataClient(address_)), connectionStatus_(false)
{
    connect(strataClient_.get(), &StrataClient::clientConnected, this, [this]() {
        connectionStatus_ = true;
        emit connectionStatusUpdated();
    });
}

Client::~Client()
{
}

bool Client::init()
{
    return true;
}

void Client::start()
{

}

bool Client::getConnectionStatus()
{
    return connectionStatus_;
}

void Client::connectToServer()
{
    qDebug() << "gui connecting";
    strataClient_->connectServer();
}

void Client::disconnectServer()
{
    qDebug() << "gui disconnecting";
    if (true == strataClient_->disconnectServer()) {
        connectionStatus_ = false;
        emit connectionStatusUpdated();
    }
}

/*
 * Copyright (c) 2018-2021 onsemi.
 *
 * All rights reserved. This software and/or documentation is licensed by onsemi under
 * limited terms and conditions. The terms and conditions pertaining to the software and/or
 * documentation are available at http://www.onsemi.com/site/pdf/ONSEMI_T&C.pdf (“onsemi Standard
 * Terms and Conditions of Sale, Section 8 Software”).
 */
#include "ZmqPublisherConnector.h"

namespace strata::connector
{

ZmqPublisherConnector::ZmqPublisherConnector() : ZmqConnector(ZMQ_PUB), mSubscribers_()
{
    qCInfo(logCategoryZmqPublisherConnector) << "ZMQ_PUB Creating connector object";
}

ZmqPublisherConnector::~ZmqPublisherConnector()
{
}

bool ZmqPublisherConnector::open(const std::string& ip_address)
{
    if (false == socketAndContextOpen()) {
        qCCritical(logCategoryZmqPublisherConnector) << "Unable to open socket";
        return false;
    }

    int linger = 0;
    if (socketSetOptInt(zmq::sockopt::linger, linger) &&
        socketBind(ip_address)) {
        setConnectionState(true);
        qCInfo(logCategoryZmqPublisherConnector).nospace().noquote()
                << "Connected to the server socket '" << QString::fromStdString(ip_address)
                << "' (ID: 0x" << QByteArray::fromStdString(getDealerID()).toHex() << ")";
        return true;
    }

    qCCritical(logCategoryZmqPublisherConnector).nospace().noquote()
            << "Unable to configure and/or connect to server socket '" << QString::fromStdString(ip_address) << "'";
    close();
    return false;
}

bool ZmqPublisherConnector::read(std::string&)
{
    assert(false);
    return false;
}

bool ZmqPublisherConnector::send(const std::string& message)
{
    if (false == socketValid()) {
        qCCritical(logCategoryZmqPublisherConnector) << "Unable to send messages, socket not open";
        return false;
    }

    for (const std::string& dealerID : mSubscribers_) {
        if ((false == socketSendMore(dealerID)) || (false == socketSend(message))) {
            qCWarning(logCategoryZmqPublisherConnector).nospace().noquote()
                    << "Failed to send message: '" << QString::fromStdString(message)
                    << "' (ID: 0x" << QByteArray::fromStdString(getDealerID()).toHex() << ")";
            return false;
        }
        qCDebug(logCategoryZmqPublisherConnector).nospace().noquote()
                << "Tx'ed message: '" << QString::fromStdString(message)
                << "' (ID: 0x" << QByteArray::fromStdString(getDealerID()).toHex() << ")";
    }

    return true;
}

void ZmqPublisherConnector::addSubscriber(const std::string& dealerID)
{
    mSubscribers_.insert(dealerID);
    qCDebug(logCategoryZmqPublisherConnector).nospace().noquote()
            << "Added subscriber: 0x" << QByteArray::fromStdString(getDealerID()).toHex();
}

} // namespace strata::connector

/*
 * Copyright (c) 2018-2021 onsemi.
 *
 * All rights reserved. This software and/or documentation is licensed by onsemi under
 * limited terms and conditions. The terms and conditions pertaining to the software and/or
 * documentation are available at http://www.onsemi.com/site/pdf/ONSEMI_T&C.pdf (“onsemi Standard
 * Terms and Conditions of Sale, Section 8 Software”).
 */
#include "RequestsController.h"
#include "logging/LoggingQtCategories.h"

using namespace strata::strataRPC;

RequestsController::RequestsController() : findTimedoutRequestsTimer_(this)
{
    currentRequestId_ = 0;
    findTimedoutRequestsTimer_.setInterval(FIND_TIMEDOUT_REQUESTS_INTERVAL);
    connect(&findTimedoutRequestsTimer_, &QTimer::timeout, this,
            &RequestsController::findTimedoutRequests);

    findTimedoutRequestsTimer_.start();
}

RequestsController::~RequestsController()
{
}

std::pair<DeferredRequest *, QByteArray> RequestsController::addNewRequest(
    const QString &method, const QJsonObject &payload)
{
    ++currentRequestId_;

    const auto it = requests_.find(currentRequestId_);
    if (it != requests_.end()) {
        qCCritical(logCategoryRequestsController) << "Duplicate request id.";
        return {nullptr, QByteArray()};
    }

    qCDebug(logCategoryRequestsController)
        << "Building request. id:" << currentRequestId_ << "method:" << method;

    DeferredRequest *deferredRequest = new DeferredRequest(currentRequestId_, this);
    const auto request = requests_.insert(
        currentRequestId_, Request(method, payload, currentRequestId_, deferredRequest));

    return {deferredRequest, request.value().toJson()};
}

bool RequestsController::isPendingRequest(const int &id)
{
    return requests_.contains(id);
}

bool RequestsController::removePendingRequest(const int &id)
{
    qCDebug(logCategoryRequestsController) << "Removing pending request id:" << id;
    auto it = requests_.find(id);
    if (it == requests_.end()) {
        qCDebug(logCategoryRequestsController) << "Request id not found.";
        return false;
    }
    return requests_.remove(id) > 0;
}

std::pair<bool, Request> RequestsController::popPendingRequest(const int &id)
{
    qCDebug(logCategoryRequestsController) << "Popping pending request id:" << id;
    auto it = requests_.find(id);
    if (it == requests_.end()) {
        qDebug(logCategoryRequestsController) << "Request id not found.";
        return {false, Request("", QJsonObject({{}}), 0, nullptr)};
    }
    Request request(it.value());
    return {requests_.remove(id) > 0, request};
}

QString RequestsController::getMethodName(const int &id)
{
    auto it = requests_.find(id);
    if (it == requests_.end()) {
        qCDebug(logCategoryRequestsController) << "Request id not found.";
        return "";
    }
    qCDebug(logCategoryRequestsController)
        << "request id" << it->messageId_ << "method" << it->method_;
    return it->method_;
}

void RequestsController::findTimedoutRequests()
{
    qint64 currentTime = QDateTime::currentMSecsSinceEpoch();
    for (const auto &request : qAsConst(requests_)) {
        if ((currentTime - request.timestamp_) < REQUEST_TIMEOUT) {
            return;
        }
        emit requestTimedout(request.messageId_);
    }
}

#include <StrataRPC/DeferredRequest.h>
#include <QMetaMethod>
using namespace strata::strataRPC;

DeferredRequest::DeferredRequest(int id, QObject *parent) : QObject(parent), id_(id), timer_(this)
{
    timer_.setSingleShot(true);
    connect(&timer_, &QTimer::timeout, this, &DeferredRequest::requestTimeoutHandler);
}

DeferredRequest::~DeferredRequest()
{
}

int DeferredRequest::getId() const
{
    return id_;
}

bool DeferredRequest::hasSuccessCallback()
{
    return isSignalConnected(QMetaMethod::fromSignal(&DeferredRequest::finishedSuccessfully));
}

bool DeferredRequest::hasErrorCallback()
{
    return isSignalConnected(QMetaMethod::fromSignal(&DeferredRequest::finishedWithError));
}

void DeferredRequest::callSuccessCallback(const Message &message)
{
    emit finishedSuccessfully(message);
}

void DeferredRequest::callErrorCallback(const Message &message)
{
    emit finishedWithError(message);
}

void DeferredRequest::startTimer()
{
    timer_.start(REQUEST_TIMEOUT);
}

void DeferredRequest::stopTimer()
{
    timer_.stop();
}

void DeferredRequest::requestTimeoutHandler()
{
    emit requestTimedout(id_);
}
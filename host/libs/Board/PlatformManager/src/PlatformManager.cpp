#include "PlatformManager.h"
#include "PlatformManagerConstants.h"

#include "logging/LoggingQtCategories.h"

#include <Serial/SerialDevice.h>
#include <Operations/Identify.h>

#include <CommandValidator.h>

#include <QSerialPortInfo>
#include <QMutexLocker>

#include <rapidjson/document.h>
#include <rapidjson/schema.h>

#include <vector>

namespace strata {

using device::Device;
using device::DevicePtr;
using device::SerialDevice;

namespace operation = platform::operation;

PlatformManager::PlatformManager() {
    // checkNewSerialDevices() slot uses mutex_
    connect(&timer_, &QTimer::timeout, this, &PlatformManager::checkNewSerialDevices, Qt::QueuedConnection);
    // handlePlatformIdChanged() slot uses mutex_
    connect(this, &PlatformManager::platformIdChanged, this, &PlatformManager::handlePlatformIdChanged, Qt::QueuedConnection);
}

PlatformManager::~PlatformManager() { }

void PlatformManager::init(bool requireFwInfoResponse, bool keepDevicesOpen) {
    reqFwInfoResp_ = requireFwInfoResponse;
    keepDevicesOpen_ = keepDevicesOpen;
    timer_.start(DEVICE_CHECK_INTERVAL);
}

bool PlatformManager::disconnectDevice(const QByteArray& deviceId, std::chrono::milliseconds disconnectDuration) {
    bool success = false;
    {
        QMutexLocker lock(&mutex_);
        auto it = openedDevices_.find(deviceId);
        if (it != openedDevices_.end()) {
            it.value()->close();
            openedDevices_.erase(it);

            if (disconnectDuration > std::chrono::milliseconds(0)) {
                QTimer* reconnectTimer = new QTimer(this);
                reconnectTimers_.insert(deviceId, reconnectTimer);
                reconnectTimer->setSingleShot(true);
                reconnectTimer->callOnTimeout(this, [this, deviceId, reconnectTimer](){
                    QMutexLocker lock(&mutex_);
                    reconnectTimer->deleteLater();
                    reconnectTimers_.remove(deviceId);
                    // Remove serial port from list of known ports, device will be
                    // added (reconnected) in next round of scaning serial ports.
                    serialPortsList_.erase(deviceId);
                });
                reconnectTimer->start(disconnectDuration);
            }

            success = true;
        }
    }
    if (success) {
        qCInfo(logCategoryPlatformManager).noquote() << "Disconnected serial device" << deviceId;
        if (disconnectDuration > std::chrono::milliseconds(0)) {
            qCInfo(logCategoryPlatformManager) << "Device will be connected again after" << disconnectDuration.count()
                                            << "milliseconds at the earliest.";
        }
        emit boardDisconnected(deviceId);
    } else {
        logInvalidDeviceId(QStringLiteral("Cannot disconnect"), deviceId);
    }
    return success;
}

bool PlatformManager::reconnectDevice(const QByteArray& deviceId) {
    bool ok = false;
    bool disconnected = false;
    {
        QMutexLocker lock(&mutex_);
        auto it = openedDevices_.find(deviceId);
        if (it != openedDevices_.end()) {
            it.value()->close();
            openedDevices_.erase(it);
            ok = true;
            disconnected = true;
        } else {
            // desired port is not opened, check if it is connected
            if (serialPortsList_.find(deviceId) != serialPortsList_.end()) {
                ok = true;
            }
        }
        if (ok) {
            ok = addSerialPort(deviceId);  // modifies openedDevices_ - call it while mutex_ is locked
        }
    }
    if (disconnected) {
        emit boardDisconnected(deviceId);
    }
    if (ok) {
        qCInfo(logCategoryPlatformManager).noquote() << "Reconnected serial device" << deviceId;
        emit boardConnected(deviceId);
    } else {
        logInvalidDeviceId(QStringLiteral("Cannot reconnect"), deviceId);
    }
    return ok;
}

DevicePtr PlatformManager::device(const QByteArray& deviceId) {
    QMutexLocker lock(&mutex_);
    auto it = openedDevices_.constFind(deviceId);
    if (it != openedDevices_.constEnd()) {
        return it.value();
    } else {
        return nullptr;
    }
}

QVector<QByteArray> PlatformManager::activeDeviceIds() {
    QMutexLocker lock(&mutex_);
    return QVector<QByteArray>::fromList(openedDevices_.keys());
}

void PlatformManager::checkNewSerialDevices() {
    // TODO refactoring, take serial port functionality out from this class
    // or make another check function for bluetooth devices when it will be needed
#if defined(Q_OS_MACOS)
    const QString usbKeyword("usb");
    const QString cuKeyword("cu");
#elif defined(Q_OS_LINUX)
    // TODO: this code was not tested on Linux, test it
    const QString usbKeyword("USB");
#elif defined(Q_OS_WIN)
    const QString usbKeyword("COM");
#endif

    const auto serialPortInfos = QSerialPortInfo::availablePorts();
    std::set<QByteArray> ports;
    QHash<QByteArray, QString> idToName;

    for (const QSerialPortInfo& serialPortInfo : serialPortInfos) {
        const QString& name = serialPortInfo.portName();

        if (serialPortInfo.isNull()) {
            continue;
        }
        if (name.contains(usbKeyword) == false) {
            continue;
        }
#ifdef Q_OS_MACOS
        if (name.startsWith(cuKeyword) == false) {
            continue;
        }
#endif
        // device ID must be int because of integration with QML
        const QByteArray deviceId = SerialDevice::createDeviceId(name);
        auto [iter, success] = ports.emplace(deviceId);
        if (success == false) {
            // Error: hash already exists!
            qCCritical(logCategoryPlatformManager).nospace().noquote()
                << "Cannot add device (hash conflict: " << deviceId << "): '" << name << "'";
            continue;
        }
        idToName.insert(deviceId, name);

        // qCDebug(logCategoryPlatformManager).nospace().noquote() << "Found serial device, ID: " << deviceId << ", name: '" << name << "'";
    }

    std::set<QByteArray> added, removed;
    std::vector<QByteArray> opened, deleted;

    {  // this block of code modifies serialPortsList_, openedDevices_, serialIdToName_
        QMutexLocker lock(&mutex_);

        serialIdToName_ = std::move(idToName);

        computeListDiff(ports, added, removed);  // uses serialPortsList_ (needs old value from previous run)

        // Do not emit boardDisconnected and boardConnected signals in this locked block of code.
        for (const auto& deviceId : removed) {
            if (removeDevice(deviceId)) {  // modifies openedDevices_ and reconnectTimers_
                deleted.emplace_back(deviceId);
            }
        }

        for (const auto& deviceId : added) {
            if (addSerialPort(deviceId)) {  // modifies openedDevices_, uses serialIdToName_
                opened.emplace_back(deviceId);
            } else {
                // If serial port cannot be opened (for example it is hold by another application),
                // remove it from list of known ports. There will be another attempt to open it in next round.
                ports.erase(deviceId);
            }
        }

        serialPortsList_ = std::move(ports);
    }

    for (const auto& deviceId : deleted) {
        emit boardDisconnected(deviceId);
    }
    for (const auto& deviceId : opened) {
        emit boardConnected(deviceId);
    }
}

// mutex_ must be locked before calling this function (due to accessing serialPortsList_)
void PlatformManager::computeListDiff(std::set<QByteArray>& list, std::set<QByteArray>& added_ports, std::set<QByteArray>& removed_ports) {
    //create differences of the lists.. what is added / removed
    std::set_difference(list.begin(), list.end(),
                        serialPortsList_.begin(), serialPortsList_.end(),
                        std::inserter(added_ports, added_ports.begin()));

    std::set_difference(serialPortsList_.begin(), serialPortsList_.end(),
                        list.begin(), list.end(),
                        std::inserter(removed_ports, removed_ports.begin()));
}

// mutex_ must be locked before calling this function (due to modification openedDevices_ and using serialIdToName_)
bool PlatformManager::addSerialPort(const QByteArray& deviceId) {
    // 1. construct the serial device
    // 2. open the device
    // 3. attach PlatformOperations object

    const QString name = serialIdToName_.value(deviceId);

    SerialDevice::SerialPortPtr serialPort = SerialDevice::establishPort(name);

    if (serialPort == nullptr) {
        qCInfo(logCategoryPlatformManager).nospace().noquote()
            << "Port for device: ID: " << deviceId << ", name: '" << name
            << "' cannot be open, it is probably hold by another application.";
        return false;
    }

    DevicePtr device = std::make_shared<SerialDevice>(deviceId, name, std::move(serialPort));

    if (openDevice(device) == false) {
        qCWarning(logCategoryPlatformManager).nospace().noquote()
            << "Cannot open device: ID: " << deviceId << ", name: '" << name << "'";
        return false;
    }
    qCInfo(logCategoryPlatformManager).nospace().noquote()
        << "Added new serial device: ID: " << deviceId << ", name: '" << name << "'";
    startPlatformOperations(device);
    return true;
}

// mutex_ must be locked before calling this function (due to modification openedDevices_)
bool PlatformManager::openDevice(const DevicePtr device) {
    if (device->open() == false) {
        return false;
    }
    openedDevices_.insert(device->deviceId(), device);

    connect(device.get(), &Device::deviceError, this, &PlatformManager::handleDeviceError);

    return true;
}

void PlatformManager::startPlatformOperations(const DevicePtr device) {
    startIdentifyOperation(device);

    connect(device.get(), &Device::msgFromDevice, this, &PlatformManager::checkNotification);
}

void PlatformManager::startIdentifyOperation(const DevicePtr device) {
    // shared_ptr because QHash::insert() calls copy constructor (unique_ptr has deleted copy constructor)
    // We need deleteLater() because PlatformOperations object is deleted
    // in slot connected to signal from it (PlatformManager::handleOperationFinished).
    std::shared_ptr<operation::BasePlatformOperation> operation (
        // Some boards need time for booting. If board is rebooted it also takes some time to start.
        new operation::Identify(device, reqFwInfoResp_, GET_FW_INFO_MAX_RETRIES, IDENTIFY_LAUNCH_DELAY),
        operationLaterDeleter
    );

    connect(operation.get(), &operation::BasePlatformOperation::finished, this, &PlatformManager::handleOperationFinished);

    identifyOperations_.insert(device->deviceId(), operation);

    operation->run();
}

// mutex_ must be locked before calling this function (due to modification openedDevices_ and reconnectTimers_)
bool PlatformManager::removeDevice(const QByteArray& deviceId) {
    identifyOperations_.remove(deviceId);

    // If device is physically disconnected, remove reconnect timer (if exists).
    auto timerIter = reconnectTimers_.find(deviceId);
    if (timerIter != reconnectTimers_.end()) {
        QTimer* reconnectTimer = timerIter.value();
        reconnectTimer->stop();
        delete reconnectTimer;
        reconnectTimers_.erase(timerIter);
        qCInfo(logCategoryPlatformManager).noquote() << "Removed timer for reconnecting device" << deviceId;
    }

    auto deviceIter = openedDevices_.find(deviceId);
    if (deviceIter != openedDevices_.end()) {
        deviceIter.value()->close();
        openedDevices_.erase(deviceIter);
        qCInfo(logCategoryPlatformManager).noquote() << "Removed serial device" << deviceId;
        return true;
    } else {
        return false;
    }
}

void PlatformManager::logInvalidDeviceId(const QString& message, const QByteArray& deviceId) const {
    qCWarning(logCategoryPlatformManager).nospace().noquote() << message << ", invalid device ID: " << deviceId;
}

void PlatformManager::handleOperationFinished(operation::Result result, int status, QString errStr) {
    Q_UNUSED(status)

    operation::BasePlatformOperation *baseOp = qobject_cast<operation::BasePlatformOperation*>(QObject::sender());
    if (baseOp == nullptr) {
        return;
    }

    if (baseOp->type() == operation::Type::Identify) {
        const QByteArray deviceId = baseOp->deviceId();

        // operation has finished, we do not need BasePlatformOperation object anymore
        identifyOperations_.remove(deviceId);

        if (result == operation::Result::Error) {
            emit boardError(deviceId, errStr);
        }

        // If identify operation is cancelled, another identify operation will be started soon.
        // So there is no need for emitting boardInfoChanged signal. (See handlePlatformIdChanged() function.)
        if (result != operation::Result::Cancel) {
            bool boardRecognized = (result == operation::Result::Success);
            emit boardInfoChanged(deviceId, boardRecognized);
            if (boardRecognized == false && keepDevicesOpen_ == false) {
                qCInfo(logCategoryPlatformManager).noquote()
                    << "Device" << deviceId << "was not recognized, going to release communication channel.";
                // Device cannot be removed in this slot (this slot is connected to signal emitted by device).
                // Remove it (and emit 'disconnected' signal) after return to main loop (when signal handling
                // is done and other slots connected to this signal are also done) - this is why is used single shot timer.
                QTimer::singleShot(0, this, [this, deviceId](){
                    disconnectDevice(deviceId);
                });
            }
        }
    }
}

void PlatformManager::handleDeviceError(Device::ErrorCode errCode, QString errStr) {
    Q_UNUSED(errStr)
    Device *device = qobject_cast<Device*>(QObject::sender());
    if (device == nullptr) {
        return;
    }
    // if serial device is unexpectedly disconnected, remove it
    if (errCode == Device::ErrorCode::SP_ResourceError) {
        disconnect(device, &Device::msgFromDevice, this, &PlatformManager::checkNotification);
        const QByteArray deviceId = device->deviceId();
        qCWarning(logCategoryPlatformManager).noquote() << "Interrupted connection with device" << deviceId;

        // Device cannot be removed in this slot (this slot is connected to signal emitted by device).
        // Remove it (and emit 'disconnected' signal) after return to main loop (when signal handling
        // is done and other slots connected to this signal are also done) - this is why is used single shot timer.
        QTimer::singleShot(0, this, [this, deviceId](){
            disconnectDevice(deviceId);
        });
    }
}

const rapidjson::SchemaDocument platformIdChangedSchema(
    CommandValidator::parseSchema(
R"(
{
  "$schema": "http://json-schema.org/draft-04/schema#",
  "type": "object",
  "properties": {
    "notification": {
      "type": "object",
      "properties": {
        "value": {"type": "string", "pattern": "^platform_id_changed$"}
      },
      "required": ["value"]
    }
  },
  "required": ["notification"]
}
)"
    )
);

void PlatformManager::checkNotification(QByteArray message) {
    Device *device = qobject_cast<Device*>(QObject::sender());
    if (device == nullptr) {
        return;
    }

    rapidjson::Document doc;
    if (CommandValidator::parseJsonCommand(message, doc, true) == false) {
        return;
    }
    if (CommandValidator::validateJsonWithSchema(platformIdChangedSchema, doc, true) == false) {
        return;
    }

    qCInfo(logCategoryPlatformManager).noquote()
        << "Received 'platform_id_changed' notification for device" << device->deviceId();

    emit platformIdChanged(device->deviceId(), QPrivateSignal());
}

void PlatformManager::handlePlatformIdChanged(const QByteArray& deviceId) {
    // method device() uses mutex_
    DevicePtr device = this->device(deviceId);
    if (device == nullptr) {
        return;
    }

    auto it = identifyOperations_.find(deviceId);
    if (it != identifyOperations_.end()) {
        it.value()->cancelOperation();
        // If operation is cancelled, finished is signal will be received (with Result::Cancel)
        // and operation will be removed from identifyOperations_ in handleOperationFinished slot.
    }

    startIdentifyOperation(device);
}

void PlatformManager::operationLaterDeleter(operation::BasePlatformOperation *operation) {
    operation->deleteLater();
}

}  // namespace

#pragma once

#include <chrono>

#include "BasePlatformCommand.h"

namespace strata::platform::command {

// This is special command used for waiting between commands in command list.
// There is also special handling of this command in BasePlatformOperation.

class CmdWait : public BasePlatformCommand {
public:
    CmdWait(const device::DevicePtr& device,
            std::chrono::milliseconds waitTime,
            const QString& description = QString());
    QByteArray message() override;
    bool processNotification(rapidjson::Document& doc) override;
    void setWaitTime(std::chrono::milliseconds waitTime);
    std::chrono::milliseconds waitTime() const;
    QString description() const;
private:
    std::chrono::milliseconds waitTime_;
    QString description_;
};

}  // namespace

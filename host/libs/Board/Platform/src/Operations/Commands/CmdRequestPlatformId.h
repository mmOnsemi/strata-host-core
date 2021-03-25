#ifndef CMD_REQUEST_PLATFORM_ID_H
#define CMD_REQUEST_PLATFORM_ID_H

#include "BasePlatformCommand.h"

namespace strata::platform::command {

class CmdRequestPlatformId : public BasePlatformCommand {
public:
    explicit CmdRequestPlatformId(const device::DevicePtr& device);
    QByteArray message() override;
    bool processNotification(rapidjson::Document& doc) override;
};

}  // namespace

#endif

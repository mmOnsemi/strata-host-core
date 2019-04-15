
#include <EvEvent.h>	//for r/w flags

#include "WinTimerEvent.h"

#if defined(_WIN32)

namespace spyglass {

WinTimerEvent::WinTimerEvent() : WinEventBase(2), hTimer_(NULL), timeInMs_(0), active_(false)
{
}

WinTimerEvent::~WinTimerEvent()
{
	if (hTimer_ != NULL) {
		::CloseHandle(hTimer_);
	}
}

bool WinTimerEvent::create(unsigned int timeInMs)
{
    if (hTimer_ != NULL) {
        return false;
    }

	hTimer_ = ::CreateWaitableTimer(NULL, TRUE, NULL);
    if (hTimer_ != NULL) {
        timeInMs_ = timeInMs;
    }

	return hTimer_ != NULL;
}

bool WinTimerEvent::activate(int flags)
{
    if (hTimer_ == NULL)
        return false;

    if (active_) {
        return true;
    }

    bool ret;
    if ((ret = setTimer()) == true) {
        active_ = true;
    }
    return ret;
}

void WinTimerEvent::deactivate()
{
    if (active_ == false) {
        return;
    }

	::CancelWaitableTimer(hTimer_);
    active_ = false;
}

bool WinTimerEvent::setTimer()
{
    LARGE_INTEGER time;
    time.QuadPart = (static_cast<int64_t>(timeInMs_ * 10000)) * -1;

    return ::SetWaitableTimer(hTimer_, &time, 0, NULL, NULL, FALSE) == TRUE;
}

ev2_handle_t WinTimerEvent::getWaitHandle()
{
	return reinterpret_cast<ev2_handle_t>(hTimer_);
}

void WinTimerEvent::restartTimer()
{
    setTimer();
}

} //namespace

#endif //defined(_WIN32)

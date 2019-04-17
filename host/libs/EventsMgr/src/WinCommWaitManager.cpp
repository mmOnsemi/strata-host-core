
#if !defined(_WIN32)
#error "This file is only for Widnows"
#endif

#include "WinCommWaitManager.h"
#include "EvEventBase.h"
#include "WinCommEvent.h"
#include "WinCommFakeEvent.h"
#include "WinTimerEvent.h"

#include <Windows.h>

#include <thread>
#include <assert.h>

namespace spyglass
{

unsigned int g_waitTimeout = 5000;  //in ms
unsigned int g_maxEventMapSize = MAXIMUM_WAIT_OBJECTS-1;

WinCommWaitManager::WinCommWaitManager() : hStopEvent_(NULL)
{
}

WinCommWaitManager::~WinCommWaitManager()
{
    if (hStopEvent_ != NULL) {
        ::CloseHandle(hStopEvent_);
    }
}

bool WinCommWaitManager::registerEvent(EvEventBase* ev)
{
    if (eventList_.size() >= g_maxEventMapSize) {
        return false;
    }

    //TODO: check for duplicates
    ev2_handle_t handle = ev->getWaitHandle();
    if (handle == NULL) {
        return false;
    }

    eventList_.push_back(std::make_pair(handle, ev));
    return true;
}

void WinCommWaitManager::unregisterEvent(EvEventBase* ev)
{
    std::list<event_pair>::iterator it;
    for (it = eventList_.begin(); it != eventList_.end(); ++it) {
        if (it->second == ev) {
            eventList_.erase(it);
            return;
        }
    }
}

void WinCommWaitManager::startInThread()
{
    if (hStopEvent_ == NULL) {
        hStopEvent_ = ::CreateEvent(NULL, TRUE, FALSE, NULL);
        if (hStopEvent_ == 0) {
            return;
        }
    }

    eventsThread_ = std::thread(&WinCommWaitManager::threadMain, this);
}

void WinCommWaitManager::stop()
{
    if (eventsThread_.get_id() == std::thread::id()) {
        return;
    }

    stopThread_ = true;
    ::SetEvent(hStopEvent_);

    eventsThread_.join();
}

int WinCommWaitManager::dispatch()
{
    int ret;
    DWORD dwCount = 0;
    HANDLE waitList[MAXIMUM_WAIT_OBJECTS];

    {
        std::lock_guard<std::mutex> lock(dispatchLock_);

        for (auto item : eventList_) {

            if (item.second->getType() == EvEventBase::EvType::eEvTypeWinHandle) {
                WinCommEvent* ev = static_cast<WinCommEvent*>(item.second);
                ret = ev->preDispatch();
                if (ret != 1)       //TODO: handle imedially dispatch..
                    continue;

            }

            waitList[dwCount] = item.first; dwCount++;
            if (dwCount >= (MAXIMUM_WAIT_OBJECTS-1))
                break;
        }

    }

    if (dwCount == 0) {
        return 0;
    }

    waitList[dwCount] = hStopEvent_; dwCount++;

    DWORD dwRet = ::WaitForMultipleObjects(dwCount, waitList, FALSE, g_waitTimeout);
    if (dwRet == WAIT_FAILED) {
        return -1;
    }
    else if (dwRet == WAIT_TIMEOUT) {

        //Loop over all ev and cancel the Wait...

        for (const auto& item : eventList_) {

            if (item.second->getType() == EvEventBase::EvType::eEvTypeWinHandle) {
                WinCommEvent* com = static_cast<WinCommEvent*>(item.second);
                com->cancelWait();
            }
        }

        return 0;
    }
    else if (dwRet >= WAIT_OBJECT_0 && dwRet < (WAIT_OBJECT_0 + dwCount)) {

        // check witch one is signaled..
        HANDLE hSignaled = waitList[(dwRet - WAIT_OBJECT_0)];
        if (hSignaled == hStopEvent_) {
            return 0;
        }

        EvEventBase* ev;
        std::list<event_pair>::iterator findIt;
        {
            std::lock_guard<std::mutex> lock(dispatchLock_);
            for(findIt = eventList_.begin(); findIt != eventList_.end(); ++findIt) {
                if (findIt->first == hSignaled) {
                    break;
                }
            }

            if (findIt == eventList_.end()) {
                assert(false);     //Something really wrong!
                return -1;
            }

            ev = findIt->second;
        }

        int flags = 0;
        if (ev->getType() == EvEventBase::EvType::eEvTypeWinHandle) {
            WinCommEvent* com = static_cast<WinCommEvent*>(ev);
            flags = com->getEvFlagsState();
        }
        else if (ev->getType() == EvEventBase::EvType::eEvTypeWinFakeHandle) {
            WinCommFakeEvent* com = static_cast<WinCommFakeEvent*>(ev);
            flags = com->getEvFlagsState();
        }

        ev->handle_event(flags);

        //reset wait event, and loop WaitFor... ??

        if (ev->getType() == EvEventBase::EvType::eEvTypeWinHandle) {
            WinCommEvent* com = static_cast<WinCommEvent*>(ev);
            com->cancelWait();
        }
        else if (ev->getType() == EvEventBase::EvType::eEvTypeWinTimer) {
            WinTimerEvent* timer = static_cast<WinTimerEvent*>(ev);
            timer->restartTimer();
        }

        if (eventList_.size() > 1) {

            //NOTE: move signalled event to back of the event list
            //      to avoid signalling one and the same event
            std::lock_guard<std::mutex> lock(dispatchLock_);
            event_pair temp = *findIt;

            eventList_.erase(findIt);
            eventList_.push_back(temp);
        }

        return 1;
    }

    return -2;
}

void WinCommWaitManager::threadMain()
{
    //TODO: put this in log:  std::cout << "Start thread.." << std::endl;

    int ret;
    while (!stopThread_) {
        ret = dispatch();
        if (ret < 0)
            break;

    }

    //TODO: put this in log:  std::cout << "Stop thread." << std::endl;
}


} //namespace spyglass

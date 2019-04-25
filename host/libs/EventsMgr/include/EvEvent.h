#ifndef STRATA_EVENTS_MGR_EVENT_H
#define STRATA_EVENTS_MGR_EVENT_H

#include <mutex>
#include <functional>
#include <cstdio>

#include "EvEventBase.h"

#if defined(_WIN32)
#include <WinSock2.h>
#endif

struct event;

namespace spyglass
{

class EvEventsMgr;

//////////////////////////////////////////////////////////////////

class EvEvent : public EvEventBase
{
public:
    EvEvent();

    /**
     * Constructor
     * @param type type of event
     * @param fileHandle file handle or -1 for undefined
     * @param timeInMs timeout or 0 for undefined
     */
    EvEvent(EvType type, ev_handle_t fileHandle, unsigned int timeInMs);
    ~EvEvent();

    /**
     * Sets the event type
     * @param type type of the event (Timer and Handle is now supported)
     * @param fileHandle filehandle or -1 for undefined
     * @param timeInMs timeout for event or 0 for undefined
     */
    void set(EvType type, ev_handle_t fileHandle, unsigned int timeInMs);

    /**
     * Sets the dispatcher for event
     * @param mgr
     */
    void setDispatcher(EvEventsMgr* mgr);

    /**
     * returns wait handle, in this case invalid
     */
    ev_handle_t getWaitHandle() override;

    /**
     * Activates the event in EvEventMgr
     * @param ev_flags flags see enum EvTypeFlags
     * @return
     */
    bool activate(int ev_flags = 0) override;

    /**
     * Deactivates event, removes from event_loop
     */
    void deactivate() override;

    /**
     * returns activation flags
     * @return returns true when flags are set otherwise false
     */
    int getActivationFlags() override;

    /**
     * Checks event activation flags
     * @param ev_flags flags to check
     * @return returns true when flags are set otherwise false
     */
    bool isActive(int ev_flags) const override;    //TODO: probably better name...

    /**
     * Fires the event
     * @param ev_flags flags see enum EvTypeFlags
     */
    void fire(int ev_flags = 0);

    /**
     * Static method to convert time in miliseconds into 'struct timeval'
     * @param msecs time in miliseconds
     * @return converted time
     */
    static struct timeval tvMsecs(unsigned int msecs);

private:
    unsigned int timeInMs_;
    ev_handle_t fileHandle_;

    struct event* event_ = nullptr;
    EvEventsMgr* mgr_ = nullptr;

    bool active_ = false;       //status if event is in some event_base queue
    std::mutex lock_;
};


} //end of namespace

#endif //STRATA_EVENTS_MGR_EVENT_H

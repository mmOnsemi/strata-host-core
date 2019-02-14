
#ifndef PROJECT_EVENTSMGR_H
#define PROJECT_EVENTSMGR_H

#include <functional>
#include <thread>
#include <mutex>
#include <atomic>

struct event_base;
struct event;

//a copy from libevent2
#if defined(_WIN32)
#define evutil_socket_t intptr_t
#else
#define evutil_socket_t int
#endif

namespace spyglass
{

#ifdef _WIN32
typedef intptr_t ev_handle_t;
#else
typedef int      ev_handle_t;
#endif

class EvEventsMgr;

//////////////////////////////////////////////////////////////////

class EvEvent
{
public:
    enum EvType {
        eEvTypeUnknown = 0,
        eEvTypeTimer,
        eEvTypeHandle,
        eEvTypeSignal       //Linux or Mac only
    };

    enum EvTypeFlags {   //flags for event type occured
        eEvStateRead  = 1,
        eEvStateWrite = 2,
        eEvStateTimeout = 4,
    };

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
     * Sets callback function for this event
     * @param callback function to call
     */
    void setCallback(std::function<void(EvEvent*, int)> callback);

    /**
     * Activates the event in EvEventMgr
     * @param mgr event manager to attach
     * @param ev_flags flags see enum EvTypeFlags
     * @return
     */
    bool activate(EvEventsMgr* mgr, int ev_flags = 0);

    /**
     * Deactivates event, removes from event_loop
     */
    void deactivate();

    /**
     * Checks event activation flags
     * @param ev_flags flags to check
     * @return returns true when flags are set otherwise false
     */
    bool isActive(int ev_flags) const;    //TODO: probably better name...

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

protected:

    void event_notification(int flags);

private:
    EvType type_;
    unsigned int timeInMs_;
    ev_handle_t fileHandle_;

    struct event* event_ = nullptr;

    std::function<void(EvEvent*, int)> callback_;
    bool active_ = false;       //status if event is in some event_base queue
    std::mutex lock_;

    friend void evEventsCallback(evutil_socket_t fd, short what, void* arg);
};

//////////////////////////////////////////////////////////////////

class EvEventsMgr
{
public:
    EvEventsMgr();
    ~EvEventsMgr();

    /**
     * Creates event for a filehandle
     * @param fd file handle
     * @return returns new event
     */
    EvEvent* CreateEventHandle(ev_handle_t fd);

    /**
     * Creates event for a timeout
     * @param timeInMs timeour in miliseconds
     * @return returns new event
     */
    EvEvent* CreateEventTimer(unsigned int timeInMs);

    /**
     * Starts dispatch loop with given flags
     * @param flags - not used at the moment
     */
    void dispatch(int flags = 0);

    /**
     * Starts dispatch loop in second thread and returns
     */
    void startInThread();

    /**
     * Stops thread with dispatch loop
     */
    void stop();

    struct event_base* base() const { return event_base_; }

private:
    void threadMain();

private:
    std::thread eventsThread_;
    std::atomic_bool stopThread_{false};

private:
    struct event_base* event_base_;

};

} //end of namespace


#endif //PROJECT_EVENTSMGR_H

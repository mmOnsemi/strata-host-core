#include "ZmqDealerConnector.h"
#include <zmq.hpp>

namespace strata::connector
{

ZmqDealerConnector::ZmqDealerConnector() : ZmqConnector(ZMQ_DEALER)
{
    CONNECTOR_DEBUG_LOG("%s Creating connector object\n", "ZMQ_DEALER");
}

ZmqDealerConnector::~ZmqDealerConnector()
{
}

bool ZmqDealerConnector::open(const std::string& ip_address)
{
    if (false == socketConnected()) {
        return false;
    }

    const std::string& id = getDealerID();
    if (false == id.empty() && 0 != socketSetOptLegacy(ZMQ_IDENTITY, id.c_str(), id.length())) {
        return false;
    }

    int linger = 0;
    if (0 == socketSetOptInt(zmq::sockopt::linger, linger) &&
        0 == socketConnect(ip_address)) {
        CONNECTOR_DEBUG_LOG("%s Connecting to the server socket %s(ID:%s)\n", "ZMQ_DEALER",
                            ip_address.c_str(), getDealerID().c_str());
        setConnectionState(true);
        return true;
    }

    return false;
}

}  // namespace strata::connector

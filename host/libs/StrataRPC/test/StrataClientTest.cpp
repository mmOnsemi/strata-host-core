#include "StrataClientTest.h"

#include "ServerConnector.h"

void StrataClientTest::waitForZmqMessages(int delay)
{
    QTimer timer;
    timer.setSingleShot(true);
    timer.start(delay);
    do {
        QCoreApplication::processEvents(QEventLoop::WaitForMoreEvents);
    } while (timer.isActive());
}

void StrataClientTest::testRegisterAndUnregisterHandlers()
{
    StrataClient client(address_);

    // register new handler
    QVERIFY_(
        client.registerHandler("handler_1", [](const strata::strataRPC::Message &) { return; }));
    QVERIFY_(
        client.registerHandler("handler_2", [](const strata::strataRPC::Message &) { return; }));
    QVERIFY_(false == client.registerHandler("handler_2",
                                             [](const strata::strataRPC::Message &) { return; }));

    QVERIFY_(client.unregisterHandler("handler_1"));
    QVERIFY_(client.unregisterHandler("handler_2"));
    QVERIFY_(false == client.unregisterHandler("handler_2"));
    QVERIFY_(false == client.unregisterHandler("not_registered_handler"));
}

void StrataClientTest::testConnectDisconnectToTheServer()
{
    // serverConnector set up
    strata::strataRPC::ServerConnector server(address_);
    server.initilizeConnector();
    bool serverRevicedMessage = false;
    connect(
        &server, &strata::strataRPC::ServerConnector::newMessageReceived, this,
        [&server, &serverRevicedMessage](const QByteArray &clientId, const QByteArray &message) {
            qDebug() << "ServerConnector new message handler. client id:" << clientId << "message"
                     << message;
            serverRevicedMessage = true;
            server.sendMessage(clientId, message);
        });

    // StrataClient set up
    StrataClient client(address_);

    bool clientReceivedMessage = false;
    connect(&client, &StrataClient::newServerMessageParsed, this,
            [&clientReceivedMessage] { clientReceivedMessage = true; });

    serverRevicedMessage = false;
    clientReceivedMessage = false;
    QVERIFY_(client.connectServer());
    waitForZmqMessages();
    QVERIFY_(serverRevicedMessage);
    QVERIFY_(clientReceivedMessage);

    serverRevicedMessage = false;
    clientReceivedMessage = false;
    QVERIFY_(client.disconnectServer());
    waitForZmqMessages();
    QVERIFY_(serverRevicedMessage);
    QVERIFY_(false == clientReceivedMessage);

    serverRevicedMessage = false;
    clientReceivedMessage = false;
    server.sendMessage("StrataClient", "test message");
    waitForZmqMessages();
    QVERIFY_(false == serverRevicedMessage);
    QVERIFY_(false == clientReceivedMessage);

    serverRevicedMessage = false;
    clientReceivedMessage = false;
    QVERIFY_(client.connectServer());
    waitForZmqMessages();
    QVERIFY_(serverRevicedMessage);
    QVERIFY_(clientReceivedMessage);
}

void StrataClientTest::testBuildRequest()
{
    // some variables used for validation.
    bool serverRevicedMessage = false;
    QString expectedMethod = "";
    int expectedId = 0;

    strata::strataRPC::ServerConnector server(address_);
    server.initilizeConnector();
    connect(&server, &strata::strataRPC::ServerConnector::newMessageReceived, this,
            [&expectedId, &expectedMethod, &serverRevicedMessage](const QByteArray &,
                                                                  const QByteArray &message) {
                QJsonObject jsonObject(QJsonDocument::fromJson(message).object());

                QVERIFY_(jsonObject.contains("jsonrpc"));
                QVERIFY_(jsonObject.value("jsonrpc").isString());

                QVERIFY_(jsonObject.contains("id"));
                QVERIFY_(jsonObject.value("id").isDouble());
                QCOMPARE_(jsonObject.value("id").toDouble(), expectedId);

                QVERIFY_(jsonObject.contains("method"));
                QVERIFY_(jsonObject.value("method").isString());
                QCOMPARE_(jsonObject.value("method").toString(), expectedMethod);

                QVERIFY_(jsonObject.contains("params"));
                QVERIFY_(jsonObject.value("params").isObject());

                serverRevicedMessage = true;
            });

    StrataClient client(address_);

    expectedMethod = "register_client";
    expectedId = 1;
    serverRevicedMessage = false;
    client.connectServer();
    waitForZmqMessages();
    QVERIFY_(serverRevicedMessage);

    expectedMethod = "method_1";
    expectedId = 2;
    serverRevicedMessage = false;
    auto requestInfo_1 = client.sendRequest("method_1", {{"param_1", 0}});
    QVERIFY_(true == requestInfo_1.first);
    QVERIFY_(requestInfo_1.second != 0);
    waitForZmqMessages();
    QVERIFY_(serverRevicedMessage);

    expectedMethod = "method_2";
    expectedId = 3;
    serverRevicedMessage = false;
    auto requestInfo_2 = client.sendRequest("method_2", {});
    QVERIFY_(true == requestInfo_2.first);
    QVERIFY_(requestInfo_2.second != 0);
    waitForZmqMessages();
    QVERIFY_(serverRevicedMessage);
}

void StrataClientTest::testNonDefaultDealerId()
{
    bool defaultIdRecieved = false;
    bool customIdRecieved = false;

    strata::strataRPC::ServerConnector server(address_);
    server.initilizeConnector();

    connect(
        &server, &strata::strataRPC::ServerConnector::newMessageReceived, this,
        [&defaultIdRecieved, &customIdRecieved](const QByteArray &clientId, const QByteArray &) {
            if (clientId == "customId") {
                customIdRecieved = true;
            } else if (clientId == "StrataClient") {
                defaultIdRecieved = true;
            }
        });

    StrataClient client_1(address_);
    client_1.connectServer();

    StrataClient client_2(address_, "customId");
    client_2.connectServer();

    waitForZmqMessages();
    QVERIFY_(defaultIdRecieved);
    QVERIFY_(customIdRecieved);
}
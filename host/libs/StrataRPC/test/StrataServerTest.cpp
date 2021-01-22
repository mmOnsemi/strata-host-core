#include "StrataServerTest.h"
#include "ClientConnector.h"

void StrataServerTest::testValidApiVer2Message()
{
    StrataServer server(address_, false);
    bool validMessage = false;
    connect(this, &StrataServerTest::mockNewMessageReceived, &server,
            &StrataServer::newClientMessage);

    // Connect a handler to verify that the message got parsed and the dispatch signal got emitted.
    connect(&server, &StrataServer::newClientMessageParsed, this,
            [&validMessage]() { validMessage = true; });

    // This will register the client and sets the api as v2
    validMessage = false;
    emit mockNewMessageReceived(
        "AAA",
        R"({"jsonrpc": "2.0","method":"register_client","params":{"api_version": "1.0"},"id":1})");
    QVERIFY_(validMessage);

    validMessage = false;
    emit mockNewMessageReceived(
        "AAA",
        R"({"jsonrpc": "2.0","method":"register_client","params":{"api_version": "1.0"},"id":1})");
    QVERIFY_(validMessage);

    validMessage = false;
    emit mockNewMessageReceived(
        "AAA",
        R"({"jsonrpc": "2.0","method":"register_client","params":{"api_version": "1.0"},"id":1})");
    QVERIFY_(validMessage);

    validMessage = false;
    emit mockNewMessageReceived(
        "AAA",
        R"({"jsonrpc": "2.0","method":"register_client","params":{"api_version": "1.0"},"id":1})");
    QVERIFY_(validMessage);

    validMessage = false;
    emit mockNewMessageReceived("AAA", R"({"cmd":"load_documents","payload":{}})");
    QVERIFY_(false == validMessage);

    validMessage = false;
    emit mockNewMessageReceived("AAA", R"()");
    QVERIFY_(false == validMessage);

    validMessage = false;
    emit mockNewMessageReceived("AAA", R"(0000)");
    QVERIFY_(false == validMessage);

    validMessage = false;
    emit mockNewMessageReceived("AAA", R"(invalid message)");
    QVERIFY_(false == validMessage);

    validMessage = false;
    emit mockNewMessageReceived(
        "AAA",
        R"({"jsonrpc": 2.0,"method":"register_client","params":{"api_version": "1.0"},"id":1})");
    QVERIFY_(false == validMessage);
}

void StrataServerTest::testValidApiVer1Message()
{
    StrataServer server(address_, false);
    bool validMessage = false;
    connect(this, &StrataServerTest::mockNewMessageReceived, &server,
            &StrataServer::newClientMessage);
    connect(&server, &StrataServer::newClientMessageParsed, this,
            [&validMessage]() { validMessage = true; });

    // This will register the client and sets the api as v1
    validMessage = false;
    emit mockNewMessageReceived("AAA", R"({"cmd":"register_client", "payload":{}})");
    QVERIFY_(validMessage);

    validMessage = false;
    emit mockNewMessageReceived("AAA", R"({"cmd":"load_documents","payload":{}})");
    QVERIFY_(validMessage);

    validMessage = false;
    emit mockNewMessageReceived("AAA", R"({"sscmd":"load_documents","payload":{}})");
    QVERIFY_(false == validMessage);

    validMessage = false;
    emit mockNewMessageReceived("AAA", R"({"cmd":0,"payload":{}})");
    QVERIFY_(false == validMessage);

    validMessage = false;
    emit mockNewMessageReceived(
        "AAA",
        R"({"jsonrpc": "2.0","method":"register_client","params":{"api_version": "1.0"},"id":1})");
    QVERIFY_(false == validMessage);

    validMessage = false;
    emit mockNewMessageReceived("AAA", R"()");
    QVERIFY_(false == validMessage);

    validMessage = false;
    emit mockNewMessageReceived("AAA", R"(0000)");
    QVERIFY_(false == validMessage);

    validMessage = false;
    emit mockNewMessageReceived("AAA", R"(invalid message)");
    QVERIFY_(false == validMessage);
}

void StrataServerTest::testFloodTheServer()
{
    // QSKIP("too large to during development");
    StrataServer server(address_, false);
    int counter = 0;
    int testSize = 1000;
    connect(this, &StrataServerTest::mockNewMessageReceived, &server,
            &StrataServer::newClientMessage);
    connect(&server, &StrataServer::newClientMessageParsed, this, [&counter]() { counter++; });

    for (int i = 0; i < testSize; i++) {
        emit mockNewMessageReceived(QByteArray::number(i),
                                    R"({"cmd":"register_client", "payload":{}})");
    }

    QCOMPARE_(counter, testSize);
}

void StrataServerTest::testServerFunctionality()
{
    StrataServer server(address_, false);
    QVERIFY_(server.initializeServer());

    // add a handler to handler the client message.
    // add a handler to create a response
    server.registerHandler("register_client", [&server](const strata::strataRPC::Message &message) {
        server.notifyClient(message, {{"status", "client registered."}},
                            strata::strataRPC::ResponseType::Response);
    });

    bool clientGotResponse = false;
    strata::strataRPC::ClientConnector client(address_, "AA");
    connect(
        &client, &strata::strataRPC::ClientConnector::newMessageReceived, this,
        [&clientGotResponse](const QByteArray &message) {
            QCOMPARE_(
                message,
                "{\"id\":1,\"jsonrpc\":\"2.0\",\"result\":{\"status\":\"client registered.\"}}");
            clientGotResponse = true;
        });
    client.initializeConnector();
    client.sendMessage(
        R"({"jsonrpc": "2.0","method":"register_client","params": {"api_version": "1.0"},"id":1})");

    bool clientGotResponse_2 = false;
    strata::strataRPC::ClientConnector client_2(address_, "BB");
    connect(&client_2, &strata::strataRPC::ClientConnector::newMessageReceived, this,
            [&clientGotResponse_2](const QByteArray &message) {
                QCOMPARE_(message,
                          "{\"hcs::notification\":{\"status\":\"client "
                          "registered.\",\"type\":\"register_client\"}}");
                clientGotResponse_2 = true;
            });
    client_2.initializeConnector();
    client_2.sendMessage(R"({"cmd":"register_client", "payload":{}})");

    waitForZmqMessages();

    QVERIFY_(clientGotResponse);
    QVERIFY_(clientGotResponse_2);
}

void StrataServerTest::testBuildNotificationApiV2()
{
    bool testExecuted = false;
    StrataServer server(address_, false);
    QVERIFY_(server.initializeServer());

    strata::strataRPC::ClientConnector client(address_, "AA");
    client.initializeConnector();
    connect(&client, &strata::strataRPC::ClientConnector::newMessageReceived, this,
            [&testExecuted](const QByteArray &message) {
                QJsonParseError jsonParseError;
                QJsonDocument jsonDocument = QJsonDocument::fromJson(message, &jsonParseError);
                QVERIFY_(jsonParseError.error == QJsonParseError::NoError);
                QJsonObject jsonObject = jsonDocument.object();

                QVERIFY_(jsonObject.contains("jsonrpc"));
                QVERIFY_(jsonObject.value("jsonrpc").isString());

                QVERIFY_(jsonObject.contains("method"));
                QVERIFY_(jsonObject.value("method").isString());

                QVERIFY_(jsonObject.contains("params"));
                QVERIFY_(jsonObject.value("params").isObject());
                testExecuted = true;
            });

    client.sendMessage(
        R"({"jsonrpc": "2.0","method":"register_client","params": {"api_version": "1.0"},"id":1})");

    server.registerHandler("test_notification",
                           [&server](const strata::strataRPC::Message &message) {
                               server.notifyClient(message, {{"key", "value"}, {"test", "test"}},
                                                   strata::strataRPC::ResponseType::Notification);
                           });

    client.sendMessage(R"({"jsonrpc": "2.0","method":"test_notification","params":{},"id":2})");

    waitForZmqMessages();

    QVERIFY_(testExecuted);
}

void StrataServerTest::testBuildResponseApiV2()
{
    bool testExecuted = false;
    StrataServer server(address_, false);
    QVERIFY_(server.initializeServer());

    strata::strataRPC::ClientConnector client(address_, "AA");
    client.initializeConnector();
    connect(&client, &strata::strataRPC::ClientConnector::newMessageReceived, this,
            [&testExecuted](const QByteArray &message) {
                QJsonParseError jsonParseError;
                QJsonDocument jsonDocument = QJsonDocument::fromJson(message, &jsonParseError);
                QVERIFY_(jsonParseError.error == QJsonParseError::NoError);
                QJsonObject jsonObject = jsonDocument.object();

                QVERIFY_(jsonObject.contains("jsonrpc"));
                QVERIFY_(jsonObject.value("jsonrpc").isString());

                QVERIFY_(jsonObject.contains("id"));
                QVERIFY_(jsonObject.value("id").isDouble());

                QVERIFY_(jsonObject.contains("result"));
                QVERIFY_(jsonObject.value("result").isObject());
                testExecuted = true;
            });

    client.sendMessage(
        R"({"jsonrpc": "2.0","method":"register_client","params": {"api_version": "1.0"},"id":1})");

    server.registerHandler("test_response", [&server](const strata::strataRPC::Message &message) {
        server.notifyClient(message, {{"key", "value"}, {"test", "test"}},
                            strata::strataRPC::ResponseType::Response);
    });

    client.sendMessage(R"({"jsonrpc": "2.0","method":"test_response","params":{},"id":1})");

    waitForZmqMessages();

    QVERIFY_(testExecuted);
}

void StrataServerTest::testBuildErrorApiV2()
{
    bool testExecuted = false;
    StrataServer server(address_, false);
    QVERIFY_(server.initializeServer());

    strata::strataRPC::ClientConnector client(address_, "AA");
    client.initializeConnector();
    connect(&client, &strata::strataRPC::ClientConnector::newMessageReceived, this,
            [&testExecuted](const QByteArray &message) {
                QJsonParseError jsonParseError;
                QJsonDocument jsonDocument = QJsonDocument::fromJson(message, &jsonParseError);
                QVERIFY_(jsonParseError.error == QJsonParseError::NoError);
                QJsonObject jsonObject = jsonDocument.object();

                QVERIFY_(jsonObject.contains("jsonrpc"));
                QVERIFY_(jsonObject.value("jsonrpc").isString());

                QVERIFY_(jsonObject.contains("id"));
                QVERIFY_(jsonObject.value("id").isDouble());

                QVERIFY_(jsonObject.contains("error"));
                QVERIFY_(jsonObject.value("error").isObject());
                testExecuted = true;
            });

    client.sendMessage(
        R"({"jsonrpc": "2.0","method":"register_client","params": {"api_version": "1.0"},"id":1})");

    server.registerHandler("test_error", [&server](const strata::strataRPC::Message &message) {
        server.notifyClient(message, {{"key", "value"}, {"test", "test"}},
                            strata::strataRPC::ResponseType::Error);
    });

    client.sendMessage(R"({"jsonrpc": "2.0","method":"test_error","params":{},"id":3})");

    // verify that the thing is valid in the handlers.
    waitForZmqMessages();

    QVERIFY_(testExecuted);
}

void StrataServerTest::testBuildPlatformMessageApiV2()
{
    bool testExecuted = false;
    StrataServer server(address_, false);
    QVERIFY_(server.initializeServer());

    strata::strataRPC::ClientConnector client(address_, "AA");
    client.initializeConnector();
    connect(&client, &strata::strataRPC::ClientConnector::newMessageReceived, this,
            [&testExecuted](const QByteArray &message) {
                QJsonParseError jsonParseError;
                QJsonDocument jsonDocument = QJsonDocument::fromJson(message, &jsonParseError);
                QVERIFY_(jsonParseError.error == QJsonParseError::NoError);
                QJsonObject jsonObject = jsonDocument.object();

                QVERIFY_(jsonObject.contains("jsonrpc"));
                QVERIFY_(jsonObject.value("jsonrpc").isString());

                QVERIFY_(jsonObject.contains("method"));
                QVERIFY_(jsonObject.value("method").isString());
                QVERIFY_(jsonObject.value("method") == "platform_notification");

                QVERIFY_(jsonObject.contains("params"));
                QVERIFY_(jsonObject.value("params").isObject());
                testExecuted = true;
            });

    client.sendMessage(
        R"({"jsonrpc": "2.0","method":"register_client","params": {"api_version": "1.0"},"id":1})");

    server.registerHandler(
        "platform_notification", [&server](const strata::strataRPC::Message &message) {
            server.notifyClient(message, {{"key", "value"}, {"test", "test"}},
                                strata::strataRPC::ResponseType::PlatformMessage);
        });

    client.sendMessage(R"({"jsonrpc": "2.0","method":"platform_notification","params":{},"id":4})");

    waitForZmqMessages();

    QVERIFY_(testExecuted);
}

void StrataServerTest::testBuildNotificationApiV1()
{
    bool testExecuted = false;
    StrataServer server(address_, false);
    QVERIFY_(server.initializeServer());

    strata::strataRPC::ClientConnector client(address_, "AA");
    client.initializeConnector();
    connect(&client, &strata::strataRPC::ClientConnector::newMessageReceived, this,
            [&testExecuted](const QByteArray &message) {
                QJsonParseError jsonParseError;
                QJsonDocument jsonDocument = QJsonDocument::fromJson(message, &jsonParseError);
                QVERIFY_(jsonParseError.error == QJsonParseError::NoError);
                QJsonObject jsonObject = jsonDocument.object();

                QVERIFY_(jsonObject.contains("hcs::notification"));
                QVERIFY_(jsonObject.value("hcs::notification").isObject());
                QVERIFY_(jsonObject.value("hcs::notification").toObject().contains("type"));
                testExecuted = true;
            });

    client.sendMessage(R"({"cmd":"register_client", "payload":{}})");

    server.registerHandler("test_notification",
                           [&server](const strata::strataRPC::Message &message) {
                               server.notifyClient(message, {{"key", "value"}, {"test", "test"}},
                                                   strata::strataRPC::ResponseType::Notification);
                           });

    client.sendMessage(R"({"hcs::cmd":"test_notification","payload":{}})");

    waitForZmqMessages();

    QVERIFY_(testExecuted);
}

void StrataServerTest::testBuildResponseApiV1()
{
    bool testExecuted = false;
    StrataServer server(address_, false);
    QVERIFY_(server.initializeServer());

    strata::strataRPC::ClientConnector client(address_, "AA");
    client.initializeConnector();
    connect(&client, &strata::strataRPC::ClientConnector::newMessageReceived, this,
            [&testExecuted](const QByteArray &message) {
                QJsonParseError jsonParseError;
                QJsonDocument jsonDocument = QJsonDocument::fromJson(message, &jsonParseError);
                QVERIFY_(jsonParseError.error == QJsonParseError::NoError);
                QJsonObject jsonObject = jsonDocument.object();

                QVERIFY_(jsonObject.contains("hcs::notification"));
                QVERIFY_(jsonObject.value("hcs::notification").isObject());
                QVERIFY_(jsonObject.value("hcs::notification").toObject().contains("type"));
                testExecuted = true;
            });

    client.sendMessage(R"({"cmd":"register_client", "payload":{}})");

    server.registerHandler("test_response", [&server](const strata::strataRPC::Message &message) {
        server.notifyClient(message, {{"key", "value"}, {"test", "test"}},
                            strata::strataRPC::ResponseType::Response);
    });

    client.sendMessage(R"({"hcs::cmd":"test_response","payload":{}})");

    waitForZmqMessages();

    QVERIFY_(testExecuted);
}

void StrataServerTest::testParsePlatformMessageAPIv1()
{
    StrataServer server(address_, false);
    bool handlerCalled = false;
    QString currentCommandName = "";

    server.registerHandler("platform_message", [&handlerCalled, &currentCommandName](
                                                   const strata::strataRPC::Message &message) {
        QCOMPARE_(message.payload.value("message").toObject().value("cmd").toString(),
                  currentCommandName);
        handlerCalled = true;
    });

    QVERIFY_(server.initializeServer());

    handlerCalled = false;
    currentCommandName = "test_1";
    server.newClientMessage(
        "AA", R"({"cmd":"test_1","payload":{"enable":"off"},"device_id":-949921126})");
    QVERIFY_(handlerCalled);

    handlerCalled = false;
    currentCommandName = "test_2";
    server.newClientMessage("AA", R"({"cmd":"test_2","payload":"enable","device_id":-949921126})");
    QVERIFY_(handlerCalled);

    handlerCalled = false;
    currentCommandName = "test_3";
    server.newClientMessage("AA", R"({"cmd":"test_3","device_id":-949921126})");
    QVERIFY_(handlerCalled);

    handlerCalled = false;
    currentCommandName = "test_4";
    server.newClientMessage("AA", R"({"cmd":"test_4"})");
    QVERIFY_(false == handlerCalled);
}

void StrataServerTest::testBuildPlatformMessageApiV1()
{
    bool testExecuted = false;
    StrataServer server(address_, false);
    QVERIFY_(server.initializeServer());

    strata::strataRPC::ClientConnector client(address_, "AA");
    client.initializeConnector();
    connect(&client, &strata::strataRPC::ClientConnector::newMessageReceived, this,
            [&testExecuted](const QByteArray &message) {
                QJsonParseError jsonParseError;
                QJsonDocument jsonDocument = QJsonDocument::fromJson(message, &jsonParseError);
                QVERIFY_(jsonParseError.error == QJsonParseError::NoError);
                QJsonObject jsonObject = jsonDocument.object();

                QVERIFY_(jsonObject.contains("notification"));
                QVERIFY_(jsonObject.value("notification").isObject());
                testExecuted = true;
            });

    client.sendMessage(R"({"cmd":"register_client", "payload":{}})");

    server.registerHandler(
        "platform_notification", [&server](const strata::strataRPC::Message &message) {
            server.notifyClient(message, {{"key", "value"}, {"test", "test"}},
                                strata::strataRPC::ResponseType::PlatformMessage);
        });

    client.sendMessage(R"({"hcs::cmd":"platform_notification","payload":{}})");

    waitForZmqMessages();

    QVERIFY_(testExecuted);
}

void StrataServerTest::testNotifyAllClients()
{
    QTimer timer;
    StrataServer server(address_, false);
    std::vector<strata::strataRPC::ClientConnector *> clientsList;
    int counter = 0;
    int clientsCount = 10;

    QVERIFY_(server.initializeServer());

    // half the clients use API v2
    for (int i = 0; i < clientsCount / 2; i++) {
        clientsList.push_back(
            new strata::strataRPC::ClientConnector(address_, QByteArray::number(i)));
        clientsList.back()->initializeConnector();
        connect(clientsList.back(), &strata::strataRPC::ClientConnector::newMessageReceived, this,
                [&counter](const QByteArray &message) {
                    // validate for API v2
                    // expected response format:
                    // {
                    //     "jsonrpc": "2.0",
                    //     "method": "test_broadcast",
                    //     "params": {
                    //         "test": "test"
                    //     }
                    // }

                    QJsonDocument jsonDocument = QJsonDocument::fromJson(message);
                    QJsonObject jsonObject = jsonDocument.object();

                    QVERIFY_(jsonObject.contains("jsonrpc"));
                    QVERIFY_(jsonObject.contains("method"));
                    QVERIFY_(jsonObject.contains("params"));
                    QVERIFY_(jsonObject.value("params").isObject());

                    QCOMPARE_(jsonObject.value("jsonrpc").toString(), "2.0");
                    QCOMPARE_(jsonObject.value("method").toString(), "test_broadcast");

                    QJsonObject tempExpectedPayload{{"test", "test"}};
                    QCOMPARE_(jsonObject.value("params").toObject(), tempExpectedPayload);
                    counter++;
                });
        clientsList[i]->sendMessage(
            R"({"jsonrpc": "2.0","method":"register_client","params": {"api_version": "1.0"},"id":1})");
    }

    // other half uses API v1
    for (int i = clientsCount / 2; i < clientsCount; i++) {
        clientsList.push_back(
            new strata::strataRPC::ClientConnector(address_, QByteArray::number(i)));
        clientsList.back()->initializeConnector();
        connect(clientsList.back(), &strata::strataRPC::ClientConnector::newMessageReceived, this,
                [&counter](const QByteArray &message) {
                    // validate for API v1
                    // expected response format:
                    // {
                    //     "hcs::notification": {
                    //         "type": "test_broadcast",
                    //         "test": "test"
                    //     }
                    // }

                    QJsonDocument jsonDocument = QJsonDocument::fromJson(message);
                    QJsonObject jsonObject = jsonDocument.object();

                    QVERIFY_(jsonObject.contains("hcs::notification"));
                    QVERIFY_(jsonObject.value("hcs::notification").isObject());

                    QJsonObject payloadJsonObject =
                        jsonObject.value("hcs::notification").toObject();

                    QVERIFY_(payloadJsonObject.contains("type"));
                    QVERIFY_(payloadJsonObject.contains("test"));

                    QCOMPARE_(payloadJsonObject.value("type").toString(), "test_broadcast");
                    QCOMPARE_(payloadJsonObject.value("test").toString(), "test");

                    counter++;
                });
        clientsList[i]->sendMessage(R"({"cmd":"register_client", "payload":{}})");
    }

    waitForZmqMessages();

    server.notifyAllClients("test_broadcast", {{"test", "test"}});

    // wait for the messages
    timer.setSingleShot(true);
    timer.start(200);
    do {
        QCoreApplication::processEvents(QEventLoop::WaitForMoreEvents);
        if (counter == clientsCount) {
            break;
        }
    } while (timer.isActive());

    for (auto client : clientsList) {
        delete client;
    }
}

void StrataServerTest::testNotifyClientByClientId()
{
    bool testExecuted = false;
    StrataServer server(address_, false);
    QVERIFY_(server.initializeServer());

    strata::strataRPC::ClientConnector client(address_, "AA");
    client.initializeConnector();

    client.sendMessage(
        R"({"jsonrpc": "2.0","method":"register_client","params": {"api_version": "1.0"},"id":1})");
    waitForZmqMessages();

    connect(&client, &strata::strataRPC::ClientConnector::newMessageReceived, this,
            [&testExecuted](const QByteArray &message) {
                QJsonParseError jsonParseError;
                QJsonDocument jsonDocument = QJsonDocument::fromJson(message, &jsonParseError);

                QVERIFY_(jsonParseError.error == QJsonParseError::NoError);

                QJsonObject jsonObject = jsonDocument.object();

                QVERIFY_(jsonObject.contains("method"));
                QVERIFY_(jsonObject.value("method").isString());
                QCOMPARE_(jsonObject.value("method").toString(), "test_handler");
                testExecuted = true;
            });

    server.notifyClient("AA", "test_handler", QJsonObject({{"key", "value"}}),
                        strata::strataRPC::ResponseType::Notification);
    waitForZmqMessages();

    QVERIFY_(testExecuted);
}

void StrataServerTest::testNotifyClientToNonExistingClient()
{
    StrataServer server(address_, false);
    QVERIFY_(server.initializeServer());

    strata::strataRPC::ClientConnector client(address_, "AA");
    connect(
        &client, &strata::strataRPC::ClientConnector::newMessageReceived, this,
        [](const QByteArray &) { QFAIL_("Messages should not be sent to unregistered Clients."); });

    server.notifyClient("AA", "test_handler", QJsonObject({{"key", "value"}}),
                        strata::strataRPC::ResponseType::Notification);
    waitForZmqMessages();
}

void StrataServerTest::testInitializeServerFail()
{
    StrataServer server(address_, false);
    StrataServer duplicateServer(address_);

    QVERIFY_(server.initializeServer());
    QVERIFY_(false == duplicateServer.initializeServer());
}

void StrataServerTest::testdefaultHandlers()
{
    StrataServer server(address_, true);
    server.initializeServer();

    bool testExecuted_1 = false;
    bool testExecuted_2 = false;

    strata::strataRPC::ClientConnector client(address_, "AA");
    client.initializeConnector();
    client.connectClient();
    client.sendMessage(
        R"({"jsonrpc": "2.0","method":"register_client","params": {"api_version": "2.0"},"id":1})");
    connect(&client, &strata::strataRPC::ClientConnector::newMessageReceived, this,
            [&testExecuted_1](const QByteArray &message) {
                QJsonParseError jsonParseError;
                QJsonDocument jsonDocument = QJsonDocument::fromJson(message, &jsonParseError);

                QVERIFY_(jsonParseError.error == QJsonParseError::NoError);

                QJsonObject jsonObject = jsonDocument.object();

                QVERIFY_(jsonObject.contains("result"));
                QVERIFY_(jsonObject.value("result").isObject());
                QCOMPARE_(jsonObject.value("result").toObject(),
                          QJsonObject({{"status", "client registered."}}));
                testExecuted_1 = true;
            });

    waitForZmqMessages();

    strata::strataRPC::ClientConnector client_2(address_, "BB");
    client_2.initializeConnector();
    client_2.connectClient();
    client_2.sendMessage(
        R"({"jsonrpc": "2.0","method":"register_client","params": {"api_version": "1.0"},"id":1})");
    connect(&client_2, &strata::strataRPC::ClientConnector::newMessageReceived, this,
            [&testExecuted_2](const QByteArray &message) {
                QJsonParseError jsonParseError;
                QJsonDocument jsonDocument = QJsonDocument::fromJson(message, &jsonParseError);

                QVERIFY_(jsonParseError.error == QJsonParseError::NoError);

                QJsonObject jsonObject = jsonDocument.object();

                QVERIFY_(jsonObject.contains("error"));
                QVERIFY_(jsonObject.value("error").isObject());
                QCOMPARE_(
                    jsonObject.value("error").toObject(),
                    QJsonObject({{"massage", "Failed to register client, Unknown API Version."}}));
                testExecuted_2 = true;
            });

    waitForZmqMessages();

    QVERIFY_(testExecuted_1);
    QVERIFY_(testExecuted_2);
}

void StrataServerTest::waitForZmqMessages(int delay)
{
    QTimer timer;
    timer.setSingleShot(true);
    timer.start(delay);
    do {
        QCoreApplication::processEvents(QEventLoop::WaitForMoreEvents);
    } while (timer.isActive());
}
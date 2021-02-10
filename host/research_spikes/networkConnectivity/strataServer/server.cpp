#include "server.h"

Server::Server(QObject *parent)
    : QObject(parent), tcpSocket_(new QTcpSocket(this)), udpSocket_(new QUdpSocket(this))
{
    // UDP Socket set up.
    if (false == udpSocket_->bind(port_, QUdpSocket::ShareAddress | QUdpSocket::ReuseAddressHint)) {
        qDebug() << "udp: failed to bind to port" << port_;
    }
    qDebug() << "udp: successful bind to port" << port_;

    connect(udpSocket_, &QUdpSocket::readyRead, this, &Server::preccessPendingDatagrams);

    // TCP socket set up
    connect(tcpSocket_, &QTcpSocket::connected, this, []() { qDebug() << "tcp socket connected"; });

    connect(tcpSocket_, &QTcpSocket::disconnected, this,
            []() { qDebug() << "tcp socket disconnected"; });

    //     connect(tcpSocket_, &QAbstractSocket::error, this, [](QAbstractSocket::SocketError
    //     socketError) {
    //         qDebug() << "tcp socket error!";
    //         qDebug() << socketError;
    //     });

    connect(tcpSocket_, &QTcpSocket::bytesWritten, this,
            [](qint64 bytesWritten) { qDebug() << "tcp bytes written" << bytesWritten; });

    connect(tcpSocket_, &QTcpSocket::readyRead, this, &Server::newTcpMessage);
}

Server::~Server()
{
}

void Server::setPort(quint16 port)
{
    if (port_ != port) {
        port_ = port;
        udpSocket_->close();
        if (false == udpSocket_->bind(port_, QUdpSocket::ShareAddress)) {
            qDebug() << "udp: failed to bind to port" << port_;
        }
        qDebug() << "udp: successful bind to port" << port_;
    }
}

quint16 Server::getPort() const
{
    return port_;
}

void Server::preccessPendingDatagrams()
{
    qDebug() << "datagram..";
    QByteArray datagram;
    QHostAddress hostAddress;
    while (udpSocket_->hasPendingDatagrams()) {
        datagram.resize(int(udpSocket_->pendingDatagramSize()));
        udpSocket_->readDatagram(datagram.data(), datagram.size(), &hostAddress);
        qDebug() << "host address:" << hostAddress.toString() << "datagram:" << datagram;
    }
    setUdpBuffer(datagram);

    if (datagram == "strata client") {
        connectToStrataClient(hostAddress, TCP_PORT);
    }
}

QString Server::getUdpBuffer()
{
    return udpBuffer_;
}

QString Server::getTcpBuffer()
{
    return tcpBuffer_;
}

void Server::connectToStrataClient(QHostAddress hostAddress, qint16 port)
{
    if (tcpSocket_->state() == QTcpSocket::ConnectedState) {
        qDebug() << "tcp socket already connected";
        return;
    }

    qDebug() << "connecting to:" << hostAddress.toString() << "port:" << port;
    tcpSocket_->connectToHost(hostAddress, port);

    if (false == tcpSocket_->waitForConnected(5000)) {
        qDebug() << "failed to connect.";
    }

    sendTcpMessge("Connected?");
}

void Server::newTcpMessage()
{
    qDebug() << "tcp: New message received.";
    QByteArray data;
    data = tcpSocket_->readAll();
    qDebug() << "tcp: message:" << QString(data);
    setTcpBuffer(data);
}

void Server::sendTcpMessge(QByteArray message)
{
    tcpSocket_->write(message);
}

void Server::setUdpBuffer(const QByteArray &newDatagram)
{
    udpBuffer_ += newDatagram + '\n';
    emit udpBufferUpdated();
}

void Server::setTcpBuffer(const QByteArray &newData)
{
    tcpBuffer_ += newData + '\n';
    emit tcpBufferUpdated();
}

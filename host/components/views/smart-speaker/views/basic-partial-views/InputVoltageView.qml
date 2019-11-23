import QtQuick 2.9
import QtQuick.Controls 2.2

Rectangle {
    id: root
    width: 200
    height:200
    color:"dimgray"
    opacity:1
    radius: 10

    property alias analogAudioCurrent: analogAudioCurrent.value
    property alias digitalAudioCurrent: digitalAudioCurrent.value
    property alias audioVoltage: audioVoltage.value



    PortStatBox{
        id:analogAudioCurrent

        height:parent.height/4
        anchors.top: parent.top
        anchors.topMargin: 10

        label: "ANALOG AUDIO CURRENT"
        unit:"A"
        color:"transparent"
        valueSize: 32
        textColor: "white"
        portColor: "#2eb457"
        labelColor:"white"
        //underlineWidth: 0
        imageHeightPercentage: .65
        bottomMargin: 0
    }

    PortStatBox{
        id:digitalAudioCurrent

        height:parent.height/4
        anchors.top: analogAudioCurrent.bottom
        label: "DIGITAL AUDIO CURRENT"
        unit:"A"
        color:"transparent"
        valueSize: 32
        textColor: "white"
        portColor: "#2eb457"
        labelColor:"white"
        //underlineWidth: 0
        imageHeightPercentage: .65
        bottomMargin: 0
    }

    PortStatBox{
        id:audioVoltage

        height:parent.height/4
        anchors.top: digitalAudioCurrent.bottom
        label: "AUDIO VOLTAGE"
        unit:"V"
        color:"transparent"
        valueSize: 32
        textColor: "white"
        portColor: "#2eb457"
        labelColor:"white"
        //underlineWidth: 0
        imageHeightPercentage: .65
        bottomMargin: 0
    }

}

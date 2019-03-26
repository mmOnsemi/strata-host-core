import QtQuick 2.9
//import "qrc:/views/usb-hub/sgwidgets"
import QtQuick.Controls 2.3

Rectangle {
    id: root
    color: connected ? "white" : "darkGrey"
    border.color: connected ? "transparent" : "black"
    radius:5

    property bool connected: false
    property alias source: sourceIndicator.checked
    property alias sink: sinkIndicator.checked
    property alias fastRoleSwap: fastRoleSwapIndicator.checked
    property alias superspeed: superspeedIndicator.checked
    property alias extendedSink: extendedSinkIndicator.checked

    onConnectedChanged:{
        if (connected){
            showStats.start()
            showIndicators.start()
        }
         else{
            hideStats.start()
            hideIndicators.start()
        }
    }

    OpacityAnimator {
        id: hideStats
        target: deviceInfoColumn
        from: 1
        to: 0
        duration: 1000
    }

    OpacityAnimator {
        id: showStats
        target: deviceInfoColumn
        from: 0
        to: 1
        duration: 1000
    }

    OpacityAnimator {
        id: hideIndicators
        target: deviceStatusColumn
        from: 1
        to: 0
        duration: 1000
    }

    OpacityAnimator {
        id: showIndicators
        target: deviceStatusColumn
        from: 0
        to: 1
        duration: 1000
    }



    Rectangle{
        id:titleBackground
        color:"lightgrey"
        anchors.top: root.top
        anchors.topMargin: !connected ? 2 : 0
        anchors.left:root.left
        anchors.leftMargin: !connected ? 2 : 0
        anchors.right: root.right
        anchors.rightMargin: !connected ? 2 : 0
        height: (2*root.height)/16
        radius:5
    }

    Rectangle{
        id:squareBottomBackground
        color:"lightgrey"
        anchors.top:titleBackground.top
        anchors.topMargin:(root.height)/16
        anchors.left:titleBackground.left
        anchors.right: titleBackground.right
        height: (root.height)/16
        radius:0
    }

    Column{
        id:deviceInfoColumn
        opacity: 0
        anchors.top:squareBottomBackground.bottom
        anchors.topMargin: 10
        anchors.left:root.left
        anchors.leftMargin: 10
        anchors.right:root.right
        anchors.rightMargin: 18
        anchors.bottom:root.bottom

        spacing: 5

        Text {
            text: "SOURCE"
        }
        Text {
            text: "SINK"
        }
        Text {
            text: "FAST ROLE SWAP"
        }
        Text {
            text: "SUPERSPEED"
        }
        Text {
            text: "EXTENDED SINK"
        }
    }

    Column{
        id:deviceStatusColumn
        opacity: 0
        anchors.top:squareBottomBackground.bottom
        anchors.topMargin: 10
        anchors.left:deviceInfoColumn.right
        anchors.right:root.right
        anchors.bottom:root.bottom

        spacing: -4

        RadioButton {
            id: sourceIndicator
            height:15
            autoExclusive : false
            indicator: Rectangle{
                implicitWidth: 15
                implicitHeight: 15
                x: sourceIndicator.x
                y: sourceIndicator.y
                radius: 7
                color: sourceIndicator.checked ? "green": "white"
                border.color: sourceIndicator.checked ? "black": "grey"
            }
        }

        RadioButton {
            id: sinkIndicator
            height:15
            autoExclusive : false
            indicator: Rectangle{
                implicitWidth: 15
                implicitHeight: 15
                x: sinkIndicator.x
                y: sinkIndicator.y
                radius: 7
                color: sinkIndicator.checked ? "green": "white"
                border.color: sinkIndicator.checked ? "black": "grey"
            }
        }

        RadioButton {
            id: fastRoleSwapIndicator
            height:15
            autoExclusive : false
            indicator: Rectangle{
                implicitWidth: 15
                implicitHeight: 15
                x: fastRoleSwapIndicator.x
                y: fastRoleSwapIndicator.y
                radius: 7
                color: fastRoleSwapIndicator.checked ? "green": "white"
                border.color: fastRoleSwapIndicator.checked ? "black": "grey"
            }
        }

        RadioButton {
            id: superspeedIndicator
            height:15
            autoExclusive : false
            indicator: Rectangle{
                implicitWidth: 15
                implicitHeight: 15
                x: superspeedIndicator.x
                y: superspeedIndicator.y
                radius: 7
                color: superspeedIndicator.checked ? "green": "white"
                border.color: superspeedIndicator.checked ? "black": "grey"
            }
        }

        RadioButton {
            id: extendedSinkIndicator
            height:15
            autoExclusive : false
            indicator: Rectangle{
                implicitWidth: 15
                implicitHeight: 15
                x: extendedSinkIndicator.x
                y: extendedSinkIndicator.y
                radius: 7
                color: extendedSinkIndicator.checked ? "green": "white"
                border.color: extendedSinkIndicator.checked ? "black": "grey"
            }
        }

    }   //column


}
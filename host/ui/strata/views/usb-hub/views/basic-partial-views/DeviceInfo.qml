import QtQuick 2.0
//import "qrc:/views/usb-hub/sgwidgets"
import QtQuick.Controls 2.3

Rectangle {
    id: root
    color: "white"
    radius:5

    property alias source: sourceIndicator.checked
    property alias sink: sinkIndicator.checked
    property alias fastRoleSwap: fastRoleSwapIndicator.checked
    property alias superspeed: superspeedIndicator.checked
    property alias extendedSink: extendedSinkIndicator.checked

    Rectangle{
        id:titleBackground
        color:"lightgrey"
        anchors.top: root.top
        anchors.left:root.left
        anchors.right: root.right
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
        anchors.top:squareBottomBackground.bottom
        anchors.topMargin: 10
        anchors.left:parent.left
        anchors.leftMargin: 10
        anchors.right:parent.right
        anchors.rightMargin: 18
        anchors.bottom:parent.bottom

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
        anchors.top:squareBottomBackground.bottom
        anchors.topMargin: 10
        anchors.left:deviceInfoColumn.right
        anchors.right:parent.right
        anchors.bottom:parent.bottom

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

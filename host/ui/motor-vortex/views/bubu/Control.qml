
import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.0
import "boardBringUp"
import "qrc:/js/navigation_control.js" as NavigationControl


Rectangle {

    id: boardBringUP
    property string user_id
    property string platform_name
    property int smallFontSize: (Qt.platform.os === "osx") ? 12  : 8;
    property int mediumFontSize: (Qt.platform.os === "osx") ? 15  : 12;
    property int mediumLargeFontSize: (Qt.platform.os === "osx") ? 20  : 14;
    property int largeFontSize: (Qt.platform.os === "osx") ? 24  : 16;
    property int extraLargeFontSize: (Qt.platform.os === "osx") ? 36  : 24;
    property color lightGreyColor: "#EBEAE9"
    property color mediumGreyColor: "#E4E3E2"
    property color darkGreyColor: "#DBDAD9"
    property var currentTab : serialView
    property var newTab : serialView
    property var acknowledge

    anchors{ fill:parent }

    // Platform Implementation signals
    Connections {
        target: coreInterface
        onNotification: {

            try {
                /*
                    Attempt to parse JSON
                */
                var notification = JSON.parse(payload)
                console.log("in notification", notification.cmd);
                console.log("in notification", JSON.stringify(notification));

                // check the command for the notification and call the function accordingly
                if(notification.value === "i2c_read") {

                    serialView.i2cAckParse(notification)
                    serialView.i2cReadDataParse(notification)
                }
                if(notification.value === "i2c_write") {
                    serialView.i2cAckParse(notification)
                }

            }
            catch(e)
            {
                if ( e instanceof SyntaxError){
                    console.log("Notification JSON is invalid. ignoring")
                }
            }
        }
    }

    ParallelAnimation{
        id: crosfadeTabs
        OpacityAnimator{
            target: currentTab
            from: 1
            to: 0
            duration: 500
            running: false
        }
        OpacityAnimator{
            target: newTab
            from: 0
            to: 1
            duration: 500
            running: false
        }
    }



    ButtonGroup {
        buttons: buttonRow.children
        onClicked: {
            crosfadeTabs.start()
        }
    }

    Row {
        id:buttonRow
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 15


        SGLeftSegmentedButton{
            text:"I2C"
            objectName: "serialBoardBringUpButton"
            onClicked: { contentRectangle.currentIndex = 0; }

        }

        SGMiddleSegmentedButton{
            text:"gpio"
            objectName: "gpioBoardBringUpButton"
            onClicked: { contentRectangle.currentIndex = 1; }


        }
        SGRightSegmentedButton{
            text:"pwm"
            objectName: "pwmBoardBringUpButton"
            onClicked: { contentRectangle.currentIndex = 2; }

        }
    }

    SwipeView{
        id:contentRectangle
        anchors.left:parent.left
        anchors.right:parent.right
        anchors.bottom:parent.bottom
        anchors.top:buttonRow.bottom

        currentIndex: 0

        onCurrentIndexChanged: {
            buttonRow.children[contentRectangle.currentIndex].checked = true;

        }
        Serial{ id:serialView }

        Gpio{ id:gpioView }

        Pwm{ id:pwmView }
    }


    Rectangle{
        height: 40;width:40
        anchors { bottom: boardBringUP.bottom; right: boardBringUP.right }
        color: "white";
        Image {
            id: flipButton
            source:"qrc:/views/motor-vortex/images/icons/infoIcon.svg"
            anchors { fill: parent }
            height: 40;width:40
        }
    }
    MouseArea {
        width: flipButton.width; height: flipButton.height
        anchors { bottom: parent.bottom; right: parent.right }
        visible: true
        onClicked: {
            NavigationControl.updateState(NavigationControl.events.TOGGLE_CONTROL_CONTENT)
        }
    }
}

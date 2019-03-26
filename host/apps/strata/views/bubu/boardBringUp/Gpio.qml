import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.0
import "qrc:/views/bubu/Control.js" as BubuControl


Rectangle {
    id:container

    property var currentTab : gpioView
    property var newTab:  gpioView
    /*
       List of bits disabled for each port
    */
    property variant portAMapDisable: []
    property variant portBMapDisable: []
    property variant portCMapDisable: []
    property variant portDMapDisable: []
    property variant portEMapDisable: []
    property variant portHMapDisable: []

    /*
      set GPIO port based on pin function
    */
    function setGPIOCommand(pinFunction, portName, tabIndex)
    {
        BubuControl.setGpioPort(portName);
        bitView.currentIndex = tabIndex;
    }

    Component.onCompleted: {
        BubuControl.setGpioPort("a"); //Setting default port as "a"
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

    /*
         Holds the animation for the ports
   */
    ButtonGroup {
        id: animateButton
        buttons: buttonRow.children
        onClicked: {
            crosfadeTabs.start() // start the animation
        }
    }


    Row {
        id:buttonRow
        anchors { top: container.top;topMargin: 40; horizontalCenter: container.horizontalCenter }
        width: 600
        height: 40

        SGLeftSegmentedButton{ text:"Port A"; portName:"a"; tabIndex: 0; pinFunction: "gpio"; onClicked: setGPIOCommand(pinFunction, portName,tabIndex)}
        SGMiddleSegmentedButton{ text:"Port B"; portName: "b"; tabIndex: 1; pinFunction: "gpio"; onClicked: setGPIOCommand(pinFunction, portName,tabIndex)}
        SGMiddleSegmentedButton{ text:"Port C"; portName: "c"; tabIndex: 2; pinFunction: "gpio"; onClicked: setGPIOCommand(pinFunction, portName,tabIndex)}
        SGMiddleSegmentedButton{ text:"Port D"; portName: "d"; tabIndex: 3; pinFunction: "gpio"; onClicked: setGPIOCommand(pinFunction, portName,tabIndex)}
        SGMiddleSegmentedButton{ text:"Port E"; portName: "e"; tabIndex: 4; pinFunction: "gpio"; onClicked: setGPIOCommand(pinFunction, portName,tabIndex)}
        SGRightSegmentedButton{ text:"Port H"; portName: "h"; tabIndex: 5; pinFunction: "gpio"; onClicked: setGPIOCommand(pinFunction, portName,tabIndex)}

    }

    SwipeView {
        id: bitView
        anchors { left:container.left
            right:container.right
            bottom:container.bottom
            top:buttonRow.bottom
        }
        currentIndex: 0
        onCurrentIndexChanged: {
            buttonRow.children[bitView.currentIndex].checked = true;
        }

        /*
            view for the ports
        */
        ButtonViewGPIO { listDisableBits: portAMapDisable }
        ButtonViewGPIO { listDisableBits: portBMapDisable }
        ButtonViewGPIO { listDisableBits: portCMapDisable }
        ButtonViewGPIO { listDisableBits: portDMapDisable }
        ButtonViewGPIO { listDisableBits: portEMapDisable }
        ButtonViewGPIO { listDisableBits: portHMapDisable }
    }

    PageIndicator {
        id: indicator
        count: bitView.count
        currentIndex: bitView.currentIndex
        anchors.bottom: bitView.bottom
        anchors.horizontalCenter: container.horizontalCenter

    }
}



import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import "qrc:/views/bubu/Control.js" as BubuControl




Rectangle{

    width: 1000; height: 60
    color: lightGreyColor
    property int bitNum: 0
    anchors.horizontalCenter: parent.horizontalCenter

    /*
        Depending on the state of the switch(input/output) change the
        visibility of _highLow_ switch
      */
    states: [
        State {
            name: "input"
            when: inputOutput.stateOfTheSwitch === true
            PropertyChanges { target: highLow; visible: false}
        },

        State {
            name: "output"
            when: inputOutput.stateOfTheSwitch === false
            PropertyChanges { target: highLow; visible: true}
        }

    ]

    RowLayout {
        width: 800
        height: 50
        spacing: 6

        Label {
            id: bitNumber
            width: 95
            height: 25
            Text {
                width: 94
                height: 24
                text: bitNum
                horizontalAlignment: Text.AlignHCenter
            }
        }

        Rectangle {
            id: inputOutputContainer
            width: 200; height: 50
            anchors { left : bitNumber.right
                leftMargin: 100}
            color: "transparent"
            GPIOSetting {
                id: inputOutput
                settingSwitchType: "input_output"
                bitNumber: bitNum
                switchAngle: 90
                settingMessageOne: "Input"
                settingMessageTwo: "Output"
                initialState: true
                width: 200; height: 50
            }
        }


        Rectangle {
            id: highlowContainer
            width: 200; height: 50
            anchors { left : inputOutputContainer.right
                leftMargin: 100}
            color: "transparent"
            GPIOSetting {
                id: highLow
                settingSwitchType: "low_high"
                bitNumber: bitNum
                switchAngle: 90
                settingMessageOne: "Low"
                settingMessageTwo: "High"
                initialState: true
                width: 200; height: 50
            }
        }
        TextField {
            id: currentState
            placeholderText: qsTr("1")
            Layout.leftMargin: 250

        }
    }

}



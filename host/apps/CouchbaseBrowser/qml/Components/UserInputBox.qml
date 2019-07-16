import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

ColumnLayout {
    id: root
//    color: "transparent"
    z: 5
    spacing: 2

    signal clicked()
    signal accepted()

    property color borderColor: "white"

    property alias showButton: icon.visible
    property alias showLabel: label.visible
    property bool isPassword: false
    property real iconSize: 0

    property alias path: icon.source
    property alias placeholderText: inputField.placeholderText
    property alias label: label.text
    property alias userInput: inputField.text

    function clear(){
        inputField.text = ""
    }
    function isEmpty(){
        fieldBorder.border.color = (inputField.text === "") ? "red" : "transparent"
    }

    Label {
        id: label
        color: "#eee"
        visible: false
    }

    Rectangle {
        id: fieldBorder
        Layout.preferredHeight: row.height + 10
        Layout.preferredWidth: root.width
        border.width: 3
        border.color: "transparent"

        RowLayout {
            id:row
            width: parent.width
            anchors {
                verticalCenter: fieldBorder.verticalCenter
            }

            TextField {
                id: inputField
                Layout.fillWidth: true
                selectByMouse: true
                Component.onCompleted: {
                    inputField.echoMode = isPassword ? TextInput.Password : TextInput.Normal
                }
                background: Item {}
                onAccepted: root.accepted()
            }
            Image {
                id: icon
                Layout.preferredHeight: iconSize === 0 ? inputField.height - 5 : iconSize
                Layout.preferredWidth: iconSize === 0 ? Layout.preferredHeight : iconSize
                Layout.rightMargin: 5
                opacity: 0.5
                visible: false
                MouseArea {
                    id: mouseArea
                    hoverEnabled: true
                    onEntered: icon.opacity = 1
                    onExited: icon.opacity = 0.5
                    onClicked: {
                        root.clicked()
                    }
                    anchors.fill: parent
                }
                fillMode: Image.PreserveAspectFit
            }
        }
    }
}


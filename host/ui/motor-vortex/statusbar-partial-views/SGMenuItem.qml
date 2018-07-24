import QtQuick 2.9
import QtQuick.Controls 2.3

Button {
    id: root
    text: qsTr("Button Text")
   // width: profileMenu.width
    hoverEnabled: true

    property alias buttonColor: backRect.color
    property alias textColor: buttonText.color

    contentItem: Text {
        id: buttonText
        text: root.text
        opacity: enabled ? 1.0 : 0.3
        color: "white"
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        font {
            family: franklinGothicBook.name
        }
    }

    background: Rectangle {
        id: backRect
        implicitWidth: 100
        implicitHeight: 40
        opacity: enabled ? 1 : 0.3
        radius: 2
        color: !root.hovered ? "#00b842" : root.pressed ? Qt.darker("#007a1f", 1.25) : "#007a1f"
    }

    FontLoader {
        id: franklinGothicBook
        source: "qrc:/fonts/FranklinGothicBook.otf"
    }
}

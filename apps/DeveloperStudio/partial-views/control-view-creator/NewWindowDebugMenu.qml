import QtQuick 2.3
import QtQuick.Controls 1.2

ApplicationWindow {
    id: root
    width: 450
    height: mainWindow.height
    minimumHeight: 200
    minimumWidth: 450

    visible: true
    property alias consoleLogParent: newWindowContainer

    onClosing: {
        if (debugMenuWindow) {
            debugMenuWindow = false
        }
        isDebugMenuOpen = false
    }

    Item {
        id: newWindowContainer
        anchors.fill: parent
    }
}
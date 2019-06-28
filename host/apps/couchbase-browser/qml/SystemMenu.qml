import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.12

Item {
    id: root

    signal openFileSignal()
    signal newDocumentSignal()
    signal newDatabaseSignal()
    signal saveSignal()
    signal saveAsSignal()
    signal closeSignal()
    signal startReplicatorSignal()
    signal stopReplicatorSignal()
    signal newWindowSignal()

    property bool replicatorStarted: false
    property bool showReplicatorButton: false

    RowLayout {
        id: row
        height: parent.height
        width: implicitWidth
        spacing: 25
        CustomMenuItem {
            id: openFile
            Layout.preferredHeight: 50
            Layout.preferredWidth: 50
            Layout.leftMargin: 5
            filename: "Images/openFolderIcon"
            label: "<b>Open</b>"
            onButtonPress: openFileSignal()
        }
        CustomMenuItem {
            id: newDocument
            Layout.preferredHeight: 50
            Layout.preferredWidth: 50
            Layout.leftMargin: 5
            filename: "Images/createDocumentIcon"
            label: "<b>New Doc</b>"
            onButtonPress: newDocumentSignal()
        }
        CustomMenuItem {
            id: newDB
            Layout.preferredHeight: 50
            Layout.preferredWidth: 50
            Layout.leftMargin: 5
            filename: "Images/newDatabase"
            label: "<b>New DB</b>"
            onButtonPress: newDatabaseSignal()
        }
        CustomMenuItem {
            id: save
            Layout.preferredHeight: 50
            Layout.preferredWidth: 50
            Layout.leftMargin: 5
            filename: "Images/saveIcon"
            label: "<b>Save</b>"
            onButtonPress: saveSignal()
        }
        CustomMenuItem {
            id: saveAs
            Layout.preferredHeight: 50
            Layout.preferredWidth: 50
            Layout.leftMargin: 5
            filename: "Images/Save-as-icon"
            label: "<b>Save As</b>"
            onButtonPress: saveAsSignal()
        }
        CustomMenuItem {
            id: close
            Layout.preferredHeight: 50
            Layout.preferredWidth: 50
            Layout.leftMargin: 5
            filename: "Images/closeIcon"
            label: "<b>Close</b>"
            onButtonPress: {
                if (replicatorStarted) stopReplicatorSignal()
                closeSignal()
                showReplicatorButton = false
            }
        }
    }
    Rectangle {
        id: hiddenMenuBackground
        width: 100
        height: parent.height
        color: "transparent"
        anchors {
            right: newWindowContainer.left
        }
        RowLayout {
            id: hiddenMenuLayout
            anchors.fill: parent
            visible: showReplicatorButton
            CustomMenuItem {
                id: startReplication
                visible: !replicatorStarted
                Layout.preferredHeight: 50
                Layout.preferredWidth: 50
                Layout.alignment: Qt.AlignCenter
                label: "<b>Start Replication</b>"
                filename: "Images/replicateDatabase"
                onButtonPress: startReplicatorSignal()
            }
            CustomMenuItem {
                id: stopReplication
                visible: replicatorStarted
                Layout.preferredHeight: 50
                Layout.preferredWidth: 50
                Layout.alignment: Qt.AlignCenter
                label: "<b>Stop Replication</b>"
                filename: "Images/stopReplication"
                onButtonPress: {
                    stopReplicatorSignal()
                    replicatorStarted = false
                }
            }
        }
    }
    Rectangle {
        id: newWindowContainer
        width: 100
        height: parent.height
        color: "transparent"
        anchors {
            right: parent.right
        }
        RowLayout {
            id: newWindowLayout
            anchors.fill: parent
            CustomMenuItem {
                id: newWindow
                Layout.preferredHeight: 50
                Layout.preferredWidth: 50
                Layout.alignment: Qt.AlignCenter
                label: "<b>New Window</b>"
                filename: "Images/newTabIcon"
                onButtonPress: newWindowSignal()
            }
        }
    }
}


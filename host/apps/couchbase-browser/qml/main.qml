import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12

Window {
    id: container
    visible: true
    minimumWidth: 800
    minimumHeight: 600
    width: 1280
    height: 720
    title: qsTr("Couchbase Browser") + ((fileName !== "") ? " - " + fileName : "")
    flags: Qt.WindowFullscreenButtonHint

    property alias id: mainview.id
    property alias openedFile: mainview.openedFile

    property string fileName: ""
    property var allDocuments: ""

    MainWindow {
        id: mainview
    }
    onAllDocumentsChanged: {
        mainview.allDocuments = allDocuments
    }
}

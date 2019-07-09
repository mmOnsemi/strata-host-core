import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Dialogs 1.3
import "Popups"
import "Components"

Item {
    id: root
    anchors.fill: parent

    property var id
    property var allDocuments: "{}"
    property var jsonObj
    property alias openedFile: mainMenuView.openedFile
    property string openedDocumentID
    property string openedDocumentBody

    function updateOpenDocument() {
        if (tableSelectorView.currentIndex !== 0) {
            mainMenuView.onSingleDocument = true
            openedDocumentID = tableSelectorView.model[tableSelectorView.currentIndex]
            openedDocumentBody = JSON.stringify(jsonObj[openedDocumentID],
                                                null, 4)
            bodyView.content = openedDocumentBody
        } else {
            mainMenuView.onSingleDocument = false
            openedDocumentID = tableSelectorView.model[0]
            bodyView.content = JSON.stringify(jsonObj, null, 4)
        }
    }

    onAllDocumentsChanged: {
        if (allDocuments !== "{}") {
            var tempModel = ["All documents"]
            jsonObj = JSON.parse(allDocuments)
            for (i in jsonObj)
                tempModel.push(i)
            var prevID = openedDocumentID
            var newIndex = tempModel.indexOf(prevID)
            if (newIndex === -1)
                newIndex = 0
            tableSelectorView.model = tempModel

            if (tableSelectorView.currentIndex === newIndex) {
                updateOpenDocument()
            } else
                tableSelectorView.currentIndex = newIndex
        } else {
            tableSelectorView.model = []
            bodyView.content = ""
        }
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: "#b55400"
        GridLayout {
            id: gridview
            anchors.fill: parent
            rows: 2
            columns: 2
            columnSpacing: 2
            rowSpacing: 2

            Rectangle {
                id: menuContainer
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: 82
                Layout.row: 0
                Layout.columnSpan: 2
                color: "#222831"
                SystemMenu {
                    id: mainMenuView
                    anchors {
                        fill: parent
                        bottomMargin: 10
                    }
                    onOpenFileSignal: openFileDialog.visible = true
                    onNewDatabaseSignal: newDatabasesPopup.visible = true
                    onNewDocumentSignal: newDocPopup.visible = true
                    onDeleteDocumentSignal: deletePopup.visible = true
                    onEditDocumentSignal: editDocPopup.visible = true
                    onSaveAsSignal: saveAsPopup.visible = true
                    onCloseSignal: {
                        qmlBridge.closeFile(id)
                        bodyView.message = "Closed file"
                    }
                    onStartReplicatorSignal: {
                        loginPopup.visible = true
                    }
                    onStopReplicatorSignal: {
                        qmlBridge.stopReplicator(id)
                        bodyView.message = "Stopped replicator"
                    }
                    onNewWindowSignal: qmlBridge.createNewWindow()
                }
            }
            Rectangle {
                id: selectorContainer
                Layout.preferredWidth: 160
                Layout.preferredHeight: (parent.height - menuContainer.height)
                Layout.row: 1
                Layout.alignment: Qt.AlignTop
                color: "#222831"

                TableSelector {
                    id: tableSelectorView
                    height: parent.height
                    onCurrentIndexChanged: {
                        if (allDocuments !== "{}") {
                            updateOpenDocument()
                        }
                    }
                }
                Image {
                    id: onLogo
                    width: 50
                    height: 50
                    source: "Images/CBBrowserLogo.png"
                    fillMode: Image.PreserveAspectCrop
                    anchors {
                        bottom: parent.bottom
                        bottomMargin: 20
                        horizontalCenter: parent.horizontalCenter
                    }
                }
            }
            Rectangle {
                id: bodyContainer
                Layout.preferredWidth: (parent.width - selectorContainer.width)
                Layout.preferredHeight: (parent.height - menuContainer.height)
                Layout.alignment: Qt.AlignTop
                color: "transparent"
                BodyDisplay {
                    id: bodyView
                }
            }
        }

        Item {
            id: popupWindow
            anchors.fill: parent

            FileDialog {
                id: openFileDialog
                visible: false
                title: "Please select a database"
                folder: shortcuts.home
                onAccepted: {
                    var message = qmlBridge.setFilePath(
                                id, fileUrls.toString().replace("file://", ""))
                    if (message.length === 0) {
                        bodyView.message = "Opened file"
                        mainMenuView.openedFile = true
                    } else
                        bodyView.message = message
                }
            }

            LoginPopup {
                id: loginPopup
                onStart: {
                    var message = qmlBridge.startReplicator(id, url,
                                                            username, password,
                                                            rep_type, channels)
                    if (message.length === 0) {
                        bodyView.message = "Started replicator successfully"
                        mainMenuView.replicatorStarted = true
                        visible = false
                    } else
                        bodyView.message = message
                }
            }
            DocumentPopup {
                id: newDocPopup
                onSubmit: {
                    var message = qmlBridge.createNewDocument(id,
                                                              docID, docBody)
                    if (message.length === 0)
                        bodyView.message = "Created new document successfully!"
                    else
                        bodyView.message = message
                }
            }
            DocumentPopup {
                id: editDocPopup
                docID: openedDocumentID
                docBody: openedDocumentBody
                onSubmit: {
                    var message = qmlBridge.editDoc(id, openedDocumentID,
                                                    docID, docBody)
                    if (message.length === 0) {
                        bodyView.message = "Edited document successfully"
                    } else
                        bodyView.message = message
                    visible = false
                }
            }
            DatabasePopup {
                id: newDatabasesPopup
                onSubmit: {
                    var message = qmlBridge.createNewDatabase(
                                id, mainMenuView.openedFile,
                                folderPath.toString().replace("file://",
                                                              ""), filename)
                    if (message.length === 0) {
                        bodyView.message = "Created new database successfully"
                    } else
                        bodyView.message = message
                    visible = false
                }
            }
            DatabasePopup {
                id: saveAsPopup
                onSubmit: {
                    visible = false
                }
            }
            WarningPopup {
                id: deletePopup
                messageToDisplay: "Are you sure that you want to permanently delete document \""
                                  + openedDocumentID + "\""
                onAllow: {
                    deletePopup.visible = false
                    qmlBridge.deleteDoc(id, openedDocumentID)
                }
                onDeny: {
                    deletePopup.visible = false
                }
            }
        }
    }
}

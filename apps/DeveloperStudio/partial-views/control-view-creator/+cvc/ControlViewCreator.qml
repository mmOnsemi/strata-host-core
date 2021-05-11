import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import tech.strata.commoncpp 1.0
import tech.strata.theme 1.0
import tech.strata.sgwidgets 1.0
import tech.strata.signals 1.0

import "qrc:/js/navigation_control.js" as NavigationControl
import "navigation"
import "../"
import "qrc:/js/constants.js" as Constants
import "qrc:/js/help_layout_manager.js" as Help
import "Console"
import "PlatformInterfaceGenerator"

Rectangle {
    id: controlViewCreatorRoot

    property bool isConfirmCloseOpen: false
    property bool rccInitialized: false
    property bool recompileRequested: false
    property var debugPlatform: ({
                                     deviceId: Constants.NULL_DEVICE_ID,
                                     classId: ""
                                 })

    onDebugPlatformChanged: {
        recompileControlViewQrc();
    }

    property alias openFilesModel: editor.openFilesModel
    property alias confirmClosePopup: confirmClosePopup
    property bool isConsoleLogOpen: false

    function closeAllFiles(closeWithoutSave){
        var count = editor.fileTabRepeater.count
        if(!closeWithoutSave){
            for(var i = 0; i < count; i++){
                if(openFilesModel.getUnsavedCount() > 0){
                    openFilesModel.saveFileAt(i, true)
                } else {
                    openFilesModel.closeTabAt(i)
                }

            }
        } else {
            for(var i = 0; i < count; i++){
                openFilesModel.closeTabAt(i)
            }
        }
    }

    SGUserSettings {
        id: sgUserSettings
        classId: "controlViewCreator"
        user: NavigationControl.context.user_id
    }

    ConfirmClosePopup {
        id: confirmClosePopup
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        parent: mainWindow.contentItem

        titleText: "You have unsaved changes in " + unsavedFileCount + " files."
        popupText: "Your changes will be lost if you choose to not save them."
        acceptButtonText: "Save all"

        property int unsavedFileCount

        onPopupClosed: {
            if (closeReason === confirmClosePopup.closeFilesReason) {
                controlViewCreator.openFilesModel.closeAll()
                if (cvcCloseRequested){
                    Signals.closeCVC()
                } else {
                    mainWindow.close()
                }
            } else if (closeReason === confirmClosePopup.acceptCloseReason) {
                controlViewCreator.openFilesModel.saveAll(true)
                if (cvcCloseRequested){
                    Signals.closeCVC()
                } else {
                    mainWindow.close()
                }
            }
            isConfirmCloseOpen = false
        }
    }

    SGConfirmationPopup {
        id: confirmCleanFiles
        modal: true
        padding: 0
        closePolicy: Popup.NoAutoClose

        acceptButtonColor: Theme.palette.green
        acceptButtonHoverColor: Qt.darker(acceptButtonColor, 1.25)
        acceptButtonText: "Clean"
        cancelButtonText: "Cancel"
        titleText: "Remove missing files"
        popupText: {
            let text = "Are you sure you want to remove the following files from this project's QRC?<br><ul type=\"bullet\">";
            for (let i = 0; i < missingFiles.length; i++) {
                text += "<li>" + missingFiles[i] + "</li>"
            }
            text += "</ul>"
            return text
        }

        property var missingFiles: []

        onOpened: {
            missingFiles = editor.fileTreeModel.getMissingFiles()
        }

        onPopupClosed: {
            if (closeReason === acceptCloseReason) {
                editor.fileTreeModel.removeDeletedFilesFromQrc()
            }
        }
    }

    SGConfirmationPopup {
        id: missingControlQml
        modal: true
        padding: 0
        closePolicy: Popup.NoAutoClose

        buttons: [okButtonObject]

        property var okButtonObject: ({
                                          buttonText: "Ok",
                                          buttonColor: acceptButtonColor,
                                          buttonHoverColor: acceptButtonHoverColor,
                                          closeReason: acceptCloseReason
                                      });

        titleText: "Missing Control.qml"
        popupText: "You are missing a Control.qml file at the root of your project. This will cause errors when trying to build the project."
    }

    ConfirmClosePopup {
        id: closeAllFilesConfirmation
        titleText: "Close all files"
        popupText: "This will close all tabs. Are you sure you want to close all tabs?"
        acceptButtonText: "Close all w/saving"
        closeButtonText: "Close all wo/saving"
        closeButtonColor: "blue"

        onPopupClosed: {
            if(closeReason === acceptCloseReason){
                closeAllFiles(false)
            } else if(closeReason === closeFilesReason){
                closeAllFiles(true)
            }

            isConfirmCloseOpen = false
        }
    }

    RowLayout {
        anchors {
            fill: parent
        }
        spacing:  0

        NavigationBar {
            id: navigationBar
        }

        SGSplitView {
            Layout.fillHeight: true
            Layout.fillWidth: true
            orientation: Qt.Vertical

            StackLayout {
                id: viewStack
                Layout.fillHeight: true
                Layout.fillWidth: true

                Start {
                    id: startContainer
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                }

                Editor {
                    id: editor
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                }

                SGSplitView {
                    id: controlViewContainer
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    onResizingChanged: {
                        if (!resizing) {
                            if (debugPanel.width >= debugPanel.minimumExpandWidth) {
                                debugPanel.expandWidth = debugPanel.width
                            } else {
                                debugPanel.expandWidth = debugPanel.minimumExpandWidth
                            }
                        }
                    }

                    Loader {
                        id: controlViewLoader
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Layout.minimumWidth: 600

                        asynchronous: true

                        onStatusChanged: {
                            if (status === Loader.Ready) {
                                // Tear Down creation context
                                delete NavigationControl.context.class_id
                                delete NavigationControl.context.device_id

                                recompileRequested = false
                            } else if (status === Loader.Error) {
                                // Tear Down creation context
                                delete NavigationControl.context.class_id
                                delete NavigationControl.context.device_id

                                recompileRequested = false
                                console.error("Error while loading control view")
                                setSource(NavigationControl.screens.LOAD_ERROR,
                                          { "error_message": "Failed to load control view: " + sourceComponent.errorString() }
                                          );
                            }
                        }
                    }

                    DebugPanel {
                        id: debugPanel
                        Layout.fillHeight: true
                    }
                }

                PlatformInterfaceGenerator {
                    id: platformInterfaceGenerator
                }
            }

            Item {
                id: editViewConsoleContainer
                Layout.minimumHeight: 30
                implicitHeight: 200
                Layout.fillWidth: true
                visible:  viewStack.currentIndex === 1 &&  isConsoleLogOpen === true
            }
        }
    }

    ConsoleContainer {
        id:consoleContainer
        parent: (viewStack.currentIndex === 1) ? editViewConsoleContainer : viewConsoleLog.consoleLogParent
        onClicked: {
            isConsoleLogOpen = false
        }
    }

    ViewConsoleContainer {
        id: viewConsoleLog
        width: parent.width - 71
        implicitHeight: parent.height
        visible: viewStack.currentIndex === 2 &&  isConsoleLogOpen === true
    }

    ConfirmClosePopup {
        id: confirmBuildClean
        parent: mainWindow.contentItem

        titleText: "Stopping build due to unsaved changes in the project"
        popupText: "Some files have unsaved changes, would you like to save all changes before build or build without saving?"

        acceptButtonText: "Save All and Build"
        closeButtonText: "Build Without Saving"

        onPopupClosed: {
            if (closeReason === cancelCloseReason) {
                return
            }

            if (closeReason === acceptCloseReason) {
                editor.openFilesModel.saveAll(false)
            }

            requestRecompile()
        }
    }

    function recompileControlViewQrc() {
        if (editor.fileTreeModel.url.toString() !== '') {
            if (editor.openFilesModel.getUnsavedCount() > 0) {
                confirmBuildClean.open();
            } else {
                requestRecompile()
            }
        }
    }

    function requestRecompile() {
        recompileRequested = true
        controlViewLoader.setSource("")
        Help.resetDeviceIdTour(debugPlatform.deviceId)
        sdsModel.resourceLoader.recompileControlViewQrc(SGUtilsCpp.urlToLocalFile(editor.fileTreeModel.url))
    }

    function loadDebugView (compiledRccFile) {
        let uniquePrefix = new Date().getTime().valueOf()
        uniquePrefix = "/" + uniquePrefix

        // Register debug control view object
        if (!sdsModel.resourceLoader.registerResource(compiledRccFile, uniquePrefix)) {
            console.error("Failed to register resource")
            return
        }

        let qml_control = "qrc:" + uniquePrefix + "/Control.qml"

        Help.setDeviceId(debugPlatform.deviceId)
        NavigationControl.context.class_id = debugPlatform.classId
        NavigationControl.context.device_id = debugPlatform.deviceId

        controlViewLoader.setSource(qml_control, Object.assign({}, NavigationControl.context))
    }

    function blockWindowClose() {
        let unsavedCount = editor.openFilesModel.getUnsavedCount();
        if (unsavedCount > 0 && !controlViewCreatorRoot.isConfirmCloseOpen) {
            confirmClosePopup.unsavedFileCount = unsavedCount;
            confirmClosePopup.open();
            controlViewCreatorRoot.isConfirmCloseOpen = true;
            return true
        }
        return false
    }
}

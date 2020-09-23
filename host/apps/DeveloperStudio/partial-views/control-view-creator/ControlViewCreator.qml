import QtQuick 2.12
import QtQuick.Layouts 1.12

import tech.strata.sgwidgets 1.0
import tech.strata.SGQrcListModel 1.0
import tech.strata.commoncpp 1.0
import "qrc:/js/navigation_control.js" as NavigationControl

Rectangle {
    id: controlViewCreatorRoot
    objectName: "ControlViewCreator"
    property string currentFileUrl: ""

    SGUserSettings {
        id: sgUserSettings
        classId: "controlViewCreator"
        user: NavigationControl.context.user_id
    }

    SGQrcListModel {
        id: fileModel

        onParsingFinished: {
            for (let i = 0; i < fileModel.count; i++) {
                if (fileModel.get(i).filename.toLowerCase() === "control.qml") {
                    let item = fileModel.get(i);
                    item.open = true;
                    item.visible = true;
                    break;
                }
            }
        }
    }

    ColumnLayout {
        anchors {
            fill: parent
        }
        spacing:  0

        Rectangle {
            id: topBar
            Layout.preferredHeight: 45
            Layout.fillWidth: true
            Layout.maximumWidth: parent.width
            color: "#666"
            visible: viewStack.currentIndex >= editUseStrip.offset

            RowLayout {
                height: parent.height
                width: Math.min(implicitWidth, parent.width-5)
                x: 2.5
                spacing: 10

                SGButton {
                    text: "Open Control View Project"
                    onClicked: {
                        viewStack.currentIndex = 1
                    }
                }

                SGButton {
                    text: "New Control View Project"
                    onClicked: {
                        viewStack.currentIndex = 2
                    }
                }

                SGButtonStrip {
                    id: editUseStrip
                    model: ["Edit", "Use Control View"]
                    checkedIndices: 0
                    onClicked: {
                        if (currentFileUrl != fileModel.url) {
                            recompileControlViewQrc()
                            currentFileUrl = fileModel.url
                        }
                        viewStack.currentIndex = index + offset
                    }

                    property int offset: 3 // number of views in stack before Editor/ControlViewContainer
                }

                SGButton {
                    text: "Recompile/Reload Control View"

                    onClicked: {
                        recompileControlViewQrc()
                    }
                }
            }
        }

        StackLayout {
            id: viewStack
            Layout.fillHeight: true
            Layout.fillWidth: true

            onCurrentIndexChanged: {
                if (currentIndex !== editUseStrip.offset && currentIndex !== (editUseStrip.offset + 1)) {
                    editUseStrip.checkedIndices = 0
                }
            }

            Start {
                id: startContainer
                Layout.fillHeight: true
                Layout.fillWidth: true
            }

            OpenControlView {
                id: openProjectContainer
                Layout.fillHeight: true
                Layout.fillWidth: true
            }

            NewControlView {
                id: newControlViewContainer
                Layout.fillHeight: true
                Layout.fillWidth: true
            }

            Editor {
                id: editor
                Layout.fillHeight: true
                Layout.fillWidth: true
            }

            Rectangle {
                id: controlViewContainer
                Layout.fillHeight: true
                Layout.fillWidth: true
                color: "lightcyan"

                SGText {
                    anchors {
                        centerIn: parent
                    }
                    fontSizeMultiplier: 2
                    text: "Control view from RCC loaded here"
                    opacity: .25
                }
            }
        }
    }

    function recompileControlViewQrc () {
        if (fileModel.url != '') {
            let compiledRccFile = sdsModel.resourceLoader.recompileControlViewQrc(fileModel.url)
            if (compiledRccFile != '') {
                loadDebugView(compiledRccFile)
            }
        }
    }

    function loadDebugView (compiledRccFile) {
        NavigationControl.removeView(controlViewContainer)

        let uniquePrefix = new Date().getTime().valueOf()
        uniquePrefix = "/" + uniquePrefix

        // Register debug control view object
        if (!sdsModel.resourceLoader.registerResource(compiledRccFile, uniquePrefix)) {
            console.error("Failed to register resource")
            return
        }

        let qml_control = "qrc:" + uniquePrefix + "/Control.qml"
        let obj = sdsModel.resourceLoader.createViewObject(qml_control, controlViewContainer);
        if (obj === null) {
            let error_str = sdsModel.resourceLoader.getLastLoggedError()
            sdsModel.resourceLoader.createViewObject(NavigationControl.screens.LOAD_ERROR, controlViewContainer, {"error_message": error_str});
            console.error("Could not load view: " + error_str)
        }
    }
}

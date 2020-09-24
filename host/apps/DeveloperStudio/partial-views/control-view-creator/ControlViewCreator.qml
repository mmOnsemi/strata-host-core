import QtQuick 2.12
import QtQuick.Layouts 1.12

import tech.strata.sgwidgets 1.0
import tech.strata.commoncpp 1.0
import "qrc:/js/navigation_control.js" as NavigationControl

Rectangle {
    id: controlViewCreatorRoot
    objectName: "ControlViewCreator"
    property alias openProjectContainer: openProjectContainer

    SGUserSettings {
        id: sgUserSettings
        classId: "controlViewCreator"
        user: NavigationControl.context.user_id
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
                        viewStack.currentIndex = index + offset
                    }

                    property int offset: 3 // number of views in stack before Editor/ControlViewContainer
                }

                SGButton {
                    text: "Recompile/Reload Control View"
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
}

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import tech.strata.sci 1.0 as SciCommonCpp
import tech.strata.sgwidgets 1.0 as SGWidgets
import tech.strata.fonts 1.0 as StrataFonts
import tech.strata.commoncpp 1.0 as CommonCpp
import tech.strata.common 1.0 as Common


Item {
    id: root
    anchors {
        fill: parent
    }

    property bool programDeviceDialogOpened: false

    SciCommonCpp.SciModel {
        id: sciModel
    }

    ListModel {
        id: tabModel
    }

    Connections {
        target:  sciModel.boardController

        onActiveBoard: {
            if (programDeviceDialogOpened) {
                return
            }

            var connectionInfo = sciModel.boardController.getConnectionInfo(connectionId)

            var effectiveVerboseName = connectionInfo.verboseName

            if (connectionInfo.verboseName.length === 0) {
                if (connectionInfo.applicationVersion.lenght > 0) {
                    effectiveVerboseName = "Application v"+connectionInfo.applicationVersion
                } else if (connectionInfo.bootloaderVersion.length > 0) {
                    effectiveVerboseName = "Bootloader v"+connectionInfo.bootloaderVersion
                } else {
                    effectiveVerboseName = "Unknown"
                }
            }

            var platformItem = {
                "connectionId": connectionInfo.connectionId,
                "platformId": connectionInfo.platformId,
                "verboseName": effectiveVerboseName,
                "bootloaderVersion": connectionInfo.bootloaderVersion,
                "applicationVersion": connectionInfo.applicationVersion,
                "status": "connected"
            }

            for (var i = 0; i < tabModel.count; ++i) {
                var item = tabModel.get(i)
                if (item.connectionId === connectionId) {
                    tabModel.set(i, platformItem)
                    return
                }
            }

            tabModel.append(platformItem)

            tabBar.currentIndex = tabModel.count - 1
        }

        onDisconnectedBoard: {
            for (var i = 0; i < tabModel.count; ++i) {
                var item = tabModel.get(i)
                if (item.connectionId === connectionId) {
                    tabModel.setProperty(i, "status","disconnected")
                    return
                }
            }
        }
    }

    Item {
        id: tabBarWrapper
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }

        height: 40

        Rectangle {
            anchors.fill: parent
            color: "black"
        }

        TabBar {
            id: tabBar
            width: Math.min(tabBarWrapper.width /*- iconRowWrapper.width*/, 500 * tabModel.count)
            anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
            }

            rightPadding: tabBar.spacing
            currentIndex: -1

            background: Rectangle {
                color: "#eeeeee"
            }

            Repeater {
                model: tabModel

                delegate: TabButton {
                    id: delegate

                    hoverEnabled: true

                    property int currentIndex: TabBar.tabBar.currentIndex

                    background: Rectangle {
                        implicitHeight: 40
                        color: index === currentIndex ? "#eeeeee" : SGWidgets.SGColorsJS.STRATA_DARK
                    }

                    contentItem: Item {
                        SGWidgets.SGStatusLight {
                            id: statusLight
                            anchors {
                                left: parent.left
                                verticalCenter: parent.verticalCenter
                            }
                            lightSize: Math.round(buttonText.paintedHeight) + 10

                            status: {
                                if (model.status === "connected") {
                                    return SGWidgets.SGStatusLight.Green
                                } if (model.status === "disconnected") {
                                    return SGWidgets.SGStatusLight.Off
                                }

                                return SGWidgets.SGStatusLight.Orange
                            }
                        }

                        SGWidgets.SGText {
                            id: buttonText
                            anchors {
                                left: statusLight.right
                                leftMargin: 2
                                verticalCenter: parent.verticalCenter
                                right: delegate.hovered ? deleteButton.left : parent.right
                                rightMargin: 2
                            }

                            fontSizeMultiplier: 1.1
                            text: model.verboseName
                            font.family: StrataFonts.Fonts.franklinGothicBold
                            color: model.index === delegate.currentIndex ? "black" : "white"
                            elide: Text.ElideRight
                        }

                        SGWidgets.SGIconButton {
                            id: deleteButton
                            anchors {
                                right: parent.right
                                rightMargin: 2
                                verticalCenter: parent.verticalCenter
                            }

                            visible: delegate.hovered
                            alternativeColorEnabled: model.index !== delegate.currentIndex
                            icon.source: "qrc:/sgimages/times.svg"
                            onClicked: {
                                if (model.status === "connected") {
                                    SGWidgets.SGDialogJS.showConfirmationDialog(
                                                root,
                                                "Device is active",
                                                "Do you really want to disconnect " + model.verboseName + " ?",
                                                "Disconnect",
                                                function () {
                                                    var ret = sciModel.boardController.disconnect(connectionId)
                                                    if (ret) {
                                                        removeBoard(model.connectionId)
                                                    }
                                                },
                                                "Keep Connected"
                                                )
                                } else {
                                    removeBoard(model.connectionId)
                                }
                            }
                        }
                    }
                }
            }
        }

        Item {
            id: iconRowWrapper
            width: iconRow.width + 4
            anchors {
                right: parent.right
                top: tabBar.top
                bottom: tabBar.bottom
            }

            //hiden until there is content in side pane again
            visible: false

            Row {
                id: iconRow
                anchors {
                    centerIn: parent
                }

                spacing: 4

                SGWidgets.SGIconButton {
                    alternativeColorEnabled: true
                    icon.source: sidePane.shown ? "qrc:/images/side-pane-right-close.svg" : "qrc:/images/side-pane-right-open.svg"
                    iconSize: 26
                    onClicked: {
                        sidePane.shown = !sidePane.shown
                    }
                }
            }
        }
    }

    StackLayout {
        id: platformContentContainer
        anchors {
            top: tabBarWrapper.bottom
            left: root.left
            right: sidePane.left
            bottom: root.bottom
        }

        visible: tabModel.count > 0
        currentIndex: tabBar.currentIndex
        onCurrentIndexChanged: {
            if (currentIndex >= 0) {
                platformContentContainer.itemAt(currentIndex).forceActiveFocus()
            }
        }

        Repeater {
            model: tabModel
            delegate: PlatformDelegate {
                id: platformDelegate
                width: platformContentContainer.width
                height: platformContentContainer.height
                rootItem: root

                onSendCommandRequested: {
                    sendCommand(connectionId, message)
                }

                onProgramDeviceRequested: {
                    if (model.status === "connected") {
                        showProgramDeviceDialogDialog(model.connectionId)
                    }
                }

                Connections {
                    target:  sciModel.boardController
                    onNotifyBoardMessage: {
                        if (programDeviceDialogOpened) {
                            return
                        }

                        if (model.connectionId === connectionId) {
                            var timestamp = Date.now()
                            appendCommand(createCommand(timestamp, message, "response"))
                        }
                    }
                }
            }
        }
    }

    Item {
        anchors.fill: platformContentContainer
        visible: tabModel.count === 0
        Text {
            anchors.centerIn: parent
            text: "No Device Connected"
            font.pointSize: 50
        }
    }

    Item {
        id: sidePane
        width: shown ? 140 : 0
        anchors {
            top: tabBarWrapper.bottom
            topMargin: 1
            bottom: parent.bottom
            right: parent.right
        }

        visible: shown

        property bool shown: false

        Rectangle {
            anchors.fill: parent
            color: "black"
        }

        Column {
            anchors {
                top: parent.top
                topMargin: 16
                horizontalCenter: parent.horizontalCenter
            }

            spacing: 10

            //menu
        }
    }

    Component {
        id: programDeviceDialogComponent

        SGWidgets.SGDialog {
            id: dialog

            modal: true
            closePolicy: Popup.NoAutoClose
            focus: true
            padding: 0
            hasTitle: false

            property string connectionId

            contentItem: SGWidgets.SGPage {
                implicitWidth: root.width - 20
                implicitHeight: root.height - 20

                title: "Program Device Wizard"
                hasBack: false

                contentItem: Common.ProgramDeviceWizard {
                    boardController: sciModel.boardController
                    closeButtonVisible: true
                    requestCancelOnClose: true
                    loopMode: false
                    checkFirmware: false
                    currentConnectionId: connectionId

                    onCancelRequested: {
                        if (programDeviceDialogOpened) {
                            dialog.close()
                            programDeviceDialogOpened = false
                            refrestDeviceInfo()

                        }
                    }
                }
            }
        }
    }

    function removeBoard(connectionId) {
        for (var i = 0; i < tabModel.count; ++i) {
            var item = tabModel.get(i)
            if (item.connectionId === connectionId) {
                tabModel.remove(i)

                if (tabBar.currentIndex < 0 && tabModel.count > 0) {
                    tabBar.currentIndex = 0;
                }

                return
            }
        }
    }

    function sendCommand(connectionId, message) {
        var timestamp = Date.now()
        platformContentContainer.itemAt(tabBar.currentIndex).appendCommand(createCommand(timestamp, message, "query"))

        sciModel.boardController.sendCommand(connectionId, message)
    }

    function createCommand(timestamp, message, type) {
        return {
            "timestamp" : timestamp,
            "message": message,
            "type": type,
            "condensed": false,
        }
    }

    function showProgramDeviceDialogDialog(connectionId) {
        var dialog = SGWidgets.SGDialogJS.createDialogFromComponent(
                    root,
                    programDeviceDialogComponent,
                    {
                        "connectionId": connectionId
                    })

        programDeviceDialogOpened = true
        dialog.open()
    }

    function refrestDeviceInfo() {
        //we need deep copy
        var connectionIds = JSON.parse(JSON.stringify(sciModel.boardController.connectionIds))

        for (var i = 0; i < connectionIds.length; ++i) {
            sciModel.boardController.reconnect(connectionIds[i])
        }
    }
}

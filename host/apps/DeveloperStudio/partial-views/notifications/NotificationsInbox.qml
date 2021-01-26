import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQml 2.12
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.12

import "qrc:/js/login_utilities.js" as Authenticator
import "qrc:/js/navigation_control.js" as NavigationControl

import tech.strata.commoncpp 1.0
import tech.strata.signals 1.0
import tech.strata.theme 1.0
import tech.strata.sgwidgets 1.0
import tech.strata.notifications 1.0

Drawer {
    id: notificationsDrawer
    edge: Qt.RightEdge
    interactive: true
    dragMargin: 0 // prevent swipes to open
    width: 400
    modal: true

    //// todo: loader that only loads below when visible

    background: Rectangle {
        color: Theme.palette.lightGray
    }

    Loader {
        width: parent.width
        height: parent.height
        active: parent.visible

        sourceComponent: ColumnLayout {
            spacing: 5

            SGSortFilterProxyModel {
                id: sortedModel
                sourceModel: Notifications.model
                sortEnabled: true
                invokeCustomFilter: true
                sortRole: "date"
                sortAscending: false

                function filterAcceptsRow(index) {
                    const item = sourceModel.get(index);
                    const filterLevel = filterBox.currentIndex - 1;

                    if (filterLevel < 0) {
                        return true
                    } else {
                        return item.level === filterLevel
                    }
                }
            }

            SGText {
                text: sortedModel.count + " Notification" + (sortedModel.count === 1 ? "" : "s")
                font.bold: true
                font.capitalization: Font.AllUppercase
                Layout.fillWidth: true
                Layout.leftMargin: 5
                Layout.rightMargin: 5
                Layout.topMargin: 5
            }

            RowLayout {
                Layout.preferredHeight: 30
                Layout.fillHeight: false
                Layout.leftMargin: 5
                Layout.rightMargin: 5

                SGButton {
                    text: "Clear all"
                    Layout.fillHeight: true
                    onClicked: {
                        Notifications.model.clear()
                    }
                }

                SGComboBox {
                    id: filterBox
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    model: ["Show All", "Show Info", "Show Warning", "Show Critical"]

                    onCurrentIndexChanged: {
                        sortedModel.invalidate()
                    }
                }
            }

            ListView {
                clip: true
                model: sortedModel
                spacing: 1
                Layout.fillHeight: true
                Layout.fillWidth: true

                delegate: NotificationsInboxDelegate {
                    modelIndex: index
                }

                SGText {
                    visible: sortedModel.count === 0
                    anchors {
                        centerIn: parent
                    }
                    text: "No Notifications"
                    color: Theme.palette.darkGray
                    opacity: .5
                    fontSizeMultiplier: 2
                }
            }
        }
    }
}

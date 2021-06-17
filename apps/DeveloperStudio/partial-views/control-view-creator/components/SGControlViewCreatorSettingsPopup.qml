import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import tech.strata.sgwidgets 1.0

SGControlViewCreatorPopup {
    id: root
    modal: true
    visible: true
    headerText: "Control View Creator Settings"
    closePolicy: Popup.CloseOnEscape
    focus: true
    width: 400
    anchors.centerIn: Overlay.overlay

    onClosed: {
        parent.active = false
    }

    contentItem: ColumnLayout {
        id: column
        width: parent.width - 40

        SGText {
            text: "Build Settings"
            fontSizeMultiplier: 1.3
        }

        Rectangle {
            // divider
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: "#666"
        }

        SGControlViewCheckbox {
            id: openViewBox
            text: "Open \"the View\" on build"
            checked: cvcUserSettings.openViewOnBuild

            onCheckedChanged: {
                cvcUserSettings.openViewOnBuild = checked
                cvcUserSettings.saveSettings()
            }
        }
    }
}

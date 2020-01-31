import QtQuick 2.12
import QtQuick.Controls 2.12

import tech.strata.sgwidgets 1.0
import tech.strata.fonts 1.0
import tech.strata.logger 1.0

Item {
    anchors.fill: parent

    SGAlignedLabel {
        id: demoLabel
        target: sgSwitch
        text: "Switch:"
        fontSizeMultiplier: 1.3
        enabled: editEnabledCheckBox.checked

        SGSwitch {
            id: sgSwitch


            // Optional Configuration:
            checkedLabel: "Switch On"           // Default: "" (if not entered, label will not appear)
            uncheckedLabel: "Switch Off"        // Default: "" (if not entered, label will not appear)
            // width: 100                       // Default: switchRow.implicitWidth
            // height: 25                       // Default: 25 * fontSizeMultiplier
            // labelsInside: false              // Default: true
            // textColor: "white"               // Default: labelsInside ? "white" : "black"
            // handleColor: "white"             // Default: "white"
            // grooveColor: "#ccc"              // Default: "#B3B3B3"
            // grooveFillColor: "#0cf"          // Default: "#0cf"
            // fontSizeMultiplier: 3            // Default: 1.0


            // Usable Signals:
            onCheckedChanged: console.info("Checked toggled")
            onReleased: console.info("Switch released")
            onCanceled: console.info("Switch canceled")
            onClicked: console.info("Switch clicked")
            onPress: console.info("Switch pressed")
            onPressAndHold: console.info("Switch pressed and held")
        }
    }

    SGCheckBox {
        id: editEnabledCheckBox
        anchors {
            top: demoLabel.bottom
            topMargin: 20
        }

        text: "Everything enabled"
        checked: true
        onCheckedChanged:  {
            if(checked)
                demoLabel.opacity = 1.0
            else demoLabel.opacity = 0.5
        }

    }

}


import QtQuick 2.9
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.5

import tech.strata.fonts 1.0
import tech.strata.sgwidgets 1.0

import "qrc:/js/help_layout_manager.js" as Help

Item {
    id: controlNavigation

    anchors.fill: parent

    property real minContentHeight: 688
    property real minContentWidth: 1024-rightBarWidth
    property real rightBarWidth: 80
    property real factor: Math.min(controlNavigation.height/minContentHeight,(controlNavigation.width-rightBarWidth)/minContentWidth)
    property real vFactor: Math.max(1,height/minContentHeight)
    property real hFactor: Math.max(1,(width-rightBarWidth)/minContentWidth)

    // Notifications
    property var control_states: platformInterface.control_states
    property var telemetryNoti: platformInterface.telemetry
    property bool underVoltageNoti: platformInterface.int_vin_lw_th.value
    property bool overVoltageNoti: platformInterface.int_vin_up_th.value
    property bool powerGoodNoti: platformInterface.int_pg.value
    property bool osAlertNoti: platformInterface.int_os_alert.value

    Component.onCompleted: {
        platformInterface.get_all_states.send()
        Help.registerTarget(enableSWLabel, "None", 0, "ecoSWITCHHelp")
        Help.registerTarget(shortCircuitSWLabel, "None", 1, "ecoSWITCHHelp")
        Help.registerTarget(vccVoltageSWLabel, "None", 2, "ecoSWITCHHelp")
        Help.registerTarget(slewRateLabel, "None", 3, "ecoSWITCHHelp")
    }

    onControl_statesChanged: {
        enableSW.checked = control_states.enable
        shortCircuitSW.checked = control_states.sc_en
        vccVoltageSW.checked = control_states.vcc_sel === "5"
        slewRate.currentIndex = slewRate.model.indexOf(control_states.slew_rate)
    }

    onTelemetryNotiChanged: {
        currentBox.text = telemetryNoti.iin
        vinesBox.text = telemetryNoti.vin
        vccBox.text = telemetryNoti.vcc
        voutBox.text = telemetryNoti.vout
        boardTemp.value = Number(telemetryNoti.temperature)
        rdsVoltageDrop.value = Number(telemetryNoti.vdrop)
        powerLoss.value = Number(telemetryNoti.ploss)
    }

    onUnderVoltageNotiChanged: underVoltage.status = underVoltageNoti ? SGStatusLight.Red : SGStatusLight.Off
    onOverVoltageNotiChanged: overVoltage.status = overVoltageNoti ? SGStatusLight.Red : SGStatusLight.Off
    onPowerGoodNotiChanged: powerGood.status = powerGoodNoti ? SGStatusLight.Green : SGStatusLight.Off
    onOsAlertNotiChanged: osAlert.status = osAlertNoti ? SGStatusLight.Red : SGStatusLight.Off

    PlatformInterface {
        id: platformInterface
    }

    Rectangle {
        id: content
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
            right: rightMenu.left
        }

        GridLayout {
            anchors{
                centerIn: parent
                margins: 20 * factor
            }
            columns: 3
            rows: 2

            GridLayout {
                columns: 3
                rows: 2
                columnSpacing: 10 * factor
                rowSpacing: 20 * factor
                Layout.alignment: Qt.AlignCenter

                SGAlignedLabel {
                    id: enableSWLabel
                    target: enableSW
                    text: "<b>" + qsTr("Enable") + "</b>"
                    fontSizeMultiplier: factor * 1.4
                    SGSwitch {
                        id: enableSW
                        height: 40 * factor
                        width: 90 * factor
                        checkedLabel: "On"
                        uncheckedLabel: "Off"
                        fontSizeMultiplier: factor * 1.4
                        onClicked: platformInterface.set_enable.update(checked ? "on" : "off")
                    }
                }
                SGAlignedLabel {
                    id: shortCircuitSWLabel
                    target: shortCircuitSW
                    text: "<b>" + qsTr("Short Circuit") + "</b>"
                    fontSizeMultiplier: factor * 1.4
                    SGSwitch {
                        id: shortCircuitSW
                        height: 40 * factor
                        width: 90 * factor
                        checkedLabel: "On"
                        uncheckedLabel: "Off"
                        fontSizeMultiplier: factor * 1.4
                        onClicked: platformInterface.short_circuit_enable.update(checked ? "on" : "off")
                    }
                }
                SGAlignedLabel {
                    id: vccVoltageSWLabel
                    target: vccVoltageSW
                    text: "<b>" + qsTr("VCC Voltage") + "</b>"
                    fontSizeMultiplier: factor * 1.4
                    SGSwitch {
                        id: vccVoltageSW
                        height: 40 * factor
                        width: 95 * factor
                        checkedLabel: "5V"
                        uncheckedLabel: "3.3V"
                        fontSizeMultiplier: factor * 1.4
                        grooveColor: "#0cf"
                        onClicked: platformInterface.set_vcc.update(checked ? "5" : "3.3")
                    }
                }
                SGAlignedLabel {
                    id: slewRateLabel
                    target: slewRate
                    text: "<b>" + qsTr("Approximate Slew Rate") + "</b>"
                    fontSizeMultiplier: factor * 1.4
                    Layout.columnSpan: 3
                    SGComboBox {
                        id: slewRate
                        height: 40 * factor
                        width: 140 * factor
                        model: ["4.1 kV/s","7 kV/s", "10 kV/s", "13.7 kV/s"]
                        fontSizeMultiplier: factor * 1.4
                        onActivated: platformInterface.set_slew_rate.update(currentText)
                    }
                }
            }

            GridLayout {
                columns: 2
                rows: 2
                columnSpacing: 10 * factor
                rowSpacing: 20 * factor
                Layout.alignment: Qt.AlignCenter

                SGAlignedLabel {
                    id: currentBoxLabel
                    target: currentBox
                    text: "<b>" + qsTr("Current (IIN)") + "</b>"
                    fontSizeMultiplier: factor * 1.4
                    SGInfoBox {
                        id: currentBox
                        height: 40 * factor
                        width: 90 * factor
                        text: "0"
                        unit: "A"
                        fontSizeMultiplier: factor * 1.4
                    }
                }
                SGAlignedLabel {
                    id: vinesBoxLabel
                    target: vinesBox
                    text: "<b>" + qsTr("VIN_ES") + "</b>"
                    fontSizeMultiplier: factor * 1.4
                    SGInfoBox {
                        id: vinesBox
                        height: 40 * factor
                        width: 90 * factor
                        text: "0"
                        unit: "V"
                        fontSizeMultiplier: factor * 1.4
                    }
                }
                SGAlignedLabel {
                    id: vccBoxLabel
                    target: vccBox
                    text: "<b>" + qsTr("VCC") + "</b>"
                    fontSizeMultiplier: factor * 1.4
                    SGInfoBox {
                        id: vccBox
                        height: 40 * factor
                        width: 90 * factor
                        text: "0"
                        unit: "V"
                        fontSizeMultiplier: factor * 1.4
                    }
                }
                SGAlignedLabel {
                    id: voutBoxLabel
                    target: voutBox
                    text: "<b>" + qsTr("VOUT") + "</b>"
                    fontSizeMultiplier: factor * 1.4
                    SGInfoBox {
                        id: voutBox
                        height: 40 * factor
                        width: 90 * factor
                        text: "0"
                        unit: "V"
                        fontSizeMultiplier: factor * 1.4
                    }
                }
            }

            GridLayout {
                rows: 2
                columns: 2
                columnSpacing: 10 * factor
                rowSpacing: 20 * factor
                Layout.alignment: Qt.AlignCenter

                SGAlignedLabel {
                    id: powerGoodLabel
                    target: powerGood
                    text: "<b>" + qsTr("Power Good") + "</b>"
                    fontSizeMultiplier: factor * 1.4
                    alignment: SGAlignedLabel.SideTopCenter
                    Layout.alignment: Qt.AlignCenter
                    SGStatusLight {
                        id: powerGood
                        height: 40 * factor
                        width: 40 * factor
                        status: SGStatusLight.Off
                    }
                }
                SGAlignedLabel {
                    id: underVoltageLabel
                    target: underVoltage
                    text: "<b>" + qsTr("Under Voltage") + "</b>"
                    fontSizeMultiplier: factor * 1.4
                    alignment: SGAlignedLabel.SideTopCenter
                    Layout.alignment: Qt.AlignCenter
                    SGStatusLight {
                        id: underVoltage
                        height: 40 * factor
                        width: 40 * factor
                        status: SGStatusLight.Off
                    }
                }
                SGAlignedLabel {
                    id: osAlertLabel
                    target: osAlert
                    text: "<b>" + qsTr("OS/ALERT") + "</b>"
                    fontSizeMultiplier: factor * 1.4
                    alignment: SGAlignedLabel.SideTopCenter
                    Layout.alignment: Qt.AlignCenter
                    SGStatusLight {
                        id: osAlert
                        height: 40 * factor
                        width: 40 * factor
                        status: SGStatusLight.Off
                    }
                }
                SGAlignedLabel {
                    id: overVoltageLabel
                    target: overVoltage
                    text: "<b>" + qsTr("Over Voltage") + "</b>"
                    fontSizeMultiplier: factor * 1.4
                    alignment: SGAlignedLabel.SideTopCenter
                    Layout.alignment: Qt.AlignCenter
                    SGStatusLight {
                        id: overVoltage
                        height: 40 * factor
                        width: 40 * factor
                        status: SGStatusLight.Off
                    }
                }
            }
            SGAlignedLabel {
                id: boardTempLabel
                target: boardTemp
                text: "<b>" + qsTr("Board Temperature (°C)") + "</b>"
                fontSizeMultiplier: factor * 1.4
                alignment: SGAlignedLabel.SideBottomCenter
                Layout.alignment: Qt.AlignCenter
                SGCircularGauge {
                    id: boardTemp
                    height: 300 * factor
                    width: 300 * factor
                    unitText: "°C"
                    unitTextFontSizeMultiplier: factor * 1.4
                    value: 0
                    tickmarkStepSize: 10
                    minimumValue: 0
                    maximumValue: 150
                }
            }
            SGAlignedLabel {
                id: rdsVoltageDropLabel
                target: rdsVoltageDrop
                text: "<b>" + qsTr("RDS Voltage Drop") + "</b>"
                fontSizeMultiplier: factor * 1.4
                alignment: SGAlignedLabel.SideBottomCenter
                Layout.alignment: Qt.AlignCenter
                SGCircularGauge {
                    id: rdsVoltageDrop
                    height: 300 * factor
                    width: 300 * factor
                    unitText: "mV"
                    unitTextFontSizeMultiplier: factor * 1.4
                    value: 0
                    tickmarkStepSize: 10
                    minimumValue: 0
                    maximumValue: 150
                }
            }
            SGAlignedLabel {
                id: powerLossLabel
                target: powerLoss
                text: "<b>" + qsTr("Power Loss") + "</b>"
                fontSizeMultiplier: factor * 1.4
                alignment: SGAlignedLabel.SideBottomCenter
                Layout.alignment: Qt.AlignCenter
                SGCircularGauge {
                    id: powerLoss
                    height: 300 * factor
                    width: 300 * factor
                    unitText: "W"
                    unitTextFontSizeMultiplier: factor * 1.4
                    value: 0
                    tickmarkStepSize: 0.5
                    minimumValue: 0
                    maximumValue: 5
                }
            }
        }
    }

    Rectangle {
        id: rightMenu
        width: rightBarWidth
        anchors {
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }

        MouseArea { // to remove focus in input box when click outside
            anchors.fill: parent

            preventStealing: true
            onClicked: focus = true
        }

        Rectangle {
            width: 1
            anchors {
                top: parent.top
                bottom: parent.bottom
            }

            color: "lightgrey"
        }

        SGIcon {
            id: helpIcon
            height: 40
            width: 40
            anchors {
                right: parent.right
                top: parent.top
                margins: (rightBarWidth-helpIcon.width)/2
            }

            source: "images/question-circle-solid.svg"
            iconColor: helpMouse.containsMouse ? "lightgrey" : "grey"

            MouseArea {
                id: helpMouse
                anchors.fill: helpIcon

                hoverEnabled: true

                onClicked: {
                    focus = true
                    Help.startHelpTour("ecoSWITCHHelp")
                }
            }
        }
    }
}

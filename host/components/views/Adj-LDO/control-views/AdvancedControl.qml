import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import tech.strata.sgwidgets 1.0
import tech.strata.sgwidgets 0.9 as Widget09
import tech.strata.fonts 1.0

import "qrc:/js/help_layout_manager.js" as Help

Item {
    id: root
    property real ratioCalc: root.width / 1200

    property real initialAspectRatio: 1209/820
    property string warningTextIs: "DO NOT exceed LDO input voltage of 5.5V"

    anchors.centerIn: parent

    width: parent.width / parent.height > initialAspectRatio ? parent.height * initialAspectRatio : parent.width
    height: parent.width / parent.height < initialAspectRatio ? parent.width / initialAspectRatio : parent.height

    property var variant_name: platformInterface.variant_name.value
    onVariant_nameChanged: {
        if(variant_name === "NCP164C_TSOP5") {
            warningTextIs = "DO NOT exceed LDO input voltage of 5V"
            //"Set LDO Output Voltage" PlaceHolder
            setLDOOutputVoltage.fromText.text = "1.1V"
            setLDOOutputVoltage.toText.text =  "4.7V"
            setLDOOutputVoltage.from = 1.1
            setLDOOutputVoltage.to = 4.7
            setLDOOutputVoltage.stepSize = 0.01

            //"Set LDO Input Voltage" Placeholder
            ldoInputVolSlider.fromText.text ="1.5V"
            ldoInputVolSlider.toText.text =  "5V"
            ldoInputVolSlider.from = 1.5
            ldoInputVolSlider.to = 5
            ldoInputVolSlider.stepSize = 0.01

        }
        else if (variant_name === "NCP164A_DFN6") {
            warningTextIs = "DO NOT exceed LDO input voltage of 5.5V"
            //"Set LDO Output Voltage" PlaceHolder
            setLDOOutputVoltage.fromText.text ="1.1V"
            setLDOOutputVoltage.toText.text =  "5.2V"
            setLDOOutputVoltage.from = 1.1
            setLDOOutputVoltage.to = 5.2
            setLDOOutputVoltage.stepSize = 0.01

            //"Set LDO Input Voltage" Placeholder
            ldoInputVolSlider.fromText.text ="1.5V"
            ldoInputVolSlider.toText.text =  "5.5V"
            ldoInputVolSlider.from = 1.5
            ldoInputVolSlider.to = 5.5
            ldoInputVolSlider.stepSize = 0.01
        }
        else if (variant_name === "NCP164C_DFN8") {
            warningTextIs = "DO NOT exceed LDO input voltage of 5V"
            //"Set LDO Output Voltage" PlaceHolder
            setLDOOutputVoltage.fromText.text ="1.1V"
            setLDOOutputVoltage.toText.text =  "4.7V"
            setLDOOutputVoltage.from = 1.1
            setLDOOutputVoltage.to = 4.7
            setLDOOutputVoltage.stepSize = 0.01

            //"Set LDO Input Voltage" Placeholder
            ldoInputVolSlider.fromText.text ="1.5V"
            ldoInputVolSlider.toText.text =  "5V"
            ldoInputVolSlider.from = 1.5
            ldoInputVolSlider.to = 5
            ldoInputVolSlider.stepSize = 0.01
        }
        else if (variant_name === "NCV8164A_TSOP5") {
            warningTextIs = "DO NOT exceed LDO input voltage of 5.5V"
            //"Set LDO Output Voltage" PlaceHolder
            setLDOOutputVoltage.fromText.text ="1.2V"
            setLDOOutputVoltage.toText.text =  "5.2V"
            setLDOOutputVoltage.from = 1.2
            setLDOOutputVoltage.to = 5.2
            setLDOOutputVoltage.stepSize = 0.01

            //"Set LDO Input Voltage" Placeholder
            ldoInputVolSlider.fromText.text ="1.5V"
            ldoInputVolSlider.toText.text =  "5.5V"
            ldoInputVolSlider.from = 1.5
            ldoInputVolSlider.to = 5.5
            ldoInputVolSlider.stepSize = 0.01
        }
        else if (variant_name === "NCV8164C_DFN6") {
            warningTextIs = "DO NOT exceed LDO input voltage of 5V"
            //"Set LDO Output Voltage" PlaceHolder
            setLDOOutputVoltage.fromText.text ="1.2V"
            setLDOOutputVoltage.toText.text =  "4.7V"
            setLDOOutputVoltage.from = 1.2
            setLDOOutputVoltage.to = 4.7
            setLDOOutputVoltage.stepSize = 0.01

            //"Set LDO Input Voltage" Placeholder
            ldoInputVolSlider.fromText.text ="1.5V"
            ldoInputVolSlider.toText.text =  "5V"
            ldoInputVolSlider.from = 1.5
            ldoInputVolSlider.to = 5
            ldoInputVolSlider.stepSize = 0.01
        }
        else if (variant_name === "NCV8164A_DFN8") {
            warningTextIs = "DO NOT exceed LDO input voltage of 5.5V"
            //"Set LDO Output Voltage" PlaceHolder
            setLDOOutputVoltage.fromText.text ="1.2V"
            setLDOOutputVoltage.toText.text =  "5.2V"
            setLDOOutputVoltage.from = 1.1
            setLDOOutputVoltage.to = 5.2
            setLDOOutputVoltage.stepSize = 0.01

            //"Set LDO Input Voltage" Placeholder
            ldoInputVolSlider.fromText.text ="1.5V"
            ldoInputVolSlider.toText.text =  "5.5V"
            ldoInputVolSlider.from = 1.5
            ldoInputVolSlider.to = 5.5
            ldoInputVolSlider.stepSize = 0.01
        }
    }

    Component.onCompleted: {
        Help.registerTarget(shortCircuitButton, "This button enables the onboard short-circuit load used to emulate a short to ground on the LDO output for approximately 2 ms. The short-circuit load cannot be enabled when powering the LDO via the 5V from the Strata USB connector and/or when the input buck regulator is enabled. The current pulled by the short-circuit load will vary with LDO output voltage. See the Platform Content page for more information about the short-circuit load and LDO behavior during a short-circuit event.", 0, "AdjLDOAdvanceHelp")
        Help.registerTarget(currentLimitThresholdLabel, "This info box will show the approximate output current threshold at which the LDO's output current limit protection was triggered. This info box does not show the current limit threshold during a short-circuit event caused by enabling the onboard short-circuit load.", 1, "AdjLDOAdvanceHelp")
        Help.registerTarget(pgldoLabel, "This indicator will be green when the LDO power good signal is high.", 2, "AdjLDOAdvanceHelp")
        Help.registerTarget(ocpTriggeredLabel, "This indicator will turn red momentarily if the LDO's power good signal goes low while the short-circuit load is enabled.", 3, "AdjLDOAdvanceHelp")
        Help.registerTarget(currentLimitReachLabel, "This indicator will turn red when the LDO's current limit protection is triggered. See the Platform Content for more information on the current limit behavior of the LDO.", 4, "AdjLDOAdvanceHelp")
        Help.registerTarget(tsdTriggeredLabel, "This indicator will turn red when the LDO's thermal shutdown (TSD) protection is triggered.", 5, "AdjLDOAdvanceHelp")
        Help.registerTarget(estTSDThresLabel, "This info box will show the estimated LDO junction temperature threshold at which the LDO's TSD protection was triggered.", 6, "AdjLDOAdvanceHelp")
        Help.registerTarget(ldoPowerDissipationLabel, "This gauge shows the power loss in the LDO when it is enabled.", 7, "AdjLDOAdvanceHelp")
        Help.registerTarget(boardTempLabel, "This gauge shows the board temperature near the ground pad of the selected LDO package.", 8, "AdjLDOAdvanceHelp")
        Help.registerTarget(appxLDoTempLabel, "This gauge shows the approximate LDO junction temperature. Do not rely on this value for an accurate measurement. See the Platform Content page for more information on how the approximate LDO junction temperature is calculated.", 9, "AdjLDOAdvanceHelp")
        Help.registerTarget(ldoInputVolLabel, "This slider allows you to set the desired input voltage of the LDO when being supplied by the input buck regulator. The value can be set while the input buck regulator is not being used and the voltage will automatically be adjusted as needed when the input buck regulator is activated.", 10, "AdjLDOAdvanceHelp")
        Help.registerTarget(boardInputLabel, "This combo box allows you to choose the main input voltage option (upstream power supply) for the board. The 'External' option uses the input voltage from the input banana plugs (VIN_EXT). The 'USB 5V' option uses the 5V supply from the Strata USB connector. The 'Off' option disconnects both inputs from VIN and pulls VIN low.", 11, "AdjLDOAdvanceHelp")
        Help.registerTarget(ldoEnableSwitchLabel, "This switch enables the LDO.", 12, "AdjLDOAdvanceHelp")
        Help.registerTarget(setLDOOutputVoltageContainer, "This slider allows you to set the desired output voltage of the LDO. The value can be set while the LDO is disabled, and the voltage will automatically be adjusted as needed whenever the LDO is enabled again.", 13, "AdjLDOAdvanceHelp")
        Help.registerTarget(ldoInputLabel, "This combo box allows you to choose the input voltage option for the LDO. The 'Bypass' option connects the LDO input directly to VIN_SB through a load switch. The 'Buck Regulator' option allows adjustment of the input voltage to the LDO through an adjustable output voltage buck regulator. The 'Off' option disables both the input buck regulator and bypass load switch, disconnecting the LDO from the input power supply, and pulls VIN_LDO low. The 'Isolated' option allows you to power the LDO directly through the VIN_LDO solder pad on the board, bypassing the input stage entirely. WARNING! - when using this option, ensure you do not use the other LDO input voltage options while an external power supply is supplying power to the LDO through the VIN_LDO solder pad. See the Platform Content page for more information about the options for supplying the LDO input voltage.", 14, "AdjLDOAdvanceHelp")
        Help.registerTarget(ldoDisableLabel, "Check this box to disable the LDO output voltage adjustment circuit included on this board. This feature is intended to be used to evaluate the LDO as it would be used in an actual application with fixed resistors in the LDO feedback network and to reduce LDO output voltage noise contribution from the Strata interface circuitry. See the Platform Content page for more information on using this feature.", 15, "AdjLDOAdvanceHelp")
        Help.registerTarget(setOutputCurrentLabel, "This slider allows you to set the current pulled by the onboard load. The value can be set while the load is disabled and the load current will automatically be adjusted as needed when the load is enabled. The value may need to be reset to the desired level after recovery from an LDO UVLO event.", 16, "AdjLDOAdvanceHelp")
        Help.registerTarget(ldoPackageLabel, "This combo box allows you to choose the LDO package actually populated on the board if different from the stock LDO package option. See the Platform Content page for more information about using alternate LDO packages with this board.", 17, "AdjLDOAdvanceHelp")
        Help.registerTarget(loadEnableSwitchLabel, "This switch enables the onboard load.", 18, "AdjLDOAdvanceHelp")
        Help.registerTarget(extLoadCheckboxLabel, "Check this box if an external load is connected to the output banana plugs (VOUT).", 19 , "AdjLDOAdvanceHelp")
        Help.registerTarget(vinReadyLabel, "This indicator will be green when the LDO input voltage (VIN_LDO) is greater than the LDO input UVLO threshold of 1.6V.", 20, "AdjLDOAdvanceHelp")
        Help.registerTarget(ldoInputVoltageLabel, "This info box shows the input voltage of the LDO.", 21, "AdjLDOAdvanceHelp")
        Help.registerTarget(ldoOutputVoltageLabel, "This info box shows the output voltage of the LDO.", 22, "AdjLDOAdvanceHelp")
        Help.registerTarget(diffVoltageLabel, "This info box shows the voltage drop across the LDO.", 23, "AdjLDOAdvanceHelp")
        Help.registerTarget(ldoOutputCurrentLabel, "This info box shows the output current of the LDO when pulled by either the onboard electronic load or through an external load connected to the output banana plugs (VOUT). Current pulled by the onboard short-circuit load is not measured and thus will not be shown in this box.", 24, "AdjLDOAdvanceHelp")
        Help.registerTarget(dropReachedLabel, "This indicator will turn red when the LDO is in dropout.", 25, "AdjLDOAdvanceHelp")
    }

    property var telemetry_notification: platformInterface.telemetry
    onTelemetry_notificationChanged: {
        boardTemp.value = telemetry_notification.board_temp
        ldoPowerDissipation.value = telemetry_notification.ploss
        appxLDoTemp.value = telemetry_notification.ldo_temp

        ldoInputVoltage.text = telemetry_notification.vin_ldo
        ldoOutputVoltage.text = telemetry_notification.vout_ldo
        ldoOutputCurrent.text = telemetry_notification.iout
        diffVoltage.text = telemetry_notification.vdiff
        currentLimitThreshold.text = telemetry_notification.ldo_clim_thresh

    }

    property var control_states: platformInterface.control_states
    onControl_statesChanged: {
        if(control_states.vin_sel === "USB 5V")  boardInputComboBox.currentIndex = 0
        else if(control_states.vin_sel === "External") boardInputComboBox.currentIndex = 1
        else if (control_states.vin_sel === "Off") boardInputComboBox.currentIndex = 2

        if(control_states.vin_ldo_sel === "Bypass") ldoInputComboBox.currentIndex = 0
        else if (control_states.vin_ldo_sel === "Buck Regulator") ldoInputComboBox.currentIndex = 1
        else if (control_states.vin_ldo_sel === "Off") ldoInputComboBox.currentIndex = 2
        else if (control_states.vin_ldo_sel === "Isolated") ldoInputComboBox.currentIndex = 3

        if(control_states.load_en === "on")
            loadEnableSwitch.checked = true
        else loadEnableSwitch.checked = false

        ldoInputVolSlider.value = control_states.vin_ldo_set
        setLDOOutputVoltage.value = control_states.vout_ldo_set
        setOutputCurrent.value = control_states.load_set

        if(control_states.ldo_sel === "TSOP5")  ldoPackageComboBox.currentIndex = 0
        else if(control_states.ldo_sel === "DFN6") ldoPackageComboBox.currentIndex = 1
        else if (control_states.ldo_sel === "DFN8") ldoPackageComboBox.currentIndex = 2

    }

    property var int_status: platformInterface.int_status
    onInt_statusChanged: {
        if(int_status.int_pg_ldo === true)  pgldo.status =  SGStatusLight.Green
        else  pgldo.status =  SGStatusLight.Off

        if(int_status.ocp === true) ocpTriggered.status = SGStatusLight.Red
        else ocpTriggered.status = SGStatusLight.Off

        if(int_status.ldo_clim === true) {
            currentLimitReach.status = SGStatusLight.Red
            currentLimitThreshold.text = platformInterface.telemetry.ldo_clim_thresh
        }
        else currentLimitReach.status = SGStatusLight.Off

        if(int_status.tsd === true) tsdTriggered.status = SGStatusLight.Red
        else  tsdTriggered.status = SGStatusLight.Off

        if(int_status.dropout === true)  dropReached.status = SGStatusLight.Red
        else dropReached.status = SGStatusLight.Off
    }

    property var ext_load_checked: platformInterface.ext_load_status.value
    onExt_load_checkedChanged: {
        if (ext_load_checked === true) extLoadCheckbox.checked = true
        else extLoadCheckbox.checked = false
    }

    Rectangle {
        id: noteMessage
        width: parent.width/2
        height: 40
        anchors{
            top: root.top
            topMargin: 20
            horizontalCenter: parent.horizontalCenter
        }

        Rectangle {
            id: noteBox
            color: "red"
            anchors.fill: parent

            Text {
                id: noteText
                anchors.centerIn: noteBox
                text: "Note: External Input Required For OCP/TSD Tests"
                font.bold: true
                font.pixelSize:  ratioCalc * 15
                color: "white"
            }

            Text {
                id: warningIconleft
                anchors {
                    right: noteText.left
                    verticalCenter: noteText.verticalCenter
                    rightMargin: 5
                }
                text: "\ue80e"
                font.family: Fonts.sgicons
                font.pixelSize:  ratioCalc * 14
                color: "white"
            }

            Text {
                id: warningIconright
                anchors {
                    left: noteText.right
                    verticalCenter: noteText.verticalCenter
                    leftMargin: 5
                }
                text: "\ue80e"
                font.family: Fonts.sgicons
                font.pixelSize:  ratioCalc * 14
                color: "white"
            }
        }
    }

    Rectangle {
        width: parent.width// - 10
        height: parent.height - noteMessage.height - 50
        anchors {
            top: noteMessage.bottom
            topMargin: 5
        }

        ColumnLayout {
            anchors.fill:parent

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true

                RowLayout {
                    anchors.fill: parent
                    spacing: 20

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        ColumnLayout {
                            id: outputShortCircuiContainer
                            anchors.fill: parent

                            Text {
                                id: outputShortCircuitText
                                font.bold: true
                                text: "Output Current Limiting/Short-Circuit Protection"
                                font.pixelSize: ratioCalc * 15
                                Layout.topMargin: 20
                                color: "#696969"
                                Layout.leftMargin: 20

                            }

                            Rectangle {
                                id: line1
                                Layout.preferredHeight: 2
                                Layout.alignment: Qt.AlignCenter
                                Layout.preferredWidth: outputShortCircuiContainer.width + 10
                                border.color: "lightgray"
                                radius: 2
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                RowLayout {
                                    anchors.fill: parent
                                    spacing: 10

                                    Rectangle {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true

                                        SGButton {
                                            id: shortCircuitButton
                                            height: (preferredContentHeight * 2)
                                            width: preferredContentWidth * 1.25
                                            text: "Trigger Short \n Circuit"
                                            anchors.centerIn: parent
                                            fontSizeMultiplier: ratioCalc
                                            color: checked ? "#353637" : pressed ? "#cfcfcf": hovered ? "#eee" : "#e0e0e0"
                                            hoverEnabled: true
                                            MouseArea {
                                                hoverEnabled: true
                                                anchors.fill: parent
                                                cursorShape: containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor
                                                onClicked: {
                                                    platformInterface.enable_sc.update()
                                                }
                                            }
                                        }
                                    }

                                    Rectangle {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true

                                        SGAlignedLabel {
                                            id: currentLimitThresholdLabel
                                            target: currentLimitThreshold
                                            text:  "Current Limit \nThreshold"
                                            font.bold: true
                                            alignment: SGAlignedLabel.SideTopLeft
                                            fontSizeMultiplier: ratioCalc
                                            anchors.centerIn: parent

                                            SGInfoBox {
                                                id: currentLimitThreshold
                                                fontSizeMultiplier: ratioCalc === 0 ? 1.0 : ratioCalc * 1.2
                                                width: 100 * ratioCalc
                                                unit: "<b>mA</b>"
                                                boxColor: "lightgrey"
                                                boxFont.family: Fonts.digitalseven
                                            }
                                        }
                                    }
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                RowLayout {
                                    anchors.fill: parent
                                    spacing: 10

                                    Rectangle {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true

                                        SGAlignedLabel {
                                            id:pgldoLabel
                                            target: pgldo
                                            alignment: SGAlignedLabel.SideTopCenter
                                            anchors.centerIn: parent
                                            fontSizeMultiplier: ratioCalc
                                            text: "Power Good"
                                            font.bold: true

                                            SGStatusLight {
                                                id: pgldo
                                            }
                                        }
                                    }

                                    Rectangle {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true

                                        SGAlignedLabel {
                                            id: ocpTriggeredLabel
                                            target: ocpTriggered
                                            alignment: SGAlignedLabel.SideTopCenter
                                            anchors.centerIn: parent
                                            fontSizeMultiplier: ratioCalc
                                            text: "OCP Triggered"
                                            font.bold: true

                                            SGStatusLight {
                                                id: ocpTriggered
                                            }
                                        }
                                    }

                                    Rectangle {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true

                                        SGAlignedLabel {
                                            id: currentLimitReachLabel
                                            target: currentLimitReach
                                            alignment: SGAlignedLabel.SideTopCenter
                                            anchors.centerIn: parent
                                            fontSizeMultiplier: ratioCalc
                                            text: "Current Limit \n Reached"
                                            font.bold: true

                                            SGStatusLight {
                                                id: currentLimitReach
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        ColumnLayout {
                            id: thermalShutdownContainer
                            anchors.fill: parent

                            Text {
                                id: thermalShutdownText
                                font.bold: true
                                text: "Thermal Shutdown"
                                font.pixelSize: ratioCalc * 15
                                Layout.topMargin: 20
                                color: "#696969"
                                Layout.leftMargin: 20

                            }

                            Rectangle {
                                id: line2
                                Layout.preferredHeight: 2
                                Layout.alignment: Qt.AlignCenter
                                Layout.preferredWidth: thermalShutdownContainer.width + 10
                                border.color: "lightgray"
                                radius: 2
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: parent.height/4

                                RowLayout {
                                    anchors.fill: parent
                                    spacing: 10

                                    Rectangle {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true

                                        SGAlignedLabel {
                                            id: tsdTriggeredLabel
                                            target: tsdTriggered
                                            alignment: SGAlignedLabel.SideTopCenter
                                            anchors.centerIn: parent
                                            fontSizeMultiplier: ratioCalc
                                            text: "TSD Triggered"
                                            font.bold: true

                                            SGStatusLight {
                                                id: tsdTriggered
                                            }
                                        }
                                    }

                                    Rectangle {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true

                                        SGAlignedLabel {
                                            id: estTSDThresLabel
                                            target: estTSDThres
                                            text:  "Estimated TSD \nThreshold"
                                            font.bold: true
                                            alignment: SGAlignedLabel.SideTopLeft
                                            fontSizeMultiplier: ratioCalc
                                            anchors.centerIn: parent

                                            SGInfoBox {
                                                id: estTSDThres
                                                fontSizeMultiplier: ratioCalc === 0 ? 1.0 : ratioCalc * 1.2
                                                width: 100 * ratioCalc
                                                unit: "<b>˚C</b>"
                                                boxColor: "lightgrey"
                                                boxFont.family: Fonts.digitalseven
                                                ///text: platformInterface.telemetry.vin
                                            }
                                        }
                                    }
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                RowLayout {
                                    anchors.fill: parent
                                    // spacing: 10

                                    Rectangle {
                                        id: ldoPowerDissipationContiner
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true

                                        SGAlignedLabel {
                                            id:  ldoPowerDissipationLabel
                                            target: ldoPowerDissipation
                                            text: "LDO Power \n Loss"
                                            margin: 0
                                            anchors.centerIn: parent
                                            alignment: SGAlignedLabel.SideBottomCenter
                                            fontSizeMultiplier:   ratioCalc
                                            font.bold : true
                                            horizontalAlignment: Text.AlignHCenter

                                            SGCircularGauge {
                                                id: ldoPowerDissipation
                                                minimumValue: 0
                                                maximumValue: 2.01
                                                tickmarkStepSize:0.2
                                                gaugeFillColor1:"green"
                                                gaugeFillColor2:"red"
                                                width: ldoPowerDissipationContiner.width
                                                height: ldoPowerDissipationContiner.height - ldoPowerDissipationLabel.contentHeight
                                                unitTextFontSizeMultiplier: ratioCalc * 2.5
                                                unitText: "W"
                                                valueDecimalPlaces: 3
                                                //value: platformInterface.status_voltage_current.power_dissipated
                                                //Behavior on value { NumberAnimation { duration: 300 } }
                                            }
                                        }
                                    }

                                    Rectangle {
                                        id: boardTempContainer
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true

                                        SGAlignedLabel {
                                            id:  boardTempLabel
                                            target: boardTemp
                                            text: "Board \n Temperature"
                                            margin: 0
                                            anchors.centerIn: parent
                                            alignment: SGAlignedLabel.SideBottomCenter
                                            fontSizeMultiplier:   ratioCalc
                                            font.bold : true
                                            horizontalAlignment: Text.AlignHCenter

                                            SGCircularGauge {
                                                id: boardTemp
                                                minimumValue: -55
                                                maximumValue: 125
                                                tickmarkStepSize: 20
                                                gaugeFillColor1:"green"
                                                gaugeFillColor2:"red"
                                                width: boardTempContainer.width
                                                height: boardTempContainer.height - boardTempLabel.contentHeight
                                                unitTextFontSizeMultiplier: ratioCalc * 2.5
                                                unitText: "˚C"
                                                valueDecimalPlaces: 1
                                                // value: platformInterface.telemetry.temperature
                                                //Behavior on value { NumberAnimation { duration: 300 } }
                                            }
                                        }
                                    }

                                    Rectangle {
                                        id: appxLDoTempContainer
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true

                                        SGAlignedLabel {
                                            id:  appxLDoTempLabel
                                            target: appxLDoTemp
                                            text: "Approximate LDO \n Temperature"
                                            margin: 0
                                            anchors.centerIn: parent
                                            alignment: SGAlignedLabel.SideBottomCenter
                                            fontSizeMultiplier:   ratioCalc
                                            font.bold : true
                                            horizontalAlignment: Text.AlignHCenter

                                            SGCircularGauge {
                                                id: appxLDoTemp
                                                minimumValue: -55
                                                maximumValue: 125
                                                tickmarkStepSize:20
                                                gaugeFillColor2:"red"
                                                width: appxLDoTempContainer.width
                                                height: appxLDoTempContainer.height - appxLDoTempLabel.contentHeight
                                                unitTextFontSizeMultiplier: ratioCalc * 2.5
                                                unitText: "˚C"
                                                valueDecimalPlaces: 1
                                                //value: platformInterface.status_voltage_current.power_dissipated
                                                //Behavior on value { NumberAnimation { duration: 300 } }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: parent.height/1.9

                RowLayout {
                    anchors.fill: parent
                    spacing: 20

                    Rectangle {
                        Layout.preferredWidth: parent.width/1.5
                        Layout.fillHeight: true

                        ColumnLayout {
                            id: setBoardConfigContainer
                            anchors.fill: parent

                            Text {
                                id: bordConfigText
                                font.bold: true
                                text: "Set Board Configuration"
                                font.pixelSize: ratioCalc * 15
                                Layout.topMargin: 20
                                color: "#696969"
                                Layout.leftMargin: 20

                            }

                            Rectangle {
                                id: line3
                                Layout.preferredHeight: 2
                                Layout.alignment: Qt.AlignCenter
                                Layout.preferredWidth: setBoardConfigContainer.width + 10
                                border.color: "lightgray"
                                radius: 2
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                RowLayout {
                                    anchors.fill: parent

                                    Rectangle {
                                        id: setLDOSliderContainer
                                        Layout.preferredWidth: parent.width/2
                                        Layout.fillHeight: true

                                        SGAlignedLabel {
                                            id: ldoInputVolLabel
                                            target: ldoInputVolSlider
                                            text:"Set LDO Input Voltage"
                                            alignment: SGAlignedLabel.SideTopLeft
                                            anchors.centerIn: parent
                                            fontSizeMultiplier: ratioCalc
                                            font.bold : true

                                            SGSlider {
                                                id:ldoInputVolSlider
                                                width: setLDOSliderContainer.width/1.1
                                                textColor: "black"
                                                stepSize: 0.01
                                                from: 0.6
                                                to: 5
                                                live: false
                                                fromText.text: "0.6V"
                                                fromText.fontSizeMultiplier: 0.9
                                                toText.text: "5V"
                                                toText.fontSizeMultiplier: 0.9
                                                inputBoxWidth: setLDOSliderContainer.width/6
                                                onUserSet: {
                                                    platformInterface.set_vin_ldo.update(value.toFixed(2))
                                                }
                                            }
                                        }
                                    }

                                    Rectangle {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true

                                        SGAlignedLabel {
                                            id: boardInputLabel
                                            target: boardInputComboBox
                                            text: "Board Input Voltage Selection"
                                            alignment: SGAlignedLabel.SideTopLeft
                                            anchors.verticalCenter: parent.verticalCenter
                                            fontSizeMultiplier: ratioCalc
                                            font.bold : true

                                            SGComboBox {
                                                id: boardInputComboBox
                                                fontSizeMultiplier: ratioCalc * 0.9
                                                model: ["USB 5V", "External", "Off"]
                                                onActivated: {
                                                    platformInterface.select_vin.update(currentText)
                                                }
                                            }
                                        }
                                    }

                                    Rectangle {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        color: "transparent"

                                        SGAlignedLabel {
                                            id: ldoEnableSwitchLabel
                                            target: ldoEnableSwitch
                                            text: "Enable LDO"
                                            alignment: SGAlignedLabel.SideTopCenter
                                            anchors.centerIn: parent
                                            fontSizeMultiplier: ratioCalc
                                            font.bold : true

                                            SGSwitch {
                                                id: ldoEnableSwitch
                                                labelsInside: true
                                                checkedLabel: "On"
                                                uncheckedLabel:   "Off"
                                                textColor: "black"              // Default: "black"
                                                handleColor: "white"            // Default: "white"
                                                grooveColor: "#ccc"             // Default: "#ccc"
                                                grooveFillColor: "#0cf"         // Default: "#0cf"
                                                onToggled: {
                                                    if(checked)
                                                        platformInterface.set_ldo_enable.update("on")
                                                    else  platformInterface.set_ldo_enable.update("off")
                                                }
                                            }
                                        }
                                    }
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                RowLayout {
                                    anchors.fill: parent

                                    Rectangle {
                                        id: setLDOOutputVoltageContainer
                                        Layout.preferredWidth: parent.width/2
                                        Layout.fillHeight: true

                                        SGAlignedLabel {
                                            id: setLDOOutputVoltageLabel
                                            target: setLDOOutputVoltage
                                            text: "Set LDO Output Voltage"
                                            alignment: SGAlignedLabel.SideTopLeft
                                            anchors.centerIn: parent
                                            fontSizeMultiplier: ratioCalc
                                            font.bold : true

                                            SGSlider {
                                                id:setLDOOutputVoltage
                                                width: setLDOOutputVoltageContainer.width/1.1
                                                textColor: "black"
                                                stepSize: 0.01
                                                from: 1.1
                                                to: 4.7
                                                live: false
                                                fromText.text: "1.1V"
                                                toText.text: "4.7V"
                                                fromText.fontSizeMultiplier: 0.9
                                                toText.fontSizeMultiplier: 0.9
                                                inputBoxWidth: setLDOOutputVoltageContainer.width/6
                                                onUserSet: {
                                                    platformInterface.set_vout_ldo.update(value.toFixed(2))
                                                }
                                            }
                                        }
                                    }

                                    Rectangle {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true

                                        SGAlignedLabel {
                                            id: ldoInputLabel
                                            target: ldoInputComboBox
                                            text: "LDO Input Voltage Selection"
                                            alignment: SGAlignedLabel.SideTopLeft
                                            anchors.verticalCenter: parent.verticalCenter
                                            fontSizeMultiplier: ratioCalc
                                            font.bold : true

                                            SGComboBox {
                                                id: ldoInputComboBox
                                                fontSizeMultiplier: ratioCalc * 0.9
                                                model: ["Bypass", "Buck Regulator", "Off", "Isolated"]
                                                onActivated: {
                                                    platformInterface.select_vin_ldo.update(currentText)
                                                }
                                            }
                                        }
                                    }

                                    Rectangle {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        color: "transparent"

                                        SGAlignedLabel {
                                            id: ldoDisableLabel
                                            target: ldoDisable
                                            text: "Disable LDO \n Output Voltage \n Adjustment"
                                            //horizontalAlignment: Text.AlignHCenter
                                            font.bold : true
                                            font.italic: true
                                            alignment: SGAlignedLabel.SideTopCenter
                                            fontSizeMultiplier: ratioCalc
                                            anchors.centerIn: parent

                                            Rectangle {
                                                color: "transparent"
                                                anchors { fill: ldoDisableLabel }
                                                MouseArea {
                                                    id: hoverArea2
                                                    anchors { fill: parent }
                                                    hoverEnabled: true
                                                }
                                            }

                                            CheckBox {
                                                id: ldoDisable
                                                checked: false
                                                onClicked: {
                                                    if(checked) {
                                                        platformInterface.disable_vout_set.update(true)
                                                        setLDOOutputVoltageLabel.opacity = 0.5
                                                        setLDOOutputVoltageLabel.enabled = false
                                                    } else {
                                                        platformInterface.disable_vout_set.update(false)
                                                        setLDOOutputVoltageLabel.opacity = 1
                                                        setLDOOutputVoltageLabel.enabled = true
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                RowLayout {
                                    anchors.fill:parent

                                    Rectangle {
                                        id: setOutputContainer
                                        Layout.preferredWidth: parent.width/2
                                        Layout.fillHeight: true

                                        SGAlignedLabel {
                                            id: setOutputCurrentLabel
                                            target: setOutputCurrent
                                            text: "Set Onboard Load Current"
                                            alignment: SGAlignedLabel.SideTopLeft
                                            anchors.centerIn: parent
                                            fontSizeMultiplier: ratioCalc
                                            font.bold : true

                                            SGSlider {
                                                id: setOutputCurrent
                                                width: setOutputContainer.width/1.1
                                                textColor: "black"
                                                stepSize: 0.1
                                                from:0
                                                to: 650
                                                live: false
                                                fromText.text: "0mA"
                                                toText.text: "650mA"
                                                fromText.fontSizeMultiplier: 0.9
                                                toText.fontSizeMultiplier: 0.9
                                                inputBoxWidth: setOutputContainer.width/6
                                                onUserSet: platformInterface.set_load.update(value.toFixed(1))
                                            }
                                        }
                                    }

                                    Rectangle {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        color: "transparent"

                                        SGAlignedLabel {
                                            id: ldoPackageLabel
                                            target: ldoPackageComboBox
                                            text: "LDO Package Selection"
                                            alignment: SGAlignedLabel.SideTopLeft
                                            anchors.verticalCenter: parent.verticalCenter
                                            fontSizeMultiplier: ratioCalc
                                            font.bold : true

                                            SGComboBox {
                                                id: ldoPackageComboBox
                                                fontSizeMultiplier: ratioCalc * 0.9
                                                model: ["TSOP5", "WDFN6", "DFNW8"]
                                                onActivated: {
                                                    if(currentIndex === 0)
                                                        platformInterface.select_ldo.update("TSOP5")
                                                    else if(currentIndex === 1)
                                                        platformInterface.select_ldo.update("DFN6")
                                                    else if(currentIndex === 2)
                                                        platformInterface.select_ldo.update("DFN8")
                                                }
                                            }
                                        }
                                    }

                                    Rectangle {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        color: "transparent"
                                    }
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                RowLayout {
                                    anchors.fill:parent

                                    Rectangle {
                                        Layout.preferredWidth: parent.width/2
                                        Layout.fillHeight: true

                                        RowLayout {
                                            anchors.fill: parent

                                            Rectangle {
                                                Layout.fillWidth: true
                                                Layout.fillHeight: true

                                                SGAlignedLabel {
                                                    id: loadEnableSwitchLabel
                                                    target: loadEnableSwitch
                                                    text: "Enable Onboard \nLoad"
                                                    alignment: SGAlignedLabel.SideTopLeft
                                                    anchors.right: parent.right
                                                    anchors.verticalCenter: parent.verticalCenter
                                                    anchors.top: parent.top
                                                    fontSizeMultiplier: ratioCalc
                                                    font.bold : true

                                                    SGSwitch {
                                                        id: loadEnableSwitch
                                                        labelsInside: true
                                                        checkedLabel: "On"
                                                        uncheckedLabel:   "Off"
                                                        textColor: "black"              // Default: "black"
                                                        handleColor: "white"            // Default: "white"
                                                        grooveColor: "#ccc"             // Default: "#ccc"
                                                        grooveFillColor: "#0cf"         // Default: "#0cf"
                                                        onToggled: {
                                                            if(checked)
                                                                platformInterface.set_load_enable.update("on")
                                                            else  platformInterface.set_load_enable.update("off")
                                                        }
                                                    }
                                                }
                                            }

                                            Rectangle {
                                                id:extLoadCheckboxContainer
                                                Layout.fillWidth: true
                                                Layout.fillHeight: true

                                                SGAlignedLabel {
                                                    id: extLoadCheckboxLabel
                                                    target: extLoadCheckbox
                                                    text: "External Load \nConnected?"
                                                    //horizontalAlignment: Text.AlignHCenter
                                                    font.bold : true
                                                    font.italic: true
                                                    alignment: SGAlignedLabel.SideTopCenter
                                                    fontSizeMultiplier: ratioCalc
                                                    anchors.verticalCenter: parent.verticalCenter
                                                    anchors.horizontalCenter: parent.horizontalCenter
                                                    anchors.top: parent.top

                                                    Rectangle {
                                                        color: "transparent"
                                                        anchors { fill: extLoadCheckboxLabel }
                                                        MouseArea {
                                                            id: hoverArea
                                                            anchors { fill: parent }
                                                            hoverEnabled: true
                                                        }
                                                    }

                                                    CheckBox {
                                                        id: extLoadCheckbox
                                                        checked: false
                                                        onClicked: {
                                                            if(checked) {
                                                                platformInterface.ext_load_conn.update(true)
                                                            } else {
                                                                platformInterface.ext_load_conn.update(false)
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }

                                    Rectangle {
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true

                                        SGAlignedLabel {
                                            id:vinReadyLabel
                                            target: vinReadyLight
                                            alignment: SGAlignedLabel.SideTopCenter
                                            anchors.centerIn: parent
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            anchors.horizontalCenterOffset: 20
                                            fontSizeMultiplier: ratioCalc
                                            text: "VIN_LDO Ready\n(Above 1.6V)"
                                            font.bold: true

                                            SGStatusLight {
                                                id: vinReadyLight
                                                property var vin_ldo_good: platformInterface.int_status.vin_ldo_good
                                                onVin_ldo_goodChanged: {
                                                    if(vin_ldo_good === true)
                                                        vinReadyLight.status  = SGStatusLight.Green
                                                    else vinReadyLight.status  = SGStatusLight.Off
                                                }
                                            }
                                        }
                                    }

                                    Rectangle {
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true
                                    }
                                }
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        RowLayout {
                            anchors.fill: parent
                            spacing: 10

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                ColumnLayout {
                                    id: dropoutContainer
                                    anchors.fill: parent

                                    Text {
                                        id: dropoutText
                                        font.bold: true
                                        text: "Dropout"
                                        font.pixelSize: ratioCalc * 15
                                        Layout.topMargin: 20
                                        color: "#696969"
                                        Layout.leftMargin: 20

                                    }

                                    Rectangle {
                                        id: line4
                                        Layout.preferredHeight: 2
                                        Layout.alignment: Qt.AlignCenter
                                        Layout.preferredWidth: dropoutContainer.width + 10
                                        border.color: "lightgray"
                                        radius: 2
                                    }

                                    Rectangle{
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true

                                        ColumnLayout {
                                            anchors.fill: parent

                                            Rectangle {
                                                Layout.fillWidth: true
                                                Layout.fillHeight: true

                                                RowLayout {
                                                    anchors.fill: parent

                                                    Rectangle {
                                                        Layout.fillWidth: true
                                                        Layout.fillHeight: true

                                                        SGAlignedLabel {
                                                            id: ldoInputVoltageLabel
                                                            target: ldoInputVoltage
                                                            text: "LDO Input Voltage \n(VIN_LDO)"
                                                            alignment: SGAlignedLabel.SideTopLeft
                                                            anchors.verticalCenter: parent.verticalCenter
                                                            fontSizeMultiplier: ratioCalc
                                                            font.bold : true

                                                            SGInfoBox {
                                                                id: ldoInputVoltage
                                                                unit: "V"
                                                                width: 100* ratioCalc
                                                                fontSizeMultiplier: ratioCalc === 0 ? 1.0 : ratioCalc * 1.2
                                                                boxColor: "lightgrey"
                                                                boxFont.family: Fonts.digitalseven
                                                                unitFont.bold: true
                                                            }
                                                        }
                                                    }

                                                    Rectangle {
                                                        Layout.fillWidth: true
                                                        Layout.fillHeight: true

                                                        SGAlignedLabel {
                                                            id: ldoOutputVoltageLabel
                                                            target: ldoOutputVoltage
                                                            text: "LDO Output Voltage \n(VOUT_LDO)"
                                                            alignment: SGAlignedLabel.SideTopLeft
                                                            anchors.verticalCenter: parent.verticalCenter
                                                            fontSizeMultiplier: ratioCalc
                                                            font.bold : true

                                                            SGInfoBox {
                                                                id: ldoOutputVoltage
                                                                unit: "V"
                                                                width: 100* ratioCalc
                                                                fontSizeMultiplier: ratioCalc === 0 ? 1.0 : ratioCalc * 1.2
                                                                boxColor: "lightgrey"
                                                                boxFont.family: Fonts.digitalseven
                                                                unitFont.bold: true
                                                            }
                                                        }
                                                    }
                                                }
                                            }

                                            Rectangle {
                                                Layout.fillWidth: true
                                                Layout.fillHeight: true

                                                RowLayout {
                                                    anchors.fill: parent

                                                    Rectangle {
                                                        Layout.fillWidth: true
                                                        Layout.fillHeight: true

                                                        SGAlignedLabel {
                                                            id: diffVoltageLabel
                                                            target: diffVoltage
                                                            text: "LDO Voltage Drop"
                                                            alignment: SGAlignedLabel.SideTopLeft
                                                            anchors.verticalCenter: parent.verticalCenter
                                                            fontSizeMultiplier: ratioCalc
                                                            font.bold : true

                                                            SGInfoBox {
                                                                id: diffVoltage
                                                                unit: "V"
                                                                width: 100* ratioCalc
                                                                fontSizeMultiplier: ratioCalc === 0 ? 1.0 : ratioCalc * 1.2
                                                                boxColor: "lightgrey"
                                                                boxFont.family: Fonts.digitalseven
                                                                unitFont.bold: true
                                                            }
                                                        }
                                                    }

                                                    Rectangle {
                                                        id: ldoOutputCurrentContainer
                                                        Layout.fillWidth: true
                                                        Layout.fillHeight: true

                                                        SGAlignedLabel {
                                                            id: ldoOutputCurrentLabel
                                                            target: ldoOutputCurrent
                                                            text: "LDO Output Current \n(IOUT)"
                                                            alignment: SGAlignedLabel.SideTopLeft
                                                            anchors.verticalCenter: parent.verticalCenter
                                                            fontSizeMultiplier: ratioCalc
                                                            font.bold : true

                                                            SGInfoBox {
                                                                id: ldoOutputCurrent
                                                                unit: "mA"
                                                                width: 110* ratioCalc
                                                                fontSizeMultiplier: ratioCalc === 0 ? 1.0 : ratioCalc * 1.2
                                                                boxColor: "lightgrey"
                                                                boxFont.family: Fonts.digitalseven
                                                                unitFont.bold: true

                                                            }
                                                        }
                                                    }
                                                }
                                            }

                                            Rectangle {
                                                Layout.fillWidth: true
                                                Layout.fillHeight: true

                                                SGAlignedLabel {
                                                    id: dropReachedLabel
                                                    target: dropReached
                                                    alignment: SGAlignedLabel.SideTopCenter
                                                    anchors.centerIn: parent
//                                                    anchors.horizontalCenter: parent.horizontalCenter
//                                                    anchors.horizontalCenterOffset: 20
                                                    fontSizeMultiplier: ratioCalc
                                                    text: "Dropout Reached"
                                                    font.bold: true

                                                    SGStatusLight {
                                                        id: dropReached
                                                    }
                                                }
                                            }
//                                            Rectangle {
//                                                Layout.fillWidth: true
//                                                Layout.fillHeight: true
//                                            }

//                                            Rectangle {
//                                                Layout.fillWidth: true
//                                                Layout.fillHeight: true
//                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}





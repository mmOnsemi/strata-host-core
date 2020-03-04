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
    property real initialAspectRatio: 1200/820
    // anchors.fill: parent
    anchors.centerIn: parent

    property string titleText: "NCP164C \n Low-noise, High PSRR Linear Regulator"
    property string warningTextIs: "DO NOT exceed LDO input voltage of 5.5V"

    onWidthChanged: {
        console.log("width",width)
    }

    onHeightChanged: {
        console.log("height",height)
    }

    width: parent.width / parent.height > initialAspectRatio ? parent.height * initialAspectRatio : parent.width
    height: parent.width / parent.height < initialAspectRatio ? parent.width / initialAspectRatio : parent.height

    Component.onCompleted: {
        Help.registerTarget(systemVoltageLabel, "aaa", 0, "AdjLDOSystemEfficiencyHelp")
        Help.registerTarget(systemCurrentLabel, "aaa", 1, "AdjLDOSystemEfficiencyHelp")
        Help.registerTarget(systemInputPowerLabel, "aaa", 2, "AdjLDOSystemEfficiencyHelp")
        Help.registerTarget(totalSystemEfficiencyLabel, "aaa", 3, "AdjLDOSystemEfficiencyHelp")
        Help.registerTarget(buckLDOOutputInputLabel, "aaa", 4, "AdjLDOSystemEfficiencyHelp")
        Help.registerTarget(buckLDOOutputInputCurrentLabel, "aaa", 5, "AdjLDOSystemEfficiencyHelp")
        Help.registerTarget(inputPowerLabel, "aaa", 6, "AdjLDOSystemEfficiencyHelp")
        Help.registerTarget(syncBuckEfficiencyLabel, "aaa", 7, "AdjLDOSystemEfficiencyHelp")
        Help.registerTarget(ldoSystemOutputVoltageLabel, "aaa", 8, "AdjLDOSystemEfficiencyHelp")
        Help.registerTarget(ldoSystemOutputCurrentLabel, "aaa", 9, "AdjLDOSystemEfficiencyHelp")
        Help.registerTarget(systemOutputPowerLabel, "aaa", 10, "AdjLDOSystemEfficiencyHelp")
        Help.registerTarget(ldoLabel, "aaa", 11, "AdjLDOSystemEfficiencyHelp")
        Help.registerTarget(setLDOInputVoltageLabel, "aaa", 12, "AdjLDOSystemEfficiencyHelp")
        Help.registerTarget(setLDOOutputVoltageLabel, "aaa", 13, "AdjLDOSystemEfficiencyHelp")
        Help.registerTarget(setOutputCurrentLabel, "aaa", 14, "AdjLDOSystemEfficiencyHelp")
        Help.registerTarget(boardInputLabel, "aaa", 15, "AdjLDOSystemEfficiencyHelp")
        Help.registerTarget(ldoInputLabel, "aaa", 16, "AdjLDOSystemEfficiencyHelp")
        Help.registerTarget(ldoPackageLabel, "aaa", 17, "AdjLDOSystemEfficiencyHelp")
        Help.registerTarget(loadEnableSwitchLabel, "aaa", 18, "AdjLDOSystemEfficiencyHelp")
        Help.registerTarget(extLoadCheckboxLabel, "aaa", 19 , "AdjLDOSystemEfficiencyHelp")
        Help.registerTarget(vinReadyLabel, "aaa", 20, "AdjLDOSystemEfficiencyHelp")
    }

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

    property var ext_load_checked: platformInterface.ext_load_status.value
    onExt_load_checkedChanged: {
        if (ext_load_checked === true) extLoadCheckbox.checked = true
        else extLoadCheckbox.checked = false
    }

    property var telemetry_notification: platformInterface.telemetry
    onTelemetry_notificationChanged: {
        inputPowerGauge.value = telemetry_notification.pin_ldo //LDO input power
        syncBuckEfficiencyGauge.value = telemetry_notification.eff_sb ////Sync buck regulator input power
        ldoEfficiencyGauge.value = telemetry_notification.eff_ldo ////LDO efficiency
        totalSystemEfficiencyGauge.value = telemetry_notification.eff_tot
        systemInputPowerGauge.value = telemetry_notification.pin_sb
        systemPowerOutputGauge.value  = telemetry_notification.pout_ldo
        buckLDOInputVoltage.text = telemetry_notification.vin_ldo
        systemInputVoltage.text = telemetry_notification.vin_sb
        systemCurrent.text = telemetry_notification.iin
        buckLDOOutputCurrent.text = telemetry_notification.iout
        ldoSystemInputVoltage.text = telemetry_notification.vout_ldo
        ldoSystemInputCurrent.text = telemetry_notification.iout
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


        if(control_states.ldo_sel === "TSOP5")  ldoPackageComboBox.currentIndex = 0
        else if(control_states.ldo_sel === "DFN6") ldoPackageComboBox.currentIndex = 1
        else if (control_states.ldo_sel === "DFN8") ldoPackageComboBox.currentIndex = 2

        ldoInputVolSlider.value = control_states.vin_ldo_set
        setLDOOutputVoltage.value = control_states.vout_ldo_set

        if(control_states.ldo_en === "on")
            ldoEnableSwitch.checked = true
        else ldoEnableSwitch.checked = false

        if(control_states.load_en === "on")
            loadEnableSwitch.checked = true
        else loadEnableSwitch.checked = false

        //if(control_states.sb_mode === "pwm") forcedPWM.checked = true
        //else if (control_states.sb_mode === "auto") pfmLightLoad.checked = true

    }

    RowLayout {
        anchors.fill: parent
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20

        Rectangle {
            Layout.fillHeight: true
            Layout.preferredWidth: parent.width/1.5

            ColumnLayout {
                anchors.fill: parent
                Text {
                    id: inputConfigurationText
                    font.bold: true
                    text: "System Input"
                    font.pixelSize: ratioCalc * 20
                    Layout.topMargin: 10
                    color: "#696969"
                    Layout.leftMargin: 20
                }

                Rectangle {
                    id: line
                    Layout.preferredHeight: 1.5
                    Layout.alignment: Qt.AlignCenter
                    Layout.preferredWidth: parent.width + 10
                    border.color: "lightgray"
                    radius: 2
                }

                RowLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        ColumnLayout {
                            anchors.fill:parent
                            Rectangle {
                                id: systemVoltageContainer
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                SGAlignedLabel {
                                    id: systemVoltageLabel
                                    target: systemInputVoltage
                                    text: "Voltage"
                                    alignment: SGAlignedLabel.SideLeftCenter
                                    anchors.centerIn: parent
                                    fontSizeMultiplier: ratioCalc
                                    font.bold : true

                                    SGInfoBox {
                                        id: systemInputVoltage
                                        unit: "V"
                                        fontSizeMultiplier: ratioCalc * 1.2
                                        width: 100
                                        height: 40
                                        boxColor: "lightgrey"
                                        boxFont.family: Fonts.digitalseven
                                        unitFont.bold: true
                                    }
                                }
                            }

                            Rectangle {
                                id:systemCurrentContainer
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                Layout.leftMargin: 12

                                SGAlignedLabel {
                                    id: systemCurrentLabel
                                    target: systemCurrent
                                    text: "Current"
                                    alignment: SGAlignedLabel.SideLeftCenter
                                    anchors.centerIn: parent
                                    fontSizeMultiplier: ratioCalc
                                    font.bold : true

                                    SGInfoBox {
                                        id: systemCurrent
                                        unit: "mA"
                                        width: 120
                                        height: 40
                                        fontSizeMultiplier:  ratioCalc * 1.2
                                        boxColor: "lightgrey"
                                        boxFont.family: Fonts.digitalseven
                                        unitFont.bold: true
                                    }
                                }
                            }
                        }
                    }

                    Rectangle {
                        id: systemPowerContainer
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: "transparent"

                        RowLayout {
                            anchors.fill: parent

                            Rectangle {
                                id: powerOutputgaugeContainer
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                SGAlignedLabel {
                                    id: systemInputPowerLabel
                                    target: systemInputPowerGauge
                                    text: "System \n Input Power"
                                    margin: 0
                                    anchors.centerIn: parent
                                    alignment: SGAlignedLabel.SideBottomCenter
                                    fontSizeMultiplier: ratioCalc
                                    font.bold : true
                                    horizontalAlignment: Text.AlignHCenter
                                    SGCircularGauge {
                                        id: systemInputPowerGauge
                                        minimumValue: 0
                                        maximumValue:  4.01
                                        tickmarkStepSize: 0.5
                                        gaugeFillColor1:"green"
                                        height: powerOutputgaugeContainer.height - systemInputPowerLabel.contentHeight
                                        gaugeFillColor2:"red"
                                        unitText: "W"
                                        valueDecimalPlaces: 3
                                        unitTextFontSizeMultiplier: ratioCalc * 2.1
                                    }
                                }
                            }

                            Rectangle {
                                id: totalSystemEfficiencyContainer
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                color: "white"

                                SGAlignedLabel {
                                    id: totalSystemEfficiencyLabel
                                    target:totalSystemEfficiencyGauge
                                    text: "Total \n System Efficiency"
                                    margin: 0
                                    anchors.centerIn: parent
                                    alignment: SGAlignedLabel.SideBottomCenter
                                    fontSizeMultiplier: ratioCalc
                                    font.bold : true
                                    horizontalAlignment: Text.AlignHCenter

                                    SGCircularGauge {
                                        id:totalSystemEfficiencyGauge
                                        minimumValue: 0
                                        maximumValue:  100
                                        tickmarkStepSize: 10
                                        gaugeFillColor1:"green"
                                        height: totalSystemEfficiencyContainer.height - totalSystemEfficiencyLabel.contentHeight
                                        gaugeFillColor2:"red"
                                        unitText: "%"
                                        valueDecimalPlaces: 1
                                        unitTextFontSizeMultiplier: ratioCalc * 2.1
                                    }
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    color: "transparent"

                    ColumnLayout {
                        anchors.fill: parent

                        Text {
                            id: buckLDOOutputInputText
                            font.bold: true
                            text: "Buck Output/LDO Input"
                            font.pixelSize: ratioCalc * 20
                            color: "#696969"
                            Layout.leftMargin: 20

                        }

                        Rectangle {
                            id: line2
                            Layout.preferredHeight: 1.5
                            Layout.alignment: Qt.AlignCenter
                            Layout.preferredWidth: parent.width
                            border.color: "lightgray"
                            radius: 2
                        }

                        RowLayout {
                            Layout.fillHeight: true
                            Layout.fillWidth: true

                            Rectangle {
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                color: "transparent"

                                ColumnLayout {
                                    anchors.fill: parent

                                    Rectangle {
                                        id: buckLDOOutputInputContainer
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true

                                        SGAlignedLabel {
                                            id: buckLDOOutputInputLabel
                                            target: buckLDOInputVoltage
                                            text: "Voltage"
                                            alignment: SGAlignedLabel.SideLeftCenter
                                            anchors.centerIn: parent
                                            fontSizeMultiplier: ratioCalc
                                            font.bold : true

                                            SGInfoBox {
                                                id: buckLDOInputVoltage
                                                unit: "V"
                                                fontSizeMultiplier: ratioCalc * 1.2
                                                width: 100
                                                height: 40
                                                boxColor: "lightgrey"
                                                boxFont.family: Fonts.digitalseven
                                                unitFont.bold: true
                                            }
                                        }
                                    }

                                    Rectangle {
                                        id:buckLDOOutputInputCurrentContainer
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        Layout.leftMargin: 12

                                        SGAlignedLabel {
                                            id: buckLDOOutputInputCurrentLabel
                                            target: buckLDOOutputCurrent
                                            text: "Current"
                                            alignment: SGAlignedLabel.SideLeftCenter
                                            anchors.centerIn: parent
                                            fontSizeMultiplier: ratioCalc
                                            font.bold : true

                                            SGInfoBox {
                                                id: buckLDOOutputCurrent
                                                unit: "mA"
                                                width: 120
                                                height: 40
                                                fontSizeMultiplier:  ratioCalc * 1.2
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
                                color: "transparent"

                                RowLayout {
                                    anchors.fill: parent

                                    Rectangle {
                                        id: ldoInputPowergaugeContainer
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true

                                        SGAlignedLabel {
                                            id: inputPowerLabel
                                            target:inputPowerGauge
                                            text: "LDO \n Input Power"
                                            margin: 0
                                            anchors.centerIn: parent
                                            alignment: SGAlignedLabel.SideBottomCenter
                                            fontSizeMultiplier: ratioCalc
                                            font.bold : true
                                            horizontalAlignment: Text.AlignHCenter

                                            SGCircularGauge {
                                                id: inputPowerGauge
                                                minimumValue: 0
                                                maximumValue:  3.01
                                                tickmarkStepSize: 0.2
                                                gaugeFillColor1:"green"
                                                height: ldoInputPowergaugeContainer.height - inputPowerLabel.contentHeight
                                                gaugeFillColor2:"red"
                                                unitText: "W"
                                                valueDecimalPlaces: 3
                                                unitTextFontSizeMultiplier: ratioCalc * 2.1
                                                //Behavior on value { NumberAnimation { duration: 300 } }
                                            }
                                        }
                                    }

                                    Rectangle {
                                        id:syncBuckEfficiencyContainer
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true

                                        SGAlignedLabel {
                                            id: syncBuckEfficiencyLabel
                                            target:syncBuckEfficiencyGauge
                                            text: "Sync Buck \n Efficiency"
                                            margin: 0
                                            anchors.centerIn: parent
                                            alignment: SGAlignedLabel.SideBottomCenter
                                            fontSizeMultiplier: ratioCalc
                                            font.bold : true
                                            horizontalAlignment: Text.AlignHCenter

                                            SGCircularGauge {
                                                id: syncBuckEfficiencyGauge
                                                minimumValue: 0
                                                maximumValue:  100
                                                tickmarkStepSize: 10
                                                gaugeFillColor1:"green"
                                                height: syncBuckEfficiencyContainer.height - syncBuckEfficiencyLabel.contentHeight
                                                gaugeFillColor2:"red"
                                                unitText: "%"
                                                valueDecimalPlaces: 1
                                                unitTextFontSizeMultiplier: ratioCalc * 2.1
                                                //Behavior on value { NumberAnimation { duration: 300 } }
                                            }
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

                    ColumnLayout {
                        anchors.fill:parent

                        Text {
                            id: ldoSystemOutputText
                            font.bold: true
                            text: "LDO/System Output"
                            font.pixelSize: ratioCalc * 20
                            color: "#696969"
                            Layout.leftMargin: 20

                        }

                        Rectangle {
                            id: line3
                            Layout.preferredHeight: 1.5
                            Layout.alignment: Qt.AlignCenter
                            Layout.preferredWidth: parent.width + 2
                            border.color: "lightgray"
                            radius: 2
                        }

                        RowLayout {
                            Layout.fillHeight: true
                            Layout.fillWidth: true

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                ColumnLayout {
                                    anchors.fill: parent

                                    Rectangle {
                                        id: ldoSystemOutputVoltageContainer
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true

                                        SGAlignedLabel {
                                            id: ldoSystemOutputVoltageLabel
                                            target: ldoSystemInputVoltage
                                            text: "Voltage"
                                            alignment: SGAlignedLabel.SideLeftCenter
                                            anchors.centerIn: parent
                                            fontSizeMultiplier: ratioCalc
                                            font.bold : true

                                            SGInfoBox {
                                                id: ldoSystemInputVoltage
                                                unit: "V"
                                                fontSizeMultiplier: ratioCalc * 1.2
                                                width: 100
                                                height: 40
                                                boxColor: "lightgrey"
                                                boxFont.family: Fonts.digitalseven
                                                unitFont.bold: true
                                            }
                                        }
                                    }

                                    Rectangle {
                                        id:ldoSystemOutputCurrentContainer
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        Layout.leftMargin: 12

                                        SGAlignedLabel {
                                            id: ldoSystemOutputCurrentLabel
                                            target: ldoSystemInputCurrent
                                            text: "Current"
                                            alignment: SGAlignedLabel.SideLeftCenter
                                            anchors.centerIn: parent
                                            fontSizeMultiplier: ratioCalc
                                            font.bold : true

                                            SGInfoBox {
                                                id: ldoSystemInputCurrent
                                                unit: "mA"
                                                width: 120
                                                height: 40
                                                fontSizeMultiplier:  ratioCalc * 1.2
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
                                color: "transparent"

                                RowLayout {
                                    anchors.fill:parent

                                    Rectangle {
                                        id:systemOutputPowerContainer
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true

                                        SGAlignedLabel {
                                            id: systemOutputPowerLabel
                                            target:systemPowerOutputGauge
                                            text: "System \n Output Power"
                                            margin: 0
                                            anchors.centerIn: parent
                                            alignment: SGAlignedLabel.SideBottomCenter
                                            fontSizeMultiplier: ratioCalc
                                            font.bold : true
                                            horizontalAlignment: Text.AlignHCenter

                                            SGCircularGauge {
                                                id: systemPowerOutputGauge
                                                minimumValue: 0
                                                maximumValue:  3.01
                                                tickmarkStepSize: 0.2
                                                gaugeFillColor1:"green"
                                                height: systemOutputPowerContainer.height - systemOutputPowerLabel.contentHeight
                                                gaugeFillColor2:"red"
                                                unitText: "W"
                                                valueDecimalPlaces: 3
                                                unitTextFontSizeMultiplier: ratioCalc * 2.1
                                            }
                                        }
                                    }

                                    Rectangle {
                                        id: ldogaugeContainer
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true

                                        SGAlignedLabel {
                                            id: ldoLabel
                                            target:ldoEfficiencyGauge
                                            text: "LDO \n Efficiency"
                                            margin: 0
                                            anchors.centerIn: parent
                                            alignment: SGAlignedLabel.SideBottomCenter
                                            fontSizeMultiplier: ratioCalc
                                            font.bold : true
                                            horizontalAlignment: Text.AlignHCenter

                                            SGCircularGauge {
                                                id: ldoEfficiencyGauge
                                                minimumValue: 0
                                                maximumValue:  100
                                                tickmarkStepSize: 10
                                                gaugeFillColor1:"green"
                                                height: ldogaugeContainer.height - ldoLabel.contentHeight
                                                gaugeFillColor2:"red"
                                                unitText: "%"
                                                valueDecimalPlaces: 1
                                                unitTextFontSizeMultiplier: ratioCalc * 2.1
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


        Rectangle {
            id: middleLine
            Layout.preferredHeight: parent.height
            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: 1.5
            Layout.leftMargin: 5
            border.color: "lightgray"
            radius: 2
        }

        Rectangle {
            id: column2Container
            Layout.fillHeight: true
            Layout.fillWidth: true
            color: "transparent"

            ColumnLayout {
                anchors.fill: parent
                spacing: 0

                Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    //color: "red"
                    Image {
                        id: blockDiagram
                        source: "SystemEfficiencyBlockDiagram.png"
                        fillMode: Image.PreserveAspectFit
                        anchors.fill: parent
                    }
                }

                Rectangle {
                    Layout.preferredHeight: parent.height/1.3
                    Layout.fillWidth: true
                    color: "transparent"

                    ColumnLayout {
                        id: setBoardConfigContainer
                        anchors.fill: parent

                        Text {
                            id: setBoardConfigurationText
                            font.bold: true
                            text: "Set Board Configuration"
                            font.pixelSize: ratioCalc * 20
                            color: "#696969"
                            Layout.leftMargin: 20
                        }

                        Rectangle {
                            id: line4
                            Layout.preferredHeight: 1.5
                            //Layout.fillWidth: true
                            //Layout.alignment: Qt.AlignCenter
                            Layout.preferredWidth: column2Container.width
                            border.color: "lightgray"
                            radius: 2
                        }

                        Rectangle {
                            id:setLDOInputVoltageContainer
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            Layout.leftMargin: 20
                            color: "transparent"

                            SGAlignedLabel {
                                id: setLDOInputVoltageLabel
                                target: ldoInputVolSlider
                                text: "Set LDO Input\nVoltage"
                                font.bold: true
                                alignment: SGAlignedLabel.SideTopLeft
                                fontSizeMultiplier: ratioCalc
                                anchors.centerIn: parent

                                SGSlider{
                                    id: ldoInputVolSlider
                                    width: setLDOInputVoltageContainer.width - 10
                                    from: 0.6
                                    to:  5
                                    fromText.text: "0.6V"
                                    toText.text: "5V"
                                    stepSize: 0.01
                                    live: false
                                    // fontSizeMultiplier: ratioCalc * 1.1
                                    inputBoxWidth: setLDOInputVoltageContainer.width/6
                                    onUserSet: {
                                        platformInterface.set_vin_ldo.update(value.toFixed(2))
                                    }
                                }
                            }
                        }

                        Rectangle {
                            id:setLDOOutputVoltageContainer
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            Layout.leftMargin: 20
                            color: "transparent"

                            SGAlignedLabel {
                                id: setLDOOutputVoltageLabel
                                target: setLDOOutputVoltage
                                text: "Set LDO Output\nVoltage"
                                font.bold: true
                                alignment: SGAlignedLabel.SideTopLeft
                                fontSizeMultiplier: ratioCalc
                                anchors.centerIn: parent

                                SGSlider{
                                    id: setLDOOutputVoltage
                                    width: setLDOOutputVoltageContainer.width - 10

                                    from: 1.1
                                    to:  5
                                    fromText.text: "1.1V"
                                    toText.text: "5V"
                                    stepSize: 0.01
                                    live: false
                                    inputBoxWidth: setLDOOutputVoltageContainer.width/6
                                    onUserSet: {
                                        platformInterface.set_vout_ldo.update(value.toFixed(2))
                                    }
                                }
                            }
                        }

                        Rectangle {
                            id: setOutputCurrentContainer
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            Layout.leftMargin: 20
                            color: "transparent"

                            SGAlignedLabel {
                                id: setOutputCurrentLabel
                                target: setOutputCurrentSlider
                                text: "Set LDO Output\nCurrent"
                                font.bold: true
                                alignment: SGAlignedLabel.SideTopLeft
                                fontSizeMultiplier: ratioCalc
                                anchors.centerIn: parent

                                SGSlider{
                                    id: setOutputCurrentSlider
                                    width: setOutputCurrentContainer.width - 10
                                    from: 0
                                    to:  650
                                    live: false
                                    fromText.text: "0mA"
                                    toText.text: "650mA"
                                    stepSize: 0.1
                                    inputBoxWidth: setOutputCurrentContainer.width/6
                                    onUserSet: platformInterface.set_load.update(parseInt(value))

                                }
                            }
                        }

                        Rectangle {
                            //id: totalSystemEfficiencyContainer
                            Layout.preferredHeight: parent.height/2
                            Layout.fillWidth: true
                            Layout.leftMargin: 20
                            color: "white"

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
                                                id: boardInputLabel
                                                target: boardInputComboBox
                                                text: "Board Input Voltage\nSelection"
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

                                            SGAlignedLabel {
                                                id: ldoInputLabel
                                                target: ldoInputComboBox
                                                text: "LDO Input Voltage\n Selection"
                                                alignment: SGAlignedLabel.SideTopLeft
                                                anchors.verticalCenter: parent.verticalCenter
                                                fontSizeMultiplier: ratioCalc
                                                font.bold : true

                                                SGComboBox {
                                                    id: ldoInputComboBox
                                                    fontSizeMultiplier: ratioCalc * 0.9
                                                    model: ["Bypass", "Buck Regulator", "Off"]
                                                    onActivated: {
                                                        platformInterface.select_vin_ldo.update(currentText)

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
                                            Layout.fillWidth: true
                                            Layout.fillHeight: true
                                            color: "transparent"

                                            SGAlignedLabel {
                                                id: ldoPackageLabel
                                                target: ldoPackageComboBox
                                                text: "LDO Package\nSelection"
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
                                            Layout.preferredWidth: parent.width/1.5
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
                                                        anchors.verticalCenter: parent.verticalCenter
                                                        anchors.horizontalCenter: parent.horizontalCenter
                                                        anchors.horizontalCenterOffset: -10
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
                                                    color: "transparent"

                                                    SGAlignedLabel {
                                                        id: extLoadCheckboxLabel
                                                        target: extLoadCheckbox
                                                        text: "External Load \nConnected?"
                                                        //horizontalAlignment: Text.AlignHCenter
                                                        font.bold : true
                                                        font.italic: true
                                                        alignment: SGAlignedLabel.SideTopCenter
                                                        fontSizeMultiplier: ratioCalc
                                                        anchors.centerIn: parent

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
                                    }
                                }

                                Rectangle {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true

                                    RowLayout{
                                        anchors.fill:parent

                                        Rectangle {
                                            Layout.fillWidth: true
                                            Layout.fillHeight: true
                                            color: "transparent"
                                            SGAlignedLabel {
                                                id:vinReadyLabel
                                                target: vinReadyLight
                                                alignment: SGAlignedLabel.SideTopCenter
                                                anchors.centerIn: parent
                                                fontSizeMultiplier: ratioCalc
                                                text: "VIN_LDO Ready \n (Above 1.6V)"
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
                            }
                        }
                    }
                }
            }
        }
    }
}

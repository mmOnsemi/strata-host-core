import QtQuick 2.12
import QtQuick.Layouts 1.12

import tech.strata.sgwidgets 1.0
import tech.strata.sgwidgets 0.9 as Widget09
import tech.strata.fonts 1.0

import "qrc:/js/help_layout_manager.js" as Help

Item {
    id: root
    property real ratioCalc: root.width / 1200
    property real initialAspectRatio: 1200/820


    property var telemetry_notification: platformInterface.telemetry
    onTelemetry_notificationChanged: {
        boardTemp.value = telemetry_notification.temperature
        ldoPowerDissipation.value = telemetry_notification.ploss


    }

    property var control_states: platformInterface.control_states
    onControl_statesChanged: {
        if(control_states.vin_sel === "USB 5V")  baordInputComboBox.currentIndex = 0
        else if(control_states.vin_sel === "External") baordInputComboBox.currentIndex = 1
        else if (control_states.vin_sel === "Off") baordInputComboBox.currentIndex = 2

        if(control_states.vin_ldo_sel === "Bypass") ldoInputComboBox.currentIndex = 0
        else if (control_states.vin_ldo_sel === "Buck Regulator") ldoInputComboBox.currentIndex = 1
        else if (control_states.vin_ldo_sel === "Off") ldoInputComboBox.currentIndex = 2

        ldoInputVol.value.value = control_states.vin_ldo_set
        setLDOOutputVoltage.value = control_states.vout_ldo_set



        if(control_states.ldo_sel === "TSOP5")  ldoPackageComboBox.currentIndex = 0
        else if(control_states.ldo_sel === "DFN6") ldoPackageComboBox.currentIndex = 1
        else if (control_states.ldo_sel === "DFN8") ldoPackageComboBox.currentIndex = 2


    }

    Rectangle {
        id: noteMessage
        width: parent.width/3
        height: 60
        anchors{
            top: root.top
            topMargin: 10
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
                font.pixelSize:  ratioCalc * 12
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
        width: parent.width - 10
        height: parent.height - noteMessage.height - 50

        anchors {
            top: noteMessage.bottom
            topMargin: 10
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
                                font.pixelSize: ratioCalc * 20
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
                                            id: cptestButton
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
                                                    platformInterface.ldo_cp_test.update()
                                                }
                                            }
                                        }

                                    }

                                    Rectangle {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true

                                        SGAlignedLabel {
                                            id: vinLabel
                                            target: vin
                                            text:  "Current Limit \nThreshold"
                                            font.bold: true
                                            alignment: SGAlignedLabel.SideTopLeft
                                            fontSizeMultiplier: ratioCalc
                                            anchors.centerIn: parent


                                            SGInfoBox {
                                                id: vin
                                                fontSizeMultiplier: ratioCalc === 0 ? 1.0 : ratioCalc * 1.2
                                                width: 100 * ratioCalc
                                                unit: "<b>mA</b>"
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
                                    spacing: 10

                                    Rectangle {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true

                                        SGAlignedLabel {
                                            id:pgldoLabel
                                            target: pgldo
                                            alignment: SGAlignedLabel.SideTopLeft
                                            anchors.centerIn: parent
                                            fontSizeMultiplier: ratioCalc
                                            text: "PG_LDO"
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
                                            alignment: SGAlignedLabel.SideTopLeft
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
                                            alignment: SGAlignedLabel.SideTopLeft
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
                                font.pixelSize: ratioCalc * 20
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
                                            alignment: SGAlignedLabel.SideTopLeft
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
                                            text: "LDO Power \n Dissipation"
                                            margin: 0
                                            anchors.centerIn: parent
                                            alignment: SGAlignedLabel.SideBottomCenter
                                            fontSizeMultiplier:   ratioCalc
                                            font.bold : true
                                            horizontalAlignment: Text.AlignHCenter

                                            SGCircularGauge {
                                                id: ldoPowerDissipation
                                                minimumValue: 0
                                                maximumValue: 1000
                                                tickmarkStepSize:100
                                                gaugeFillColor1:"green"
                                                gaugeFillColor2:"red"
                                                width: ldoPowerDissipationContiner.width
                                                height: ldoPowerDissipationContiner.height/1.6
                                                unitTextFontSizeMultiplier: ratioCalc * 2.5
                                                unitText: "mW"
                                                valueDecimalPlaces: 0
                                                //value: platformInterface.status_voltage_current.power_dissipated
                                                Behavior on value { NumberAnimation { duration: 300 } }
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
                                                tickmarkStepSize:20
                                                //                                                gaugeFillColor1:"green"
                                                //                                                gaugeFillColor2:"red"
                                                width: boardTempContainer.width
                                                height: boardTempContainer.height/1.6
                                                unitTextFontSizeMultiplier: ratioCalc * 2.5
                                                unitText: "˚C"
                                                valueDecimalPlaces: 0
                                               // value: platformInterface.telemetry.temperature
                                                Behavior on value { NumberAnimation { duration: 300 } }
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
                                                //                                                gaugeFillColor1:"green"
                                                //                                                gaugeFillColor2:"red"
                                                width: appxLDoTempContainer.width
                                                height: appxLDoTempContainer.height/1.6
                                                unitTextFontSizeMultiplier: ratioCalc * 2.5
                                                unitText: "˚C"
                                                valueDecimalPlaces: 0
                                                //value: platformInterface.status_voltage_current.power_dissipated
                                                Behavior on value { NumberAnimation { duration: 300 } }
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
                Layout.fillHeight: true

                RowLayout {
                    anchors.fill: parent
                    spacing: 20


                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        ColumnLayout {
                            id: setBoardConfigContainer
                            anchors.fill: parent
                            Text {
                                id: bordConfigText
                                font.bold: true
                                text: "Set Board Configuration"
                                font.pixelSize: ratioCalc * 20
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
                                    anchors.fill:parent
                                    Rectangle {
                                        id: setLDOSliderContainer
                                        Layout.preferredWidth: parent.width/1.5
                                        Layout.fillHeight: true

                                        SGAlignedLabel {
                                            id: ldoInputVolLabel
                                            target: ldoInputVol
                                            text:"Set LDO Input Voltage"
                                            alignment: SGAlignedLabel.SideTopLeft
                                            anchors.centerIn: parent
                                            fontSizeMultiplier: ratioCalc
                                            font.bold : true
                                            SGSlider {
                                                id:ldoInputVol
                                                width: setLDOSliderContainer.width - ldoInputVolLabel.contentWidth
                                                textColor: "black"
                                                stepSize: 0.5
                                                from: 1.6
                                                to: 5.5
                                                live: false
                                                fromText.text: "1.6V"
                                                toText.text: "5.5V"
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
                                            target: baordInputComboBox
                                            text: "Board Input Voltage Selection"
                                            alignment: SGAlignedLabel.SideTopLeft
                                            anchors.verticalCenter: parent.verticalCenter
                                            fontSizeMultiplier: ratioCalc
                                            font.bold : true

                                            SGComboBox {
                                                id: baordInputComboBox
                                                fontSizeMultiplier: ratioCalc * 0.9
                                                model: ["USB 5V", "External", "Off"]
                                                onActivated: {
                                                    platformInterface.select_vin.update(currentText)

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
                                        id: setLDOOutputVoltageContainer
                                        Layout.preferredWidth: parent.width/1.5
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
                                                width: setLDOOutputVoltageContainer.width - setLDOOutputVoltageLabel.contentWidth
                                                textColor: "black"
                                                stepSize: 0.5
                                                from: 1.2
                                                to: 5.2
                                                live: false
                                                fromText.text: "1.2V"
                                                toText.text: "5.2V"
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
                                    anchors.fill:parent

                                    Rectangle {
                                        id: setOutputContainer
                                        Layout.preferredWidth: parent.width/1.5
                                        Layout.fillHeight: true

                                        SGAlignedLabel {
                                            id: setOutputCurrentLabel
                                            target: setOutputCurrent
                                            text: "Set LDO Output Voltage"
                                            alignment: SGAlignedLabel.SideTopLeft
                                            anchors.centerIn: parent
                                            fontSizeMultiplier: ratioCalc
                                            font.bold : true

                                            SGSlider {
                                                id: setOutputCurrent
                                                width: setOutputContainer.width - setOutputCurrentLabel.contentWidth
                                                textColor: "black"
                                                stepSize: 100
                                                from:0
                                                to: 650
                                                live: false
                                                fromText.text: "1mA"
                                                toText.text: "650mA"
                                                inputBoxWidth: setOutputContainer.width/6

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
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                RowLayout {
                                    anchors.fill:parent

                                    Rectangle {
                                        Layout.preferredWidth: parent.width/1.5
                                        Layout.fillHeight: true

                                    }
                                    Rectangle {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        SGAlignedLabel {
                                            id: loadSelectionLabel
                                            target: loadSelectionComboBox
                                            text: "Load Selection"
                                            alignment: SGAlignedLabel.SideTopLeft
                                            anchors.verticalCenter: parent.verticalCenter
                                            fontSizeMultiplier: ratioCalc
                                            font.bold : true

                                            SGComboBox {
                                                id: loadSelectionComboBox
                                                fontSizeMultiplier: ratioCalc * 0.9
                                                model: ["Onboard", "External", "Parallel"]
                                                onActivated: {

                                                    if(currentIndex === 0) {
                                                        platformInterface.set_load_enable.update("on")
                                                        platformInterface.ext_load_conn.update(false)

                                                    }
                                                    else if (currentIndex === 1) {
                                                        platformInterface.set_load_enable.update("off")
                                                        platformInterface.ext_load_conn.update(true)
                                                    }
                                                    else if(currentIndex === 2) {
                                                        platformInterface.set_load_enable.update("on")
                                                        platformInterface.ext_load_conn.update(true)
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
                        Layout.fillHeight: true

                        RowLayout {
                            anchors.fill: parent
                            spacing: 20

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
                                        font.pixelSize: ratioCalc * 20
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





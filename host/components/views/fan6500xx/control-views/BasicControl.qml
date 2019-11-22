import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3
import QtGraphicalEffects 1.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4
import tech.strata.sgwidgets 1.0
import tech.strata.fonts 1.0
import "qrc:/js/navigation_control.js" as NavigationControl
import "qrc:/js/help_layout_manager.js" as Help


Item {
    id: root
    anchors.fill: parent
    property real ratioCalc: root.width / 1200
    property real initialAspectRatio: 1200/820

    width: parent.width / parent.height > initialAspectRatio ? parent.height * initialAspectRatio : parent.width
    height: parent.width / parent.height < initialAspectRatio ? parent.width / initialAspectRatio : parent.height

    //property alias warningVisible: warningBox.visible
    property string vinlable: ""

    // When the load is turned on before enable is on, the part sends out the surge and resets the mcu.
    // Detect the mcu reset and turn of the pause periodic.
    //    property var read_mcu_reset_state: platformInterface.status_mcu_reset.mcu_reset
    //    onRead_mcu_reset_stateChanged: {
    //        if(read_mcu_reset_state === "occurred") {
    //            platformInterface.pause_periodic.update(false)
    //        }
    //        else  {
    //            platformInterface.status_mcu_reset.mcu_reset = ""
    //        }
    //    }

    //    property var read_enable_state: platformInterface.initial_status_0.enable_status
    //    onRead_enable_stateChanged: {
    //        platformInterface.enabled = (read_enable_state === "on") ? true : false
    //    }

    //    property var read_vsel_status: platformInterface.initial_status_0.vsel_status
    //    onRead_vsel_statusChanged: {
    //        platformInterface.vsel_state = (read_vsel_status === "on") ? true : false
    //    }

    //    property var read_vin: platformInterface.initial_status_0.vingood_status
    //    onRead_vinChanged: {
    //        if(read_vin === "good") {
    //            ledLight.status = SGStatusLight.Green
    //            vinlable = "over"
    //            vinLabel.text = "VIN Ready ("+ vinlable + " 2.5V)"
    //            enableSwitch.enabled = true
    //            enableSwitch.opacity = 1.0
    //            enableSwitchLabel.opacity = 1.0
    //        }
    //        else {
    //            ledLight.status = SGStatusLight.Red
    //            vinlable = "under"
    //            vinLabel.text = "VIN Ready ("+ vinlable + " 2.5V)"
    //            enableSwitch.enabled = false
    //            enableSwitch.opacity = 0.5
    //            enableSwitchLabel.opacity = 0.5
    //            platformInterface.enabled = false
    //        }
    //    }

    //    Component.onCompleted:  {
    //        helpIcon.visible = true
    //        Help.registerTarget(statusLightContainer, "Vin Ready LED will light up green when the input voltage is ready (greater than 2.5V), and will light up red otherwise to warn the user that input voltage is not high enough.", 1, "basic5AHelp")
    //        Help.registerTarget(voltageContainer, "The digital gauges here show the input voltage and current to the power stage of the evaluation board. The NCV214R current sense amplifier provides the current measurement.", 2, "basic5AHelp")
    //        Help.registerTarget(tempGauge, "The gauge shows the board temperature next to the NCV6357 in degrees Celsius. This temperature will be less than the temperature internal to the NCV6357 due to the thermal isolation between the die of the NCV6357 and the die of the temperature sensor.", 3, "basic5AHelp")
    //        Help.registerTarget(enableContainer, "This switch enables/disables the NCV6357. It will be grayed out if the input voltage is not high enough (above 2.5V).", 4, "basic5AHelp")
    //        Help.registerTarget(vselContainer, "VSEL will switch the output voltage between the two voltage values stored in the VoutVSEL registers in the NCV6357. Default register setting values for VoutVSEL0 and VoutVSEL1 are 0.9V and 1.0V respectively.", 5, "basic5AHelp")
    //        Help.registerTarget(currentContainer, "The digital gauges here show the output voltage and current to the power stage of the evaluation board. The NCV214R current sense amplifier provides the current measurement.", 6, "basic5AHelp")
    //    }

    Rectangle{
        anchors.centerIn: parent
        width : parent.width
        height: parent.height - 150
        color: "transparent"
        Rectangle {
            id: pageLable
            width: parent.width/2
            height: parent.height/ 12
            anchors {
                top: parent.top
                topMargin: 15
                horizontalCenter: parent.horizontalCenter
            }

            Text {
                id: pageText
                anchors {
                    top: parent.top
                    horizontalCenter: parent.horizontalCenter
                }
                text: "<b> FAN65005A <\b>"
                font.pixelSize: (parent.width + parent.height)/ 30
                color: "black"
            }
            Text {
                id: pageText2
                anchors {
                    top: pageText.bottom
                    horizontalCenter: parent.horizontalCenter
                }
                //text:  "abc"
                font.pixelSize:(parent.width + parent.height)/ 30
                color: "black"
            }
        }

        Rectangle{
            id: leftContainer
            width: parent.width
            height: parent.height - 150
            anchors{
                top: pageLable.bottom
                topMargin: 20
            }
            color: "transparent"
            Rectangle {
                id:left
                width: parent.width/3
                height: (parent.height/2) + 200
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 20
                }
                color: "transparent"
                border.color: "black"
                border.width: 5
                radius: 10
                Rectangle {
                    id: textContainer2
                    width: parent.width/5
                    height: parent.height/10
                    anchors {
                        top: parent.top
                        topMargin: 20
                        horizontalCenter: parent.horizontalCenter
                    }
                    color: "transparent"
                    Text {
                        id: containerLabel2
                        text: "Input"
                        anchors{
                            fill: parent
                            centerIn: parent
                        }
                        font.pixelSize: height
                        font.bold: true
                        fontSizeMode: Text.Fit
                    }
                }
                Rectangle {
                    id: line
                    height: 2
                    width: parent.width - 9
                    anchors {
                        top: textContainer2.bottom
                        topMargin: 2
                        left: parent.left
                        leftMargin: 5
                    }
                    border.color: "gray"
                    radius: 2
                }
                Rectangle {
                    id: statusLightContainer
                    width: parent.width
                    height: parent.height/5
                    anchors {
                        top : line.bottom
                        topMargin : 10
                        horizontalCenter: parent.horizontalCenter
                    }
                    color: "transparent"
                    SGAlignedLabel {
                        id: vinLabel
                        target: ledLight
                        text:  "VIN Ready (under 2.5V)"
                        alignment: SGAlignedLabel.SideLeftCenter
                        anchors.centerIn: parent
                        fontSizeMultiplier: ratioCalc * 1.5
                        font.bold : true
                        SGStatusLight {
                            id: ledLight
                            property string vinMonitor: platformInterface.status_voltage_current.vingood
                            onVinMonitorChanged:  {
                                if(vinMonitor === "good") {
                                    ledLight.status = SGStatusLight.Green
                                    vinlable = "over"
                                    vinLabel.text = "VIN Ready ("+ vinlable + " 4.5V)"
                                    //                                    //Show enableSwitch if vin is "good"
                                    //                                    enableContainer.enabled  = true
                                    //                                    enableContainer.opacity = 1.0
                                }
                                else if(vinMonitor === "bad") {
                                    ledLight.status = SGStatusLight.Red
                                    vinlable = "under"
                                    vinLabel.text= "VIN Ready ("+ vinlable + " 4.5V)"
                                    //                                    //Hide enableSwitch if vin is "good"
                                    //                                    enableContainer.enabled  = false
                                    //                                    enableContainer.opacity = 0.5
                                    //                                    platformInterface.enabled = false
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    id: warningBox2
                    color: "red"
                    anchors {
                        top: statusLightContainer.bottom
                        horizontalCenter: parent.horizontalCenter
                    }
                    width: parent.width - 40
                    height: parent.height/10
                    Text {
                        id: warningText2
                        anchors.centerIn: warningBox2
                        text: "<b>DO NOT exceed input voltage more than 65V</b>"
                        font.pixelSize: (parent.width + parent.height)/32
                        color: "white"
                    }

                    Text {
                        id: warningIconleft
                        anchors {
                            right: warningText2.left
                            verticalCenter: warningText2.verticalCenter
                            rightMargin: 5
                        }
                        text: "\ue80e"
                        font.family: Fonts.sgicons
                        font.pixelSize: (parent.width + parent.height)/19
                        color: "white"
                    }

                    Text {
                        id: warningIconright
                        anchors {
                            left: warningText2.right
                            verticalCenter: warningText2.verticalCenter
                            leftMargin: 5
                        }
                        text: "\ue80e"
                        font.family: Fonts.sgicons
                        font.pixelSize: (parent.width + parent.height)/19
                        color: "white"
                    }
                }
                Rectangle{
                    id: voltageContainer
                    width: parent.width
                    height: parent.height/2.3
                    color: "transparent"
                    anchors {
                        top : warningBox2.bottom
                        topMargin : 10
                        horizontalCenter: parent.horizontalCenter
                    }

                    Rectangle {
                        id: inputContainer
                        width: parent.width
                        height: parent.height/2
                        anchors {
                            top: parent.top
                            horizontalCenter: parent.horizontalCenter
                        }

                        color: "transparent"
                        SGAlignedLabel {
                            id: inputVoltageLabel
                            target: inputVoltage
                            text: "Input Voltage"
                            alignment: SGAlignedLabel.SideLeftCenter
                            anchors.centerIn: parent
                            fontSizeMultiplier: ratioCalc * 1.5
                            font.bold : true

                            SGInfoBox {
                                id: inputVoltage
                                //text: platformInterface.status_voltage_current.vin.toFixed(2)
                                unit: "V"
                                fontSizeMultiplier: ratioCalc === 0 ? 1.0 : ratioCalc * 1.8
                                height: (inputContainer.height - inputVoltageLabel.contentHeight) + 10
                                width: (inputContainer.width - inputVoltageLabel.contentWidth)/2
                                boxColor: "lightgrey"
                                boxFont.family: Fonts.digitalseven
                                unitFont.bold: true
                                property var inputVoltageValue: platformInterface.status_voltage_current.vin.toFixed(2)
                                onInputVoltageValueChanged: {
                                    inputVoltage.text = inputVoltageValue
                                }

                            }
                        }
                    }

                    Rectangle {
                        id: inputCurrentConatiner
                        width: parent.width
                        height: parent.height/2
                        color: "transparent"
                        anchors {
                            top : inputContainer.bottom
                            horizontalCenter: parent.horizontalCenter
                        }
                        SGAlignedLabel {
                            id: inputCurrentLabel
                            target: inputCurrent
                            text: "Input Current"
                            alignment: SGAlignedLabel.SideLeftCenter
                            anchors.centerIn: parent
                            fontSizeMultiplier: ratioCalc * 1.5
                            font.bold : true

                            SGInfoBox {
                                id: inputCurrent
                                //text: platformInterface.status_voltage_current.iin.toFixed(2)
                                unit: "A"
                                height: (inputCurrentConatiner.height - inputCurrentLabel.contentHeight) + 10
                                width: (inputCurrentConatiner.width - inputCurrentLabel.contentWidth)/2
                                fontSizeMultiplier: ratioCalc === 0 ? 1.0 : ratioCalc * 1.8
                                boxColor: "lightgrey"
                                boxFont.family: Fonts.digitalseven
                                unitFont.bold: true
                                property var inputCurrentValue: platformInterface.status_voltage_current.iin.toFixed(2)
                                onInputCurrentValueChanged: {
                                    inputCurrent.text = inputCurrentValue
                                }

                            }
                        }
                    }
                }
            }
            Rectangle {
                id: gauge
                width: parent.width/3.5
                height: (parent.height/2) + 100
                anchors{
                    left: left.right
                    verticalCenter: parent.verticalCenter
                }
                color: "transparent"

                SGAlignedLabel {
                    id: tempLabel
                    target: tempGauge
                    text: "Board \n Temperature"
                    margin: 0
                    anchors.centerIn: parent
                    alignment: SGAlignedLabel.SideBottomCenter
                    fontSizeMultiplier: ratioCalc * 1.5
                    font.bold : true
                    horizontalAlignment: Text.AlignHCenter

                    SGCircularGauge {
                        id: tempGauge
                        minimumValue: -55
                        maximumValue: 125
                        tickmarkStepSize: 20
                        gaugeFillColor1: "blue"
                        gaugeFillColor2: "red"
                        unitText: "°C"
                        unitTextFontSizeMultiplier: ratioCalc * 2.2
                        //value: platformInterface.status_temperature_sensor.temperature

                        property var tempValue: platformInterface.status_temperature_sensor.temperature
                        onTempValueChanged: {
                            value = tempValue
                        }



                        Behavior on value { NumberAnimation { duration: 300 } }
                        function lerpColor (color1, color2, x){
                            if (Qt.colorEqual(color1, color2)){
                                return color1;
                            } else {
                                return Qt.rgba(
                                            color1.r * (1 - x) + color2.r * x,
                                            color1.g * (1 - x) + color2.g * x,
                                            color1.b * (1 - x) + color2.b * x, 1
                                            );
                            }
                        }
                    }
                }
            }

            Rectangle {
                id:right
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: gauge.right
                    right: parent.right
                    rightMargin: 20
                }
                width: parent.width/3
                height: (parent.height/2) + 200
                color: "transparent"
                border.color: "black"
                border.width: 5
                radius: 10

                Rectangle {
                    id: textContainer
                    width: parent.width/4.5
                    height: parent.height/10
                    anchors {
                        top: parent.top
                        topMargin: 20
                        horizontalCenter: parent.horizontalCenter
                    }
                    Text {
                        id: containerLabel
                        text: "Output"
                        anchors{
                            fill: parent
                            verticalCenter: parent.verticalCenter
                            verticalCenterOffset: 7
                        }
                        font.pixelSize: height
                        font.bold: true
                        fontSizeMode: Text.Fit
                    }
                }

                Rectangle {
                    id: line2
                    height: 2
                    width: parent.width - 9

                    anchors {
                        top: textContainer.bottom
                        topMargin: 2
                        left: parent.left
                        leftMargin: 5
                    }
                    border.color: "gray"
                    radius: 2
                }

                Rectangle {
                    id:enableContainer
                    width: parent.width
                    height: parent.height/7
                    color: "transparent"
                    anchors {
                        top: line2.bottom
                        topMargin :  5
                        horizontalCenter: parent.horizontalCenter
                    }
                    SGAlignedLabel {
                        id: enableSwitchLabel
                        target: enableSwitch
                        text: "Enable (EN)"
                        alignment: SGAlignedLabel.SideLeftCenter
                        anchors.centerIn: parent
                        fontSizeMultiplier: ratioCalc * 1.5
                        font.bold : true
                        SGSwitch {
                            id: enableSwitch
                            labelsInside: true
                            checkedLabel: "On"
                            uncheckedLabel:   "Off"
                            textColor: "black"              // Default: "black"
                            handleColor: "white"            // Default: "white"
                            grooveColor: "#ccc"             // Default: "#ccc"
                            grooveFillColor: "#0cf"         // Default: "#0cf"
                            checked: platformInterface.enabled
                            onToggled: {
                                platformInterface.enabled = checked
                                if(checked){
                                    platformInterface.set_enable.update("on")
                                }
                                else{
                                    platformInterface.set_enable.update("off")
                                }

                            }
                        }
                    }
                }

                Rectangle {
                    id: pgoodLightContainer
                    width: parent.width
                    height: parent.height/5
                    anchors {
                        top : enableContainer.bottom
                        topMargin : 10
                        horizontalCenter: parent.horizontalCenter
                    }
                    color: "transparent"
                    SGAlignedLabel {
                        id: pgoodLabel
                        target: pgoodLight
                        text:  "PGood"
                        alignment: SGAlignedLabel.SideLeftCenter
                        anchors.centerIn: parent
                        fontSizeMultiplier: ratioCalc * 1.5
                        font.bold : true
                        SGStatusLight {
                            id: pgoodLight
                            property var read_pgood: platformInterface.status_pgood.pgood
                            onRead_pgoodChanged: {
                                if(read_pgood === "good")
                                    pgoodLight.status = SGStatusLight.Green
                                else  pgoodLight.status = SGStatusLight.Red
                            }

                        }
                    }
                }
                Rectangle {
                    id: currentContainer
                    width: parent.width
                    height: parent.height/3
                    color: "transparent"
                    anchors {
                        top: pgoodLightContainer.bottom
                        horizontalCenter: parent.horizontalCenter
                    }
                    Rectangle {
                        id: outputContainer
                        width: parent.width
                        height: parent.height/2
                        anchors {
                            top : parent.top
                            horizontalCenter: parent.horizontalCenter
                        }
                        color: "transparent"
                        SGAlignedLabel {
                            id: ouputVoltageLabel
                            target: outputVoltage
                            text: "Output Voltage"
                            alignment: SGAlignedLabel.SideLeftCenter
                            anchors.centerIn: parent
                            fontSizeMultiplier: ratioCalc * 1.5
                            font.bold : true
                            //margin: 15
                            SGInfoBox {
                                id: outputVoltage
                                //text: platformInterface.status_voltage_current.vout
                                property var ouputVoltageValue:  platformInterface.status_voltage_current.vout.toFixed(2)
                                onOuputVoltageValueChanged: {
                                    text = ouputVoltageValue
                                }

                                unit: "V"
                                fontSizeMultiplier: ratioCalc === 0 ? 1.0 : ratioCalc * 1.8
                                boxColor: "lightgrey"
                                height: (outputContainer.height - ouputVoltageLabel.contentHeight) + 10
                                width: (outputContainer.width - ouputVoltageLabel.contentWidth)/2.3
                                boxFont.family: Fonts.digitalseven
                                unitFont.bold: true
                            }
                        }
                    }

                    Rectangle {
                        id: outputCurrentContainer
                        width: parent.width
                        height: parent.height/2
                        color: "transparent"
                        anchors {
                            top : outputContainer.bottom
                            topMargin : 5
                            horizontalCenter: parent.horizontalCenter
                        }
                        SGAlignedLabel {
                            id: ouputCurrentLabel
                            target: ouputCurrent
                            text:  "Output Current"
                            alignment: SGAlignedLabel.SideLeftCenter
                            anchors.centerIn: parent
                            fontSizeMultiplier: ratioCalc * 1.5
                            font.bold : true
                            //margin: 15
                            SGInfoBox {
                                id: ouputCurrent
                                //text: platformInterface.status_voltage_current.iout.toFixed(2)

                                property var ouputCurrentValue:  platformInterface.status_voltage_current.iout.toFixed(2)
                                onOuputCurrentValueChanged: {
                                    text = ouputCurrentValue
                                }

                                unit: "A"
                                fontSizeMultiplier: ratioCalc === 0 ? 1.0 : ratioCalc * 1.8
                                height: (outputCurrentContainer.height - ouputCurrentLabel.contentHeight) + 10
                                width: (outputCurrentContainer.width - ouputCurrentLabel.contentWidth)/2.3
                                boxColor: "lightgrey"
                                boxFont.family: Fonts.digitalseven
                                unitFont.bold: true

                            }
                        }
                    }
                }

                //                Rectangle {
                //                    width: parent.width
                //                    height: parent.height/3
                //                    color: "red"//"transparent"
                //                    anchors {
                //                        top: currentContainer.bottom
                //                        topMargin: 5
                //                        horizontalCenter: parent.horizontalCenter
                //                    }

                //                    Rectangle {
                //                        id: modeContainer
                //                        width: parent.width
                //                        height: parent.height/2
                //                        anchors {
                //                            top : parent.top
                //                            topMargin: 5
                //                            horizontalCenter: parent.horizontalCenter
                //                        }
                //                        color: "transparent"
                //                        SGAlignedLabel {
                //                            id: modeLabel
                //                            target: modeValue
                //                            text: "Mode "
                //                            alignment: SGAlignedLabel.SideLeftCenter
                //                            margin: 10
                //                            anchors.centerIn: parent
                //                            //anchors.horizontalCenter: parent.horizontalCenter
                //                            //anchors.horizontalCenterOffset: (ouputCurrentLabel.width - width)/3.5
                //                            fontSizeMultiplier: ratioCalc * 1.5
                //                            font.bold : true

                //                            SGComboBox {
                //                                id: modeValue
                //                                model: [ "Master", "Slave" ]
                //                                borderColor: "black"
                //                                textColor: "black"          // Default: "black"
                //                                indicatorColor: "black"
                //                                onActivated: {
                //                                    platformInterface.set_sync_mode.update(currentText.toLowerCase())
                //                                }

                //                            }
                //                        }
                //                    }
                //                    Rectangle {
                //                        id: freqContainer
                //                        width: parent.width
                //                        height: parent.height/2
                //                        anchors {
                //                            top : modeContainer.bottom
                //                            horizontalCenter: parent.horizontalCenter
                //                        }
                //                        color: "transparent"
                //                        SGAlignedLabel {
                //                            id: freqLabel
                //                            target: freqValue
                //                            text: "Switching Frequency"
                //                            alignment: SGAlignedLabel.SideLeftCenter
                //                            margin: 10
                //                            anchors.horizontalCenter: parent.horizontalCenter
                //                            //anchors.horizontalCenterOffset: (modeLabel.width - width)/3.6
                //                            fontSizeMultiplier: ratioCalc * 1.5
                //                            font.bold : true
                //                            SGInfoBox {
                //                                id: freqValue
                //                                text: "0.00"//platformInterface.status_voltage_current.vout
                //                                unit: "Khz"
                //                                fontSizeMultiplier: ratioCalc === 0 ? 1.0 : ratioCalc * 1.8
                //                                boxColor: "lightgrey"
                //                                height: (freqContainer.height - freqLabel.contentHeight) + 10
                //                                width: (freqContainer.width - freqLabel.contentWidth)/2.2
                //                                boxFont.family: Fonts.digitalseven
                //                                unitFont.bold: true
                //                                property var frequencyValue: platformInterface.switchFrequency
                //                                onFrequencyValueChanged: {
                //                                    text = frequencyValue
                //                                }
                //                            }
                //                        }
                //                    }
                //                }
            }
        }
    }
}


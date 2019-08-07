import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3
import QtGraphicalEffects 1.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4
import tech.strata.sgwidgets 0.9
import tech.strata.sgwidgets 1.0 as Widget10
import tech.strata.fonts 1.0
import "qrc:/js/navigation_control.js" as NavigationControl
import "qrc:/js/help_layout_manager.js" as Help

Item {
    id: root
    height: 200
    width: parent.width
    anchors.left: parent.left
    property string vinlable: ""
    property alias ledCalc: ledLight
    property real ratioCalc: root.width / 1200
    property real initialAspectRatio: 1200/820

    property var reset_indicator_status: platformInterface.power_cycle_status.reset
    onReset_indicator_statusChanged: {
        if(reset_indicator_status === "occurred"){
            platformInterface.reset_indicator = Widget10.SGStatusLight.Red
            platformInterface.reset_flag = true
        }
    }

    property var reset_led_status: platformInterface.reset_indicator
    onReset_led_statusChanged: {
        resetLed.status = platformInterface.reset_indicator
    }


    property var status_interrupt: platformInterface.initial_status_0.pgood_status
    onStatus_interruptChanged:  {
        if(status_interrupt === "bad"){
            pGoodLed.status =  Widget10.SGStatusLight.Red
            //            basicControl.warningVisible = true
        }
        else if(status_interrupt === "good"){
            pGoodLed.status =  Widget10.SGStatusLight.Green
            //            basicControl.warningVisible = false
        }
    }

    property var read_enable_state: platformInterface.initial_status_0.enable_status
    onRead_enable_stateChanged: {
        platformInterface.enabled = (read_enable_state === "on") ? true : false
    }

    property var read_vin: platformInterface.initial_status_0.vingood_status
    onRead_vinChanged: {
        if(read_vin === "good") {
            ledLight.status =  Widget10.SGStatusLight.Green
            platformInterface.hide_enable = true
            vinlable = "over"
            ledLightLabel.text = "VIN Ready \n ("+ vinlable + " 2.5V)"
        }
        else {
            ledLight.status =  Widget10.SGStatusLight.Red
            platformInterface.hide_enable = false
            vinlable = "under"
            ledLightLabel.text = "VIN Ready \n ("+ vinlable + " 2.5V)"
        }
        console.log("hide_enable", platformInterface.hide_enable)
    }

    property var pgood_status_interrupt: platformInterface.status_interrupt.pgood
    onPgood_status_interruptChanged: {
        if(pgood_status_interrupt === "bad"){
            pGoodLed.status = Widget10.SGStatusLight.Red
            //            basicControl.warningVisible = true
            //            platformInterface.enabled = false
            //            platformInterface.set_enable.update("off")
        }
        else if(pgood_status_interrupt === "good"){
            pGoodLed.status = Widget10.SGStatusLight.Green
            //            basicControl.warningVisible = false
            //            platformInterface.intd_state = true
        }
    }

    // On enable toggle clear the fault log and push it to fault history log
    property bool check_intd_state: platformInterface.intd_state
    onCheck_intd_stateChanged:  {
        // ToDO: Tejashree Fix this logic. May have to remove it.
//        if(check_intd_state === true) {
//            addToHistoryLog()
//            historyErrorArray = []
//        }
    }

    property var errorArray: platformInterface.status_ack_register.events_detected
    property var historyErrorArray:[]
    property var historyLogErrorArray: []
    onErrorArrayChanged: {
        // Change text color to black of the entire existing list of faults

        // Push current error on fault log and change the text to red color
        for (var i = 0; i < errorArray.length; i++){
             interruptError.append(errorArray[i].toString())
        }
    }

    Component.onCompleted: {
        //reset default is off
        resetLed.status = Widget10.SGStatusLight.Off
        Help.registerTarget(tempGauge, "This gauge displays the board temperature next to NCV6357 in degrees Celsius.", 0, "advance5AHelp")
        Help.registerTarget(efficiencyGauge, "This gauge displays the efficiency of the power conversion in %. This calculated through Pout/Pin.", 1, "advance5AHelp")
        Help.registerTarget(powerDissipatedGauge, "This gauge displays the total power loss in the converter from input to output in Watts. This is calculated through Pout - Pin.", 2, "advance5AHelp")
        Help.registerTarget(powerOutputGauge, "This gauge displays the output power of the converter in Watts.", 3, "advance5AHelp")
        Help.registerTarget(resetLedContainer, "Reset Indicator LED will come on if NCV6357 resets itself during an event (e.g. UVLO), telling the user the part has reset to its default register state. The LED will turn off as soon as enable is toggled.", 4, "advance5AHelp")
        Help.registerTarget(resetButton, "The Force Reset button will reset NCV6357's internal registers to their default values.", 5, "advance5AHelp")
        Help.registerTarget(ledLightContainer,"VIN Ready LED will turn green when input voltage is high enough to regulate (above 2.5V). NCV6357 cannot be enabled until input voltage is high enough. ", 6, "advance5AHelp")
        Help.registerTarget(pGoodContainer, "PGOOD LED re presents state of Pgood pin. The power good signal is low (red) when the DC to DC converter is off. Once the output voltage reaches 93% of the expected output level, the power good logic signal becomes high (green).", 7, "advance5AHelp")
        Help.registerTarget(interruptError, "When an interrupt is triggered, the message log will display the interrupts that occurred.", 8, "advance5AHelp")
        Help.registerTarget(faultHistory, "The fault History box will show all the previous faults generated. Every time a new fault occurs it will be displayed on the top of the list. If the new fault is same as previous one, it will not be added to the list.", 9, "advance5AHelp")
//        Help.registerTarget(inputContainer, "Input voltage is shown here in Volts.", 10, "advance5AHelp")
//        Help.registerTarget(inputCurrContainer, "Input current is shown here in A", 11, "advance5AHelp")
//        Help.registerTarget(ouputCurrentContainer, " Output current is shown here in A.", 13, "advance5AHelp")
//        Help.registerTarget(outputVoltageContainer, "Output voltage is shown here in Volts.", 12, "advance5AHelp")
        Help.registerTarget(currentVoltageContainer, "These show the input/output voltage and current.", 10, "advance5AHelp")

    }

    Item {
        id: leftColumn
        anchors {
            top: parent.top
            left: parent.left
            bottom: parent.bottom
        }
        width: parent.width/1.7

        Item {
            id: margins1
            anchors {
                fill: parent
            }

            Rectangle {
                id:gauges
                width : parent.width
                height: parent.height/1.5
                color: "transparent"
                anchors.top: parent.top


                Rectangle{
                    id: tempGaugeContainer
                    width: parent.width/4
                    height: parent.height - 10
                    anchors{
                        top: parent.top
                        left: parent.left
                    }
                    color: "transparent"
                    Widget10.SGAlignedLabel {
                        id: tempLabel
                        target: tempGauge
                        text: "Board \n Temperature"
                        margin: 0

                        alignment: Widget10.SGAlignedLabel.SideBottomCenter
                        fontSizeMultiplier: ratioCalc * 1.1
                        font.bold : true
                        anchors.centerIn: parent
                        horizontalAlignment: Text.AlignHCenter

                        Widget10.SGCircularGauge {
                            id: tempGauge
                            minimumValue: -55
                            maximumValue: 125
                            width: tempGaugeContainer.width
                            height: tempGaugeContainer.height/1.5
                            anchors.centerIn: parent
                            //valueDecimalPlaces: 2
                            gaugeFillColor1: "blue"
                            gaugeFillColor2: "red"
                            tickmarkStepSize: 20
                            unitText: "˚C"
                            unitTextFontSizeMultiplier: ratioCalc * 2.5
                            value:platformInterface.status_temperature_sensor.temperature
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
                    id: efficiencyGaugeContainer
                    width: parent.width/4
                    height: parent.height - 10
                    color: "transparent"
                    anchors {
                        top: parent.top
                        left: tempGaugeContainer.right
                    }
                    Widget10.SGAlignedLabel {
                        id: efficiencyLabel
                        target: efficiencyGauge
                        text: "Efficiency"
                        margin: 0
                        anchors.centerIn: parent
                        alignment: Widget10.SGAlignedLabel.SideBottomCenter
                        fontSizeMultiplier:  ratioCalc * 1.1
                        font.bold : true
                        horizontalAlignment: Text.AlignHCenter
                        Widget10.SGCircularGauge {
                            id: efficiencyGauge
                            minimumValue: 0
                            maximumValue: 100
                            tickmarkStepSize: 10
                            gaugeFillColor1: "red"
                            gaugeFillColor2:  "green"
                            width: tempGaugeContainer.width
                            height: tempGaugeContainer.height/1.5
                            anchors.centerIn: parent
                            unitText: "%"
                            unitTextFontSizeMultiplier: ratioCalc * 2.5
                            //valueDecimalPlaces: 2
                            value: platformInterface.status_voltage_current.efficiency
                            Behavior on value { NumberAnimation { duration: 300 } }


                        }
                    }
                }

                Rectangle {
                    id: powerDissipatedContainer
                    width: parent.width/4
                    height: parent.height - 10
                    color: "transparent"
                    anchors {
                        top: parent.top
                        left: efficiencyGaugeContainer.right
                    }
                    Widget10.SGAlignedLabel {
                        id: powerDissipatedLabel
                        target: powerDissipatedGauge
                        text: "Power Loss"
                        margin: 0
                        anchors.centerIn: parent
                        alignment: Widget10.SGAlignedLabel.SideBottomCenter
                        fontSizeMultiplier:  ratioCalc * 1.1
                        font.bold : true
                        horizontalAlignment: Text.AlignHCenter


                        Widget10.SGCircularGauge {
                            id: powerDissipatedGauge
                            minimumValue: 0
                            maximumValue: 5
                            tickmarkStepSize: 0.5
                            gaugeFillColor1:"green"
                            gaugeFillColor2:"red"
                            width: tempGaugeContainer.width
                            height: tempGaugeContainer.height/1.5
                            anchors.centerIn: parent
                            unitTextFontSizeMultiplier: ratioCalc * 2.5
                            unitText: "W"
                            valueDecimalPlaces: 2
                            value: platformInterface.status_voltage_current.power_dissipated
                            Behavior on value { NumberAnimation { duration: 300 } }
                        }
                    }
                }

                Rectangle{
                    width: parent.width/4
                    height: parent.height - 10
                    anchors {
                        top: parent.top
                        left: powerDissipatedContainer.right
                    }
                    Widget10.SGAlignedLabel {
                        id: ouputPowerLabel
                        target: powerOutputGauge
                        text: "Output Power"
                        margin: 0
                        anchors.centerIn: parent
                        alignment: Widget10.SGAlignedLabel.SideBottomCenter
                        fontSizeMultiplier: ratioCalc * 1.1
                        font.bold : true
                        horizontalAlignment: Text.AlignHCenter
                        Widget10.SGCircularGauge {
                            id: powerOutputGauge
                            minimumValue: 0
                            maximumValue:  20
                            tickmarkStepSize: 2
                            gaugeFillColor1:"green"
                            gaugeFillColor2:"red"
                            width: tempGaugeContainer.width
                            height: tempGaugeContainer.height/1.5
                            anchors.centerIn: parent
                            unitText: "W"
                            valueDecimalPlaces: 2
                            unitTextFontSizeMultiplier: ratioCalc * 2.5
                            value: platformInterface.status_voltage_current.output_power
                            Behavior on value { NumberAnimation { duration: 300 } }

                        }
                    }
                }
            }

            Rectangle {
                id: currentVoltageContainer
                width: parent.width
                height: parent.height/2.8
                color: "transparent"
                anchors.top: gauges.bottom
                Rectangle{
                    id: inputContainer
                    anchors {
                        top : parent.top
                        topMargin: 5
                        left: parent.left
                    }
                    width : parent.width/2
                    height:  parent.height/3

                    Widget10.SGAlignedLabel {
                        id: inputVoltageLabel
                        target: inputVoltage
                        text: "Input Voltage"
                        alignment: Widget10.SGAlignedLabel.SideLeftCenter
                        anchors.centerIn: parent
                        fontSizeMultiplier: ratioCalc * 1.5
                        font.bold : true

                        Widget10.SGInfoBox {
                            id: inputVoltage
                            text: platformInterface.status_voltage_current.vin.toFixed(2)
                            unit: "V"
                            //anchors.centerIn: inputContainer
                            fontSizeMultiplier: ratioCalc === 0 ? 1.0 : ratioCalc * 1.5
                            //boxBorderWidth: (parent.width+parent.height)/0.9
                            width: (inputContainer.width - inputVoltageLabel.contentWidth)/1.5
                            boxColor: "lightgrey"
                            boxFont.family: Fonts.digitalseven
                            unitFont.bold: true

                        }
                    }
                }
                Rectangle{
                    id: inputCurrContainer
                    anchors {
                        top : inputContainer.bottom
                        topMargin: 10
                        left: parent.left

                    }
                    width : parent.width/2
                    height:  parent.height/3
                    Widget10.SGAlignedLabel {
                        id: inputCurrLabel
                        target: inputCurrent
                        text: "Input Current"
                        alignment: Widget10.SGAlignedLabel.SideLeftCenter
                        anchors.centerIn: parent
                        fontSizeMultiplier: ratioCalc * 1.5
                        font.bold : true

                        Widget10.SGInfoBox {
                            id: inputCurrent
                            text:  platformInterface.status_voltage_current.iin.toFixed(2)
                            unit: "A"
                            //anchors.centerIn: inputCurrContainer
                            fontSizeMultiplier: ratioCalc === 0 ? 1.0 : ratioCalc * 1.5
                            //boxBorderWidth: (parent.width+parent.height)/0.9
                            boxColor: "lightgrey"
                            width: (inputCurrContainer.width - inputCurrLabel.contentWidth)/1.5
                            boxFont.family: Fonts.digitalseven
                            unitFont.bold: true

                        }
                    }
                }

                Rectangle {
                    id: outputVoltageContainer
                    width : parent.width/2
                    height:  parent.height/3
                    anchors {
                        top: parent.top
                        topMargin: 5
                        right: parent.right
                        rightMargin: 20
                    }
                    Widget10.SGAlignedLabel {
                        id: ouputVoltageLabel
                        target: outputVoltage
                        text: "Output Voltage"
                        alignment: Widget10.SGAlignedLabel.SideLeftCenter
                        anchors.centerIn: parent
                        fontSizeMultiplier: ratioCalc * 1.5
                        font.bold : true

                        Widget10.SGInfoBox {
                            id: outputVoltage
                            text: platformInterface.status_voltage_current.vout/*.toFixed(2)*/
                            unit: "V"
                            // anchors.centerIn: outputVoltageContainer
                            fontSizeMultiplier: ratioCalc === 0 ? 1.0 : ratioCalc * 1.5
                            //boxBorderWidth: (parent.width+parent.height)/0.9
                            boxColor: "lightgrey"
                            width: (outputVoltageContainer.width - ouputVoltageLabel.contentWidth)/1.5
                            boxFont.family: Fonts.digitalseven
                            unitFont.bold: true

                        }
                    }
                }
                Rectangle {
                    id: ouputCurrentContainer
                    width : parent.width/2
                    height:  parent.height/3

                    anchors {
                        top: outputVoltageContainer.bottom
                        topMargin: 10
                        right: parent.right
                        rightMargin: 20

                    }
                    Widget10.SGAlignedLabel {
                        id: ouputCurrentLabel
                        target: ouputCurrent
                        text:  "Output Current"
                        alignment: Widget10.SGAlignedLabel.SideLeftCenter
                        anchors.centerIn: parent
                        fontSizeMultiplier: ratioCalc * 1.5
                        font.bold : true
                        Widget10.SGInfoBox {
                            id: ouputCurrent
                            text: platformInterface.status_voltage_current.iout.toFixed(2)
                            unit: "A"
                            //anchors.centerIn: ouputCurrentContainer
                            fontSizeMultiplier: ratioCalc === 0 ? 1.0 : ratioCalc * 1.5
                            //boxBorderWidth: (parent.width+parent.height)/0.9
                            boxColor: "lightgrey"
                            width: (ouputCurrentContainer.width - ouputCurrentLabel.contentWidth)/1.5
                            boxFont.family: Fonts.digitalseven
                            unitFont.bold: true
                        }
                    }
                }
            }
            //            }
        }
        SGLayoutDivider {
            id: divider
            position: "right"
        }
    }

    Item {
        id: rightColumn
        anchors {
            left: leftColumn.right
            top: parent.top
            bottom: parent.bottom
            right: parent.right
        }
        Item {
            id: margins2
            anchors {
                fill: parent
                margins: 15
            }

            Rectangle {
                id: faultContainer
                height: (parent.height - resetContainer.height) + 5
                width: parent.width
                border.color: "black"
                border.width: 3
                radius: 10
                anchors{
                    top: resetContainer.bottom
                    topMargin: 3
                    //                    bottom: parent.bottom
                    //                    bottomMargin: 5
                }

                Widget10.SGStatusLogBox {
                    id: interruptError
                    height: parent.height/2.2
                    width: parent.width/1.1
                    anchors {
                        top: parent.top
                        topMargin: 10
                        horizontalCenter: parent.horizontalCenter
                    }
                    title: " <b> Faults Log: </b>"
                    showMessageIds: true
                }

                Widget10.SGStatusLogBox {
                    id: faultHistory
                    height: parent.height/2.5
                    width: parent.width/1.1
                    anchors {
                        top: interruptError.bottom
                        topMargin: 5
                        horizontalCenter: parent.horizontalCenter
                        bottom: parent.bottom
                        bottomMargin: 10

                    }
                    title: "<b> Faults History: </b>"
                    showMessageIds: true
                }
            }

            Rectangle {
                id:resetContainer
                height: rightColumn.height/3
                width: rightColumn.width/1.3
                color: "transparent"
                border.color: "black"
                border.width: 3
                radius: 10
                anchors{
                    top: parent.top
                    horizontalCenter: parent.horizontalCenter
                }
                Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                    anchors.horizontalCenter: parent.horizontalCenter

                    ColumnLayout{
                        id: leftTelemarySetting

                        width: parent.width/2
                        height: parent.height

                        Rectangle {
                            id: resetLedContainer
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            color: "transparent"
                            Widget10.SGAlignedLabel {
                                id: vinLabel
                                target: resetLed
                                text:  "Reset \n Indicator"
                                alignment: Widget10.SGAlignedLabel.SideLeftCenter
                                anchors.centerIn: parent
                                fontSizeMultiplier: ratioCalc * 1.1
                                font.bold : true
                                horizontalAlignment: Text.AlignHCenter
                                Widget10.SGStatusLight {
                                    id: resetLed
                                    status: Widget10.SGStatusLight.Off
                                }
                            }
                        }

                        Rectangle{
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            color: "transparent"
                            Widget10.SGButton {
                                id: resetButton
                                width: parent.width/1.7
                                height: parent.height - 20
                                anchors.centerIn: parent

                                background: Rectangle {
                                    color: "light gray"
                                    border.width: 1
                                    border.color: "gray"
                                    radius: 10
                                }
                                Text {
                                    text: "Force \n Reset"
                                    font.bold: true
                                    anchors.centerIn: parent
                                    horizontalAlignment: Text.AlignHCenter
                                }
                                onClicked: {
                                    platformInterface.force_reset_registers.update("reset")
                                    platformInterface.rearm_device.update("off")
                                    platformInterface.read_initial_status.update()
                                    addToHistoryLog()
                                }
                            }
                        }
                    }

                    Rectangle{

                        width: parent.width/2
                        height: parent.height
                        anchors.left: leftTelemarySetting.right
                        color: "transparent"

                        Rectangle {
                            id: ledLightContainer
                            width: parent.width/1.3
                            height: parent.height/2
                            anchors.top: parent.top
                            color: "transparent"
                            Widget10.SGAlignedLabel {
                                id: ledLightLabel
                                target: ledLight
                                text:  "VIN Ready \n (under 2.5V)"
                                alignment: Widget10.SGAlignedLabel.SideLeftCenter
                                anchors.centerIn: parent
                                fontSizeMultiplier: ratioCalc * 1.1
                                font.bold : true
                                horizontalAlignment: Text.AlignHCenter
                                Widget10.SGStatusLight {
                                    id: ledLight

                                    property string vinMonitor: platformInterface.status_vin_good.vingood
                                    onVinMonitorChanged:  {
                                        console.log("advance vingood")
                                        if(vinMonitor === "good") {
                                            status =  Widget10.SGStatusLight.Green
                                            vinlable = "over"
                                            platformInterface.hide_enable = true
                                            ledLightLabel.text = "VIN Ready \n ("+ vinlable + " 2.5V)"
                                            platformInterface.read_initial_status.update()

                                        }
                                        else if(vinMonitor === "bad") {
                                            status =  Widget10.SGStatusLight.Red
                                            platformInterface.hide_enable = false
                                            vinlable = "under"
                                            ledLightLabel.text = "VIN Ready \n ("+ vinlable + " 2.5V)"
                                            platformInterface.enabled = false
                                            platformInterface.set_enable.update("off")
                                        }
                                    }
                                }
                            }
                        }

                        Rectangle {
                            id: pGoodContainer
                            width: parent.width/1.8
                            height: parent.height/2
                            color: "transparent"
                            anchors {
                                top: ledLightContainer.bottom
                                horizontalCenter: ledLightContainer.horizontalCenter
                                horizontalCenterOffset: -(width - ledLightContainer.width)/2

                            }
                            Layout.alignment : Qt.AlignHCenter
                            Widget10.SGAlignedLabel {
                                id: pGoodLabel
                                target: pGoodLed
                                text: "PGood"
                                alignment: Widget10.SGAlignedLabel.SideLeftCenter
                                anchors.centerIn: parent

                                fontSizeMultiplier: ratioCalc * 1.1
                                font.bold : true
                                horizontalAlignment: Text.AlignHCenter

                                Widget10.SGStatusLight {
                                    id: pGoodLed
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.horizontalCenterOffset: -(width + ledCalc.width)/2


                                }
                            }
                        }
                    }
                }
            }
        }
    }
}



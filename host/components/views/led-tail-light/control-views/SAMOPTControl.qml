import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.3
import tech.strata.sgwidgets 1.0
import tech.strata.sgwidgets 0.9 as Widget09
import "qrc:/js/help_layout_manager.js" as Help

Item {
    id: root
    property real ratioCalc: root.width / 1200
    property real initialAspectRatio: 1200/820
    anchors.centerIn: parent
    height: parent.height
    width: parent.width / parent.height > initialAspectRatio ? parent.height * initialAspectRatio : parent.width

    function toHex(d) {
        return  ("0"+(Number(d).toString(16))).slice(-2).toUpperCase()
    }

    property var soc_sam_conf_1_values: platformInterface.soc_sam_conf_1_values.values
    onSoc_sam_conf_1_valuesChanged: {
        out1.checked = soc_sam_conf_1_values[0]
        out2.checked = soc_sam_conf_1_values[1]
        out3.checked = soc_sam_conf_1_values[2]
        out4.checked = soc_sam_conf_1_values[3]
        out5.checked = soc_sam_conf_1_values[4]
        out6.checked = soc_sam_conf_1_values[5]
        out7.checked = soc_sam_conf_1_values[6]
        out8.checked = soc_sam_conf_1_values[7]
        out9.checked = soc_sam_conf_1_values[8]
        out10.checked = soc_sam_conf_1_values[9]
        out11.checked = soc_sam_conf_1_values[10]
        out12.checked = soc_sam_conf_1_values[11]

        platformInterface.soc_sam_conf_1_out1 = soc_sam_conf_1_values[0]
        platformInterface.soc_sam_conf_1_out2 = soc_sam_conf_1_values[1]
        platformInterface.soc_sam_conf_1_out3 = soc_sam_conf_1_values[2]
        platformInterface.soc_sam_conf_1_out4 = soc_sam_conf_1_values[3]
        platformInterface.soc_sam_conf_1_out5 = soc_sam_conf_1_values[4]
        platformInterface.soc_sam_conf_1_out6 = soc_sam_conf_1_values[5]
        platformInterface.soc_sam_conf_1_out7 = soc_sam_conf_1_values[6]
        platformInterface.soc_sam_conf_1_out8 = soc_sam_conf_1_values[7]
        platformInterface.soc_sam_conf_1_out9 = soc_sam_conf_1_values[8]
        platformInterface.soc_sam_conf_1_out10 = soc_sam_conf_1_values[9]
        platformInterface.soc_sam_conf_1_out11 = soc_sam_conf_1_values[10]
        platformInterface.soc_sam_conf_1_out12 = soc_sam_conf_1_values[11]



    }

    property var soc_sam_conf_1_state: platformInterface.soc_sam_conf_1_state.state
    onSoc_sam_conf_1_stateChanged: {
        if(soc_sam_conf_1_state === "enabled") {
            out1.enabled = true
            out1.opacity = 1.0
            out2.enabled = true
            out2.opacity = 1.0
            out3.enabled = true
            out3.opacity = 1.0
            out4.enabled = true
            out4.opacity = 1.0
            out5.enabled = true
            out5.opacity = 1.0
            out6.enabled = true
            out6.opacity = 1.0
            out7.enabled = true
            out7.opacity = 1.0
            out8.enabled = true
            out8.opacity = 1.0
            out9.enabled = true
            out9.opacity = 1.0
            out10.enabled = true
            out10.opacity = 1.0
            out11.enabled = true
            out11.opacity = 1.0
            out12.enabled = true
            out12.opacity = 1.0

        }
        else if (soc_sam_conf_1_state === "disabled") {
            out1.enabled = false
            out1.opacity = 1.0
            out2.enabled = false
            out2.opacity = 1.0
            out3.enabled = false
            out3.opacity = 1.0
            out4.enabled = false
            out4.opacity = 1.0
            out5.enabled = false
            out5.opacity = 1.0
            out6.enabled = false
            out6.opacity = 1.0
            out7.enabled = false
            out7.opacity = 1.0
            out8.enabled = false
            out8.opacity = 1.0
            out9.enabled = false
            out9.opacity = 1.0
            out10.enabled = false
            out10.opacity = 1.0
            out11.enabled = false
            out11.opacity = 1.0
            out12.enabled = false
            out12.opacity = 1.0

        }
        else {
            out1.enabled = false
            out1.opacity = 0.5
            out2.enabled = false
            out2.opacity = 0.5
            out3.enabled = false
            out3.opacity = 0.5
            out4.enabled = false
            out4.opacity = 0.5
            out5.enabled = false
            out5.opacity = 0.5
            out6.enabled = false
            out6.opacity = 0.5
            out7.enabled = false
            out7.opacity = 0.5
            out8.enabled = false
            out8.opacity = 0.5
            out9.enabled = false
            out9.opacity = 0.5
            out10.enabled = false
            out10.opacity = 0.5
            out11.enabled = false
            out11.opacity = 0.5
            out12.enabled = false
            out12.opacity = 0.5
        }
    }

    property var soc_sam_conf_2_values: platformInterface.soc_sam_conf_2_values.values
    onSoc_sam_conf_2_valuesChanged: {


        samOut1.checked = soc_sam_conf_2_values[0]
        samOut2.checked = soc_sam_conf_2_values[1]
        samOut3.checked = soc_sam_conf_2_values[2]
        samOut4.checked = soc_sam_conf_2_values[3]
        samOut5.checked = soc_sam_conf_2_values[4]
        samOut6.checked = soc_sam_conf_2_values[5]
        samOut7.checked = soc_sam_conf_2_values[6]
        samOut8.checked = soc_sam_conf_2_values[7]
        samOut9.checked = soc_sam_conf_2_values[8]
        samOut10.checked = soc_sam_conf_2_values[9]
        samOut11.checked = soc_sam_conf_2_values[10]
        samOut12.checked = soc_sam_conf_2_values[11]


        platformInterface.soc_sam_conf_2_out1 = soc_sam_conf_2_values[0]
        platformInterface.soc_sam_conf_2_out2 = soc_sam_conf_2_values[1]
        platformInterface.soc_sam_conf_2_out3 = soc_sam_conf_2_values[2]
        platformInterface.soc_sam_conf_2_out4 = soc_sam_conf_2_values[3]
        platformInterface.soc_sam_conf_2_out5 = soc_sam_conf_2_values[4]
        platformInterface.soc_sam_conf_2_out6 = soc_sam_conf_2_values[5]
        platformInterface.soc_sam_conf_2_out7 = soc_sam_conf_2_values[6]
        platformInterface.soc_sam_conf_2_out8 = soc_sam_conf_2_values[7]
        platformInterface.soc_sam_conf_2_out9 = soc_sam_conf_2_values[8]
        platformInterface.soc_sam_conf_2_out10 = soc_sam_conf_2_values[9]
        platformInterface.soc_sam_conf_2_out11 = soc_sam_conf_2_values[10]
        platformInterface.soc_sam_conf_2_out12 = soc_sam_conf_2_values[11]
    }

    property var soc_sam_conf_2_state: platformInterface.soc_sam_conf_2_state.state
    onSoc_sam_conf_2_stateChanged: {
        if(soc_sam_conf_2_state === "enabled") {
            samOut1.enabled = true
            samOut1.opacity = 1.0
            samOut2.enabled = true
            samOut2.opacity = 1.0
            samOut3.enabled = true
            samOut3.opacity = 1.0
            samOut4.enabled = true
            samOut4.opacity = 1.0
            samOut5.enabled = true
            samOut5.opacity = 1.0
            samOut6.enabled = true
            samOut6.opacity = 1.0
            samOut7.enabled = true
            samOut7.opacity = 1.0
            samOut8.enabled = true
            samOut8.opacity = 1.0
            samOut9.enabled = true
            samOut9.opacity = 1.0
            samOut10.enabled = true
            samOut10.opacity = 1.0
            samOut11.enabled = true
            samOut11.opacity = 1.0
            samOut12.enabled = true
            samOut12.opacity = 1.0

        }
        else if (soc_sam_conf_2_state === "disabled") {
            samOut1.enabled = false
            samOut1.opacity = 1.0
            samOut2.enabled = false
            samOut2.opacity = 1.0
            samOut3.enabled = false
            samOut3.opacity = 1.0
            samOut4.enabled = false
            samOut4.opacity = 1.0
            samOut5.enabled = false
            samOut5.opacity = 1.0
            samOut6.enabled = false
            samOut6.opacity = 1.0
            samOut7.enabled = false
            samOut7.opacity = 1.0
            samOut8.enabled = false
            samOut8.opacity = 1.0
            samOut9.enabled = false
            samOut9.opacity = 1.0
            samOut10.enabled = false
            samOut10.opacity = 1.0
            samOut11.enabled = false
            samOut11.opacity = 1.0
            samOut12.enabled = false
            samOut12.opacity = 1.0

        }
        else {
            samOut1.enabled = false
            samOut1.opacity = 0.5
            samOut2.enabled = false
            samOut2.opacity = 0.5
            samOut3.enabled = false
            samOut3.opacity = 0.5
            samOut4.enabled = false
            samOut4.opacity = 0.5
            samOut5.enabled = false
            samOut5.opacity = 0.5
            samOut6.enabled = false
            samOut6.opacity = 0.5
            samOut7.enabled = false
            samOut7.opacity = 0.5
            samOut8.enabled = false
            samOut8.opacity = 0.5
            samOut9.enabled = false
            samOut9.opacity = 0.5
            samOut10.enabled = false
            samOut10.opacity = 0.5
            samOut11.enabled = false
            samOut11.opacity = 0.5
            samOut12.enabled = false
            samOut12.opacity = 0.5
        }
    }

    Popup{
        id: warningPopup
        width: parent.width/2
        height: parent.height/4
        anchors.centerIn: parent
        modal: true
        focus: true
        closePolicy: Popup.NoAutoClose
        background: Rectangle{
            id: warningPopupContainer
            width: warningPopup.width
            height: warningPopup.height
            color: "#dcdcdc"
            border.color: "grey"
            border.width: 2
            radius: 10
            Rectangle {
                id:topBorder
                width: parent.width
                height: parent.height/7
                anchors{
                    top: parent.top
                    topMargin: 2
                    right: parent.right
                    rightMargin: 2
                    left: parent.left
                    leftMargin: 2
                }
                radius: 5
                color: "#c0c0c0"
                border.color: "#c0c0c0"
                border.width: 2
            }
        }

        Rectangle {
            id: warningPopupBox
            color: "transparent"
            anchors {
                top: parent.top
                topMargin: 5
                horizontalCenter: parent.horizontalCenter
            }
            width: warningPopupContainer.width - 50
            height: warningPopupContainer.height - 50

            Rectangle {
                id: messageContainerForPopup
                anchors {
                    top: parent.top
                    topMargin: 10
                    centerIn:  parent.Center
                }
                color: "transparent"
                width: parent.width
                height:  parent.height - selectionContainerForPopup.height
                Text {
                    id: warningTextForPopup
                    anchors.fill:parent
                    text: "The part will be permanently OTP’ed. The registers on this page will become read-only. Do you want to continue?”"
                    verticalAlignment:  Text.AlignVCenter
                    wrapMode: Text.WordWrap
                    fontSizeMode: Text.Fit
                    width: parent.width
                    font.family: "Helvetica Neue"
                    font.pixelSize: ratioCalc * 15
                }
            }

            Rectangle {
                id: selectionContainerForPopup
                width: parent.width/2
                height: parent.height/4.5
                anchors{
                    top: messageContainerForPopup.bottom
                    topMargin: 10
                    right: parent.right
                }
                color: "transparent"

                SGButton {
                    id: continueButton
                    width: parent.width/3
                    height:parent.height
                    anchors.left: parent.left
                    //anchors.leftMargin: 20
                    //anchors.centerIn: parent
                    text: "Continue"
                    color: checked ? "white" : pressed ? "#cfcfcf": hovered ? "#eee" : "white"
                    roundedLeft: true
                    roundedRight: true

                    onClicked: {
                        warningPopup.close()
                        platformInterface.soc_otpValue = true
                        platformInterface.set_soc_write.update(
                                    platformInterface.soc_otpValue,
                                    [platformInterface.soc_sam_conf_1_out1,
                                     platformInterface.soc_sam_conf_1_out2,
                                     platformInterface.soc_sam_conf_1_out3,
                                     platformInterface.soc_sam_conf_1_out4,
                                     platformInterface.soc_sam_conf_1_out5,
                                     platformInterface.soc_sam_conf_1_out6,
                                     platformInterface.soc_sam_conf_1_out7,
                                     platformInterface.soc_sam_conf_1_out8,
                                     platformInterface.soc_sam_conf_1_out9,
                                     platformInterface.soc_sam_conf_1_out10,
                                     platformInterface.soc_sam_conf_1_out11,
                                     platformInterface.soc_sam_conf_1_out12

                                    ],
                                    [platformInterface.soc_sam_conf_2_out1,
                                     platformInterface.soc_sam_conf_2_out2,
                                     platformInterface.soc_sam_conf_2_out3,
                                     platformInterface.soc_sam_conf_2_out4,
                                     platformInterface.soc_sam_conf_2_out5,
                                     platformInterface.soc_sam_conf_2_out6,
                                     platformInterface.soc_sam_conf_2_out7,
                                     platformInterface.soc_sam_conf_2_out8,
                                     platformInterface.soc_sam_conf_2_out9,
                                     platformInterface.soc_sam_conf_2_out10,
                                     platformInterface.soc_sam_conf_2_out11,
                                     platformInterface.soc_sam_conf_2_out12
                                    ],
                                    samOpenLoadDiagnostic.currentText,
                                    platformInterface.soc_otpValue,
                                    platformInterface.addr_curr_apply)
                    }
                }

                SGButton {
                    id: cancelButton
                    width: parent.width/3
                    height:parent.height
                    anchors.left: continueButton.right
                    anchors.leftMargin: 20
                    //anchors.centerIn: parent
                    text: "Cancel"
                    color: checked ? "white" : pressed ? "#cfcfcf": hovered ? "#eee" : "white"
                    roundedLeft: true
                    roundedRight: true

                    onClicked: {
                        warningPopup.close()
                        platformInterface.soc_otpValue = false
                        platformInterface.set_soc_write.update(
                                    platformInterface.soc_otpValue,
                                    [platformInterface.soc_sam_conf_1_out1,
                                     platformInterface.soc_sam_conf_1_out2,
                                     platformInterface.soc_sam_conf_1_out3,
                                     platformInterface.soc_sam_conf_1_out4,
                                     platformInterface.soc_sam_conf_1_out5,
                                     platformInterface.soc_sam_conf_1_out6,
                                     platformInterface.soc_sam_conf_1_out7,
                                     platformInterface.soc_sam_conf_1_out8,
                                     platformInterface.soc_sam_conf_1_out9,
                                     platformInterface.soc_sam_conf_1_out10,
                                     platformInterface.soc_sam_conf_1_out11,
                                     platformInterface.soc_sam_conf_1_out12

                                    ],
                                    [platformInterface.soc_sam_conf_2_out1,
                                     platformInterface.soc_sam_conf_2_out2,
                                     platformInterface.soc_sam_conf_2_out3,
                                     platformInterface.soc_sam_conf_2_out4,
                                     platformInterface.soc_sam_conf_2_out5,
                                     platformInterface.soc_sam_conf_2_out6,
                                     platformInterface.soc_sam_conf_2_out7,
                                     platformInterface.soc_sam_conf_2_out8,
                                     platformInterface.soc_sam_conf_2_out9,
                                     platformInterface.soc_sam_conf_2_out10,
                                     platformInterface.soc_sam_conf_2_out11,
                                     platformInterface.soc_sam_conf_2_out12
                                    ],
                                    samOpenLoadDiagnostic.currentText,
                                    platformInterface.soc_otpValue,
                                    platformInterface.addr_curr)
                    }
                }

            }
        }
    }


    ColumnLayout {
        width: parent.width/1.1
        height: parent.height/1.2
        anchors.centerIn: parent

        Rectangle {
            Layout.fillHeight: true
            Layout.fillWidth: true

            RowLayout {
                anchors.fill: parent

                Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    SGAlignedLabel {
                        id: diagLabel
                        target: diag
                        alignment: SGAlignedLabel.SideTopCenter
                        anchors {
                            top:parent.top
                            topMargin: 10
                            //left: parent.left
                            verticalCenter: parent.verticalCenter
                            //leftMargin: 20
                        }

                        fontSizeMultiplier: ratioCalc * 1.2
                        // text: "DIAG"
                        font.bold: true

                        SGStatusLight {
                            id: diag
                            width : 40

                        }

                        property var soc_diag_caption: platformInterface.soc_diag_caption.caption
                        onSoc_diag_captionChanged: {
                            diagLabel.text = soc_diag_caption
                        }

                        property var soc_diag_state: platformInterface.soc_diag_state.state
                        onSoc_diag_stateChanged: {
                            if(soc_diag_state === "enabled"){
                                diag.enabled = true
                                diag.opacity = 1.0
                            }
                            else if (soc_diag_state === "disabled") {
                                diag.enabled = false
                                diag.opacity = 1.0
                            }
                            else {
                                diag.enabled = false
                                diag.opacity = 0.5
                            }
                        }

                        property var soc_diag_value: platformInterface.soc_diag_value.value
                        onSoc_diag_valueChanged: {
                            if(soc_diag_value === true)
                                diag.status = SGStatusLight.Red
                            else  diag.status = SGStatusLight.Off
                        }
                    }
                }

                Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    SGAlignedLabel {
                        id: enableCRCLabel
                        target: enableCRC
                        //text: "Enable\nCRC"
                        alignment: SGAlignedLabel.SideTopLeft
                        anchors {
                            top:parent.top
                            left: parent.left
                            verticalCenter: parent.verticalCenter
                            leftMargin: 20
                        }
                        fontSizeMultiplier: ratioCalc * 1.2
                        font.bold : true

                        SGSwitch {
                            id: enableCRC
                            labelsInside: true
                            checkedLabel: "on"
                            uncheckedLabel: "off"
                            textColor: "black"              // Default: "black"
                            handleColor: "white"            // Default: "white"
                            grooveColor: "#ccc"             // Default: "#ccc"
                            grooveFillColor: "#0cf"         // Default: "#0cf"
                            fontSizeMultiplier: ratioCalc * 1.2
                            //checked: false
                            onToggled: {
                                platformInterface.soc_otpValue = checked
                                platformInterface.set_soc_write.update(
                                            platformInterface.soc_otpValue,
                                            [platformInterface.soc_sam_conf_1_out1,
                                             platformInterface.soc_sam_conf_1_out2,
                                             platformInterface.soc_sam_conf_1_out3,
                                             platformInterface.soc_sam_conf_1_out4,
                                             platformInterface.soc_sam_conf_1_out5,
                                             platformInterface.soc_sam_conf_1_out6,
                                             platformInterface.soc_sam_conf_1_out7,
                                             platformInterface.soc_sam_conf_1_out8,
                                             platformInterface.soc_sam_conf_1_out9,
                                             platformInterface.soc_sam_conf_1_out10,
                                             platformInterface.soc_sam_conf_1_out11,
                                             platformInterface.soc_sam_conf_1_out12

                                            ],
                                            [platformInterface.soc_sam_conf_2_out1,
                                             platformInterface.soc_sam_conf_2_out2,
                                             platformInterface.soc_sam_conf_2_out3,
                                             platformInterface.soc_sam_conf_2_out4,
                                             platformInterface.soc_sam_conf_2_out5,
                                             platformInterface.soc_sam_conf_2_out6,
                                             platformInterface.soc_sam_conf_2_out7,
                                             platformInterface.soc_sam_conf_2_out8,
                                             platformInterface.soc_sam_conf_2_out9,
                                             platformInterface.soc_sam_conf_2_out10,
                                             platformInterface.soc_sam_conf_2_out11,
                                             platformInterface.soc_sam_conf_2_out12
                                            ],
                                            samOpenLoadDiagnostic.currentText,
                                            platformInterface.soc_otpValue,
                                            platformInterface.addr_curr)

                            }
                        }

                        property var soc_crc_caption: platformInterface.soc_crc_caption.caption
                        onSoc_crc_captionChanged: {
                            enableCRCLabel.text = soc_crc_caption
                        }

                        property var soc_crc_state: platformInterface.soc_crc_state.state
                        onSoc_crc_stateChanged: {
                            if(soc_crc_state === "enabled"){
                                enableCRC.enabled = true
                                enableCRC.opacity = 1.0
                            }
                            else if (soc_crc_state === "disabled") {
                                enableCRC.enabled = false
                                enableCRC.opacity = 1.0
                            }
                            else {
                                enableCRC.enabled = false
                                enableCRC.opacity = 0.5
                            }
                        }

                        property var soc_crc_value: platformInterface.soc_crc_value.value
                        onSoc_crc_valueChanged: {
                            enableCRC.checked = soc_crc_value
                        }

                    }
                }

                Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    SGAlignedLabel {
                        id: vDDVoltageDisconnectLabel
                        target: vDDVoltageDisconnect
                        //text: "VDD Voltage\nDisconnect"
                        alignment: SGAlignedLabel.SideTopLeft
                        anchors {
                            top:parent.top
                            left: parent.left
                            verticalCenter: parent.verticalCenter
                            leftMargin: 20
                        }

                        fontSizeMultiplier: ratioCalc * 1.2
                        font.bold : true

                        SGSwitch {
                            id: vDDVoltageDisconnect
                            labelsInside: true
                            // checkedLabel: "Connect"
                            // uncheckedLabel: "Disconnect"
                            textColor: "black"              // Default: "black"
                            handleColor: "white"            // Default: "white"
                            grooveColor: "#ccc"             // Default: "#ccc"
                            grooveFillColor: "#0cf"         // Default: "#0cf"
                            fontSizeMultiplier: ratioCalc * 1.2
                            onToggled: {
                                if(checked)
                                    platformInterface.set_soc_vdd_disconnect.update("Connect")
                                else  platformInterface.set_soc_vdd_disconnect.update("Disconnect")
                            }
                        }

                        property var soc_vdd_disconnect_caption: platformInterface.soc_vdd_disconnect_caption.caption
                        onSoc_vdd_disconnect_captionChanged: {
                            vDDVoltageDisconnectLabel.text = soc_vdd_disconnect_caption
                        }

                        property var soc_vdd_disconnect_state: platformInterface.soc_vdd_disconnect_state.state
                        onSoc_vdd_disconnect_stateChanged: {
                            if(soc_vdd_disconnect_state === "enabled"){
                                vDDVoltageDisconnect.enabled = true
                                vDDVoltageDisconnect.opacity = 1.0
                            }
                            else if (soc_vdd_disconnect_state === "disabled") {
                                vDDVoltageDisconnect.enabled = false
                                vDDVoltageDisconnect.opacity = 1.0
                            }
                            else {
                                vDDVoltageDisconnect.enabled = false
                                vDDVoltageDisconnect.opacity = 0.5
                            }
                        }

                        property var soc_vdd_disconnect_values: platformInterface.soc_vdd_disconnect_values.values
                        onSoc_vdd_disconnect_valuesChanged: {
                            vDDVoltageDisconnect.checkedLabel = soc_vdd_disconnect_values[0]
                            vDDVoltageDisconnect.uncheckedLabel = soc_vdd_disconnect_values[1]
                        }

                        property var soc_vdd_disconnect_value: platformInterface.soc_vdd_disconnect_value.value
                        onSoc_vdd_disconnect_valueChanged:{
                            if(soc_vdd_disconnect_value === "Connect"){
                                vDDVoltageDisconnect.checked = true
                            }
                            else  vDDVoltageDisconnect.checked = false
                        }


                    }
                }

                Rectangle{
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    SGAlignedLabel {
                        id: samConfigLabel
                        target: samConfig
                       // text: "SAM\n(Configuration)"
                        alignment: SGAlignedLabel.SideTopLeft
                        anchors {
                            top:parent.top
                            left: parent.left
                            verticalCenter: parent.verticalCenter
                            leftMargin: 20
                        }

                        fontSizeMultiplier: ratioCalc * 1.2
                        font.bold : true

                        SGSwitch {
                            id: samConfig
                            labelsInside: true
                            //checkedLabel: "SAM1"
                            //uncheckedLabel: "SAM2"
                            textColor: "black"              // Default: "black"
                            handleColor: "white"            // Default: "white"
                            grooveColor: "#ccc"             // Default: "#ccc"
                            grooveFillColor: "#0cf"         // Default: "#0cf"
                            fontSizeMultiplier: ratioCalc * 1.2
                            onToggled: {
                                if(checked)
                                    platformInterface.set_soc_conf.update("SAM1")
                                else
                                    platformInterface.set_soc_conf.update("SAM2")

                            }

                            property var soc_conf_caption: platformInterface.soc_conf_caption.caption
                            onSoc_conf_captionChanged: {
                                samConfigLabel.text = soc_conf_caption
                            }

                            property var soc_conf_state: platformInterface.soc_conf_state.state
                            onSoc_conf_stateChanged: {
                                if(soc_conf_state === "enabled"){
                                    samConfig.enabled = true
                                    samConfig.opacity = 1.0
                                }
                                else if (soc_conf_state === "disabled") {
                                    samConfig.enabled = false
                                    samConfig.opacity = 1.0
                                }
                                else {
                                    samConfig.enabled = false
                                    samConfig.opacity = 0.5
                                }
                            }

                            property var soc_conf_values: platformInterface.soc_conf_values.values
                            onSoc_conf_valuesChanged: {
                                samConfig.checkedLabel = soc_conf_values[0]
                                samConfig.uncheckedLabel = soc_conf_values[1]
                            }

                            property var soc_conf_value: platformInterface.soc_conf_value.value
                            onSoc_conf_valueChanged:{
                                if(soc_conf_value === "SAM1"){
                                    samConfig.checked = true
                                }
                                else  samConfig.checked = false
                            }



                        }
                    }
                }

                Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    SGAlignedLabel {
                        id: i2cStandaloneLabel
                        target: i2cStandalone
                        // text: "I2C/Standalone\n(I2CFLAG)"
                        alignment: SGAlignedLabel.SideTopLeft
                        anchors {
                            top:parent.top
                            left: parent.left
                            verticalCenter: parent.verticalCenter
                            leftMargin: 20
                        }

                        fontSizeMultiplier: ratioCalc * 1.2
                        font.bold : true

                        SGSwitch {
                            id: i2cStandalone
                            labelsInside: true
                            //                            checkedLabel: "on"
                            //                            uncheckedLabel: "off"
                            textColor: "black"              // Default: "black"
                            handleColor: "white"            // Default: "white"
                            grooveColor: "#ccc"             // Default: "#ccc"
                            grooveFillColor: "#0cf"         // Default: "#0cf"
                            fontSizeMultiplier: ratioCalc * 1.2
                            onToggled: {
                                if(checked)
                                    platformInterface.set_soc_mode.update("I2C")
                                else platformInterface.set_soc_mode.update("SAM")
                            }
                        }

                        property var soc_mode_caption: platformInterface.soc_mode_caption.caption
                        onSoc_mode_captionChanged: {
                            i2cStandaloneLabel.text = soc_mode_caption
                        }

                        property var soc_mode_state: platformInterface.soc_mode_state.state
                        onSoc_mode_stateChanged: {
                            if(soc_mode_state === "enabled"){
                                i2cStandalone.enabled = true
                                i2cStandalone.opacity = 1.0
                            }
                            else if (soc_mode_state === "disabled") {
                                i2cStandalone.enabled = false
                                i2cStandalone.opacity = 1.0
                            }
                            else {
                                i2cStandalone.enabled = false
                                i2cStandalone.opacity = 0.5
                            }
                        }

                        property var soc_mode_values: platformInterface.soc_mode_values.values
                        onSoc_mode_valuesChanged: {
                            i2cStandalone.checkedLabel = soc_mode_values[0]
                            i2cStandalone.uncheckedLabel = soc_mode_values[1]
                        }

                        property var soc_mode_value: platformInterface.soc_mode_value.value
                        onSoc_mode_valueChanged:{
                            if(soc_mode_value === "I2C"){
                                i2cStandalone.checked = true
                            }
                            else  i2cStandalone.checked = false
                        }


                    }
                }
                Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    SGAlignedLabel {
                        id: samOpenLoadLabel
                        target: samOpenLoadDiagnostic
                        //text: "SAM Open Load\nDiagnostic"
                        alignment: SGAlignedLabel.SideTopLeft
                        anchors {
                            top:parent.top
                            left: parent.left
                            verticalCenter: parent.verticalCenter
                            leftMargin: 20
                        }
                        fontSizeMultiplier: ratioCalc * 1.2
                        font.bold : true

                        SGComboBox {
                            id: samOpenLoadDiagnostic
                            fontSizeMultiplier: ratioCalc
                            //model: ["No Diagnostic", "Auto Retry", "Detect Only", "No Regulation Change"]
                            onActivated: {
                                platformInterface.set_soc_write.update(
                                            platformInterface.soc_otpValue,
                                            [platformInterface.soc_sam_conf_1_out1,
                                             platformInterface.soc_sam_conf_1_out2,
                                             platformInterface.soc_sam_conf_1_out3,
                                             platformInterface.soc_sam_conf_1_out4,
                                             platformInterface.soc_sam_conf_1_out5,
                                             platformInterface.soc_sam_conf_1_out6,
                                             platformInterface.soc_sam_conf_1_out7,
                                             platformInterface.soc_sam_conf_1_out8,
                                             platformInterface.soc_sam_conf_1_out9,
                                             platformInterface.soc_sam_conf_1_out10,
                                             platformInterface.soc_sam_conf_1_out11,
                                             platformInterface.soc_sam_conf_1_out12
                                            ],
                                            [platformInterface.soc_sam_conf_2_out1,
                                             platformInterface.soc_sam_conf_2_out2,
                                             platformInterface.soc_sam_conf_2_out3,
                                             platformInterface.soc_sam_conf_2_out4,
                                             platformInterface.soc_sam_conf_2_out5,
                                             platformInterface.soc_sam_conf_2_out6,
                                             platformInterface.soc_sam_conf_2_out7,
                                             platformInterface.soc_sam_conf_2_out8,
                                             platformInterface.soc_sam_conf_2_out9,
                                             platformInterface.soc_sam_conf_2_out10,
                                             platformInterface.soc_sam_conf_2_out11
                                            ],
                                            samOpenLoadDiagnostic.currentText,
                                            platformInterface.soc_otpValue,
                                            platformInterface.addr_curr)
                            }
                        }

                        property var soc_open_load_diagnostic_caption: platformInterface.soc_open_load_diagnostic_caption.caption
                        onSoc_open_load_diagnostic_captionChanged: {
                            samOpenLoadLabel.text = soc_open_load_diagnostic_caption
                        }

                        property var soc_open_load_diagnostic_state: platformInterface.soc_open_load_diagnostic_state.state
                        onSoc_open_load_diagnostic_stateChanged: {
                            if(soc_open_load_diagnostic_state === "enabled"){
                                samOpenLoadDiagnostic.enabled = true
                                samOpenLoadDiagnostic.opacity = 1.0
                            }
                            else if (soc_open_load_diagnostic_state === "disabled") {
                                samOpenLoadDiagnostic.enabled = false
                                samOpenLoadDiagnostic.opacity = 1.0
                            }
                            else {
                                samOpenLoadDiagnostic.enabled = false
                                samOpenLoadDiagnostic.opacity = 0.5
                            }
                        }

                        property var soc_open_load_diagnostic_values: platformInterface.soc_open_load_diagnostic_values.values
                        onSoc_open_load_diagnostic_valuesChanged: {
                            samOpenLoadDiagnostic.model = soc_open_load_diagnostic_values
                        }

                        property var soc_open_load_diagnostic_value: platformInterface.soc_open_load_diagnostic_value.value
                        onSoc_open_load_diagnostic_valueChanged: {
                            for(var a = 0; a < samOpenLoadDiagnostic.model.length; ++a) {
                                if(soc_open_load_diagnostic_value === samOpenLoadDiagnostic.model[a].toString()){
                                    samOpenLoadDiagnostic.currentIndex = a
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
            // color: "green"
            RowLayout{
                anchors.fill: parent

                Rectangle {
                    Layout.preferredWidth: parent.width/4
                    Layout.fillHeight: true

                    SGText {
                        //text: "<b>" + qsTr("SAM_CONF_1") + "</b>"
                        fontSizeMultiplier: ratioCalc * 1.2
                        font.bold: true
                        anchors.verticalCenter: parent.verticalCenter
                        property var soc_sam_conf_1_caption: platformInterface.soc_sam_conf_1_caption.caption
                        onSoc_sam_conf_1_captionChanged: {
                            text = soc_sam_conf_1_caption
                        }
                    }


                }

                Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    SGSwitch {
                        id: out1
                        labelsInside: true
                        checkedLabel: "On"
                        uncheckedLabel: "Off"
                        fontSizeMultiplier: ratioCalc
                        checked: false
                        anchors.verticalCenter: parent.verticalCenter

                        onToggled: {
                            platformInterface.soc_sam_conf_1_out1 = checked
                            platformInterface.set_soc_write.update(
                                        platformInterface.soc_otpValue,
                                        [platformInterface.soc_sam_conf_1_out1,
                                         platformInterface.soc_sam_conf_1_out2,
                                         platformInterface.soc_sam_conf_1_out3,
                                         platformInterface.soc_sam_conf_1_out4,
                                         platformInterface.soc_sam_conf_1_out5,
                                         platformInterface.soc_sam_conf_1_out6,
                                         platformInterface.soc_sam_conf_1_out7,
                                         platformInterface.soc_sam_conf_1_out8,
                                         platformInterface.soc_sam_conf_1_out9,
                                         platformInterface.soc_sam_conf_1_out10,
                                         platformInterface.soc_sam_conf_1_out11,
                                         platformInterface.soc_sam_conf_1_out12

                                        ],
                                        [platformInterface.soc_sam_conf_2_out1,
                                         platformInterface.soc_sam_conf_2_out2,
                                         platformInterface.soc_sam_conf_2_out3,
                                         platformInterface.soc_sam_conf_2_out4,
                                         platformInterface.soc_sam_conf_2_out5,
                                         platformInterface.soc_sam_conf_2_out6,
                                         platformInterface.soc_sam_conf_2_out7,
                                         platformInterface.soc_sam_conf_2_out8,
                                         platformInterface.soc_sam_conf_2_out9,
                                         platformInterface.soc_sam_conf_2_out10,
                                         platformInterface.soc_sam_conf_2_out11,
                                         platformInterface.soc_sam_conf_2_out12
                                        ],
                                        samOpenLoadDiagnostic.currentText,
                                        platformInterface.soc_otpValue,
                                        platformInterface.addr_curr)
                        }

                    }
                }
                Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    SGSwitch {
                        id: out2
                        labelsInside: true
                        checkedLabel: "On"
                        uncheckedLabel: "Off"
                        fontSizeMultiplier: ratioCalc
                        checked: false
                        anchors.verticalCenter: parent.verticalCenter
                        onToggled: {
                            platformInterface.soc_sam_conf_1_out2 = checked
                            platformInterface.set_soc_write.update(
                                        platformInterface.soc_otpValue,
                                        [platformInterface.soc_sam_conf_1_out1,
                                         platformInterface.soc_sam_conf_1_out2,
                                         platformInterface.soc_sam_conf_1_out3,
                                         platformInterface.soc_sam_conf_1_out4,
                                         platformInterface.soc_sam_conf_1_out5,
                                         platformInterface.soc_sam_conf_1_out6,
                                         platformInterface.soc_sam_conf_1_out7,
                                         platformInterface.soc_sam_conf_1_out8,
                                         platformInterface.soc_sam_conf_1_out9,
                                         platformInterface.soc_sam_conf_1_out10,
                                         platformInterface.soc_sam_conf_1_out11,
                                         platformInterface.soc_sam_conf_1_out12

                                        ],
                                        [platformInterface.soc_sam_conf_2_out1,
                                         platformInterface.soc_sam_conf_2_out2,
                                         platformInterface.soc_sam_conf_2_out3,
                                         platformInterface.soc_sam_conf_2_out4,
                                         platformInterface.soc_sam_conf_2_out5,
                                         platformInterface.soc_sam_conf_2_out6,
                                         platformInterface.soc_sam_conf_2_out7,
                                         platformInterface.soc_sam_conf_2_out8,
                                         platformInterface.soc_sam_conf_2_out9,
                                         platformInterface.soc_sam_conf_2_out10,
                                         platformInterface.soc_sam_conf_2_out11,
                                         platformInterface.soc_sam_conf_2_out12
                                        ],
                                        samOpenLoadDiagnostic.currentText,
                                        platformInterface.soc_otpValue,
                                        platformInterface.addr_curr)
                        }

                    }
                }

                Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    SGSwitch {
                        id: out3
                        labelsInside: true
                        checkedLabel: "On"
                        uncheckedLabel: "Off"
                        fontSizeMultiplier: ratioCalc
                        checked: false
                        anchors.verticalCenter: parent.verticalCenter
                        onToggled: {
                            platformInterface.soc_sam_conf_1_out3 = checked
                            platformInterface.set_soc_write.update(
                                        platformInterface.soc_otpValue,
                                        [platformInterface.soc_sam_conf_1_out1,
                                         platformInterface.soc_sam_conf_1_out2,
                                         platformInterface.soc_sam_conf_1_out3,
                                         platformInterface.soc_sam_conf_1_out4,
                                         platformInterface.soc_sam_conf_1_out5,
                                         platformInterface.soc_sam_conf_1_out6,
                                         platformInterface.soc_sam_conf_1_out7,
                                         platformInterface.soc_sam_conf_1_out8,
                                         platformInterface.soc_sam_conf_1_out9,
                                         platformInterface.soc_sam_conf_1_out10,
                                         platformInterface.soc_sam_conf_1_out11,
                                         platformInterface.soc_sam_conf_1_out12

                                        ],
                                        [platformInterface.soc_sam_conf_2_out1,
                                         platformInterface.soc_sam_conf_2_out2,
                                         platformInterface.soc_sam_conf_2_out3,
                                         platformInterface.soc_sam_conf_2_out4,
                                         platformInterface.soc_sam_conf_2_out5,
                                         platformInterface.soc_sam_conf_2_out6,
                                         platformInterface.soc_sam_conf_2_out7,
                                         platformInterface.soc_sam_conf_2_out8,
                                         platformInterface.soc_sam_conf_2_out9,
                                         platformInterface.soc_sam_conf_2_out10,
                                         platformInterface.soc_sam_conf_2_out11,
                                         platformInterface.soc_sam_conf_2_out12
                                        ],
                                        samOpenLoadDiagnostic.currentText,
                                        platformInterface.soc_otpValue,
                                        platformInterface.addr_curr)
                        }

                    }
                }

                Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    SGSwitch {
                        id: out4
                        labelsInside: true
                        checkedLabel: "On"
                        uncheckedLabel: "Off"
                        fontSizeMultiplier: ratioCalc
                        checked: false
                        anchors.verticalCenter: parent.verticalCenter
                        onToggled: {
                            platformInterface.soc_sam_conf_1_out4 = checked
                            platformInterface.set_soc_write.update(
                                        platformInterface.soc_otpValue,
                                        [platformInterface.soc_sam_conf_1_out1,
                                         platformInterface.soc_sam_conf_1_out2,
                                         platformInterface.soc_sam_conf_1_out3,
                                         platformInterface.soc_sam_conf_1_out4,
                                         platformInterface.soc_sam_conf_1_out5,
                                         platformInterface.soc_sam_conf_1_out6,
                                         platformInterface.soc_sam_conf_1_out7,
                                         platformInterface.soc_sam_conf_1_out8,
                                         platformInterface.soc_sam_conf_1_out9,
                                         platformInterface.soc_sam_conf_1_out10,
                                         platformInterface.soc_sam_conf_1_out11,
                                         platformInterface.soc_sam_conf_1_out12

                                        ],
                                        [platformInterface.soc_sam_conf_2_out1,
                                         platformInterface.soc_sam_conf_2_out2,
                                         platformInterface.soc_sam_conf_2_out3,
                                         platformInterface.soc_sam_conf_2_out4,
                                         platformInterface.soc_sam_conf_2_out5,
                                         platformInterface.soc_sam_conf_2_out6,
                                         platformInterface.soc_sam_conf_2_out7,
                                         platformInterface.soc_sam_conf_2_out8,
                                         platformInterface.soc_sam_conf_2_out9,
                                         platformInterface.soc_sam_conf_2_out10,
                                         platformInterface.soc_sam_conf_2_out11,
                                         platformInterface.soc_sam_conf_2_out12
                                        ],
                                        samOpenLoadDiagnostic.currentText,
                                        platformInterface.soc_otpValue,
                                        platformInterface.addr_curr)
                        }

                    }
                }

                Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    SGSwitch {
                        id: out5
                        labelsInside: true
                        checkedLabel: "On"
                        uncheckedLabel: "Off"
                        fontSizeMultiplier: ratioCalc
                        checked: false
                        anchors.verticalCenter: parent.verticalCenter
                        onToggled: {
                            platformInterface.soc_sam_conf_1_out5 = checked
                            platformInterface.set_soc_write.update(
                                        platformInterface.soc_otpValue,
                                        [platformInterface.soc_sam_conf_1_out1,
                                         platformInterface.soc_sam_conf_1_out2,
                                         platformInterface.soc_sam_conf_1_out3,
                                         platformInterface.soc_sam_conf_1_out4,
                                         platformInterface.soc_sam_conf_1_out5,
                                         platformInterface.soc_sam_conf_1_out6,
                                         platformInterface.soc_sam_conf_1_out7,
                                         platformInterface.soc_sam_conf_1_out8,
                                         platformInterface.soc_sam_conf_1_out9,
                                         platformInterface.soc_sam_conf_1_out10,
                                         platformInterface.soc_sam_conf_1_out11,
                                         platformInterface.soc_sam_conf_1_out12

                                        ],
                                        [platformInterface.soc_sam_conf_2_out1,
                                         platformInterface.soc_sam_conf_2_out2,
                                         platformInterface.soc_sam_conf_2_out3,
                                         platformInterface.soc_sam_conf_2_out4,
                                         platformInterface.soc_sam_conf_2_out5,
                                         platformInterface.soc_sam_conf_2_out6,
                                         platformInterface.soc_sam_conf_2_out7,
                                         platformInterface.soc_sam_conf_2_out8,
                                         platformInterface.soc_sam_conf_2_out9,
                                         platformInterface.soc_sam_conf_2_out10,
                                         platformInterface.soc_sam_conf_2_out11,
                                         platformInterface.soc_sam_conf_2_out12
                                        ],
                                        samOpenLoadDiagnostic.currentText,
                                        platformInterface.soc_otpValue,
                                        platformInterface.addr_curr)
                        }

                    }
                }

                Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    SGSwitch {
                        id: out6
                        labelsInside: true
                        checkedLabel: "On"
                        uncheckedLabel: "Off"
                        fontSizeMultiplier: ratioCalc
                        checked: false
                        anchors.verticalCenter: parent.verticalCenter
                        onToggled: {
                            platformInterface.soc_sam_conf_1_out6 = checked
                            platformInterface.set_soc_write.update(
                                        platformInterface.soc_otpValue,
                                        [platformInterface.soc_sam_conf_1_out1,
                                         platformInterface.soc_sam_conf_1_out2,
                                         platformInterface.soc_sam_conf_1_out3,
                                         platformInterface.soc_sam_conf_1_out4,
                                         platformInterface.soc_sam_conf_1_out5,
                                         platformInterface.soc_sam_conf_1_out6,
                                         platformInterface.soc_sam_conf_1_out7,
                                         platformInterface.soc_sam_conf_1_out8,
                                         platformInterface.soc_sam_conf_1_out9,
                                         platformInterface.soc_sam_conf_1_out10,
                                         platformInterface.soc_sam_conf_1_out11,
                                         platformInterface.soc_sam_conf_1_out12

                                        ],
                                        [platformInterface.soc_sam_conf_2_out1,
                                         platformInterface.soc_sam_conf_2_out2,
                                         platformInterface.soc_sam_conf_2_out3,
                                         platformInterface.soc_sam_conf_2_out4,
                                         platformInterface.soc_sam_conf_2_out5,
                                         platformInterface.soc_sam_conf_2_out6,
                                         platformInterface.soc_sam_conf_2_out7,
                                         platformInterface.soc_sam_conf_2_out8,
                                         platformInterface.soc_sam_conf_2_out9,
                                         platformInterface.soc_sam_conf_2_out10,
                                         platformInterface.soc_sam_conf_2_out11,
                                         platformInterface.soc_sam_conf_2_out12
                                        ],
                                        samOpenLoadDiagnostic.currentText,
                                        platformInterface.soc_otpValue,
                                        platformInterface.addr_curr)
                        }

                    }
                }

                Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    SGSwitch {
                        id: out7
                        labelsInside: true
                        checkedLabel: "On"
                        uncheckedLabel: "Off"
                        fontSizeMultiplier: ratioCalc
                        checked: false
                        anchors.verticalCenter: parent.verticalCenter
                        onToggled: {
                            platformInterface.soc_sam_conf_1_out7 = checked
                            platformInterface.set_soc_write.update(
                                        platformInterface.soc_otpValue,
                                        [platformInterface.soc_sam_conf_1_out1,
                                         platformInterface.soc_sam_conf_1_out2,
                                         platformInterface.soc_sam_conf_1_out3,
                                         platformInterface.soc_sam_conf_1_out4,
                                         platformInterface.soc_sam_conf_1_out5,
                                         platformInterface.soc_sam_conf_1_out6,
                                         platformInterface.soc_sam_conf_1_out7,
                                         platformInterface.soc_sam_conf_1_out8,
                                         platformInterface.soc_sam_conf_1_out9,
                                         platformInterface.soc_sam_conf_1_out10,
                                         platformInterface.soc_sam_conf_1_out11,
                                         platformInterface.soc_sam_conf_1_out12

                                        ],
                                        [platformInterface.soc_sam_conf_2_out1,
                                         platformInterface.soc_sam_conf_2_out2,
                                         platformInterface.soc_sam_conf_2_out3,
                                         platformInterface.soc_sam_conf_2_out4,
                                         platformInterface.soc_sam_conf_2_out5,
                                         platformInterface.soc_sam_conf_2_out6,
                                         platformInterface.soc_sam_conf_2_out7,
                                         platformInterface.soc_sam_conf_2_out8,
                                         platformInterface.soc_sam_conf_2_out9,
                                         platformInterface.soc_sam_conf_2_out10,
                                         platformInterface.soc_sam_conf_2_out11,
                                         platformInterface.soc_sam_conf_2_out12
                                        ],
                                        samOpenLoadDiagnostic.currentText,
                                        platformInterface.soc_otpValue,
                                        platformInterface.addr_curr)
                        }

                    }
                }

                Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    SGSwitch {
                        id: out8
                        labelsInside: true
                        checkedLabel: "On"
                        uncheckedLabel: "Off"
                        fontSizeMultiplier: ratioCalc
                        checked: false
                        anchors.verticalCenter: parent.verticalCenter
                        onToggled: {
                            platformInterface.soc_sam_conf_1_out8 = checked
                            platformInterface.set_soc_write.update(
                                        platformInterface.soc_otpValue,
                                        [platformInterface.soc_sam_conf_1_out1,
                                         platformInterface.soc_sam_conf_1_out2,
                                         platformInterface.soc_sam_conf_1_out3,
                                         platformInterface.soc_sam_conf_1_out4,
                                         platformInterface.soc_sam_conf_1_out5,
                                         platformInterface.soc_sam_conf_1_out6,
                                         platformInterface.soc_sam_conf_1_out7,
                                         platformInterface.soc_sam_conf_1_out8,
                                         platformInterface.soc_sam_conf_1_out9,
                                         platformInterface.soc_sam_conf_1_out10,
                                         platformInterface.soc_sam_conf_1_out11,
                                         platformInterface.soc_sam_conf_1_out12

                                        ],
                                        [platformInterface.soc_sam_conf_2_out1,
                                         platformInterface.soc_sam_conf_2_out2,
                                         platformInterface.soc_sam_conf_2_out3,
                                         platformInterface.soc_sam_conf_2_out4,
                                         platformInterface.soc_sam_conf_2_out5,
                                         platformInterface.soc_sam_conf_2_out6,
                                         platformInterface.soc_sam_conf_2_out7,
                                         platformInterface.soc_sam_conf_2_out8,
                                         platformInterface.soc_sam_conf_2_out9,
                                         platformInterface.soc_sam_conf_2_out10,
                                         platformInterface.soc_sam_conf_2_out11,
                                         platformInterface.soc_sam_conf_2_out12
                                        ],
                                        samOpenLoadDiagnostic.currentText,
                                        platformInterface.soc_otpValue,
                                        platformInterface.addr_curr)
                        }

                    }
                }

                Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    SGSwitch {
                        id: out9
                        labelsInside: true
                        checkedLabel: "On"
                        uncheckedLabel: "Off"
                        fontSizeMultiplier: ratioCalc
                        checked: false
                        anchors.verticalCenter: parent.verticalCenter
                        onToggled: {
                            platformInterface.soc_sam_conf_1_out9 = checked
                            platformInterface.set_soc_write.update(
                                        platformInterface.soc_otpValue,
                                        [platformInterface.soc_sam_conf_1_out1,
                                         platformInterface.soc_sam_conf_1_out2,
                                         platformInterface.soc_sam_conf_1_out3,
                                         platformInterface.soc_sam_conf_1_out4,
                                         platformInterface.soc_sam_conf_1_out5,
                                         platformInterface.soc_sam_conf_1_out6,
                                         platformInterface.soc_sam_conf_1_out7,
                                         platformInterface.soc_sam_conf_1_out8,
                                         platformInterface.soc_sam_conf_1_out9,
                                         platformInterface.soc_sam_conf_1_out10,
                                         platformInterface.soc_sam_conf_1_out11,
                                         platformInterface.soc_sam_conf_1_out12

                                        ],
                                        [platformInterface.soc_sam_conf_2_out1,
                                         platformInterface.soc_sam_conf_2_out2,
                                         platformInterface.soc_sam_conf_2_out3,
                                         platformInterface.soc_sam_conf_2_out4,
                                         platformInterface.soc_sam_conf_2_out5,
                                         platformInterface.soc_sam_conf_2_out6,
                                         platformInterface.soc_sam_conf_2_out7,
                                         platformInterface.soc_sam_conf_2_out8,
                                         platformInterface.soc_sam_conf_2_out9,
                                         platformInterface.soc_sam_conf_2_out10,
                                         platformInterface.soc_sam_conf_2_out11,
                                         platformInterface.soc_sam_conf_2_out12
                                        ],
                                        samOpenLoadDiagnostic.currentText,
                                        platformInterface.soc_otpValue,
                                        platformInterface.addr_curr)
                        }

                    }
                }

                Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    SGSwitch {
                        id: out10
                        labelsInside: true
                        checkedLabel: "On"
                        uncheckedLabel: "Off"
                        fontSizeMultiplier: ratioCalc
                        checked: false
                        anchors.verticalCenter: parent.verticalCenter
                        onToggled: {
                            platformInterface.soc_sam_conf_1_out10 = checked
                            platformInterface.set_soc_write.update(
                                        platformInterface.soc_otpValue,
                                        [platformInterface.soc_sam_conf_1_out1,
                                         platformInterface.soc_sam_conf_1_out2,
                                         platformInterface.soc_sam_conf_1_out3,
                                         platformInterface.soc_sam_conf_1_out4,
                                         platformInterface.soc_sam_conf_1_out5,
                                         platformInterface.soc_sam_conf_1_out6,
                                         platformInterface.soc_sam_conf_1_out7,
                                         platformInterface.soc_sam_conf_1_out8,
                                         platformInterface.soc_sam_conf_1_out9,
                                         platformInterface.soc_sam_conf_1_out10,
                                         platformInterface.soc_sam_conf_1_out11,
                                         platformInterface.soc_sam_conf_1_out12

                                        ],
                                        [platformInterface.soc_sam_conf_2_out1,
                                         platformInterface.soc_sam_conf_2_out2,
                                         platformInterface.soc_sam_conf_2_out3,
                                         platformInterface.soc_sam_conf_2_out4,
                                         platformInterface.soc_sam_conf_2_out5,
                                         platformInterface.soc_sam_conf_2_out6,
                                         platformInterface.soc_sam_conf_2_out7,
                                         platformInterface.soc_sam_conf_2_out8,
                                         platformInterface.soc_sam_conf_2_out9,
                                         platformInterface.soc_sam_conf_2_out10,
                                         platformInterface.soc_sam_conf_2_out11,
                                         platformInterface.soc_sam_conf_2_out12
                                        ],
                                        samOpenLoadDiagnostic.currentText,
                                        platformInterface.soc_otpValue,
                                        platformInterface.addr_curr)
                        }

                    }
                }

                Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    SGSwitch {
                        id: out11
                        labelsInside: true
                        checkedLabel: "On"
                        uncheckedLabel: "Off"
                        fontSizeMultiplier: ratioCalc
                        checked: false
                        anchors.verticalCenter: parent.verticalCenter
                        onToggled: {
                            platformInterface.soc_sam_conf_1_out11 = checked
                            platformInterface.set_soc_write.update(
                                        platformInterface.soc_otpValue,
                                        [platformInterface.soc_sam_conf_1_out1,
                                         platformInterface.soc_sam_conf_1_out2,
                                         platformInterface.soc_sam_conf_1_out3,
                                         platformInterface.soc_sam_conf_1_out4,
                                         platformInterface.soc_sam_conf_1_out5,
                                         platformInterface.soc_sam_conf_1_out6,
                                         platformInterface.soc_sam_conf_1_out7,
                                         platformInterface.soc_sam_conf_1_out8,
                                         platformInterface.soc_sam_conf_1_out9,
                                         platformInterface.soc_sam_conf_1_out10,
                                         platformInterface.soc_sam_conf_1_out11,
                                         platformInterface.soc_sam_conf_1_out12

                                        ],
                                        [platformInterface.soc_sam_conf_2_out1,
                                         platformInterface.soc_sam_conf_2_out2,
                                         platformInterface.soc_sam_conf_2_out3,
                                         platformInterface.soc_sam_conf_2_out4,
                                         platformInterface.soc_sam_conf_2_out5,
                                         platformInterface.soc_sam_conf_2_out6,
                                         platformInterface.soc_sam_conf_2_out7,
                                         platformInterface.soc_sam_conf_2_out8,
                                         platformInterface.soc_sam_conf_2_out9,
                                         platformInterface.soc_sam_conf_2_out10,
                                         platformInterface.soc_sam_conf_2_out11,
                                         platformInterface.soc_sam_conf_2_out12
                                        ],
                                        samOpenLoadDiagnostic.currentText,
                                        platformInterface.soc_otpValue,
                                        platformInterface.addr_curr)
                        }

                    }
                }
                Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    SGSwitch {
                        id: out12
                        labelsInside: true
                        checkedLabel: "On"
                        uncheckedLabel: "Off"
                        fontSizeMultiplier: ratioCalc
                        checked: false
                        anchors.verticalCenter: parent.verticalCenter
                        onToggled: {
                            platformInterface.soc_sam_conf_1_out12 = checked
                            platformInterface.set_soc_write.update(
                                        platformInterface.soc_otpValue,
                                        [platformInterface.soc_sam_conf_1_out1,
                                         platformInterface.soc_sam_conf_1_out2,
                                         platformInterface.soc_sam_conf_1_out3,
                                         platformInterface.soc_sam_conf_1_out4,
                                         platformInterface.soc_sam_conf_1_out5,
                                         platformInterface.soc_sam_conf_1_out6,
                                         platformInterface.soc_sam_conf_1_out7,
                                         platformInterface.soc_sam_conf_1_out8,
                                         platformInterface.soc_sam_conf_1_out9,
                                         platformInterface.soc_sam_conf_1_out10,
                                         platformInterface.soc_sam_conf_1_out11,
                                         platformInterface.soc_sam_conf_1_out12

                                        ],
                                        [platformInterface.soc_sam_conf_2_out1,
                                         platformInterface.soc_sam_conf_2_out2,
                                         platformInterface.soc_sam_conf_2_out3,
                                         platformInterface.soc_sam_conf_2_out4,
                                         platformInterface.soc_sam_conf_2_out5,
                                         platformInterface.soc_sam_conf_2_out6,
                                         platformInterface.soc_sam_conf_2_out7,
                                         platformInterface.soc_sam_conf_2_out8,
                                         platformInterface.soc_sam_conf_2_out9,
                                         platformInterface.soc_sam_conf_2_out10,
                                         platformInterface.soc_sam_conf_2_out11,
                                         platformInterface.soc_sam_conf_2_out12
                                        ],
                                        samOpenLoadDiagnostic.currentText,
                                        platformInterface.soc_otpValue,
                                        platformInterface.addr_curr)
                        }

                    }
                }
            }
        }
        Rectangle {
            Layout.fillHeight: true
            Layout.fillWidth: true

            RowLayout{
                anchors.fill: parent

                Rectangle {
                    Layout.preferredWidth: parent.width/4
                    Layout.fillHeight: true

                    SGText {
                        // text: "<b>" + qsTr("SAM_CONF_2") + "</b>"
                        fontSizeMultiplier: ratioCalc * 1.2
                        anchors.verticalCenter: parent.verticalCenter
                        font.bold: true

                        property var soc_sam_conf_2_caption: platformInterface.soc_sam_conf_2_caption.caption
                        onSoc_sam_conf_2_captionChanged: {
                            text = soc_sam_conf_2_caption
                        }
                    }


                }

                Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    SGSwitch {
                        id: samOut1
                        labelsInside: true
                        checkedLabel: "On"
                        uncheckedLabel: "Off"
                        fontSizeMultiplier: ratioCalc
                        checked: false
                        anchors.verticalCenter: parent.verticalCenter
                        onToggled: {
                            platformInterface.soc_sam_conf_2_out1 = checked
                            platformInterface.set_soc_write.update(
                                        platformInterface.soc_otpValue,
                                        [platformInterface.soc_sam_conf_1_out1,
                                         platformInterface.soc_sam_conf_1_out2,
                                         platformInterface.soc_sam_conf_1_out3,
                                         platformInterface.soc_sam_conf_1_out4,
                                         platformInterface.soc_sam_conf_1_out5,
                                         platformInterface.soc_sam_conf_1_out6,
                                         platformInterface.soc_sam_conf_1_out7,
                                         platformInterface.soc_sam_conf_1_out8,
                                         platformInterface.soc_sam_conf_1_out9,
                                         platformInterface.soc_sam_conf_1_out10,
                                         platformInterface.soc_sam_conf_1_out11,
                                         platformInterface.soc_sam_conf_1_out12

                                        ],
                                        [platformInterface.soc_sam_conf_2_out1,
                                         platformInterface.soc_sam_conf_2_out2,
                                         platformInterface.soc_sam_conf_2_out3,
                                         platformInterface.soc_sam_conf_2_out4,
                                         platformInterface.soc_sam_conf_2_out5,
                                         platformInterface.soc_sam_conf_2_out6,
                                         platformInterface.soc_sam_conf_2_out7,
                                         platformInterface.soc_sam_conf_2_out8,
                                         platformInterface.soc_sam_conf_2_out9,
                                         platformInterface.soc_sam_conf_2_out10,
                                         platformInterface.soc_sam_conf_2_out11,
                                         platformInterface.soc_sam_conf_2_out12
                                        ],
                                        samOpenLoadDiagnostic.currentText,
                                        platformInterface.soc_otpValue,
                                        platformInterface.addr_curr)
                        }
                    }
                }
                Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    SGSwitch {
                        id: samOut2
                        labelsInside: true
                        checkedLabel: "On"
                        uncheckedLabel: "Off"
                        fontSizeMultiplier: ratioCalc
                        checked: false
                        anchors.verticalCenter: parent.verticalCenter
                        onToggled: {
                            platformInterface.soc_sam_conf_2_out2 = checked
                            platformInterface.set_soc_write.update(
                                        platformInterface.soc_otpValue,
                                        [platformInterface.soc_sam_conf_1_out1,
                                         platformInterface.soc_sam_conf_1_out2,
                                         platformInterface.soc_sam_conf_1_out3,
                                         platformInterface.soc_sam_conf_1_out4,
                                         platformInterface.soc_sam_conf_1_out5,
                                         platformInterface.soc_sam_conf_1_out6,
                                         platformInterface.soc_sam_conf_1_out7,
                                         platformInterface.soc_sam_conf_1_out8,
                                         platformInterface.soc_sam_conf_1_out9,
                                         platformInterface.soc_sam_conf_1_out10,
                                         platformInterface.soc_sam_conf_1_out11,
                                         platformInterface.soc_sam_conf_1_out12

                                        ],
                                        [platformInterface.soc_sam_conf_2_out1,
                                         platformInterface.soc_sam_conf_2_out2,
                                         platformInterface.soc_sam_conf_2_out3,
                                         platformInterface.soc_sam_conf_2_out4,
                                         platformInterface.soc_sam_conf_2_out5,
                                         platformInterface.soc_sam_conf_2_out6,
                                         platformInterface.soc_sam_conf_2_out7,
                                         platformInterface.soc_sam_conf_2_out8,
                                         platformInterface.soc_sam_conf_2_out9,
                                         platformInterface.soc_sam_conf_2_out10,
                                         platformInterface.soc_sam_conf_2_out11,
                                         platformInterface.soc_sam_conf_2_out12
                                        ],
                                        samOpenLoadDiagnostic.currentText,
                                        platformInterface.soc_otpValue,
                                        platformInterface.addr_curr)
                        }
                    }
                }

                Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    SGSwitch {
                        id: samOut3
                        labelsInside: true
                        checkedLabel: "On"
                        uncheckedLabel: "Off"
                        fontSizeMultiplier: ratioCalc
                        checked: false
                        anchors.verticalCenter: parent.verticalCenter
                        onToggled: {
                            platformInterface.soc_sam_conf_2_out3 = checked
                            platformInterface.set_soc_write.update(
                                        platformInterface.soc_otpValue,
                                        [platformInterface.soc_sam_conf_1_out1,
                                         platformInterface.soc_sam_conf_1_out2,
                                         platformInterface.soc_sam_conf_1_out3,
                                         platformInterface.soc_sam_conf_1_out4,
                                         platformInterface.soc_sam_conf_1_out5,
                                         platformInterface.soc_sam_conf_1_out6,
                                         platformInterface.soc_sam_conf_1_out7,
                                         platformInterface.soc_sam_conf_1_out8,
                                         platformInterface.soc_sam_conf_1_out9,
                                         platformInterface.soc_sam_conf_1_out10,
                                         platformInterface.soc_sam_conf_1_out11,
                                         platformInterface.soc_sam_conf_1_out12

                                        ],
                                        [platformInterface.soc_sam_conf_2_out1,
                                         platformInterface.soc_sam_conf_2_out2,
                                         platformInterface.soc_sam_conf_2_out3,
                                         platformInterface.soc_sam_conf_2_out4,
                                         platformInterface.soc_sam_conf_2_out5,
                                         platformInterface.soc_sam_conf_2_out6,
                                         platformInterface.soc_sam_conf_2_out7,
                                         platformInterface.soc_sam_conf_2_out8,
                                         platformInterface.soc_sam_conf_2_out9,
                                         platformInterface.soc_sam_conf_2_out10,
                                         platformInterface.soc_sam_conf_2_out11,
                                         platformInterface.soc_sam_conf_2_out12
                                        ],
                                        samOpenLoadDiagnostic.currentText,
                                        platformInterface.soc_otpValue,
                                        platformInterface.addr_curr)
                        }
                    }
                }

                Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    SGSwitch {
                        id: samOut4
                        labelsInside: true
                        checkedLabel: "On"
                        uncheckedLabel: "Off"
                        fontSizeMultiplier: ratioCalc
                        checked: false
                        anchors.verticalCenter: parent.verticalCenter
                        onToggled: {
                            platformInterface.soc_sam_conf_2_out4 = checked
                            platformInterface.set_soc_write.update(
                                        platformInterface.soc_otpValue,
                                        [platformInterface.soc_sam_conf_1_out1,
                                         platformInterface.soc_sam_conf_1_out2,
                                         platformInterface.soc_sam_conf_1_out3,
                                         platformInterface.soc_sam_conf_1_out4,
                                         platformInterface.soc_sam_conf_1_out5,
                                         platformInterface.soc_sam_conf_1_out6,
                                         platformInterface.soc_sam_conf_1_out7,
                                         platformInterface.soc_sam_conf_1_out8,
                                         platformInterface.soc_sam_conf_1_out9,
                                         platformInterface.soc_sam_conf_1_out10,
                                         platformInterface.soc_sam_conf_1_out11,
                                         platformInterface.soc_sam_conf_1_out12

                                        ],
                                        [platformInterface.soc_sam_conf_2_out1,
                                         platformInterface.soc_sam_conf_2_out2,
                                         platformInterface.soc_sam_conf_2_out3,
                                         platformInterface.soc_sam_conf_2_out4,
                                         platformInterface.soc_sam_conf_2_out5,
                                         platformInterface.soc_sam_conf_2_out6,
                                         platformInterface.soc_sam_conf_2_out7,
                                         platformInterface.soc_sam_conf_2_out8,
                                         platformInterface.soc_sam_conf_2_out9,
                                         platformInterface.soc_sam_conf_2_out10,
                                         platformInterface.soc_sam_conf_2_out11,
                                         platformInterface.soc_sam_conf_2_out12
                                        ],
                                        samOpenLoadDiagnostic.currentText,
                                        platformInterface.soc_otpValue,
                                        platformInterface.addr_curr)
                        }
                    }
                }

                Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    SGSwitch {
                        id: samOut5
                        labelsInside: true
                        checkedLabel: "On"
                        uncheckedLabel: "Off"
                        fontSizeMultiplier: ratioCalc
                        checked: false
                        anchors.verticalCenter: parent.verticalCenter
                        onToggled: {
                            platformInterface.soc_sam_conf_2_out5 = checked
                            platformInterface.set_soc_write.update(
                                        platformInterface.soc_otpValue,
                                        [platformInterface.soc_sam_conf_1_out1,
                                         platformInterface.soc_sam_conf_1_out2,
                                         platformInterface.soc_sam_conf_1_out3,
                                         platformInterface.soc_sam_conf_1_out4,
                                         platformInterface.soc_sam_conf_1_out5,
                                         platformInterface.soc_sam_conf_1_out6,
                                         platformInterface.soc_sam_conf_1_out7,
                                         platformInterface.soc_sam_conf_1_out8,
                                         platformInterface.soc_sam_conf_1_out9,
                                         platformInterface.soc_sam_conf_1_out10,
                                         platformInterface.soc_sam_conf_1_out11,
                                         platformInterface.soc_sam_conf_1_out12

                                        ],
                                        [platformInterface.soc_sam_conf_2_out1,
                                         platformInterface.soc_sam_conf_2_out2,
                                         platformInterface.soc_sam_conf_2_out3,
                                         platformInterface.soc_sam_conf_2_out4,
                                         platformInterface.soc_sam_conf_2_out5,
                                         platformInterface.soc_sam_conf_2_out6,
                                         platformInterface.soc_sam_conf_2_out7,
                                         platformInterface.soc_sam_conf_2_out8,
                                         platformInterface.soc_sam_conf_2_out9,
                                         platformInterface.soc_sam_conf_2_out10,
                                         platformInterface.soc_sam_conf_2_out11,
                                         platformInterface.soc_sam_conf_2_out12
                                        ],
                                        samOpenLoadDiagnostic.currentText,
                                        platformInterface.soc_otpValue,
                                        platformInterface.addr_curr)
                        }
                    }
                }

                Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    SGSwitch {
                        id: samOut6
                        labelsInside: true
                        checkedLabel: "On"
                        uncheckedLabel: "Off"
                        fontSizeMultiplier: ratioCalc
                        checked: false
                        anchors.verticalCenter: parent.verticalCenter
                        onToggled: {
                            platformInterface.soc_sam_conf_2_out6 = checked
                            platformInterface.set_soc_write.update(
                                        platformInterface.soc_otpValue,
                                        [platformInterface.soc_sam_conf_1_out1,
                                         platformInterface.soc_sam_conf_1_out2,
                                         platformInterface.soc_sam_conf_1_out3,
                                         platformInterface.soc_sam_conf_1_out4,
                                         platformInterface.soc_sam_conf_1_out5,
                                         platformInterface.soc_sam_conf_1_out6,
                                         platformInterface.soc_sam_conf_1_out7,
                                         platformInterface.soc_sam_conf_1_out8,
                                         platformInterface.soc_sam_conf_1_out9,
                                         platformInterface.soc_sam_conf_1_out10,
                                         platformInterface.soc_sam_conf_1_out11,
                                         platformInterface.soc_sam_conf_1_out12

                                        ],
                                        [platformInterface.soc_sam_conf_2_out1,
                                         platformInterface.soc_sam_conf_2_out2,
                                         platformInterface.soc_sam_conf_2_out3,
                                         platformInterface.soc_sam_conf_2_out4,
                                         platformInterface.soc_sam_conf_2_out5,
                                         platformInterface.soc_sam_conf_2_out6,
                                         platformInterface.soc_sam_conf_2_out7,
                                         platformInterface.soc_sam_conf_2_out8,
                                         platformInterface.soc_sam_conf_2_out9,
                                         platformInterface.soc_sam_conf_2_out10,
                                         platformInterface.soc_sam_conf_2_out11,
                                         platformInterface.soc_sam_conf_2_out12
                                        ],
                                        samOpenLoadDiagnostic.currentText,
                                        platformInterface.soc_otpValue,
                                        platformInterface.addr_curr)
                        }
                    }
                }

                Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    SGSwitch {
                        id: samOut7
                        labelsInside: true
                        checkedLabel: "On"
                        uncheckedLabel: "Off"
                        fontSizeMultiplier: ratioCalc
                        checked: false
                        anchors.verticalCenter: parent.verticalCenter
                        onToggled: {
                            platformInterface.soc_sam_conf_2_out7 = checked
                            platformInterface.set_soc_write.update(
                                        platformInterface.soc_otpValue,
                                        [platformInterface.soc_sam_conf_1_out1,
                                         platformInterface.soc_sam_conf_1_out2,
                                         platformInterface.soc_sam_conf_1_out3,
                                         platformInterface.soc_sam_conf_1_out4,
                                         platformInterface.soc_sam_conf_1_out5,
                                         platformInterface.soc_sam_conf_1_out6,
                                         platformInterface.soc_sam_conf_1_out7,
                                         platformInterface.soc_sam_conf_1_out8,
                                         platformInterface.soc_sam_conf_1_out9,
                                         platformInterface.soc_sam_conf_1_out10,
                                         platformInterface.soc_sam_conf_1_out11,
                                         platformInterface.soc_sam_conf_1_out12

                                        ],
                                        [platformInterface.soc_sam_conf_2_out1,
                                         platformInterface.soc_sam_conf_2_out2,
                                         platformInterface.soc_sam_conf_2_out3,
                                         platformInterface.soc_sam_conf_2_out4,
                                         platformInterface.soc_sam_conf_2_out5,
                                         platformInterface.soc_sam_conf_2_out6,
                                         platformInterface.soc_sam_conf_2_out7,
                                         platformInterface.soc_sam_conf_2_out8,
                                         platformInterface.soc_sam_conf_2_out9,
                                         platformInterface.soc_sam_conf_2_out10,
                                         platformInterface.soc_sam_conf_2_out11,
                                         platformInterface.soc_sam_conf_2_out12
                                        ],
                                        samOpenLoadDiagnostic.currentText,
                                        platformInterface.soc_otpValue,
                                        platformInterface.addr_curr)
                        }
                    }
                }

                Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    SGSwitch {
                        id: samOut8
                        labelsInside: true
                        checkedLabel: "On"
                        uncheckedLabel: "Off"
                        fontSizeMultiplier: ratioCalc
                        checked: false
                        anchors.verticalCenter: parent.verticalCenter
                        onToggled: {
                            platformInterface.soc_sam_conf_2_out8 = checked
                            platformInterface.set_soc_write.update(
                                        platformInterface.soc_otpValue,
                                        [platformInterface.soc_sam_conf_1_out1,
                                         platformInterface.soc_sam_conf_1_out2,
                                         platformInterface.soc_sam_conf_1_out3,
                                         platformInterface.soc_sam_conf_1_out4,
                                         platformInterface.soc_sam_conf_1_out5,
                                         platformInterface.soc_sam_conf_1_out6,
                                         platformInterface.soc_sam_conf_1_out7,
                                         platformInterface.soc_sam_conf_1_out8,
                                         platformInterface.soc_sam_conf_1_out9,
                                         platformInterface.soc_sam_conf_1_out10,
                                         platformInterface.soc_sam_conf_1_out11,
                                         platformInterface.soc_sam_conf_1_out12

                                        ],
                                        [platformInterface.soc_sam_conf_2_out1,
                                         platformInterface.soc_sam_conf_2_out2,
                                         platformInterface.soc_sam_conf_2_out3,
                                         platformInterface.soc_sam_conf_2_out4,
                                         platformInterface.soc_sam_conf_2_out5,
                                         platformInterface.soc_sam_conf_2_out6,
                                         platformInterface.soc_sam_conf_2_out7,
                                         platformInterface.soc_sam_conf_2_out8,
                                         platformInterface.soc_sam_conf_2_out9,
                                         platformInterface.soc_sam_conf_2_out10,
                                         platformInterface.soc_sam_conf_2_out11,
                                         platformInterface.soc_sam_conf_2_out12
                                        ],
                                        samOpenLoadDiagnostic.currentText,
                                        platformInterface.soc_otpValue,
                                        platformInterface.addr_curr)
                        }
                    }
                }

                Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    SGSwitch {
                        id: samOut9
                        labelsInside: true
                        checkedLabel: "On"
                        uncheckedLabel: "Off"
                        fontSizeMultiplier: ratioCalc
                        checked: false
                        anchors.verticalCenter: parent.verticalCenter
                        onToggled: {
                            platformInterface.soc_sam_conf_2_out9 = checked
                            platformInterface.set_soc_write.update(
                                        platformInterface.soc_otpValue,
                                        [platformInterface.soc_sam_conf_1_out1,
                                         platformInterface.soc_sam_conf_1_out2,
                                         platformInterface.soc_sam_conf_1_out3,
                                         platformInterface.soc_sam_conf_1_out4,
                                         platformInterface.soc_sam_conf_1_out5,
                                         platformInterface.soc_sam_conf_1_out6,
                                         platformInterface.soc_sam_conf_1_out7,
                                         platformInterface.soc_sam_conf_1_out8,
                                         platformInterface.soc_sam_conf_1_out9,
                                         platformInterface.soc_sam_conf_1_out10,
                                         platformInterface.soc_sam_conf_1_out11,
                                         platformInterface.soc_sam_conf_1_out12

                                        ],
                                        [platformInterface.soc_sam_conf_2_out1,
                                         platformInterface.soc_sam_conf_2_out2,
                                         platformInterface.soc_sam_conf_2_out3,
                                         platformInterface.soc_sam_conf_2_out4,
                                         platformInterface.soc_sam_conf_2_out5,
                                         platformInterface.soc_sam_conf_2_out6,
                                         platformInterface.soc_sam_conf_2_out7,
                                         platformInterface.soc_sam_conf_2_out8,
                                         platformInterface.soc_sam_conf_2_out9,
                                         platformInterface.soc_sam_conf_2_out10,
                                         platformInterface.soc_sam_conf_2_out11,
                                         platformInterface.soc_sam_conf_2_out12
                                        ],
                                        samOpenLoadDiagnostic.currentText,
                                        platformInterface.soc_otpValue,
                                        platformInterface.addr_curr)
                        }
                    }
                }

                Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    SGSwitch {
                        id: samOut10
                        labelsInside: true
                        checkedLabel: "On"
                        uncheckedLabel: "Off"
                        fontSizeMultiplier: ratioCalc
                        checked: false
                        anchors.verticalCenter: parent.verticalCenter
                        onToggled: {
                            platformInterface.soc_sam_conf_2_out10 = checked
                            platformInterface.set_soc_write.update(
                                        platformInterface.soc_otpValue,
                                        [platformInterface.soc_sam_conf_1_out1,
                                         platformInterface.soc_sam_conf_1_out2,
                                         platformInterface.soc_sam_conf_1_out3,
                                         platformInterface.soc_sam_conf_1_out4,
                                         platformInterface.soc_sam_conf_1_out5,
                                         platformInterface.soc_sam_conf_1_out6,
                                         platformInterface.soc_sam_conf_1_out7,
                                         platformInterface.soc_sam_conf_1_out8,
                                         platformInterface.soc_sam_conf_1_out9,
                                         platformInterface.soc_sam_conf_1_out10,
                                         platformInterface.soc_sam_conf_1_out11,
                                         platformInterface.soc_sam_conf_1_out12

                                        ],
                                        [platformInterface.soc_sam_conf_2_out1,
                                         platformInterface.soc_sam_conf_2_out2,
                                         platformInterface.soc_sam_conf_2_out3,
                                         platformInterface.soc_sam_conf_2_out4,
                                         platformInterface.soc_sam_conf_2_out5,
                                         platformInterface.soc_sam_conf_2_out6,
                                         platformInterface.soc_sam_conf_2_out7,
                                         platformInterface.soc_sam_conf_2_out8,
                                         platformInterface.soc_sam_conf_2_out9,
                                         platformInterface.soc_sam_conf_2_out10,
                                         platformInterface.soc_sam_conf_2_out11,
                                         platformInterface.soc_sam_conf_2_out12
                                        ],
                                        samOpenLoadDiagnostic.currentText,
                                        platformInterface.soc_otpValue,
                                        platformInterface.addr_curr)
                        }
                    }
                }

                Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    SGSwitch {
                        id: samOut11
                        labelsInside: true
                        checkedLabel: "On"
                        uncheckedLabel: "Off"
                        fontSizeMultiplier: ratioCalc
                        checked: false
                        anchors.verticalCenter: parent.verticalCenter
                        onToggled: {
                            platformInterface.soc_sam_conf_2_out11 = checked
                            platformInterface.set_soc_write.update(
                                        platformInterface.soc_otpValue,
                                        [platformInterface.soc_sam_conf_1_out1,
                                         platformInterface.soc_sam_conf_1_out2,
                                         platformInterface.soc_sam_conf_1_out3,
                                         platformInterface.soc_sam_conf_1_out4,
                                         platformInterface.soc_sam_conf_1_out5,
                                         platformInterface.soc_sam_conf_1_out6,
                                         platformInterface.soc_sam_conf_1_out7,
                                         platformInterface.soc_sam_conf_1_out8,
                                         platformInterface.soc_sam_conf_1_out9,
                                         platformInterface.soc_sam_conf_1_out10,
                                         platformInterface.soc_sam_conf_1_out11,
                                         platformInterface.soc_sam_conf_1_out12

                                        ],
                                        [platformInterface.soc_sam_conf_2_out1,
                                         platformInterface.soc_sam_conf_2_out2,
                                         platformInterface.soc_sam_conf_2_out3,
                                         platformInterface.soc_sam_conf_2_out4,
                                         platformInterface.soc_sam_conf_2_out5,
                                         platformInterface.soc_sam_conf_2_out6,
                                         platformInterface.soc_sam_conf_2_out7,
                                         platformInterface.soc_sam_conf_2_out8,
                                         platformInterface.soc_sam_conf_2_out9,
                                         platformInterface.soc_sam_conf_2_out10,
                                         platformInterface.soc_sam_conf_2_out11,
                                         platformInterface.soc_sam_conf_2_out12
                                        ],
                                        samOpenLoadDiagnostic.currentText,
                                        platformInterface.soc_otpValue,
                                        platformInterface.addr_curr)
                        }
                    }
                }
                Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    SGSwitch {
                        id: samOut12
                        labelsInside: true
                        checkedLabel: "On"
                        uncheckedLabel: "Off"
                        fontSizeMultiplier: ratioCalc
                        checked: false
                        anchors.verticalCenter: parent.verticalCenter
                        onToggled: {
                            platformInterface.soc_sam_conf_2_out12 = checked
                            platformInterface.set_soc_write.update(
                                        platformInterface.soc_otpValue,
                                        [platformInterface.soc_sam_conf_1_out1,
                                         platformInterface.soc_sam_conf_1_out2,
                                         platformInterface.soc_sam_conf_1_out3,
                                         platformInterface.soc_sam_conf_1_out4,
                                         platformInterface.soc_sam_conf_1_out5,
                                         platformInterface.soc_sam_conf_1_out6,
                                         platformInterface.soc_sam_conf_1_out7,
                                         platformInterface.soc_sam_conf_1_out8,
                                         platformInterface.soc_sam_conf_1_out9,
                                         platformInterface.soc_sam_conf_1_out10,
                                         platformInterface.soc_sam_conf_1_out11,
                                         platformInterface.soc_sam_conf_1_out12

                                        ],
                                        [platformInterface.soc_sam_conf_2_out1,
                                         platformInterface.soc_sam_conf_2_out2,
                                         platformInterface.soc_sam_conf_2_out3,
                                         platformInterface.soc_sam_conf_2_out4,
                                         platformInterface.soc_sam_conf_2_out5,
                                         platformInterface.soc_sam_conf_2_out6,
                                         platformInterface.soc_sam_conf_2_out7,
                                         platformInterface.soc_sam_conf_2_out8,
                                         platformInterface.soc_sam_conf_2_out9,
                                         platformInterface.soc_sam_conf_2_out10,
                                         platformInterface.soc_sam_conf_2_out11,
                                         platformInterface.soc_sam_conf_2_out12
                                        ],
                                        samOpenLoadDiagnostic.currentText,
                                        platformInterface.soc_otpValue,
                                        platformInterface.addr_curr)
                        }
                    }
                }
            }

        }
        Rectangle {
            Layout.fillHeight: true
            Layout.fillWidth: true
            RowLayout {
                anchors.fill: parent
                Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    SGAlignedLabel {
                        id: current7bitLabel
                        //text: "Current 7-bit\nI2C Address"
                        target: current7bit
                        alignment: SGAlignedLabel.SideTopLeft
                        anchors.verticalCenter: parent.verticalCenter
                        fontSizeMultiplier: ratioCalc * 1.2
                        font.bold : true
                        SGInfoBox {
                            id: current7bit
                            height:  35 * ratioCalc
                            width: 140 * ratioCalc
                            fontSizeMultiplier: ratioCalc === 0 ? 1.0 : ratioCalc * 1.2
                            //text: "0x60"
                        }

                        property var soc_addr_curr_caption: platformInterface.soc_addr_curr_caption.caption
                        onSoc_addr_curr_captionChanged: {
                            text = soc_addr_curr_caption

                        }

                        property var soc_addr_curr_state: platformInterface.soc_addr_curr_state.state
                        onSoc_addr_curr_stateChanged: {
                            if(soc_addr_curr_state === "enabled") {
                                current7bit.enabled = true
                                current7bit.opacity = 1.0
                            }
                            else if (soc_addr_curr_state === "disabled") {
                                current7bit.enabled = false
                                current7bit.opacity = 1.0
                            }
                            else {
                                current7bit.enabled = false
                                current7bit.opacity = 0.5
                            }
                        }

                        property var soc_addr_curr_value: platformInterface.soc_addr_curr_value.value
                        onSoc_addr_curr_valueChanged: {
                            current7bit.text = soc_addr_curr_value
                            platformInterface.addr_curr = parseInt(soc_addr_curr_value, 16)

                        }
                    }
                }



                Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true


                    SGAlignedLabel {
                        id: new7bitLabel
                        //text: "New 7-bit I2C\nAddress After OTP"
                        target: new7bit
                        alignment: SGAlignedLabel.SideTopLeft
                        anchors.verticalCenter: parent.verticalCenter
                        fontSizeMultiplier: ratioCalc * 1.2
                        font.bold : true
                        SGSubmitInfoBox {
                            id: new7bit
                            fontSizeMultiplier: ratioCalc === 0 ? 1.0 : ratioCalc * 1.2
                            height:  35 * ratioCalc
                            width: 140 * ratioCalc
                            //                            validator: IntValidator {
                            //                                 top: platformInterface.soc_addr_new.scales[0]
                            //                                  bottom: platformInterface.soc_addr_new.scales[1]
                            //


                            onAccepted: {
                                //                                new7bit.text = "0x"+ text



                                var hexTodecimal = parseInt(text, 16)
                                console.log(text)
                                console.log(hexTodecimal)



                                if(hexTodecimal > platformInterface.soc_addr_new.scales[0]) {
                                    console.log(text.toString(16))
                                    new7bit.text = toHex(platformInterface.soc_addr_new.scales[0])
                                    platformInterface.addr_curr_apply = parseInt(new7bit.text, 16)
                                }

                                else if(hexTodecimal < platformInterface.soc_addr_new.scales[1]){
                                    new7bit.text = toHex(platformInterface.soc_addr_new.scales[1])
                                    platformInterface.addr_curr_apply = parseInt(new7bit.text, 16)
                                }
                                else if(hexTodecimal <= platformInterface.soc_addr_new.scales[0] && hexTodecimal >= platformInterface.soc_addr_new.scales[1]){
                                    new7bit.text = text
                                    platformInterface.addr_curr_apply = parseInt(new7bit.text, 16)
                                }



                            }

                        }

                        //what's scale for

                        property var soc_addr_new_caption: platformInterface.soc_addr_new_caption.caption
                        onSoc_addr_new_captionChanged: {
                            new7bitLabel.text = soc_addr_new_caption
                        }

                        property var soc_addr_new_state: platformInterface.soc_addr_new_state.state
                        onSoc_addr_new_stateChanged: {
                            if(soc_addr_new_state === "enabled") {
                                new7bit.enabled = true
                                new7bit.opacity = 1.0
                            }
                            else if (soc_addr_new_state === "disabled") {
                                new7bit.enabled = false
                                new7bit.opacity = 1.0
                            }
                            else {
                                new7bit.enabled = false
                                new7bit.opacity = 0.5
                            }
                        }

                        property var soc_addr_new_value: platformInterface.soc_addr_new_value.value
                        onSoc_addr_new_valueChanged: {

                            new7bit.text =  toHex(soc_addr_new_value)
                            platformInterface.addr_curr_apply = parseInt(soc_addr_new_value, 16)
                        }

                    }


                }
                Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    SGButton {
                        id:  i2cAddressButton
                        text: qsTr("Apply \n I2C Address")
                        anchors.verticalCenter: parent.verticalCenter
                        fontSizeMultiplier: ratioCalc
                        color: checked ? "#353637" : pressed ? "#cfcfcf": hovered ? "#eee" : "#e0e0e0"
                        hoverEnabled: true
                        height: parent.height/3
                        width: parent.width/3
                        MouseArea {
                            hoverEnabled: true
                            anchors.fill: parent
                            cursorShape: containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor
                            onClicked: {
                                platformInterface.set_soc_write.update(
                                            platformInterface.soc_otpValue,
                                            [platformInterface.soc_sam_conf_1_out1,
                                             platformInterface.soc_sam_conf_1_out2,
                                             platformInterface.soc_sam_conf_1_out3,
                                             platformInterface.soc_sam_conf_1_out4,
                                             platformInterface.soc_sam_conf_1_out5,
                                             platformInterface.soc_sam_conf_1_out6,
                                             platformInterface.soc_sam_conf_1_out7,
                                             platformInterface.soc_sam_conf_1_out8,
                                             platformInterface.soc_sam_conf_1_out9,
                                             platformInterface.soc_sam_conf_1_out10,
                                             platformInterface.soc_sam_conf_1_out11
                                            ],
                                            [platformInterface.soc_sam_conf_2_out1,
                                             platformInterface.soc_sam_conf_2_out2,
                                             platformInterface.soc_sam_conf_2_out3,
                                             platformInterface.soc_sam_conf_2_out4,
                                             platformInterface.soc_sam_conf_2_out5,
                                             platformInterface.soc_sam_conf_2_out6,
                                             platformInterface.soc_sam_conf_2_out7,
                                             platformInterface.soc_sam_conf_2_out8,
                                             platformInterface.soc_sam_conf_2_out9,
                                             platformInterface.soc_sam_conf_2_out10,
                                             platformInterface.soc_sam_conf_2_out11
                                            ],
                                            samOpenLoadDiagnostic.currentText,
                                            platformInterface.soc_otpValue,
                                            platformInterface.addr_curr_apply)

                            }

                        }
                    }
                }

                //                Rectangle {
                //                    Layout.fillHeight: true
                //                    Layout.preferredWidth: parent.width/6
                //                    RowLayout {
                //                        anchors.fill: parent
                //                        Rectangle {
                //                            Layout.fillHeight: true
                //                            Layout.fillWidth: true

                //                            SGAlignedLabel {
                //                                id: i2cAddressLabel
                //                                text: "I2C\nAddress"
                //                                target: i2cAddress
                //                                alignment: SGAlignedLabel.SideTopLeft
                //                                anchors.centerIn: parent
                //                                fontSizeMultiplier: ratioCalc * 1.2
                //                                font.bold : true

                //                                SGStatusLight {
                //                                    id: i2cAddress
                //                                    width: 30

                //                                }
                //                            }
                //                        }

                //                        Rectangle {
                //                            Layout.fillHeight: true
                //                            Layout.fillWidth: true
                //                            SGAlignedLabel {
                //                                id: placeholdLabel
                //                                text: "\n"
                //                                target: add2
                //                                alignment: SGAlignedLabel.SideTopLeft
                //                                anchors.centerIn: parent
                //                                fontSizeMultiplier: ratioCalc * 1.2
                //                                font.bold : true
                //                                SGStatusLight {
                //                                    id: add2
                //                                    width: 30
                //                                    //anchors.centerIn: parent
                //                                }
                //                            }
                //                        }
                //                    }
                //                }

                //                Rectangle {
                //                    Layout.preferredWidth: parent.width/2.6
                //                    Layout.fillHeight: true
                //                    RowLayout {
                //                        anchors.fill: parent
                //                        Rectangle {
                //                            Layout.fillHeight: true
                //                            Layout.fillWidth: true
                //                            SGAlignedLabel {
                //                                id: placehold3Label
                //                                text: "\n"
                //                                target: add3
                //                                alignment: SGAlignedLabel.SideTopLeft
                //                                anchors.centerIn: parent
                //                                fontSizeMultiplier: ratioCalc * 1.2
                //                                font.bold : true
                //                                SGStatusLight {
                //                                    id: add3
                //                                    width: 30
                //                                    // anchors.centerIn: parent
                //                                }
                //                            }
                //                        }

                //                        Rectangle {
                //                            Layout.fillHeight: true
                //                            Layout.fillWidth: true
                //                            SGAlignedLabel {
                //                                id: placehold4Label
                //                                text: "\n"
                //                                target: add4
                //                                alignment: SGAlignedLabel.SideTopLeft
                //                                anchors.centerIn: parent
                //                                fontSizeMultiplier: ratioCalc * 1.2
                //                                font.bold : true
                //                                SGStatusLight {
                //                                    id: add4
                //                                    width: 30
                //                                    // anchors.centerIn: parent
                //                                }
                //                            }
                //                        }
                //                        Rectangle {
                //                            Layout.fillHeight: true
                //                            Layout.fillWidth: true
                //                            SGAlignedLabel {
                //                                id: placehold5Label
                //                                text: "\n"
                //                                target: add5
                //                                alignment: SGAlignedLabel.SideTopLeft
                //                                anchors.centerIn: parent
                //                                fontSizeMultiplier: ratioCalc * 1.2
                //                                font.bold : true
                //                                SGStatusLight {
                //                                    id: add5
                //                                    width: 30
                //                                    //anchors.centerIn: parent
                //                                }
                //                            }
                //                        }

                //                        Rectangle {
                //                            Layout.fillHeight: true
                //                            Layout.fillWidth: true

                //                            SGAlignedLabel {
                //                                id: placehold6Label
                //                                text: "\n"
                //                                target: add6
                //                                alignment: SGAlignedLabel.SideTopLeft
                //                                anchors.centerIn: parent
                //                                fontSizeMultiplier: ratioCalc * 1.2
                //                                font.bold : true
                //                                SGStatusLight {
                //                                    id: add6
                //                                    width: 30
                //                                    // anchors.centerIn: parent
                //                                }
                //                            }
                //                        }
                //                    }
                //                }
            }
        }

        Rectangle {
            Layout.fillHeight: true
            Layout.fillWidth: true
            RowLayout {
                width:parent.width/3
                height: parent.height
                anchors.left:parent.left
                Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    SGButton {
                        id:  zapButton
                        //text: qsTr("One Time \n Program (zap)")
                        anchors.verticalCenter: parent.verticalCenter
                        fontSizeMultiplier: ratioCalc
                        color: checked ? "#353637" : pressed ? "#cfcfcf": hovered ? "#eee" : "#e0e0e0"
                        hoverEnabled: true
                        height: parent.height/3
                        width: parent.width/3
                        MouseArea {
                            hoverEnabled: true
                            anchors.fill: parent
                            cursorShape: containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor
                            onClicked: warningPopup.open()

                        }

                        property var soc_otp_caption: platformInterface.soc_otp_caption.caption
                        onSoc_otp_captionChanged: {
                            text = soc_otp_caption
                        }

                        property var soc_otp_state: platformInterface.soc_otp_state.state
                        onSoc_otp_stateChanged: {
                            if(soc_otp_state === "enabled") {
                                zapButton.opacity = 1.0
                                zapButton.enabled = true
                            }
                            else if (soc_otp_state === "disabled") {
                                zapButton.opacity = 1.0
                                zapButton.enabled = false
                            }
                            else {
                                zapButton.opacity = 0.5
                                zapButton.enabled = false
                            }
                        }
                    }

                }


            }
        }
    }
}

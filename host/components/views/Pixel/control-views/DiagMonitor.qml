import QtQuick 2.12
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.12
import tech.strata.sgwidgets 0.9
import "qrc:/js/help_layout_manager.js" as Help

Item {
    id:root
    width: parent.width
    height: parent.height

    property var read_vled1on: platformInterface.diag3_buck.vled1on
    onRead_vled1onChanged: {
        sgCircularGauge11.value = read_vled1on
    }

    property var read_vled2on: platformInterface.diag3_buck.vled2on
    onRead_vled2onChanged: {
        sgCircularGauge21.value = read_vled2on
    }

    property var read_vled1: platformInterface.diag3_buck.vled1
    onRead_vled1Changed: {
        sgCircularGauge12.value = read_vled1
    }

    property var read_vled2: platformInterface.diag3_buck.vled2
    onRead_vled2Changed: {
        sgCircularGauge22.value = read_vled2
    }

    property var read_vboost: platformInterface.diag3_buck.vboost
    onRead_vboostChanged: {
        sgCircularGauge31.value = read_vboost
    }

    property var read_vtemp: platformInterface.diag3_buck.vtemp
    onRead_vtempChanged: {
        sgCircularGauge32.value = read_vtemp
    }

    ColumnLayout{
        anchors.fill:parent

        Rectangle{
            id:rec0
            Layout.preferredWidth: parent.width/1.05
            Layout.preferredHeight: parent.height/18
            //            Layout.alignment: Qt.AlignCenter
            Layout.leftMargin: 30
            color:"transparent"

            RowLayout{
                anchors.fill: parent
                Layout.preferredWidth: parent.width/4.5
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignCenter

                SGSegmentedButtonStrip {
                    id: segmentedButtons21
                    Layout.alignment: Qt.AlignCenter

                    segmentedButtons: GridLayout {
                        columnSpacing: 3

                        SGSegmentedButton{
                            text: qsTr("Buck1")
                            onClicked: {
                                platformInterface.buck1_monitor = true
                                platformInterface.buck2_monitor = false
                                platformInterface.buck3_monitor = false
                                platformInterface.buck_diag_read.update(1,3)
                            }
                        }

                        SGSegmentedButton{
                            text: qsTr("Buck2")
                            onClicked: {
                                platformInterface.buck1_monitor = false
                                platformInterface.buck2_monitor = true
                                platformInterface.buck3_monitor = false
                                platformInterface.buck_diag_read.update(2,3)
                            }
                        }

                        SGSegmentedButton{
                            text: qsTr("Buck3")
                            onClicked: {
                                platformInterface.buck1_monitor = false
                                platformInterface.buck2_monitor = false
                                platformInterface.buck3_monitor = true
                                platformInterface.buck_diag_read.update(3,3)
                            }
                        }
                    }
                }
            }
        }

        Rectangle{
            id:rec1
            Layout.preferredWidth:parent.width/1.05
            Layout.preferredHeight: parent.height/1.2
            Layout.leftMargin: 30
            color:"transparent"

            RowLayout{
                anchors.fill: parent

                Rectangle{
                    id: rec11
                    Layout.preferredWidth:parent.width/3.5
                    Layout.preferredHeight: parent.height
                    color: "transparent"

                    ColumnLayout{
                        anchors.fill: parent
                        anchors{
                            horizontalCenter: parent.horizontalCenter
                            verticalCenter:parent.verticalCenter
                        }

                        Text {
                            text: "VLED1ON"
                            font {
                                pixelSize: 15
                            }
                            color:"black"
                        }

                        SGCircularGauge {
                            id: sgCircularGauge11
                            minimumValue: 0
                            maximumValue: 100
                            tickmarkStepSize: 10
                            gaugeRearColor: "#ddd"                  // Default: "#ddd"(background color that gets filled in by gauge)
                            centerColor: "black"
                            outerColor: "#999"
                            gaugeFrontColor1: Qt.rgba(0,.75,1,1)
                            gaugeFrontColor2: Qt.rgba(1,0,0,1)
                            unitLabel: "Volts"                        // Default: "RPM"
                            value: 0.0
                        }

                        Text {
                            text: "VLED1"
                            font {
                                pixelSize: 15
                            }
                            color:"black"
                        }

                        SGCircularGauge {
                            id: sgCircularGauge12
                            minimumValue: 0
                            maximumValue: 100
                            tickmarkStepSize: 10
                            gaugeRearColor: "#ddd"                  // Default: "#ddd"(background color that gets filled in by gauge)
                            centerColor: "black"
                            outerColor: "#999"
                            gaugeFrontColor1: Qt.rgba(0,.75,1,1)
                            gaugeFrontColor2: Qt.rgba(1,0,0,1)
                            unitLabel: "Volts"                        // Default: "RPM"
                            value: 0.0
                        }
                    }
                }

                Rectangle{
                    id: rec12
                    Layout.preferredWidth:parent.width/3.5
                    Layout.preferredHeight: parent.height
                    color: "transparent"

                    ColumnLayout{
                        anchors.fill: parent
                        anchors{
                            horizontalCenter: parent.horizontalCenter
                            verticalCenter:parent.verticalCenter
                        }

                        Text {
                            text: "VLED2ON"
                            font {
                                pixelSize: 15
                            }
                            color:"black"
                        }

                        SGCircularGauge {
                            id: sgCircularGauge21
                            minimumValue: 0
                            maximumValue: 100
                            tickmarkStepSize: 10
                            gaugeRearColor: "#ddd"                  // Default: "#ddd"(background color that gets filled in by gauge)
                            centerColor: "black"
                            outerColor: "#999"
                            gaugeFrontColor1: Qt.rgba(0,.75,1,1)
                            gaugeFrontColor2: Qt.rgba(1,0,0,1)
                            unitLabel: "Volts"                        // Default: "RPM"
                            value: 0.0
                        }

                        Text {
                            text: "VLED2"
                            font {
                                pixelSize: 15
                            }
                            color:"black"
                        }

                        SGCircularGauge {
                            id: sgCircularGauge22
                            minimumValue: 0
                            maximumValue: 100
                            tickmarkStepSize: 10
                            gaugeRearColor: "#ddd"                  // Default: "#ddd"(background color that gets filled in by gauge)
                            centerColor: "black"
                            outerColor: "#999"
                            gaugeFrontColor1: Qt.rgba(0,.75,1,1)
                            gaugeFrontColor2: Qt.rgba(1,0,0,1)
                            unitLabel: "Volts"                        // Default: "RPM"
                            value: 0.0
                        }
                    }
                }

                Rectangle{
                    id: rec13
                    Layout.preferredWidth:parent.width/3.5
                    Layout.preferredHeight: parent.height
                    color: "transparent"

                    ColumnLayout{
                        anchors.fill: parent
                        anchors{
                            horizontalCenter: parent.horizontalCenter
                            verticalCenter:parent.verticalCenter
                        }

                        Text {
                            text: "VBOOST"
                            font {
                                pixelSize: 15
                            }
                            color:"black"
                        }

                        SGCircularGauge {
                            id: sgCircularGauge31
                            minimumValue: 0
                            maximumValue: 100
                            tickmarkStepSize: 10
                            gaugeRearColor: "#ddd"                  // Default: "#ddd"(background color that gets filled in by gauge)
                            centerColor: "black"
                            outerColor: "#999"
                            gaugeFrontColor1: Qt.rgba(0,.75,1,1)
                            gaugeFrontColor2: Qt.rgba(1,0,0,1)
                            unitLabel: "Volts"                        // Default: "RPM"
                            value: 0.0
                        }

                        Text {
                            text: "VTEMP"
                            font {
                                pixelSize: 15
                            }
                            color:"black"
                        }

                        SGCircularGauge {
                            id: sgCircularGauge32
                            minimumValue: 0
                            maximumValue: 100
                            tickmarkStepSize: 10
                            gaugeRearColor: "#ddd"                  // Default: "#ddd"(background color that gets filled in by gauge)
                            centerColor: "black"
                            outerColor: "#999"
                            gaugeFrontColor1: Qt.rgba(0,.75,1,1)
                            gaugeFrontColor2: Qt.rgba(1,0,0,1)
                            unitLabel: "Degree C"                        // Default: "RPM"
                            value: 0.0
                        }
                    }
                }
            }
        }
    }

    Component.onCompleted:  {
        Help.registerTarget(segmentedButtons21, "Boost Enable control switch, All sliders and siwtches will be able to control after Boost Enable switch is ON, if OFF all switched and sliders will be disabled.", 0, "Help2")
//        Help.registerTarget(sgSlider1, "Boost set point voltage select.", 2, "Help1")
//        Help.registerTarget(sgStatusLight1, "LED indicator for Boost Enable, LED green if Boost Enable is ON.", 1, "Help1")
//        Help.registerTarget(sgSwitch2, "Buck1 to 6 Enable control swith.", 3, "Help1")
//        Help.registerTarget(sgSlider2, "Buck1 o 6 current setting", 5, "Help1")
//        Help.registerTarget(sgStatusLight2, "LED indicator for Buck Enable, LED green if Buck1 to 6 Enable switch is ON", 4, "Help1")
//        Help.registerTarget(sgSlider8, "Buck4 to 6 dimming control, 0 - 100 [%], slider is avairable when Buck Enable switch is ON", 6, "Help1")
    }
}


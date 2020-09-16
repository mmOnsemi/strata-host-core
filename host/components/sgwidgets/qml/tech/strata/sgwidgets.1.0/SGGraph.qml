import QtQuick 2.0
import QtQuick.Controls 2.12
import tech.strata.commoncpp 1.0
import tech.strata.sgwidgets 1.0 as SGWidgets

SGQWTPlot {
    id: sgGraph

    Component.onCompleted: {
        initialize()
    }

    property bool panXEnabled: true
    property bool panYEnabled: true
    property bool zoomXEnabled: true
    property bool zoomYEnabled: true
    property real fontSizeMultiplier: 1.0
    property alias mouseArea: mouseArea

    titlePixelSize: SGWidgets.SGSettings.fontPixelSize * fontSizeMultiplier * 1.1667
    xTitlePixelSize: SGWidgets.SGSettings.fontPixelSize * fontSizeMultiplier
    yTitlePixelSize: SGWidgets.SGSettings.fontPixelSize * fontSizeMultiplier

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: (sgGraph.panXEnabled || sgGraph.panYEnabled || sgGraph.zoomXEnabled || sgGraph.zoomYEnabled) && !(sgGraph.xLogarithmic || sgGraph.yLogarithmic)
        preventStealing: true
        hoverEnabled: true

        property point mousePosition: "0,0"
        property int wheelChoke: 0 // chokes output of high resolution trackpads on mac

        onPressed: {
            if (sgGraph.panXEnabled || sgGraph.panYEnabled) {
                mousePosition = Qt.point(mouse.x, mouse.y)
            }
        }

        onPositionChanged: {
            if ((sgGraph.panXEnabled || sgGraph.panYEnabled) && pressed) {
                let originToPosition = sgGraph.mapToPosition(Qt.point(0,0))
                originToPosition.x += (mouse.x - mousePosition.x)
                originToPosition.y += (mouse.y - mousePosition.y)
                let deltaLocation = sgGraph.mapToValue(originToPosition)
                sgGraph.autoUpdate = false
                if (sgGraph.panXEnabled) {
                    sgGraph.shiftXAxis(-deltaLocation.x)
                }
                if (sgGraph.panYEnabled) {
                    sgGraph.shiftYAxis(-deltaLocation.y)
                }
                sgGraph.autoUpdate = true
                sgGraph.update()
                mousePosition = Qt.point(mouse.x, mouse.y)

            }
        }

        onWheel: {
            if (sgGraph.zoomXEnabled || sgGraph.zoomYEnabled){
                wheelChoke += wheel.angleDelta.y

                if (wheelChoke > 119 || wheelChoke < -119){
                    var scale = Math.pow(1.5, wheelChoke * 0.001)

                    var scaledChartWidth = (sgGraph.xMax - sgGraph.xMin) / scale
                    var scaledChartHeight = (sgGraph.yMax - sgGraph.yMin) / scale
                    var scaledChartHeightYAxisRight = (sgGraph.yRightMax - sgGraph.yRightMin) / scale

                    var chartCenter = Qt.point((sgGraph.xMin + sgGraph.xMax) / 2, (sgGraph.yMin + sgGraph.yMax) / 2)
                    var chartCenterYAxisRight = Qt.point((sgGraph.xMin + sgGraph.xMax) / 2, (sgGraph.yRightMax + sgGraph.yRightMin) / 2)
                    var chartWheelPosition = mapToValue(Qt.point(wheel.x, wheel.y))
                    var chartOffset = Qt.point((chartCenter.x - chartWheelPosition.x) * (1 - scale), (chartCenter.y - chartWheelPosition.y) * (1 - scale))
                    var chartOffsetYAxisRight = Qt.point((chartCenterYAxisRight.x - chartWheelPosition.x) * (1 - scale), (chartCenterYAxisRight.y - chartWheelPosition.y) * (1 - scale))

                    sgGraph.autoUpdate = false

                    if (sgGraph.zoomXEnabled) {
                        sgGraph.xMin = (chartCenter.x - (scaledChartWidth / 2)) + chartOffset.x
                        sgGraph.xMax = (chartCenter.x + (scaledChartWidth / 2)) + chartOffset.x
                    }
                    if (sgGraph.zoomYEnabled) {
                        sgGraph.yMin = (chartCenter.y - (scaledChartHeight / 2)) + chartOffset.y
                        sgGraph.yMax = (chartCenter.y + (scaledChartHeight / 2)) + chartOffset.y
                        sgGraph.yRightMin = (chartOffsetYAxisRight.y - (scaledChartHeightYAxisRight / 2)) + chartOffsetYAxisRight.y
                        sgGraph.yRightMax = (chartOffsetYAxisRight.y + (scaledChartHeightYAxisRight / 2)) + chartOffsetYAxisRight.y
                    }

                    sgGraph.autoUpdate = true
                    sgGraph.update()

                    wheelChoke = 0
                }
            }
        }
    }
}

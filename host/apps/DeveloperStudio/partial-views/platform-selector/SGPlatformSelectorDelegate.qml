import QtQuick 2.9
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.3
import QtQuick.Shapes 1.0
import "qrc:/js/platform_selection.js" as PlatformSelection

import tech.strata.fonts 1.0
import tech.strata.logger 1.0

Item {
    id: root
    implicitWidth: 950
    implicitHeight: 160
    property bool isCurrentItem: false

    MouseArea{
        anchors{
            fill: parent
        }
        onClicked: {
            root.ListView.view.currentIndex = index
        }
    }

    Rectangle {
        id: imageContainer
        height: 120
        width: 167
        anchors {
            verticalCenter: root.verticalCenter
            left: root.left
            leftMargin: 25
        }

        Image {
            id: image
            sourceSize.height: imageContainer.height
            sourceSize.width: imageContainer.width
            anchors.fill: imageContainer
            source: {
                if (model.image === "file:/") {
                    console.error(Logger.devStudioCategory, "Platform Selector Delegate: No image source supplied by platform list")
                    return "qrc:/partial-views/platform-selector/images/platform-images/notFound.png"
                } else {
                    return model.image
                }
            }
            visible: model.image !== undefined && status == Image.Ready

            onStatusChanged: {
                if (image.status == Image.Error){
                    source = ""
                    imageCheck.start()
                }
            }

            Timer {
                id: imageCheck
                interval: 1000
                running: false
                repeat: false
                onTriggered: {
                    if (count < 30) {
                        image.source = model.image
                        count++;
                    } else {
                        // stop trying to load after 30 seconds
                        image.source = "qrc:/partial-views/platform-selector/images/platform-images/notFound.png"
                    }
                }

                property int count: 0
            }

            Image {
                id: comingSoon
                sourceSize.height: image.sourceSize.height
                fillMode: Image.PreserveAspectFit
                source: "images/platform-images/comingsoon.png"
                visible: !model.available.documents && !model.available.control && !model.error
            }
        }

        AnimatedImage {
            id: loaderImage
            height: 40
            width: 40
            anchors {
                centerIn: imageContainer
                verticalCenterOffset: -15
            }
            playing: image.status !== Image.Ready
            visible: playing
            source: "qrc:/images/loading.gif"
            opacity: .25
        }

        Text {
            id: loadingText
            anchors {
                top: loaderImage.bottom
                topMargin: 15
                horizontalCenter: loaderImage.horizontalCenter
            }
            visible: loaderImage.visible
            color: "lightgrey"
            text: "Loading..."
            font.family: Fonts.franklinGothicBold
        }
    }

    DropShadow {
        anchors {
            centerIn: imageContainer
        }
        width: imageContainer.width
        height: imageContainer.height
        horizontalOffset: 1
        verticalOffset: 3
        radius: 15.0
        samples: radius*2
        color: "#cc000000"
        source: imageContainer
        z: -1
        cached: true
    }

    Item {
        id: infoColumn
        anchors {
            left: imageContainer.right
            leftMargin: 20
            top: root.top
            topMargin: 20
            bottom: root.bottom
            bottomMargin: 20
        }
        width: 350

        Text {
            id: name
            text: model.verbose_name
            font {
                pixelSize: 16
                family: Fonts.franklinGothicBold
            }
            width: infoColumn.width
            anchors {
                horizontalCenter: infoColumn.horizontalCenter
                top: infoColumn.top
            }
            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignHCenter
        }

        Text {
            id: productId
            text: model.opn
            anchors {
                horizontalCenter: infoColumn.horizontalCenter
                top: name.bottom
                topMargin: 12
            }
            width: infoColumn.width
            font {
                pixelSize: 13
                family: Fonts.franklinGothicBold
            }
            color: "#333"
            font.italic: true
            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignHCenter
        }

        Text {
            id: info
            text: model.description
            anchors {
                horizontalCenter: infoColumn.horizontalCenter
                top: productId.bottom
                topMargin: 12
                bottom: infoColumn.bottom
            }
            width: infoColumn.width
            font {
                pixelSize: 12
                family: Fonts.franklinGothicBook
            }
            color: "#666"
            wrapMode: Text.Wrap
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignHCenter
        }
    }

    Item {
        id: iconContainer
        anchors {
            verticalCenter: root.verticalCenter
            left: infoColumn.right
            leftMargin: 30
            right: buttonColumn.left
            rightMargin: 30
        }
        height: root.height - 20
        width: 240

        PathView  {
            id: iconPathview
            anchors {
                fill: iconContainer
            }
            clip: true
            model: icons
            pathItemCount: 3
            interactive: false
            preferredHighlightBegin: .5
            preferredHighlightEnd: .5
            property real delegateHeight: 100
            property real delegateWidth: 100
            delegate: Item {
                id: delegate
                z: PathView.delZ ? PathView.delZ : 1 // if/then due to random bug that assigns undefined occassionally
                height: icon.height
                width: icon.width
                scale: PathView.delScale ? PathView.delScale : 0.5 // if/then due to random bug that assigns undefined occassionally

                Image {
                    id: icon
                    height: iconPathview.delegateHeight
                    width: iconPathview.delegateWidth
                    source: "images/icons/" + model.icon + ".png"
                    opacity: delegate.PathView.delOpacity ? delegate.PathView.delOpacity : 0.7 // if/then due to random bug that assigns undefined occassionally
                }

                Rectangle {
                    height: icon.height*.966
                    width: icon.width*.966
                    anchors {
                        centerIn: parent
                    }
                    z:-1
                    radius: height/2
                    opacity: 1
                }

                MouseArea {
                    id: delegateMouse
                    anchors.fill: delegate
                    hoverEnabled: true
                }

                ToolTip {
                    text: model.icon.toUpperCase();
                    y: delegate.height
                    visible: delegateMouse.containsMouse
                }
            }

            path: pathIcon

            Path {
                id: pathIcon

                startX : -iconPathview.delegateWidth
                startY: (iconPathview.height * 0.5)

                PathAttribute {name : "delScale"; value: 0.5}
                PathAttribute {name : "delZ"; value: 0}
                PathAttribute {name : "delOpacity"; value: 0.7}

                PathLine {x : 0; y : iconPathview.height * 0.5}

                PathPercent {value : 0.1}
                PathAttribute {name : "delScale"; value : 0.5}
                PathAttribute {name : "delZ"; value :0}
                PathAttribute {name : "delOpacity"; value: 0.7}

                PathLine {x : iconPathview.width/3; y : iconPathview.height * 0.5}

                PathPercent {value : 0.4}
                PathAttribute {name : "delScale"; value: 1.0}
                PathAttribute {name : "delZ"; value: 1}
                PathAttribute {name : "delOpacity"; value: 1.0}

                PathLine {x : 2*iconPathview.width/3; y : iconPathview.height * 0.5}

                PathAttribute {name : "delScale"; value: 1.0}
                PathAttribute {name : "delZ"; value: 1}
                PathAttribute {name : "delOpacity"; value: 1.0}
                PathPercent {value : 0.6}

                PathLine {x : iconPathview.width; y : iconPathview.height * 0.5}

                PathAttribute {name : "delScale"; value: 0.5}
                PathAttribute {name : "delZ"; value: 0}
                PathAttribute {name : "delOpacity"; value: 0.7}
                PathPercent {value : 0.9}

                PathLine {x : iconPathview.width + iconPathview.delegateWidth; y : iconPathview.height * 0.5}
            }

            highlightMoveDuration: 200

            Timer {
                running: root.isCurrentItem
                interval: 1500
                onTriggered: {
                    iconPathview.decrementCurrentIndex()
                }
                repeat: true
            }
        }
    }

    Column {
        id: buttonColumn
        spacing: 20
        anchors {
            verticalCenter: root.verticalCenter
            right: root.right
            rightMargin: 25
        }
        width: 170

        Text {
            id: comingSoonWarn
            text: "This platform is coming soon!"
            visible: !model.available.documents && !model.available.control && !model.error
            width: buttonColumn.width
            font.pixelSize: 16
            font.family: Fonts.franklinGothicBold
            opacity: enabled ? 1.0 : 0.3
            color: "#333"
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.Wrap
        }

        Button {
            id: select
            text: model.connection === "connected" ? "Connect to Board" : "Browse Documentation"
            anchors {
                horizontalCenter: buttonColumn.horizontalCenter
            }
            visible: model.connection === "connected" ? model.available.control : model.available.documents

            contentItem: Text {
                text: select.text
                font.pixelSize: 12
                font.family: Fonts.franklinGothicBook
                opacity: enabled ? 1.0 : 0.3
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }

            background: Rectangle {
                implicitWidth: 100
                implicitHeight: 40
                opacity: enabled ? 1 : 0.3
                color: select.down ? "#666" : "#999"
            }

            onClicked: {
                if (root.ListView.view.filteredList){
                    PlatformSelection.selectPlatform(model.filteredIndex)
                } else {
                    PlatformSelection.selectPlatform(index)
                }
            }
        }

        Button {
            id: order
            text: "Contact Sales"
            anchors {
                horizontalCenter: buttonColumn.horizontalCenter
            }
            visible: model.available.documents || model.available.control

            contentItem: Text {
                text: order.text
                font.pixelSize: 12
                font.family: Fonts.franklinGothicBook
                opacity: enabled ? 1.0 : 0.3
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }

            background: Rectangle {
                implicitWidth: 100
                implicitHeight: 40
                opacity: enabled ? 1 : 0.3
                color: order.down ? "#666" : "#999"
            }

            onClicked: {
                orderPopup.open()
            }
        }
    }

    Rectangle {
        id: bottomDivider
        color: "#ddd"
        height: 1
        anchors {
            bottom: root.bottom
            horizontalCenter: root.horizontalCenter
        }
        width: parent.width - 20
    }
}

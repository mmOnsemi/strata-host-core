import QtQuick 2.9
import QtQuick.Controls 2.3
import Fonts 1.0

ScrollView {
    id: scrollView
    anchors {
        fill: profileStack
    }

    contentHeight: contentContainer.height
    contentWidth: contentContainer.width
    clip: true

    Item {
        id: contentContainer
        width: Math.max(popupContainer.width, updateColumn.width)
        height: updateColumn.height + updateColumn.anchors.topMargin*2
        clip: true

        Column {
            id: updateColumn
            anchors {
                horizontalCenter: contentContainer.horizontalCenter
                top: contentContainer.top
                topMargin: 20
            }
            spacing: 15

            Rectangle {
                id: updateContainer
                color: "#efefef"
                width: 500
                height: subColumn1.height + 30

                Column {
                    id: subColumn1
                    anchors {
                        top:updateContainer.top
                        topMargin: 15
                        horizontalCenter: updateContainer.horizontalCenter
                    }
                    spacing: 15

                    Text {
                        id: updateTitle
                        text: "Update Profile Information:"
                        font {
                            pixelSize: 25
                            family: Fonts.franklinGothicBold
                        }
                        anchors {
                            horizontalCenter: subColumn1.horizontalCenter
                        }
                    }

                    SGSubmitInfoBox {
                        label: "Name:"
                        overrideLabelWidth: 150
                        infoBoxWidth: 300
                        value: getUserName(user_id)
                    }

                    SGSubmitInfoBox {
                        label: "Email:"
                        overrideLabelWidth: 150
                        infoBoxWidth: 300
                        value: getUserName(user_id) + "@onsemi.com"
                    }

                    SGSubmitInfoBox {
                        label: "Phone:"
                        overrideLabelWidth: 150
                        infoBoxWidth: 300
                        value: "Phone: 123-123-5555"
                    }

                    SGSubmitInfoBox {
                        label: "Company:"
                        overrideLabelWidth: 150
                        infoBoxWidth: 300
                        value: "Acme Inc."
                    }

                    SGSubmitInfoBox {
                        label: "Address:"
                        overrideLabelWidth: 150
                        infoBoxWidth: 300
                        value: "9000 ACME Drive, Somewhere USA 91234"
                    }

                    Row {
                        spacing: 20
                        anchors {
                            horizontalCenter: subColumn1.horizontalCenter
                        }

                        Button {
                            text: "Apply Changes"
                            onClicked: profileStack.currentIndex = 0
                        }

                        Button {
                            text: "Cancel"
                            onClicked: profileStack.currentIndex = 0
                        }
                    }
                }
            }

            Item {
                id: spacer2
                width: 10
                height: 20
            }

            Rectangle {
                id: passwordContainer
                color: "#efefef"
                width: 500
                height: subColumn2.height + subColumn2.anchors.topMargin*2

                Column {
                    id: subColumn2
                    anchors {
                        top:passwordContainer.top
                        topMargin: 15
                        horizontalCenter: passwordContainer.horizontalCenter
                    }
                    spacing: 15

                    SGSubmitInfoBox {
                        label: "Current Password:"
                        overrideLabelWidth: 150
                        infoBoxWidth: 300
                        echoMode: TextInput.Password
                    }
                    SGSubmitInfoBox {
                        label: "New Password:"
                        overrideLabelWidth: 150
                        infoBoxWidth: 300
                        echoMode: TextInput.Password
                    }
                    SGSubmitInfoBox {
                        label: "Retype New Password:"
                        overrideLabelWidth: 150
                        infoBoxWidth: 300
                        echoMode: TextInput.Password
                    }

                    Row {
                        spacing: 20
                        anchors {
                            horizontalCenter: subColumn2.horizontalCenter
                        }

                        Button {
                            id: setPassButton
                            text: "Set New Password"
                            onClicked: profileStack.currentIndex = 0
                        }

                        Button {
                            text: "Cancel"
                            onClicked: profileStack.currentIndex = 0
                        }
                    }
                }
            }
        }
    }
}
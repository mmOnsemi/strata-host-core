import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.3
import QtQuick.Window 2.0
import QtQuick.Dialogs 1.3
import QtWebEngine 1.8
import QtWebChannel 1.0

import tech.strata.sgwidgets 1.0
import tech.strata.fonts 1.0
import tech.strata.commoncpp 1.0

Item {
    id: fileContainerRoot
    Layout.fillHeight: true
    Layout.fillWidth: true

    property int modelIndex: index
    property string file: model.filename
    property string fileText: ""
    property int savedVersionId
    property int currentVersionId

    function openFile(fileUrl) {
        return SGUtilsCpp.readTextFileContent(SGUtilsCpp.urlToLocalFile(fileUrl));
    }

    function saveFile(fileUrl, text) {
        savedVersionId = currentVersionId;
        model.unsavedChanges = false;
        return SGUtilsCpp.atomicWrite(SGUtilsCpp.urlToLocalFile(fileUrl), text);
    }

    Connections {
        target: saveButton
        onClicked: {
            if (openFilesModel.currentId === model.id)
            saveFile(model.filepath,fileText)
        }
    }

    Keys.onPressed: {
        if (event.matches(StandardKey.Save)) {
            saveFile(model.filepath, fileText)
        }
    }

    WebChannel {
        id: channel
        registeredObjects: [channelObject]
    }

    QtObject {
        id: channelObject
        objectName: "fileChannel"
        WebChannel.id: "valueLink"

        signal setValue(string value);

        function setHtml(value) {
            setValue(value)
        }

        function setFileText(value) {
            fileText = value;
        }

        function setVersionId(version) {
            // If this is the first change, then we have just initialized the editor
            if (!savedVersionId) {
                savedVersionId = version
            }
            currentVersionId = version
            model.unsavedChanges = (savedVersionId !== version)
        }
    }

    WebEngineView {
        id: webEngine

        webChannel: channel
        settings.localContentCanAccessRemoteUrls: false
        settings.localContentCanAccessFileUrls: true
        settings.localStorageEnabled: true

        settings.errorPageEnabled: false
        settings.javascriptCanOpenWindows: false
        settings.javascriptEnabled: true
        settings.javascriptCanAccessClipboard: true
        settings.pluginsEnabled: true

        anchors.fill: parent

        onLoadingChanged: {
            if (loadRequest.status === WebEngineLoadRequest.LoadSucceededStatus) {
                webEngine.runJavaScript("setContainerHeight(%1)".replace("%1", parent.height), function result(result) {

                });
                fileText = openFile(model.filepath)
                channelObject.setHtml(fileText)
            }
        }

        onJavaScriptConsoleMessage: {
            switch (level) {
            case WebEngineView.InfoMessageLevel:
                console.info(sourceID, "-", lineNumber, "-", message)
                break;
            case WebEngineView.WarningMessageLevel:
                console.warn(sourceID, "-", lineNumber, "-", message);
                break;
            case WebEngineView.ErrorMessageLevel:
                console.error(sourceID, "-", lineNumber, "-", message);
                break;
            default:
                break;
            }
        }

        url: "qrc:///partial-views/control-view-creator/editor.html"

        Rectangle {
            id: barContainer
            color: "white"
            anchors {
                fill: webEngine
            }
            visible: progressBar.value !== 100

            ProgressBar {
                id: progressBar
                anchors {
                    centerIn: barContainer
                    verticalCenterOffset: 10
                }
                height: 10
                width: webEngine.width/2
                from: 0
                to: 100
                value: webEngine.loadProgress

                Text {
                    text: qsTr("Loading...")
                    anchors {
                        bottom: progressBar.top
                        bottomMargin: 10
                        horizontalCenter: progressBar.horizontalCenter
                    }
                }
            }
        }
    }
}


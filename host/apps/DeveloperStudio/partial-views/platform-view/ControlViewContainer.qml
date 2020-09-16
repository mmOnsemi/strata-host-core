import QtQuick 2.12
import QtQuick.Controls 2.12

import "qrc:/js/uuid_map.js" as UuidMap
import "qrc:/js/navigation_control.js" as NavigationControl
import "qrc:/js/help_layout_manager.js" as Help

import tech.strata.ResourceLoader 1.0
import tech.strata.sgwidgets 1.0

Item {
    id: controlViewContainer

    property bool usingStaticView: true
    property string activeDownloadUri: ""
    property var otaVersionsToRemove: []
    property var controlViewList: sdsModel.documentManager.getClassDocuments(platformStack.class_id).controlViewListModel
    property int controlViewListCount: controlViewList.count
    property bool controlLoaded: false

    readonly property string staticVersion: "static"

    Rectangle {
        id: loadingBarContainer
        anchors {
            fill: parent
        }

        ProgressBar {
            id: loadingBar
            anchors {
                centerIn: parent
            }

            background: Rectangle {
                id: barContainer
                implicitWidth: controlViewContainer.width / 2
                implicitHeight: 15
                color: "#e6e6e6"
                radius: 5
            }

            contentItem: Rectangle {
                id: bar
                color: "#57d445"
                height: parent.height
                width: loadingBar.visualPosition * parent.width
                radius: 5
            }
        }

        SGText {
            anchors {
                left: loadingBar.left
                bottom: loadingBar.top
                bottomMargin: 10
            }
            text: loadingBar.value === 1.0 ? "Loading Control View..." : "Downloading Control View..."
            fontSizeMultiplier: 2
            color: "#666"
        }
    }

    Item {
        id: controlContainer
        anchors {
            fill: parent
        }

        // Control views are dynamically placed inside this container
    }

    DisconnectedOverlay {
        visible: platformStack.connected === false
    }

    function initialize() {
        if (controlLoaded === false){
            // When we reconnect the board, the view has already been registered, so we can immediately load the control
            if (sdsModel.resourceLoader.isViewRegistered(platformStack.class_id)) {
                if (sdsModel.resourceLoader.getVersionRegistered(platformStack.class_id) !== controlViewContainer.staticVersion) {
                    usingStaticView = false;
                }
                loadControl()
            } else {
                loadingBarContainer.visible = true;
                loadingBar.value = 0.01;

                // Try to load static resource, otherwise move to OTA logic
                if (getStaticResource() === false) {
                    usingStaticView = false;
                    getOTAResource();
                }
            }
        }
    }

    /*
      Loads Control.qml from the installed resource file into controlContainer
    */
    function loadControl () {
        let version = controlViewContainer.staticVersion
        if (usingStaticView === false) {
            let installedVersionIndex = controlViewList.getInstalledVersion();
            version = controlViewList.version(installedVersionIndex);
        }

        let control_filepath = NavigationControl.getQMLFile("Control", platformStack.class_id, version)

        // Set up context for control object creation
        Help.setClassId(platformStack.device_id)
        NavigationControl.context.class_id = platformStack.class_id
        NavigationControl.context.device_id = platformStack.device_id

        let control_obj = sdsModel.resourceLoader.createViewObject(control_filepath, controlContainer);

        // Tear Down creation context
        delete NavigationControl.context.class_id
        delete NavigationControl.context.device_id

        if (control_obj === null) {
            createErrorScreen("Could not load file: " + control_filepath)
        } else {
            controlLoaded = true
        }
        loadingBarContainer.visible = false;
        loadingBar.value = 0.0;
    }

    /*
        Try to find/register a static resource file
        Todo: remove this when fully OTA
    */
    function getStaticResource() {
        if (UuidMap.uuid_map.hasOwnProperty(platformStack.class_id)){
            let name = UuidMap.uuid_map[platformStack.class_id];
            let RCCpath = sdsModel.resourceLoader.getStaticResourcesString() + "/views-" + name + ".rcc"

            usingStaticView = true
            if (registerResource(RCCpath, controlViewContainer.staticVersion)) {
                return true;
            } else {
                removeControl() // registerResource() failing creates an error screen, kill it to show OTA progress bar
                usingStaticView = false
            }
        }
        return false
    }

    /*
        Try to find an installed OTA resource file and load it, otherwise download newest version
    */
    function getOTAResource() {
        // Find index of any installed version
        let installedVersionIndex = controlViewList.getInstalledVersion();

        if (installedVersionIndex >= 0) {
            registerResource(controlViewList.filepath(installedVersionIndex), controlViewList.version(installedVersionIndex))
        } else {
            let latestVersionindex = controlViewList.getLatestVersion();

            if (controlViewList.uri(latestVersionindex) === "" || controlViewList.md5(latestVersionindex) === "") {
                createErrorScreen("Found no local control view and none for download.")
                return
            }

            let downloadCommand = {
                "hcs::cmd": "download_view",
                "payload": {
                    "url": controlViewList.uri(latestVersionindex),
                    "md5": controlViewList.md5(latestVersionindex),
                    "class_id": platformStack.class_id
                }
            };

            activeDownloadUri = controlViewList.uri(latestVersionindex)

            coreInterface.sendCommand(JSON.stringify(downloadCommand));
        }
    }

    /*
      Installs new resource file and loads it, cleans up old versions
    */
    function installResource(newVersion, newPath) {
        removeControl();

        if (newVersion !== "") {
            for (let i = 0; i < controlViewListCount; i++) {
                if (controlViewList.version(i) === newVersion) {
                    controlViewList.setInstalled(i, true);
                    controlViewList.setFilepath(i, newPath);
                } else if (controlViewList.version(i) !== newVersion && controlViewList.installed(i) === true) {
                    controlViewList.setInstalled(i, false);
                    let versionToRemove = {
                        "version": controlViewList.version(i),
                        "filepath": controlViewList.filepath(i)
                    }
                    otaVersionsToRemove.push(versionToRemove);
                }
            }
            usingStaticView = false;

            if (platformStack.connected) {
                // Can update from software mgmt while not connected, but don't want to create control view
                registerResource(newPath, newVersion);
            }

            cleanUpResources()
        } else {
            createErrorScreen("No version number found for install")
        }
    }

    /*
      Unregister and delete all resources that are not the new installed one
    */
    function cleanUpResources() {
        // Remove any static resources if available
        if (UuidMap.uuid_map.hasOwnProperty(platformStack.class_id)) {
            let name = UuidMap.uuid_map[platformStack.class_id];
            let RCCpath = sdsModel.resourceLoader.getStaticResourcesString() + "/views-" + name + ".rcc"
            sdsModel.resourceLoader.requestDeleteViewResource(platformStack.class_id, RCCpath, controlViewContainer.staticVersion, controlContainer);
        }

        for (let i = 0; i < otaVersionsToRemove.length; i++) {
            sdsModel.resourceLoader.requestDeleteViewResource(platformStack.class_id, otaVersionsToRemove[i].filepath, otaVersionsToRemove[i].version, controlContainer);
        }

        otaVersionsToRemove = []
    }

    /*
      Removes the control view from controlContainer
    */
    function registerResource (filepath, version) {
        let success = sdsModel.resourceLoader.registerControlViewResource(filepath, platformStack.class_id, version);
        if (success) {
            loadingBar.value = 1.0
            loadControl()
        } else {
            createErrorScreen("Failed to find or load control view resource file: " + filepath)
        }
        return success
    }

    /*
      Removes the control view from controlContainer
    */
    function removeControl () {
        if (controlLoaded) {
            for (let i = 0; i < controlContainer.children.length; i++) {
                controlContainer.children[i].destroy();
            }
            controlLoaded = false
        }
    }

    /*
      Populates controlContainer with an error string
    */
    function createErrorScreen(errorString) {
        removeControl();
        sdsModel.resourceLoader.createViewObject(NavigationControl.screens.LOAD_ERROR, controlContainer, {"error_message": errorString});
        controlLoaded = true
    }

    Connections {
        id: coreInterfaceConnections
        target: sdsModel.coreInterface

        onDownloadViewFinished: {
            if (payload.url === activeDownloadUri) {
                activeDownloadUri = ""

                if (payload.error_string.length > 0) {
                    controlViewContainer.createErrorScreen(payload.error_string);
                    return
                }

                for (let i = 0; i < controlViewContainer.controlViewListCount; i++) {
                    if (controlViewContainer.controlViewList.uri(i) === payload.url) {
                        installResource(controlViewContainer.controlViewList.version(i), payload.filepath)
                        break;
                    }
                }
            }
        }

        onDownloadControlViewProgress: {
            if (payload.url === activeDownloadUri) {
                let percent = payload.bytes_received / payload.bytes_total;
                if (percent !== 1.0) {
                    loadingBar.value = percent
                }
            }
        }
    }
}

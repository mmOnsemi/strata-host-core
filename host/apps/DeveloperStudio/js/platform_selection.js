.pragma library
.import "navigation_control.js" as NavigationControl
.import "uuid_map.js" as UuidMap
.import "qrc:/js/platform_filters.js" as PlatformFilters

.import tech.strata.logger 1.0 as LoggerModule

var isInitialized = false
var coreInterface
var documentManager
var platformViewModel
var listError = {
    "retry_count": 0,
    "retry_timer": Qt.createQmlObject("import QtQuick 2.12; Timer {interval: 3000; repeat: false; running: false;}",Qt.application,"TimeOut")
}
var platformListModel
var platformMap = {}
var autoConnectEnabled = true
var previouslyConnected = []

function initialize (newCoreInterface, newDocumentManager, newPlatformViewModel) {
    platformListModel = Qt.createQmlObject("import QtQuick 2.12; ListModel {property int currentIndex: 0; property string platformListStatus: 'loading'}",Qt.application,"PlatformListModel")
    coreInterface = newCoreInterface
    documentManager = newDocumentManager
    platformViewModel = newPlatformViewModel
    listError.retry_timer.triggered.connect(function () { getPlatformList() });
    isInitialized = true
}

/*
    Generate model from incoming platform list
*/
function populatePlatforms(platform_list_json) {
    platformListModel.clear()
    platformMap = {}
    let platform_list

    // Parse JSON
    try {
        platform_list = JSON.parse(platform_list_json)
    } catch(err) {
        console.error(LoggerModule.Logger.devStudioPlatformSelectionCategory, "Error parsing platform list:", err.toString())
        platformListModel.clear()
        platformListModel.platformListStatus = "error"
    }

    if (platform_list.list.length < 1) {
        // empty list received from HCS, retry getPlatformList() query
        emptyListRetry()
        return
    }
    listError.retry_count = 0

    PlatformFilters.initialize()

    console.log(LoggerModule.Logger.devStudioPlatformSelectionCategory, "Processing platform list");
    let index = 0
    for (let platform of platform_list.list){
        platform.error = false

        if (platform.class_id === undefined) {
            console.error(LoggerModule.Logger.devStudioPlatformSelectionCategory, "Platform class_id undefined, skipping");
            continue
        }

        let class_id_string = String(platform.class_id)

        if (platform.hasOwnProperty("available") === false) {
            console.error(LoggerModule.Logger.devStudioPlatformSelectionCategory, "'available' field missing for class id", platform.class_id, ", skipping");
            continue
        }
        platform.connected = false

        if (UuidMap.uuid_map.hasOwnProperty(class_id_string)) {
            platform.name = UuidMap.uuid_map[class_id_string]   // fetch directory name used to bring up the UI
        } else {
            if (platform.available.control){
                console.error(LoggerModule.Logger.devStudioPlatformSelectionCategory, "Control 'available' flag set but no mapped UI for this class_id; overriding to deny access");
                platform.available.control = false
            }
        }

        // Parse list of text filters and gather complete filter info from PlatformFilters
        if (platform.hasOwnProperty("filters")) {
            let filterModel = []
            for (let filter of platform.filters) {
                let filterListItem = PlatformFilters.findFilter(filter)
                if (filterListItem) {
                    filterModel.push(filterListItem)
                } else {
                    console.warn(LoggerModule.Logger.devStudioPlatformSelectionCategory, "Ignoring unimplemented filter:", filter);
                }
            }
            platform.filters = filterModel
        } else {
            platform.filters = []
        }

        // Add to the model
        platformListModel.append(platform)

        // Create entry in platformMap
        platformMap[class_id_string] = {
            "index": index,
            "ui_exists": (platform.name !== undefined),
            "available": platform.available
        }
        index++
    }

    parseConnectedPlatforms(coreInterface.connected_platform_list_)
    platformListModel.platformListStatus = "loaded"
}

/*
    Determine platform connection changes and update model accordingly.
    Generate listings for unlisted/unknown platforms.
*/
function parseConnectedPlatforms (connected_platform_list_json) {
    // Build next 'previouslyConnected' list
    let currentlyConnected = []
    let connected_platform_list

    try {
        connected_platform_list = JSON.parse(connected_platform_list_json)
    } catch(err) {
        console.error(LoggerModule.Logger.devStudioPlatformSelectionCategory, "Error parsing connected platforms list:", err.toString())
        return
    }

    for (let platform of connected_platform_list.list) {
        if (platform.class_id === undefined) {
            console.error(LoggerModule.Logger.devStudioPlatformSelectionCategory, "Connected platform has undefined class_id, skipping")
            continue
        }
        let class_id_string = String(platform.class_id);
        currentlyConnected.push(class_id_string)

        // Determine if platform exists in model or if unlisted/unrecognized
        if (platformMap.hasOwnProperty(class_id_string)) {
            if (previouslyConnected.includes(class_id_string)) {
                // platform previously connected: keep status, remove from previouslyConnected list
                previouslyConnected.splice(previouslyConnected.indexOf(class_id_string), 1);
            } else {
                // update model
                let index = platformMap[class_id_string].index
                if (platformMap[class_id_string].available.unlisted) {
                    let available = Object.assign({}, platformMap[class_id_string].available) // make copy - don't modify original 'available' state
                    available.unlisted = false // override to show hidden listing when physical board present
                    platformListModel.get(index).available = available
                }
                platformListModel.get(index).connected = true

                if (platformMap[class_id_string].ui_exists && platformListModel.get(index).available.control) {
                    autoConnect(class_id_string)
                }
            }
        } else if (class_id_string !== "undefined" && UuidMap.uuid_map.hasOwnProperty(class_id_string)) {
            // unlisted platform connected: no entry in DP platform list, but UI found in UuidMap
            console.log(LoggerModule.Logger.devStudioPlatformSelectionCategory, "Unlisted platform connected:", class_id_string);
            insertUnlistedListing(platform)
            autoConnect(class_id_string)
        } else {
            // connected platform class_id not listed in UuidMap or DP platform list, or undefined
            console.log(LoggerModule.Logger.devStudioPlatformSelectionCategory, "Unknown platform connected:", class_id_string);
            insertUnknownListing(platform)
        }
    }

    // Clean up disconnected platforms remaining in previouslyConnected, restore model state
    for (let class_id of previouslyConnected) {
        let index = platformMap[class_id].index
        if (platformListModel.get(index).error) {
            // Remove listings for unlisted/unknown boards
            delete platformMap[class_id]
            platformListModel.remove(index)
        } else {
            // Restore original disconnected state
            platformListModel.get(index).available = platformMap[class_id].available
            platformListModel.get(index).connected = false
        }

        let data = {"class_id": class_id}
        NavigationControl.updateState(NavigationControl.events.PLATFORM_DISCONNECTED_EVENT, data)
    }

    previouslyConnected = currentlyConnected
}

function selectPlatform(class_id){
    let index = platformMap[String(class_id)].index
    let data = { "class_id": class_id, "name": platformListModel.get(index).verbose_name, "available": platformListModel.get(index).available }
    if (platformListModel.get(index).connected && platformMap[String(class_id)].ui_exists && platformListModel.get(index).available.control) {
        NavigationControl.updateState(NavigationControl.events.PLATFORM_CONNECTED_EVENT,data)
    } else { // no connection or no UI exists
        NavigationControl.updateState(NavigationControl.events.VIEW_COLLATERAL_EVENT, data)
    }
}

function autoConnect(class_id) {
    if (autoConnectEnabled) {
        selectPlatform(class_id)
    }
}

function getPlatformList () {
    platformListModel.platformListStatus = "loading"
    const get_dynamic_plat_list = {
        "hcs::cmd": "dynamic_platform_list",
        "payload": {}
    }
    coreInterface.sendCommand(JSON.stringify(get_dynamic_plat_list));
}

function emptyListRetry() {
    if (listError.retry_count < 3) {
        console.error(LoggerModule.Logger.devStudioPlatformSelectionCategory, "Received empty platform list from HCS, will retry in 3 seconds")
        listError.retry_count++
        listError.retry_timer.start()
    } else if (listError.retry_count < 8) {
        console.error(LoggerModule.Logger.devStudioPlatformSelectionCategory, "Received empty platform list from HCS, will retry in 10 seconds")
        listError.retry_timer.interval = 10000
        listError.retry_count++
        listError.retry_timer.start()
    } else {
        console.error(LoggerModule.Logger.devStudioPlatformSelectionCategory, "HCS failed to supply valid list, displaying error.")
        platformListModel.platformListStatus = "error"
    }
}

function insertUnknownListing (platform) {
    let platform_info = {
        "verbose_name" : "Unknown Platform",
        "class_id" : platform.class_id,
        "opn": "Class id: " + platform.class_id,
        "description": "Strata does not recognize this class_id. Updating Strata may fix this problem.",
        "available": { "control": false, "documents": false, "unlisted": false, "order": false},  // Don't allow control or docs for unknown platform
        "filters":[],
        "connected": true,
        "error": true
    }
    platformListModel.append(platform_info)

    // create entry in platformMap
    platformMap[String(platform_info.class_id)] = {
        "index": platformListModel.count - 1,
        "ui_exists": false
    }
}

function insertUnlistedListing (platform) {
    let class_id_string = String(platform.class_id)

    let platform_info = {
        "verbose_name" : "Unknown Platform",
        "class_id" : platform.class_id,
        "opn": "Class id: " + platform.class_id,
        "description": "No information to display.",
        "image": "", // Assigns 'not found' image
        "available": { "control": true, "documents": true, "unlisted": false, "order": false},  // If UI exists and customer has physical platform, allow access
        "filters":[],
        "name": UuidMap.uuid_map[class_id_string],
        "connected": true,
        "error": true,
    }
    platformListModel.append(platform_info)

    // create entry in platformMap
    platformMap[class_id_string] = {
        "index": platformListModel.count - 1,
        "ui_exists": true
    }
}

function logout() {
    platformListModel.platformListStatus = "loading"
    platformListModel.clear()
    platformMap = {}
    previouslyConnected = []
}

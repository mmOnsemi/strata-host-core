.pragma library
.import QtQuick 2.0 as QtQuickModule


/*
    Data that will likely be needed for platform views
*/
var context = {
    "control_qml" : "",
    "user_id" : "",
    "platform_name" : "",
    "is_logged_in" : "false",
    "platform_state" : ""
}
/*
  Mapping of verbose_name to file directory structure.
*/

var screens = {
    LOGIN_SCREEN: "qrc:/SGLoginScreen.qml",
    WELCOME_SCREEN : "qrc:/SGWelcome.qml",
    CONTENT_SCREEN : "qrc:/Content.qml",
    STATUS_BAR:     "qrc:/SGStatusBar.qml"
}

var components = {
    METRICS: "qrc:/SGMetrics.qml"
}

/*
  All states handled by navigation_state_
*/
var states = {

    UNINITIALIZED: 1,       // Init() has not been called
    LOGIN_STATE: 2,         // User needs to login
    CONTROL_STATE: 3,       // Platform is connected and we are ready for control
}

/*
    All events to handle by navigation state machine
*/
var events = {
    PROMPT_LOGIN_EVENT:             1,
    LOGIN_SUCCESSFUL_EVENT:         2,
    LOGOUT_EVENT:                   3,
    PLATFORM_CONNECTED_EVENT:       4,
    PLATFORM_DISCONNECTED_EVENT:    5,
    SHOW_CONTROL_EVENT:             6,
    OFFLINE_MODE_EVENT:             7,
    NEW_PLATFORM_CONNECTED_EVENT:   8,
    TOGGLE_CONTROL_CONTENT:         9,
}

/*
 Navigation Members
*/
var navigation_state_ = states.UNINITIALIZED
var control_container_ = null
var content_container_ = null
var status_bar_container_ = null
var metrics = null
var flipable_parent_= null

/*
    Retrieve the qml file in the templated file structure
*/
var PREFIX = "qrc:/views/"
function getQMLFile(platform_name, filename) {
    console.log(platform_name, "-", filename, "qml file requested.")

    // Build the file name - ./view/<platform_name>/filename.qml
    if (filename.search(".qml") < 0){
        console.log("adding extension to filename: ", filename)
        filename = filename + ".qml"
    }

    var qml_file_name = PREFIX + platform_name + "/" + filename
    console.log("Locating at ", qml_file_name)

    return qml_file_name
}

/*
  Navigation must be initialized with parent container
  that will hold control views
*/
function init(flipable_parent, control_parent, content_parent, bar_parent)
{
    // Create metrics object to track usage
    metrics = createView(components.METRICS, null);

    flipable_parent_    = flipable_parent
    control_container_ = control_parent
    content_container_ = content_parent
    status_bar_container_ = bar_parent
    updateState(events.PROMPT_LOGIN_EVENT)
}

/*
  Dynamically load qml controls by qml filename
*/
function createView(name, parent)
{
    console.log("createObject: name =", name, ", parameters =", JSON.stringify(context))

    var component = Qt.createComponent(name, QtQuickModule.Component.PreferSynchronous, parent);

    if (component.status === QtQuickModule.Component.Error) {
        console.log("ERROR: Cannot createComponent(", name, "), parameters=", JSON.stringify(context));
    }

    // TODO[Abe]: store this globally for later destroying
    var object = component.createObject(parent,context)
    if (object === null) {
        console.log("Error creating object: name=", name, ", parameters=", JSON.stringify(context));
    }



    return object;
}

/*
  Remove first child from a view
*/
function removeView(parent)
{
    console.log("destroying view: ", parent.children[0])
    parent.children[0].destroy()
}
/*
  a catch-all for events that are required to be handled regardless of state
*/
function globalState(event,data)
{

    switch(event)
    {
    case events.PROMPT_LOGIN_EVENT:
        console.log("Updated state to Login:", states.LOGIN_STATE)
        navigation_state_ = states.LOGIN_STATE

        // Update both containers; Login blocks both
        createView(screens.LOGIN_SCREEN, control_container_)
        createView(screens.LOGIN_SCREEN, content_container_)

        // Remove StatusBar at Login
        removeView(status_bar_container_)
        break;

    case events.LOGOUT_EVENT:
        context.is_logged_in = false;

        // Show Login Screen
        console.log("Logging user out. Displaying Login screen")
        updateState(events.PROMPT_LOGIN_EVENT)
        break;

    case events.NEW_PLATFORM_CONNECTED_EVENT:
        // Cache platform name until we are ready to view
        console.log("Platform connected. Caching platform: ", data.platform_name)
        context.platform_name = data.platform_name
        context.platform_state = true;
        break;

    case events.PLATFORM_DISCONNECTED_EVENT:
        // Disconnected
        console.log("Platform disconnected")
        context.platform_state = false;
        break;
    default:
        console.log("Unhandled signal, ", event, " in state ", navigation_state_)
        break;
    }
}

/*
  Navigator state machine
*/
function updateState(event)
{
    updateState(event,null)
}

function updateState(event, data)
{
    console.log("Received event: ", event)

    switch(navigation_state_){
        case states.UNINITIALIZED:
            switch(event)
            {

            default:
                globalState(event,data)
            break;
            }

        break;

        case states.LOGIN_STATE:
            switch(event)
            {
            case events.LOGIN_SUCCESSFUL_EVENT:
                context.user_id = data.user_id
                context.is_logged_in = true;
                navigation_state_ = states.CONTROL_STATE

                // Update StatusBar
                createView(screens.STATUS_BAR, status_bar_container_)
                // Update Control by next state
                updateState(events.SHOW_CONTROL_EVENT,null)
            break;

            default:
                globalState(event,data)
            break;

            }
        break;
        case states.CONTROL_STATE:
            switch(event)
            {
            case events.SHOW_CONTROL_EVENT:
                // Refresh Control View based on conditions
                if (context.platform_state){
                    // Show control when connected
                    var qml_control = getQMLFile(context.platform_name, "Control")
                    createView(qml_control, control_container_)
                    metrics.restartCounter()
                }
                else {
                    // Disconnected; Show detection page
                    createView(screens.WELCOME_SCREEN, control_container_)

                }

                // Show content when we have a platform name; doesn't have to be actively connected
                if(context.platform_name !== ""){
                    var qml_content = getQMLFile(context.platform_name, "Content")
                    var contentObject = createView(qml_content, content_container_)
                    // Insert Listener
                    injectEventToTree(contentObject)
                    metrics.restartCounter()

                }
                else {
                    // Otherwise; no platform has been connected or chosen
                    createView(screens.WELCOME_SCREEN, content_container_)
                }

                break;

            case events.NEW_PLATFORM_CONNECTED_EVENT:
                // Cache platform name until we are ready to view
                console.log("data:", data.platform_name)
                context.platform_name = data.platform_name
                context.platform_state = true;
                // Refresh
                updateState(events.SHOW_CONTROL_EVENT)
                break;

            case events.PLATFORM_CONNECTED_EVENT:
                context.platform_state = true;
                updateState(events.SHOW_CONTROL_EVENT)
                break;

            case events.PLATFORM_DISCONNECTED_EVENT:
                context.platform_state = false;
                // Refresh
                updateState(events.SHOW_CONTROL_EVENT)
                break;

            case events.OFFLINE_MODE_EVENT:
                // Offline mode just keeps platform_state as false
                console.log("Entering offline mode for ", data.platform_name)
                context.platform_name = data.platform_name
                context.platform_state = false;
                updateState(events.SHOW_CONTROL_EVENT)
                break;
            case events.TOGGLE_CONTROL_CONTENT:
                //send request to metrics service when entering and leaving platfrom coontrol view
                var pageName = '';
                if(flipable_parent_.flipped===false){
                    console.log("in fplipable ",context.platform_name)
                    pageName = context.platform_name +' Control'
                }else {
                    var currentTabName = metrics.getCurrentTab()
                    pageName = context.platform_name +' '+ currentTabName
                }

                metrics.sendMetricsToCloud(pageName)

                // Flip to show control/content
                flipable_parent_.flipped = !flipable_parent_.flipped

                break;
            default:
                globalState(event,data)
            break;
            }
        break;

        default:
            globalState(event,data)
            break;

    }
}

/*
    Metrics Code
*/

//Iterate through qml objects tree and invoke add custom function to listen on events
function injectEventToTree(obj) {

    // inject custom function to all children that has onCurrentIndexChanged event
    if(qmltypeof(obj,"QQuickTabBar")){
        Object.defineProperty(obj, 'onCurrentIndexChangedlListenerFunction', { value: createListenerFunction(obj) })
        obj.onCurrentIndexChanged.connect(obj.onCurrentIndexChangedlListenerFunction);

        //TODO: Add a listener to get tababr button's name at index 0
        //Object.defineProperty(obj, 'onCompletedListenerFunction', { value: onTabBarCompletedListenerFunction(obj) })
        //obj.Component.onCompleted.connect(obj.onCompletedListenerFunction);

    }

    if (obj.children) {

        for (var i = 0; i < obj.children.length; i++) {
            injectEventToTree(obj.children[i])
        }
        if(obj.children.length > 100){
            console.log("WARNING: QML object children exceeds 100.")
        }
    }
}

// return a listener function that will be invoked on the tabbar change event
function createListenerFunction(object) {
    return function() { metrics.onCurrentIndexChange(object, arguments) }
}
function onTabBarCompletedListenerFunction(object) {

    return function() { metrics.tabBarCompleted(object, arguments) }
}
// given qml object and name, it check whether name is matching object type
function qmltypeof(obj, className) {
  var str = obj.toString();
  return str.indexOf(className + "(") === 0 || str.indexOf(className + "_QML") === 0;
}


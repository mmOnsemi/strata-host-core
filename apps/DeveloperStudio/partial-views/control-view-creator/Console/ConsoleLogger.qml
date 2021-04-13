import QtQuick 2.12
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.12
import QtQml 2.12

import tech.strata.sgwidgets 1.0
import tech.strata.commoncpp 1.0

import "ConsoleMessages"

Item {
    id: root
    width: parent.width
    height: parent.height

    property double fontMultiplier: 1.0
    property string searchText: ""

    onFontMultiplierChanged: {
        if(fontMultiplier >= 2.5){
            fontMultiplier = 2.5
        } else if(fontMultiplier <= 0.8){
            fontMultiplier = 0.8
        }
    }

    onSearchTextChanged: {
        consoleItems.invalidate()
        consoleLogs.deselectAll()
    }

    ListView {
        id: consoleLogs
        anchors.fill: parent
        model: consoleItems
        clip: true
        spacing: 0

        property int indexDragStarted: -1
        property bool selecting: false
        property bool isActiveSelecting: false

        signal selectInBetween(int indexDragEnded)
        signal deselectAll()

        onDeselectAll: {
            for (var i = 0; i < consoleModel.count; i++) {
                consoleModel.get(i).state = "noneSelected"
            }
        }

        onSelectInBetween: {
            var start
            var end
            if (indexDragEnded > indexDragStarted) {
                start = indexDragStarted + 1
                end = indexDragEnded
            } else {
                start = indexDragEnded + 1
                end = indexDragStarted
            }

            for (var i = 0; i < consoleLogs.model.count; i++) {
                var listElement = consoleModel.get(consoleLogs.model.mapIndexToSource(i));
                if (i >= start && i < end) {
                    listElement.state = "allSelected"
                } else if (i < start - 1 || i > end) {
                    listElement.state = "noneSelected"
                }
            }
        }

        function logAdded() {
            // if user is at end of list +/- 10px, scroll to end of list to focus on new logs
            if (contentY >= (contentHeight - height) - 10){
                positionViewAtEnd()
            }
        }

        ScrollBar.vertical: ScrollBar {
            active: true
        }

        delegate: Item  {
            id: consoleDelegate
            height: consoleMessage.height
            width: consoleLogs.width

            Component.onCompleted: {
                state = Qt.binding(function() { return model.state })
            }

            function startSelection(mouse) {
                consoleLogs.indexDragStarted = index
                model.state = "someSelected"
                var composedY = -(consoleDelegate.y - mouse.y - consoleDelegate.ListView.view.contentY) - consoleMessage.y
                var composedX = mouse.x - consoleMessage.x
                dropArea.start = consoleMessage.positionAt(composedX, composedY)
            }

            states: [
                State {
                    name: "noneSelected"
                    StateChangeScript {
                        script: {
                            consoleMessage.deselect()
                            dropArea.start = -1
                        }
                    }
                },
                State {
                    name: "someSelected"
                    StateChangeScript {
                        script: {
                            if (model.selectionStart !== consoleMessage.selectionStart || model.selectionEnd !== consoleMessage.selectionEnd) {
                                consoleMessage.select(model.selectionStart, model.selectionEnd);
                            }
                        }
                    }
                },
                State {
                    name: "allSelected"
                    StateChangeScript {
                        script: consoleMessage.selectAll()
                    }
                }
            ]

            ConsoleTime {
                id: consoleTime
                time: model.time
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: 5
                current: model.current
            }

            ConsoleTypes {
                id: consoleTypes
                type: model.type
                anchors.left: consoleTime.right
                anchors.top: parent.top
                anchors.leftMargin: 5
                current: model.current
            }

            ConsoleMessage {
                id: consoleMessage
                text: model.msg
                anchors.top: parent.top
                anchors.left: consoleTypes.right
                anchors.right: parent.right
                anchors.leftMargin: 10
                current: model.current
            }

            DropArea {
                id: dropArea
                anchors {
                    fill: consoleMessage
                }
                property int start:-1
                property int end:-1

                onEntered: {
                    if (index > consoleLogs.indexDragStarted) {
                        start = 0
                    } else if (index < consoleLogs.indexDragStarted){
                        start = consoleMessage.length
                    }

                    model.state = "someSelected"
                    consoleLogs.selectInBetween(index)
                }

                onPositionChanged: {
                    end = consoleMessage.positionAt(drag.x, drag.y)
                    consoleMessage.select(start, end)
                }
            }

            Connections {
                target: consoleLogs
                onSelectInBetween:{
                    // covers case where drag hasn't triggered before leaving first delegate
                    if (index === consoleLogs.indexDragStarted) {
                        if (indexDragEnded > consoleLogs.indexDragStarted) {
                            dropArea.end = consoleMessage.length
                            consoleMessage.select(dropArea.start, dropArea.end)
                        } else if (indexDragEnded < consoleLogs.indexDragStarted) {
                            dropArea.end = 0
                            consoleMessage.select(dropArea.start, dropArea.end)
                        }
                    }
                }
            }
        }

        MouseArea {
            id: consoleMouseArea
            anchors.fill: consoleLogs
            drag.target: dragitem
            cursorShape: Qt.IBeamCursor
            propagateComposedEvents: true

            onPressed:{
                consoleLogs.deselectAll()
                var clickedDelegate = consoleLogs.itemAt(mouse.x + consoleLogs.contentX, mouse.y + consoleLogs.contentY)
                if (clickedDelegate) {
                    clickedDelegate.startSelection(mouse)
                } else {
                    consoleLogs.indexDragStarted = consoleLogs.model.count
                }
                consoleLogs.forceActiveFocus()
            }

            onClicked: {
                consoleLogs.deselectAll()
            }

            onDoubleClicked: {
                consoleLogs.deselectAll()
                var clickedIndex = consoleLogs.indexAt(mouse.x + consoleLogs.contentX, mouse.y + consoleLogs.contentY)
                if (clickedIndex > -1) {
                    consoleModel.get(consoleItems.mapIndexToSource(clickedIndex)).state = "allSelected"
                }
            }

            onPositionChanged: {
                // Scroll up or down to select more when user is close to edges of list
                if (consoleMouseArea.pressed) {
                    if (mouse.y > consoleMouseArea.height * .95) {
                        consoleLogs.flick(0, -200)
                    } else if (mouse.y < consoleMouseArea.height * .05 && consoleLogs.contentY > 0) {
                        consoleLogs.flick(0, 200)
                    }
                }
            }
        }

        Item {
            id: dragitem
            x: consoleMouseArea.mouseX
            y: consoleMouseArea.mouseY
            width: 1
            height: 1
            Drag.active: consoleMouseArea.drag.active
            Component.onCompleted: dragitem.parent = consoleMouseArea
        }
    }

    SGSortFilterProxyModel {
        id: consoleItems
        sourceModel: consoleModel
        sortEnabled: true
        invokeCustomFilter: true

        function filterAcceptsRow(row){
            var item = sourceModel.get(row)
            return containsFilterText(item)
        }

        function containsFilterText(item){
            if(searchText === ""){
                return true
            } else {
                var searchMsg = item.time  + ` [ ${item.type} ] ` + item.msg
                if(searchBox.useCase) {
                    if(searchMsg.includes(searchText)){
                        return true
                    } else {
                        return false
                    }
                }
                if(searchMsg.toLowerCase().includes(searchText.toLowerCase())){
                    return true
                } else {
                    return false
                }
            }
        }
    }

    ListModel {
        id: consoleModel
    }

    Connections {
        id: srcConnection
        target: logger
        onLogMsg: {
            if(controlViewCreatorRoot.visible){
                if(consoleModel.count > 0 && recompileRequested){
                    for (var i = 0; i < consoleModel.count; i++){
                        consoleModel.get(i).current = false
                    }
                }

                consoleModel.append({
                                        time: timestamp(),
                                        type: getMsgType(type),
                                        msg: msg,
                                        current: true,
                                        state: "noneSelected",
                                        selection: "",
                                        selectionStart: 0,
                                        selectionEnd: 0
                                    })

                consoleLogs.logAdded()

                if(type === 1){
                    warningCount += 1
                }
                if(type === 2){
                    errorCount += 1
                }
            }
        }
    }

    function getMsgType(type){
        switch(type){
        case 0: return "debug"
        case 1: return "warning"
        case 2: return "error"
        case 4: return "info"
        }
    }

    function timestamp(){
        var date = new Date(Date.now())
        let hours = date.getHours()
        let minutes = date.getMinutes()
        let seconds = date.getSeconds()
        let millisecs = date.getMilliseconds()

        if(hours < 10){
            hours = `0${hours}`
        }

        if(minutes < 10){
            minutes = `0${minutes}`
        }

        if(seconds < 10){
            seconds = `0${seconds}`
        }

        if(millisecs < 100){
            if(millisecs < 10){
                millisecs =`00${millisecs}`
            } else {
                millisecs = `0${millisecs}`
            }
        }

        return `${hours}:${minutes}:${seconds}.${millisecs}`
    }

    function clearLogs() {
        consoleModel.clear();
        errorCount = 0
        warningCount = 0
    }
}
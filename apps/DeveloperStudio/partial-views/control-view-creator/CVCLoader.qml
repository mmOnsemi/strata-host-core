import QtQuick 2.12
import QtQuick.Layouts 1.3

import "qrc:/partial-views/control-view-creator"
import "qrc:/js/navigation_control.js" as NavigationControl
import tech.strata.signals 1.0

Loader {
    id: cvcLoader
    Layout.fillHeight: true
    Layout.fillWidth: true
    active: false

    property bool cvcCloseRequested: false
    property bool cvcLoggingOut: false

    sourceComponent: ControlViewCreator {
        id: controlViewCreator
    }

    Connections {
        target: Signals

        onLoadCVC: {
            cvcLoader.active = true
            let data = {"index": NavigationControl.stack_container_.count-1}
            NavigationControl.updateState(NavigationControl.events.SWITCH_VIEW_EVENT, data)
        }

        onRequestClose: {
            if (cvcLoader.active) {
                cvcLoader.cvcCloseRequested = true
                cvcLoggingOut = isLoggingOut
                Signals.blockingFromCVC(true)
                if (cvcLoader.item.blockWindowClose() === false) {
                    Signals.closeCVC(isLoggingOut)
                }
            } else {
               Signals.closeCVC(isLoggingOut)
            }
        }

        onCloseCVC: {
            Signals.blockingFromCVC(false)
            cvcLoader.cvcCloseRequested = false
            cvcLoader.active = false
            let data = {"index": NavigationControl.stack_container_.count-2}
            NavigationControl.updateState(NavigationControl.events.SWITCH_VIEW_EVENT, data)
        }
    }
}

    LayoutButton { // start_%1
        id: button_%1
        layoutInfo.uuid: "%1"
        layoutInfo.columnsWide: 5
        layoutInfo.rowsTall: 2
        layoutInfo.xColumns: 0
        layoutInfo.yRows: 0

        // start_user_content
        onClicked: {
            console.log("Clicked:", objectName, layoutInfo.uuid)
        }
        // end_user_content
    } // end_%1

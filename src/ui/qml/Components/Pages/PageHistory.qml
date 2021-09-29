import QtQuick
import QtQuick.Controls

import "../Dialogs" as Dialogs
import "../Delegates" as Delegates
import "../Custom" as Custom

Page {
    id: pageHistory

    SwitchDelegate {
        id: switchDelegateFilters

        x: 10
        y: 10
        text: qsTr("Filters")
        onClicked: {
            if (!checked) {
                console.log("Clear and add all transactions...")
                //modelTransactions.clear()
                //modelTransactions.addMultipleTransactions(historyManager.getTransactions())
            }
            else {
                console.log("Clear and add filtered transactions...")
                //modelTransactions.clear()
                //modelTransactions.addMultipleTransactions(historyManager.getTransactionsWithFilters())
            }
        }
    }
    Button {
        id: buttonFilters

        x: switchDelegateFilters.x + switchDelegateFilters.width + 10
        y: switchDelegateFilters.y + (switchDelegateFilters.height - height)/2
        enabled: switchDelegateFilters.checked
        flat: true
        highlighted: true
        text: qsTr("Select filters")

        onClicked: {
            console.log("Opening filters...")
            //toolTipFilters.open()
        }
    }


    ListView {
        id: listTransactions

        y: switchDelegateFilters.y + switchDelegateFilters.height + 10
        width: parent.width
        height: parent.height - y
        clip: true
        model: modelTransactions

        delegate: Delegates.DelegateHistoryList {
            width: parent.width

            onClicked: {
                console.log("Opening transaction details")
                //dialogTransactionDetails.open()
                listTransactions.currentIndex = index
            }
        }

        ScrollBar.vertical: Custom.CustomScrollBar {}
    }

    // TODO: Implement in the backend
    ListModel {
        id: modelTransactions
        // Model type: Send, Receive
        // Model status: Confirmed, Pending, Preview
        ListElement { date: "24-02-2002 05:34"; type: 0; status: 0; amount: 10; hoursTraspassed: 200; hoursBurned: 150; transactionID: "2b37e0f7d8c26b"; addresses: "hd763jakcc63sj,hs6283hhhet,8dh272odnndmgu" }
        ListElement { date: "15-12-2004 16:23"; type: 1; status: 2; amount: 14; hoursTraspassed: 315; hoursBurned: 150; transactionID: "7aueakjshduaww"; addresses: "adhkuawykd7wud,snajgbdjawy,bjasgydjawydsw" }
        ListElement { date: "30-01-2015 11:08"; type: 1; status: 0; amount: 22; hoursTraspassed: 502; hoursBurned: 150; transactionID: "kmaueyiawudsah"; addresses: "kjshcnawunkjas,kjashdkuwau,kajsdnkuawdjss" }
        ListElement { date: "01-08-2021 15:00"; type: 0; status: 1; amount: 11; hoursTraspassed: 203; hoursBurned: 150; transactionID: "iuasduyw7eyuas"; addresses: "jskhdna7yuakss,ksahdkaw8yd,kashdkuwndu73d" }
    }

    /*
    Dialog {
        id: toolTipFilters

        anchors.centerIn: Overlay.overlay
        width: applicationWindow.width > 440 ? 440 - 40 : applicationWindow.width - 40
        height: Math.min(applicationWindow.height - 40, filter.contentHeight + header.height + footer.height + topPadding + bottomPadding)

        modal: true
        standardButtons: Dialog.Close
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        title: qsTr("Available filters")

        onClosed: {
            modelTransactions.clear()
            modelTransactions.addMultipleTransactions(historyManager.getTransactionsWithFilters())
        }

        onOpened:{
            filter.loadWallets()
        }

        HistoryFilterList {
            id: filter
            anchors.fill: parent
        }
    } // Dialog

    DialogTransactionDetails {
        id: dialogTransactionDetails

        readonly property real maxHeight: expanded ? 590 : 370

        anchors.centerIn: Overlay.overlay
        width: applicationWindow.width > 640 ? 640 - 40 : applicationWindow.width - 40
        height: applicationWindow.height > maxHeight ? maxHeight - 40 : applicationWindow.height - 40
        Behavior on height { NumberAnimation { duration: 1000; easing.type: Easing.OutQuint } }

        modal: true
        focus: true

        date: listTransactions.currentItem ? listTransactions.currentItem.modelDate : ""
        status: listTransactions.currentItem ? listTransactions.currentItem.modelStatus : 0
        type: listTransactions.currentItem ? listTransactions.currentItem.modelType : 0
        amount: listTransactions.currentItem ? listTransactions.currentItem.modelAmount : ""
        hoursReceived: listTransactions.currentItem ? listTransactions.currentItem.modelHoursReceived : 1 
        hoursBurned: listTransactions.currentItem ?  listTransactions.currentItem.modelHoursBurned : 1 
        transactionID: listTransactions.currentItem ? listTransactions.currentItem.modelTransactionID : "" 
        modelInputs: listTransactions.currentItem ? listTransactions.currentItem.modelInputs : null
        modelOutputs: listTransactions.currentItem ? listTransactions.currentItem.modelOutputs : null
    }

    QTransactionList {
        id: modelTransactions
    }

    HistoryManager {
        id: historyManager
        onNewTransactions: {
            if (!switchFilters.checked) {
                modelTransactions.addMultipleTransactions(historyManager.getNewTransactions())
            }
            else {
                modelTransactions.addMultipleTransactions(historyManager.getNewTransactionsWithFilters())
            }
        }
    }
    */

}

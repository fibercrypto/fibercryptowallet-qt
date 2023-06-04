import QtQuick
import QtQuick.Controls.Material

import FiberCrypto.UI as UI

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
        y: ~~(switchDelegateFilters.y + (switchDelegateFilters.height - height)/2)
        enabled: switchDelegateFilters.checked
        flat: true
        highlighted: true
        text: qsTr("Select filters")

        onClicked: {
            console.log("Opening filters...")
            toolTipFilters.open()
        }
    }


    ListView {
        id: listTransactions

        y: ~~(switchDelegateFilters.y + switchDelegateFilters.height + 10)
        width: parent.width
        height: parent.height - y
        clip: true
        model: modelTransactions
        pixelAligned: true

        delegate: UI.DelegateHistoryList {
            width: parent ? parent.width : 0

            onClicked: {
                dialogTransactionDetails.date = modelDate
                dialogTransactionDetails.type = modelType
                dialogTransactionDetails.status = modelStatus
                dialogTransactionDetails.amount = modelAmount
                dialogTransactionDetails.hoursReceived = modelHoursReceived
                dialogTransactionDetails.hoursBurned = modelHoursBurned
                dialogTransactionDetails.transactionID = modelTransactionID
                dialogTransactionDetails.inputs = modelInputs
                dialogTransactionDetails.outputs = modelOutputs
                dialogTransactionDetails.open()
            }
        }

        ScrollBar.vertical: UI.ScrollBar {}
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

    Dialog {
        id: toolTipFilters

        anchors.centerIn: Overlay.overlay
        width: applicationWindow.width > 440 ? 440 - 40 : applicationWindow.width - 40
        height: Math.min(applicationWindow.height - 40, filter.implicitHeight + header.height + footer.height + topPadding + bottomPadding)

        modal: true
        standardButtons: Dialog.Close
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        title: qsTr("Available filters")

        onClosed: {
            console.log("Set filters")
            //modelTransactions.clear()
            //modelTransactions.addMultipleTransactions(historyManager.getTransactionsWithFilters())
        }

        onOpened:{
            filter.loadWallets()
        }

        UI.PageHistoryFilter {
            id: filter

            width: parent.width
            height: parent.height
            clip: true
        }
    } // Dialog

    /*
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

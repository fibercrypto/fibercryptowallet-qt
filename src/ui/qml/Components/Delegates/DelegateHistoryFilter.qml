import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

import FiberCrypto.UI as UI

Item {
    id: delegateHistoryFilter

    property alias tristate: checkDelegate.tristate
    property alias walletText: checkDelegate.text

    signal filterAdded(var filter)
    signal filterRemoved(var filter)

    implicitWidth: 300
    implicitHeight: checkDelegate.height + listViewFilterAddress.height + 5
    clip: true

    CheckDelegate {
        id: checkDelegate

        width: parent.width
        tristate: true
        text: name
        LayoutMirroring.enabled: true

        nextCheckState: function() {
            if (checkState === Qt.Checked) {
                if (!listViewFilterAddress.allChecked) {
                    listViewFilterAddress.allChecked = true
                }
                listViewFilterAddress.allChecked = false
                return Qt.Unchecked
            } else {
                if (listViewFilterAddress.allChecked) {
                    listViewFilterAddress.allChecked = false
                }
                listViewFilterAddress.allChecked = true
                return Qt.Checked
            }
        }

        contentItem: Label {
            leftPadding: checkDelegate.indicator.width + checkDelegate.spacing
            verticalAlignment: Qt.AlignVCenter
            text: checkDelegate.text
            color: checkDelegate.enabled ? checkDelegate.Material.foreground : checkDelegate.Material.hintTextColor
        }
    } // CheckDelegate

    ListView {
        id: listViewFilterAddress

        property int checkedDelegates: 0
        property bool allChecked: false

        y: checkDelegate.height + 5
        width: parent.width
        implicitHeight: contentHeight
        model: listAddresses
        interactive: false

        onCheckedDelegatesChanged: {
            if (checkedDelegates === 0) {
                checkDelegate.checkState = Qt.Unchecked
            } else if (checkedDelegates === count) {
                checkDelegate.checkState = Qt.Checked
            } else {
                checkDelegate.checkState = Qt.PartiallyChecked
            }
        }

        Component.onCompleted: {
            //modelManager.setWalletManager(walletManager)
            //listAddresses = modelManager.getAddressModel(fileName)
        }

        delegate: UI.DelegateHistoryFilterAddress {
            // BUG: Checking the wallet does not change the check state of addresses
            // Is `checked: marked` ok? Or it should be the opposite?
            checked: marked
            width: parent.width
            text: address

            Connections {
                target: checkDelegate
                function onClicked() {
                    var i
                    if (checkDelegate.checkState === Qt.Checked) {
                        for (i = 0; i < listAddresses.count; ++i) {
                            listAddresses.setProperty(i, "marked", true)
                        }
                    } else if (checkDelegate.checkState === Qt.Unchecked) {
                        for (i = 0; i < listAddresses.count; ++i) {
                            listAddresses.setProperty(i, "marked", false)
                        }
                    }
                    //walletManager.editMarkAddress(address, listViewFilterAddress.allChecked)
                    //listViewFilterAddress.listAddresses.editAddress(index, address, sky, coinHours, listViewFilterAddress.allChecked)
                }
            }
            onCheckedChanged: {
                ListView.view.checkedDelegates += checked ? 1: -1

                if (checked) {
                    delegateHistoryFilter.filterAdded(address)
                } else {
                    delegateHistoryFilter.filterRemoved(address)
                }
                //walletManager.editMarkAddress(address, checked)
                //listViewFilterAddress.listAddresses.editAddress(index, address, sky, coinHours, checked)
                marked = checked
            }
        } // HistoryFilterListAddressDelegate (delegate)
    } // ListView

    ListModel {
        id: listAddresses
        ListElement { address: "llaksjdlkajsdyagwdh"; marked: false }
        ListElement { address: "oeifhdskfjhkudsafja"; marked: false }
        ListElement { address: "rqiweladskhdflkdsft"; marked: false }

        ListElement { address: "mvkjsdnhuaydiauksjd"; marked: false }
        ListElement { address: "vscytafdhsdhjxhcdjs"; marked: false }
        ListElement { address: "dsjnhffaskdfhnkdjhu"; marked: false }

        ListElement { address: "zsdfjsdhcmhjsdkfhjs"; marked: false }
        ListElement { address: "oidhfkusjdhfnhadgfe"; marked: false }
        ListElement { address: "eydsjjfndshgnjsdehd"; marked: false }
    }
}

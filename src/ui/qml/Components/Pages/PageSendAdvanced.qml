import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

import "../Delegates" as Delegates
import "../Dialogs" as Dialogs
import "../Controls" as Controls
import "../Custom" as Custom

Page {
    id: subPageSendAdvanced

    property bool activated: true

    property int upperCoinBound: 0
    property int upperAltCointBound: 0
    property int minFeeAmount: 0

    visible: opacity > 0
    enabled: visible
    implicitHeight: Math.max(labelWallet.height, toolButtonWalletPopupHelp.height) + comboBoxWalletsSendFrom.height + Math.max(labelAddresses.height, toolButtonAddressPopupHelp.height) + comboBoxWalletsAddressesSendFrom.height + Math.max(labelUnspentOutputs.height + toolButtonUnspentOutputsPopupHelp.height, checkBoxUnspentOutputsUseAllOutputs.height) + comboBoxWalletsUnspentOutputsSendFrom.height + Math.max(labelDestinations.height, toolButtonDestinationPopupHelp.height) + listViewDestinations.height + Math.max(labelCustomChangeAddress.height, toolButtonCustomChangeAddressPopupHelp.height, buttonSelectCustomChangeAddress.height) + textFieldCustomChangeAddress.height + checkBoxAutomaticCoinHoursAllocation.height + sliderCoinHoursShareFactor.height + 80

    //! WALLETS

    Label {
        id: labelWallet

        y: 4
        text: qsTr("Wallet")
    }

    ToolButton {
        id: toolButtonWalletPopupHelp

        x: labelWallet.x + labelWallet.width
        y: labelWallet.y + (labelWallet.height - height)/2
        icon.source: "qrc:/images/icons/actions/help.svg"
        //icon.color: Material.color(Material.Grey)
    }

    ComboBox {
        id: comboBoxWalletsSendFrom

        property var checkedElements: []
        property var checkedElementsText: []
        property int numberOfCheckedElements: checkedElements.length
        property alias filterString: filterPopupWallets.filterText

        x: labelWallet.x
        y: Math.max(labelWallet.y + labelWallet.height, toolButtonWalletPopupHelp.y + toolButtonWalletPopupHelp.height) - toolButtonWalletPopupHelp.bottomPadding
        width: parent.width - 2*x

        textRole: "name"
        displayText: numberOfCheckedElements > 1 ? (numberOfCheckedElements + ' ' + qsTr("address selected")) : numberOfCheckedElements === 1 ? checkedElementsText[0] : qsTr("No address selected")
        model: listWallets/*WalletModel {
            Component.onCompleted: {
                loadModel(walletManager.getWallets())
            }
        }*/

        popup: Custom.CustomComboBoxPopupFilter {
            id: filterPopupWallets
            comboBox: comboBoxWalletsSendFrom
            filterPlaceholderText: qsTr("Filter wallets by name")
        }

        // Taken from Qt 5.13.0 source code:
        delegate: Item {
            id: rootDelegate

            property alias checked: checkDelegate.checked
            property alias text: checkDelegate.text
            readonly property bool matchFilter: !comboBoxWalletsSendFrom.filterString || text.toLowerCase().includes(comboBoxWalletsSendFrom.filterString.toLowerCase())

            width: parent.width
            height: matchFilter ? checkDelegate.height : 0
            Behavior on height { NumberAnimation { easing.type: Easing.OutQuint } }
            clip: true

            CheckDelegate {
                id: checkDelegate

                width: parent.width
                text: comboBoxWalletsSendFrom.textRole ? (Array.isArray(comboBoxWalletsSendFrom.model) ? modelData[comboBoxWalletsSendFrom.textRole] + " - " + modelData["sky"] + " SKY (" + modelData["coinHours"] + " CoinHours)"  : model[comboBoxWalletsSendFrom.textRole] + " - " + model["sky"] + " SKY (" + model["coinHours"] + " CoinHours)") : " --- " + modelData
                // Load the saved state when the delegate is recicled:
                checked: model["checked"]//comboBoxWalletsSendFrom.checkedElements.indexOf(index) >= 0
                hoverEnabled: comboBoxWalletsSendFrom.hoverEnabled
                highlighted: hovered
                Material.foreground: checked ? parent.Material.accent : parent.Material.foreground
                leftPadding: highlighted ? 2*padding : padding // added
                Behavior on leftPadding { NumberAnimation { duration: 500; easing.type: Easing.OutQuint } } // added

                LayoutMirroring.enabled: true
                contentItem: Label {
                    leftPadding: comboBoxWalletsSendFrom.indicator.width + comboBoxWalletsSendFrom.spacing
                    text: checkDelegate.text
                    verticalAlignment: Qt.AlignVCenter
                    color: checkDelegate.enabled ? checkDelegate.Material.foreground : checkDelegate.Material.hintTextColor
                }

                // Update the states saved in `checkedElements`
                onClicked: {
                    console.log("Clicked wallet index", index)
                    model["checked"] = checked
                    /* TODO (do all this in the backend)
                       - update checked elements (add a "checked" role)
                       - update selected addresses
                       - update selected outputs
                    */
                }
            } // CheckDelegate
        } // Item (delegate)
    } // ComboBox (wallets, send from)


    //! ADDRESSES

    Label {
        id: labelAddresses

        x: labelWallet.x
        y: comboBoxWalletsSendFrom.y + comboBoxWalletsSendFrom.height + height+ 10
        text: qsTr("Address")
    }

    ToolButton {
        id: toolButtonAddressPopupHelp

        x: labelAddresses.x + labelAddresses.width
        y: labelAddresses.y + (labelAddresses.height - height)/2
        icon.source: "qrc:/images/icons/actions/help.svg"
        icon.color: Material.color(Material.Grey)
    }
    CheckBox {
        id: checkBoxAllAddresses

        x: toolButtonAddressPopupHelp.x + toolButtonAddressPopupHelp.width
        y: toolButtonAddressPopupHelp.y + (toolButtonAddressPopupHelp.height - height)/2
        text: qsTr("All Addresses of the selected addresses")
        checked: true
        onClicked: {
            console.log("Update here")
            //subPageSendAdvanced.updateInfo()
        }
    }

    ComboBox {
        id: comboBoxWalletsAddressesSendFrom

        property var checkedElements: []
        property var checkedElementsText: []
        property int numberOfCheckedElements: checkedElements.length
        property alias filterString: filterPopupAddresses.filterText

        x: labelAddresses.x
        y: Math.max(labelAddresses.y + labelAddresses.height, toolButtonAddressPopupHelp.y + toolButtonAddressPopupHelp.height, checkBoxAllAddresses.y + checkBoxAllAddresses.height) - toolButtonAddressPopupHelp.bottomPadding
        width: parent.width - 2*x

        popup: Custom.CustomComboBoxPopupFilter {
            id: filterPopupAddresses
            comboBox: comboBoxWalletsAddressesSendFrom
            filterPlaceholderText: qsTr("Filter Addresses")
        }

        model: listAddresses/*AddressModel{
            id: listAddresses
        }*/
        onModelChanged: {
            if (!model) {
                checkedElements = []
                checkedElementsText = []
                numberOfCheckedElements = 0
            }
        }

        textRole: "address"
        displayText: !checkBoxAllAddresses.checked ? (numberOfCheckedElements > 1 ? (numberOfCheckedElements + ' ' + qsTr("addresses selected")) : numberOfCheckedElements === 1 ? checkedElementsText[0] : qsTr("No addresses selected")): "All address selected"
        enabled: !checkBoxAllAddresses.checked
        delegate: Item {

            property alias checked: checkDelegate2.checked
            property alias text: checkDelegate2.text
            readonly property bool matchFilter: !comboBoxWalletsAddressesSendFrom.filterString || text.toLowerCase().includes(comboBoxWalletsAddressesSendFrom.filterString.toLowerCase())

            width: parent.width
            height: matchFilter ? checkDelegate2.height : 0
            Behavior on height { NumberAnimation { easing.type: Easing.OutQuint } }
            clip: true

            CheckDelegate {
                id: checkDelegate2

                width: parent.width
                text: comboBoxWalletsAddressesSendFrom.textRole ? (Array.isArray(comboBoxWalletsAddressesSendFrom.model) ? modelData["addressSky"] + " --- " +  modelData[comboBoxWalletsAddressesSendFrom.textRole]  + " - " + modelData["addressSky"] + " SKY (" + modelData["addressCoinHours"] + " CoinHours)" : model[comboBoxWalletsAddressesSendFrom.textRole] + " - " + model["addressSky"] + " SKY (" + model["addressCoinHours"] + " CoinHours)") : modelData
                font.family: "Code New Roman"

                // Load the saved state when the delegate is recicled:
                checked: comboBoxWalletsAddressesSendFrom.checkedElements.indexOf(index) >= 0
                hoverEnabled: comboBoxWalletsAddressesSendFrom.hoverEnabled
                highlighted: hovered
                Material.foreground: checked ? parent.Material.accent : parent.Material.foreground
                leftPadding: highlighted ? 2*padding : padding // added
                Behavior on leftPadding { NumberAnimation { duration: 500; easing.type: Easing.OutQuint } } // added

                LayoutMirroring.enabled: true
                contentItem: Label {
                    leftPadding: comboBoxWalletsAddressesSendFrom.indicator.width + comboBoxWalletsAddressesSendFrom.spacing
                    text: checkDelegate2.text
                    verticalAlignment: Qt.AlignVCenter
                    color: checkDelegate2.enabled ? checkDelegate2.Material.foreground : checkDelegate2.Material.hintTextColor
                }
                onClicked: {
                    console.log("Clicked address index", index)
                    /* TODO (do all this in the backend)
                       - update checked elements
                       - update selected outputs
                    */
                }

            } // CheckDelegate
        } // Item (delegate)
    } // ComboBox (addresses, send from)


    //! OUTPUTS

    Label {
        id: labelUnspentOutputs

        x: labelAddresses.x
        y: comboBoxWalletsAddressesSendFrom.y + comboBoxWalletsAddressesSendFrom.height + height+ 10
        text: qsTr("Unspent outputs")
    }

    ToolButton {
        id: toolButtonUnspentOutputsPopupHelp

        x: labelUnspentOutputs.x + labelUnspentOutputs.width
        y: labelUnspentOutputs.y + (labelUnspentOutputs.height - height)/2
        icon.source: "qrc:/images/icons/actions/help.svg"
        icon.color: Material.color(Material.Grey)
    }

    CheckBox {
        id: checkBoxUnspentOutputsUseAllOutputs

        x: toolButtonUnspentOutputsPopupHelp.x + toolButtonUnspentOutputsPopupHelp.width
        y: toolButtonUnspentOutputsPopupHelp.y + (toolButtonUnspentOutputsPopupHelp.height - height)/2
        text: qsTr("All outputs of the selected addresses")
        checked: true
        onClicked: {
            console.log("Update here")
            //subPageSendAdvanced.updateInfo()
        }
    }

    ComboBox {
        id: comboBoxWalletsUnspentOutputsSendFrom

        function getCheckedDelegates() {
            return checkedElements
        }
        property var checkedElements: []
        property var checkedElementsText: []
        property int numberOfCheckedElements: checkedElements.length
        property alias filterString: filterPopupOutputs.filterText

        x: labelUnspentOutputs.x
        y: Math.max(labelUnspentOutputs.y + labelUnspentOutputs.height, toolButtonUnspentOutputsPopupHelp.y + toolButtonUnspentOutputsPopupHelp.height, checkBoxUnspentOutputsUseAllOutputs.y + checkBoxUnspentOutputsUseAllOutputs.height) - toolButtonUnspentOutputsPopupHelp.bottomPadding
        width: parent.width - 2*x

        textRole: "outputID"
        displayText: checkBoxUnspentOutputsUseAllOutputs.checked ? qsTr("All outputs selected") : numberOfCheckedElements > 1 ? (numberOfCheckedElements + ' ' + qsTr("outputs selected")) : numberOfCheckedElements === 1 ? checkedElementsText[0] : qsTr("No output selected")

        enabled: !checkBoxUnspentOutputsUseAllOutputs.checked
        model: listOutputs/*QOutputs {
            id: listOutputs
        }*/

        onModelChanged: {
            if (!model) {
                checkedElements = []
                checkedElementsText = []
                numberOfCheckedElements = 0
            }
        }

        popup: Custom.CustomComboBoxPopupFilter {
            id: filterPopupOutputs
            comboBox: comboBoxWalletsUnspentOutputsSendFrom
            filterPlaceholderText: qsTr("Filter outputs")
        }

        delegate: Item {

            property alias checked: checkDelegate3.checked
            property alias text: checkDelegate3.text
            readonly property bool matchFilter: !comboBoxWalletsUnspentOutputsSendFrom.filterString || text.toLowerCase().includes(comboBoxWalletsUnspentOutputsSendFrom.filterString.toLowerCase())

            width: parent.width
            height: matchFilter ? checkDelegate3.height : 0
            Behavior on height { NumberAnimation { easing.type: Easing.OutQuint } }
            clip: true

            CheckDelegate {
                id: checkDelegate3

                // Update the states saved in `checkedElements`
                onClicked: {
                    console.log("Clicked output index", index)
                    /* TODO (do all this in the backend)
                       - update checked elements
                    */
                }

                width: parent.width
                text: comboBoxWalletsUnspentOutputsSendFrom.textRole ? (Array.isArray(comboBoxWalletsUnspentOutputsSendFrom.model) ? modelData[comboBoxWalletsUnspentOutputsSendFrom.textRole] + " - " + modelData["addressSky"] + " SKY (" + modelData["addressCoinHours"] + " CoinHours)" :model[comboBoxWalletsUnspentOutputsSendFrom.textRole] + " - " + model["addressSky"] + " SKY (" + model["addressCoinHours"] + " CoinHours)") : modelData
                font.family: "Code New Roman"
                // Load the saved state when the delegate is recicled:
                checked: comboBoxWalletsUnspentOutputsSendFrom.checkedElements.indexOf(index) >= 0
                hoverEnabled: comboBoxWalletsUnspentOutputsSendFrom.hoverEnabled
                highlighted: hovered
                Material.foreground: checked ? parent.Material.accent : parent.Material.foreground
                leftPadding: highlighted ? 2*padding : padding // added
                Behavior on leftPadding { NumberAnimation { duration: 500; easing.type: Easing.OutQuint } } // added

                LayoutMirroring.enabled: true
                contentItem: Label {
                    leftPadding: comboBoxWalletsUnspentOutputsSendFrom.indicator.width + comboBoxWalletsUnspentOutputsSendFrom.spacing
                    text: checkDelegate3.text
                    verticalAlignment: Qt.AlignVCenter
                    color: checkDelegate3.enabled ? checkDelegate3.Material.foreground : checkDelegate3.Material.hintTextColor
                }
            } // CheckDelegate
        } // Item (delegate)
    } // ComboBox (outputs, send from)


    //! RESUME

    Label {
        id: labelResume

        x: comboBoxWalletsUnspentOutputsSendFrom.x
        y: comboBoxWalletsUnspentOutputsSendFrom.y + comboBoxWalletsUnspentOutputsSendFrom.height + 10
        width: parent.width - 2*x

        text: qsTr("With your current selection you can send up to <b>%1 SKY</b> and <b>%2 Coin Hours</b> (at least <b>%3 Coin Hours</b> must be used for the transaction fee)").arg(subPageSendAdvanced.upperCoinBound).arg(subPageSendAdvanced.upperAltCointBound).arg(subPageSendAdvanced.minFeeAmount)
        wrapMode: Text.Wrap
        horizontalAlignment: Text.AlignHCenter
    }


    //! DESTINATIONS

    Label {
        id: labelDestinations

        x: labelResume.x
        y: labelResume.y + labelResume.height + 10
        text: qsTr("Destinations")
    }

    ToolButton {
        id: toolButtonDestinationPopupHelp

        x: labelDestinations.x + labelDestinations.width
        y: labelDestinations.y + (labelDestinations.height - height)/2
        icon.source: "qrc:/images/icons/actions/help.svg"
        icon.color: Material.color(Material.Grey)
    }

    ListView {
        id: listViewDestinations

        x: labelDestinations.x
        y: Math.max(labelDestinations.y + labelDestinations.height, toolButtonDestinationPopupHelp.y + toolButtonDestinationPopupHelp.height)
        width: parent.width - 2*x
        implicitHeight: contentItem.height
        Behavior on implicitHeight { NumberAnimation { duration: 250; easing.type: Easing.OutQuint } }

        interactive: false
        clip: true

        model: listModelDestinations

        delegate: Delegates.DelegateDestinationList {
            width: listViewDestinations.width
            automaticCoinHoursAllocation: checkBoxAutomaticCoinHoursAllocation.checked

            onAppendRequested: function(listElement) {
                listModelDestinations.append(listElement)
            }

            onRemovalRequested: function(index) {
                listModelDestinations.remove(index)
            }
        }
    } // ListView


    //! CHANGE ADDRESS

    Label {
        id: labelCustomChangeAddress

        x: listViewDestinations.x
        y: listViewDestinations.y + listViewDestinations.height+ 10
        text: qsTr("Custom change address")
    }

    ToolButton {
        id: toolButtonCustomChangeAddressPopupHelp

        x: labelCustomChangeAddress.x + labelCustomChangeAddress.width
        y: labelCustomChangeAddress.y + (labelCustomChangeAddress.height - height)/2
        icon.source: "qrc:/images/icons/actions/help.svg"
        icon.color: Material.color(Material.Grey)
    }

    Button {
        id: buttonSelectCustomChangeAddress

        x: toolButtonCustomChangeAddressPopupHelp.x +  toolButtonCustomChangeAddressPopupHelp.width
        y: toolButtonCustomChangeAddressPopupHelp.y + (toolButtonCustomChangeAddressPopupHelp.height - height)/2
        text: qsTr("Select")
        flat: true
        highlighted: true

        onClicked: {
            console.log("Get addresses by wallet")
            // modelAddressesByWallet.loadModel(walletManager.getAllAddresses())
            // dialogSelectAddressByWallet.open()
        }
    }

    Controls.TextField {
        id: textFieldCustomChangeAddress

        x: labelCustomChangeAddress.x
        y: Math.max(toolButtonCustomChangeAddressPopupHelp.y + toolButtonCustomChangeAddressPopupHelp.height, buttonSelectCustomChangeAddress.y + buttonSelectCustomChangeAddress.height) - toolButtonCustomChangeAddressPopupHelp.bottomPadding
        width: parent.width - 2*x
        placeholderText: qsTr("Address to receive change")
        selectByMouse: true
        font.family: "Code New Roman"
    }

    CheckBox {
        id: checkBoxAutomaticCoinHoursAllocation

        x: textFieldCustomChangeAddress.x
        y: textFieldCustomChangeAddress.y + textFieldCustomChangeAddress.height + 10
        text: qsTr("Automatic coin hours allocation")
        checked: true
    }

    Slider {
        id: sliderCoinHoursShareFactor

        x: checkBoxAutomaticCoinHoursAllocation.x
        y: checkBoxAutomaticCoinHoursAllocation.y + checkBoxAutomaticCoinHoursAllocation.height
        width: parent.width - 2*x

        opacity: checkBoxAutomaticCoinHoursAllocation.checked ? 1.0 : 0.0
        Behavior on opacity { NumberAnimation {} }
        enabled: opacity > 0
        from: 0.01
        to: 1.00
        value: 0.50
        stepSize: 0.01

        ToolTip {
            parent: sliderCoinHoursShareFactor.handle
            visible: sliderCoinHoursShareFactor.pressed
            text: sliderCoinHoursShareFactor.value.toFixed(2)
            font.pointSize: Qt.application.font.pointSize * 1.2
        }
    }

    ListModel {
        id: listWallets
        ListElement { name: "My first wallet";   checked: false; sky: 5;    coinHours: 10 }
        ListElement { name: "My second wallet";  checked: false; sky: 300;  coinHours: 1049 }
        ListElement { name: "My third wallet";   checked: false; sky: 13;   coinHours: 201 }

        ListElement { name: "My fourth wallet";  checked: false; sky: 3941; coinHours: 6652 }
        ListElement { name: "My fiveth wallet";  checked: false; sky: 9;    coinHours: 35448 }
        ListElement { name: "My sixth wallet";   checked: false; sky: 439;  coinHours: 685 }

        ListElement { name: "My seventh wallet"; checked: false; sky: 22;   coinHours: 315 }
        ListElement { name: "My eighth wallet";  checked: false; sky: 2001; coinHours: 10628 }
        ListElement { name: "My nineth wallet";  checked: false; sky: 93;   coinHours: 381 }
    }

    ListModel {
        id: listAddresses
        ListElement { address: "llaksjdlkajsdyagwdh"; addressSky: 5;    addressCoinHours: 10 }
        ListElement { address: "oeifhdskfjhkudsafja"; addressSky: 300;  addressCoinHours: 1049 }
        ListElement { address: "rqiweladskhdflkdsft"; addressSky: 13;   addressCoinHours: 201 }

        ListElement { address: "mvkjsdnhuaydiauksjd"; addressSky: 3941; addressCoinHours: 6652 }
        ListElement { address: "vscytafdhsdhjxhcdjs"; addressSky: 0;    addressCoinHours: 35448 }
        ListElement { address: "dsjnhffaskdfhnkdjhu"; addressSky: 439;  addressCoinHours: 685 }

        ListElement { address: "zsdfjsdhcmhjsdkfhjs"; addressSky: 0;   addressCoinHours: 315 }
        ListElement { address: "oidhfkusjdhfnhadgfe"; addressSky: 0; addressCoinHours: 10628 }
        ListElement { address: "eydsjjfndshgnjsdehd"; addressSky: 93;   addressCoinHours: 381 }
    }

    ListModel {
        id: listOutputs
        ListElement { address: "laskjdlwd2397duiqws"; addressSky: 58;    addressCoinHours: 44 }
        ListElement { address: "n838wj9wksdnks92ksq"; addressSky: 102;  addressCoinHours: 1921 }
        ListElement { address: "92kw0dsnsbfmidmr35k"; addressSky: 39;   addressCoinHours: 142 }

        ListElement { address: "j483kwnsvaeqyeir84j"; addressSky: 3795; addressCoinHours: 3795 }
        ListElement { address: "mk9275nd62nsarwropv"; addressSky: 6;    addressCoinHours: 21701 }
        ListElement { address: "28a9dufme3n26big85m"; addressSky: 647;  addressCoinHours: 379 }
    }

    ListModel {
        id: listModelDestinations
        ListElement { address: ""; sky: "0.0"; coinHours: "0.0" }
    }

    /*
    AddressModel {
        id: modelAddressesByWallet
    }

    DialogSelectAddressByWallet {
        id: dialogSelectAddressByWallet

        anchors.centerIn: Overlay.overlay
        width: applicationWindow.width > 540 ? 540 - 40 : applicationWindow.width - 40
        height: applicationWindow.height - 40

        model: modelAddressesByWallet

        focus: true
        modal: true

        onAccepted: {
            textFieldCustomChangeAddress.text = selectedAddress
        }
    }
    */

    states: [
        State {
            name: "visible"; when: activated
            PropertyChanges {
                target: pageSendAdvanced
                scale: 1.0
                opacity: 1.0
            }
        },
        State {
            name: "hidden"; when: !activated
            PropertyChanges {
                target: pageSendAdvanced
                scale: 0.9
                opacity: 0.0
            }
        }
    ]

    transitions: [
        Transition {
            reversible: true
            NumberAnimation { property: "scale"; easing.type: Easing.OutQuint; duration: 170 }
            NumberAnimation { property: "opacity"; easing.type: Easing.OutCubic; duration: 100 }
        }
    ]
}

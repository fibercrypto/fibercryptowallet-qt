import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
// import AddrsBookManager

import "../"
import "../Controls"
import "../Dialogs"

Item {
    id: root

    enum SecurityType { LowSecurity, MediumSecurity, StrongSecurity }

    property bool automaticCoinHoursAllocation: true

    signal appendRequested(var listElement)
    signal removalRequested(var index)
    signal qrCodeRequested(var data)

    onQrCodeRequested: {
        console.log("QR code requested...")
    }

    function getAddressList() {
        contactAddrsModel.clear()
        /*
        for(var i = 0; i < abm.count; i++){
            for(var j = 0; j < abm.contacts[i].address.address.length; j++){
                contactAddrsModel.append( {
                    name: abm.contacts[i].name,
                    address: abm.contacts[i].address.address[j].value,
                    coinType: abm.contacts[i].address.address[j].coinType
                })
            }
        }
        */
    }

    implicitHeight: Math.max(buttonSelectCustomChangeAddress.height, toolButtonQR.height, textFieldDestinationAddress.height, toolButtonAddRemoveDestination.height)

    Button {
        id: buttonSelectCustomChangeAddress

        y: (parent.height - height)/2

        text: qsTr("Select")
        flat: true
        highlighted: true

        onClicked: {
            console.log("Get address from contacts")
            /*
            if (abm.getSecType() !== DestinationListDelegate.SecurityType.StrongSecurity) {
                abm.loadContacts()
                dialogSelectAddressByAddressBook.open()
            } else {
                getpass.open()
            }
            */
        }
    }

    ToolButton {
        id: toolButtonQR

        x: buttonSelectCustomChangeAddress.x + buttonSelectCustomChangeAddress.width + 12
        y: (parent.height - height)/2
        width: visible ? implicitWidth : 0
        height: visible ? implicitHeight : 0
        padding: 0
        icon.source: "qrc:/images/icons/actions/qr.svg"
        onClicked: {
            qrCodeRequested()
        }
    }

    TextField {
        id: textFieldDestinationAddress

        x: toolButtonQR.x + toolButtonQR.width + 8
        y: (parent.height - height)/2
        width: parent.width - toolButtonAddRemoveDestination.width - x - (!automaticCoinHoursAllocation ? textFieldCoinHoursAmount.width + labelCoinHoursText.width + 28 : 0)
        Behavior on width { NumberAnimation { easing.type: Easing.OutCubic; duration: 100 } }

        font.family: "Code New Roman"
        placeholderText: qsTr("Destination address")
        text: address
        selectByMouse: true
        Material.accent: text/*abm.addressIsValid(text)*/ ? parent.Material.accent : Material.color(Material.Red)
        onTextChanged: address = text
    }

    TextField {
        id: textFieldCoinHoursAmount

        x: textFieldDestinationAddress.x + textFieldDestinationAddress.width + 20
        y: (parent.height - height)/2
        implicitWidth: 60

        opacity: automaticCoinHoursAllocation ? 0 : 1
        Behavior on opacity { NumberAnimation { duration: 100 } }
        visible: opacity > 0
        enabled: visible
        text: coinHours
        selectByMouse: true
        validator: DoubleValidator {
            notation: DoubleValidator.StandardNotation
        }

        onTextChanged: {
            if (coinHours !== text)
                coinHours = text
        }
    }
    Label {
        id: labelCoinHoursText

        x: textFieldCoinHoursAmount.x + textFieldCoinHoursAmount.width + 8
        y: (parent.height - height)/2

        opacity: textFieldCoinHoursAmount.opacity
        visible: textFieldCoinHoursAmount.visible
        enabled: visible
        text: qsTr("Coin hours")
    }

    ToolButton {
        id: toolButtonAddRemoveDestination

        x: parent.width - width
        y: (parent.height - height)/2

        // The 'accent' attribute is used for button highlighting
        Material.accent: index === 0 ? Material.Teal : Material.Red
        icon.source: "qrc:/images/icons/actions/" + (index === 0 ? "add" : "remove") + "_circle.svg"
        highlighted: true // enable the usage of the `Material.accent` attribute

        onClicked: {
            if (index === 0) {
                appendRequested( { "address": "", "sky": "0.0", "coinHours": "0.0" } )
            } else {
                removalRequested(index)
            }
        }
    } // ToolButton (Add/Remove)

    /*
    DialogGetPassword {
        id: getpass
        
        anchors.centerIn: Overlay.overlay
        width: applicationWindow.width > 400 ? 400 - 40 : applicationWindow.width - 40
        height: applicationWindow.height > 280 ? 280 - 40 : applicationWindow.height - 40

        modal: true
        focus: visible

        onAccepted: {
            if (!abm.authenticate(getpass.password)) {
                getpass.open()
            } else {
                abm.loadContacts()
                dialogSelectAddressByAddressBook.open()
            }
        }
    }

    DialogSelectAddressByAddressBook {
        id: dialogSelectAddressByAddressBook

        anchors.centerIn: Overlay.overlay
        width: applicationWindow.width > 540 ? 540 - 40 : applicationWindow.width - 40
        height: applicationWindow.height - 40

        focus: visible
        modal: true

        listAddrsModel: contactAddrsModel
        onAboutToShow: {
            getAddressList()
        }

        onAccepted: {
            textFieldDestinationAddress.text = selectedAddress
        }
    }
    */

    ListModel {
        id: contactAddrsModel
    }
    
    /*
    AddrsBookModel {
        id: abm
    }
    */
}

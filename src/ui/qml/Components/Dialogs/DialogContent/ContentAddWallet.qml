import QtQuick
import QtQuick.Controls.Material

import FiberCrypto.UI as UI

Flickable {
    id: contentAddWallet

    enum Mode { CreateWallet, LoadWallet }
    property int mode: ContentAddWallet.CreateWallet
    property alias name: textFieldWalletName.text
    property alias seed: seedGenerator.seed
    property alias encrypt: checkBoxEncryptWallet.checked

    contentWidth: width
    contentHeight: textFieldConfirmWalletPassword.y + textFieldConfirmWalletPassword.height + 14
    implicitWidth: contentWidth
    implicitHeight: contentHeight
    clip: true

    Label {
        id: labelMode

        width: parent.width
        elide: Label.ElideRight
        text: qsTr("What do you want to do?")
    }

    Item {
        id: itemMode

        x: ~~((parent.width - width)/2)
        y: labelMode.y + labelMode.height
        width: radioButtonCreateWallet.width + radioButtonLoadWallet.width
        height: radioButtonCreateWallet.height

        UI.RadioButton {
            id: radioButtonCreateWallet
            text: qsTr("New wallet")
            checked: contentAddWallet.mode === ContentAddWallet.CreateWallet
            onCheckedChanged: contentAddWallet.mode = checked ? ContentAddWallet.CreateWallet : contentAddWallet.mode
        }
        UI.RadioButton {
            id: radioButtonLoadWallet
            x: radioButtonCreateWallet.x + radioButtonCreateWallet.width
            text: qsTr("Load wallet")
            checked: contentAddWallet.mode === ContentAddWallet.LoadWallet
            onCheckedChanged: contentAddWallet.mode = checked ? ContentAddWallet.LoadWallet : contentAddWallet.mode
        }
    } // Item (mode)

    UI.TextField {
        id: textFieldWalletName

        y: itemMode.y + itemMode.height - 4
        width: parent.width
        placeholderText: qsTr("Wallet's name")
        selectByMouse: true
        focus: true
    }

    UI.SeedGenerator {
        id: seedGenerator

        y: textFieldWalletName.y + textFieldWalletName.height + 5
        width: parent.width

        showModeButtons: radioButtonCreateWallet.checked
        nextTabItem: textAreaSeedConfirmation
    }

    UI.TextArea {
        id: textAreaSeedConfirmation

        y: seedGenerator.y + seedGenerator.height + 40
        width: parent.width
        height: radioButtonCreateWallet.checked ? implicitHeight : 0
        Behavior on height { NumberAnimation { easing.type: Easing.OutQuint } }

        placeholderText: qsTr("Confirm secret recovery phrase")
        opacity: radioButtonCreateWallet.checked ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 500 } }

        wrapMode: TextArea.Wrap
        selectByMouse: true
        KeyNavigation.priority: KeyNavigation.BeforeItem
        KeyNavigation.tab: checkBoxContinueWithSeedWarning
    }

    Rectangle {
        id: rectangleSeedWarning

        property bool warn: radioButtonCreateWallet.checked

        y: textAreaSeedConfirmation.y + textAreaSeedConfirmation.height + 10
        width: parent.width
        height: warn ? implicitHeight : 0
        implicitHeight: labelWarning.height + labelWarningText.height + checkBoxContinueWithSeedWarning.height + 8
        Behavior on height { NumberAnimation { duration: 500; easing.type: Easing.OutQuint } }

        color: checkBoxContinueWithSeedWarning.Material.accentColor
        opacity: warn ? 0.25 : 0
        Behavior on opacity { NumberAnimation { } }
        clip: true
    } // Rectangle (seed warning)

    Label {
        id: labelWarning

        x: 6
        y: rectangleSeedWarning.y + 4
        width: rectangleSeedWarning.width - 2*x

        opacity: rectangleSeedWarning.opacity * 4
        Material.foreground: Material.accent
        Material.accent: Material.Pink
        text: qsTr("Warning")
        font.pointSize: 14
        font.bold: true
        wrapMode: Label.Wrap
    }

    Label {
        id: labelWarningText

        x: 6
        y: labelWarning.y + labelWarning.height + 5
        width: rectangleSeedWarning.width - 2*x

        opacity: rectangleSeedWarning.opacity * 4
        Material.foreground: Material.accent
        Material.accent: Material.Pink
        text: qsTr("You introduced an unconventional secret recovery phrase. "
                 + "If you did it for any special reason, "
                 + "you can continue (only recommended for advanced users). "
                 + "However, if your intention is to use a normal system phrase, "
                 + "you must delete all the additional text and special characters.")
        wrapMode: Label.Wrap
    }

    CheckBox {
        id: checkBoxContinueWithSeedWarning

        x: 6
        y: labelWarningText.y + labelWarningText.height - 1
        width: rectangleSeedWarning.width - 2*x

        opacity: rectangleSeedWarning.opacity * 4
        Material.foreground: Material.accent
        Material.accent: Material.Pink
        text: qsTr("Continue with the unconventional phrase")

        onCheckedChanged: {
            //updateAcceptButtonStatus()
        }
    }

    Label {
        id: labelWalletType

        y: rectangleSeedWarning.y + rectangleSeedWarning.height + 5
        text: qsTr("Wallet type")
    }

    UI.ComboBox {
        id: comboBoxWalletType

        x: 6
        y: labelWalletType.y + labelWalletType.height + 5
        width: parent.width - 2*x
        model: ["Type 1", "Type 2", "Type 3"] // ask wallet manager (walletManager.getAvailableWalletTypes(), walletManager.getDefaultWalletType())
    }

    CheckBox {
        id: checkBoxEncryptWallet

        x: 6
        y: comboBoxWalletType.y + comboBoxWalletType.height
        width: parent.width
        text: qsTr("Encrypt wallet")
        checked: true

        onCheckedChanged: {
            //updateAcceptButtonStatus()
            if (checked && visible) {
                textFieldWalletPassword.forceActiveFocus()
            }
        }
    }

    Label {
        id: labelEncryptWalletWarning

        y: checkBoxEncryptWallet.y + checkBoxEncryptWallet.height
        width: parent.width
        leftPadding: checkBoxEncryptWallet.x + checkBoxEncryptWallet.indicator.width + 2*checkBoxEncryptWallet.padding

        text: qsTr("We suggest that you encrypt each one of your wallets with a password. "
                 + "If you forget your password, you can reset it with your secret recovery phrase. "
                 + "Make sure you have your phrase saved somewhere safe before encrypting your wallet.")
        wrapMode: Label.Wrap
    }

    UI.TextField {
        id: textFieldWalletPassword

        y: labelEncryptWalletWarning.y + labelEncryptWalletWarning.height + 12
        width: parent.width

        placeholderText: qsTr("Password")
        echoMode: TextField.Password
        selectByMouse: true

        onTextChanged: {
            //updateAcceptButtonStatus()
        }
    }

    UI.TextField {
        id: textFieldConfirmWalletPassword

        y: textFieldWalletPassword.y + textFieldWalletPassword.height + 12
        width: parent.width

        placeholderText: qsTr("Confirm password")
        echoMode: TextField.Password
        selectByMouse: true

        onTextChanged: {
            //updateAcceptButtonStatus()
        }
    }

    ScrollBar.vertical: UI.ScrollBar { }
} // Flickable

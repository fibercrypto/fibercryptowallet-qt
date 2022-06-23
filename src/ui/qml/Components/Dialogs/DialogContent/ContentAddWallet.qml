import QtQuick
import QtQuick.Controls
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
    contentHeight: labelMode.height + itemMode.height + textFieldWalletName.height + seedGenerator.height
                   + textAreaSeedConfirmation.height + rectangleSeedWarning.height + labelWalletType.height
                   + comboBoxWalletType.height + checkBoxEncryptWallet.height + labelEncryptWalletWarning.height + textFieldWalletPassword.height + textFieldConfirmWalletPassword.height + 50
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

        x: 6
        y: labelMode.y + labelMode.height
        width: parent.width
        height: radioButtonCreateWallet.height + radioButtonLoadWallet.height

        UI.RadioButton {
            id: radioButtonCreateWallet
            width: parent.width
            text: qsTr("Create new wallet")
            checked: contentAddWallet.mode === ContentAddWallet.CreateWallet
            onCheckedChanged: contentAddWallet.mode = checked ? ContentAddWallet.CreateWallet : contentAddWallet.mode
        }
        UI.RadioButton {
            id: radioButtonLoadWallet
            y: radioButtonCreateWallet.y + radioButtonCreateWallet.height - 6
            width: parent.width
            text: qsTr("Load existing wallet")
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

        clip: true
        showModeButtons: radioButtonCreateWallet.checked
        nextTabItem: textAreaSeedConfirmation
    }

    UI.TextArea {
        id: textAreaSeedConfirmation

        y: seedGenerator.y + seedGenerator.height + 5
        width: parent.width
        height: radioButtonCreateWallet.checked ? contentHeight + topPadding + bottomPadding : 0
        Behavior on height { NumberAnimation { easing.type: Easing.OutQuint } }

        placeholderText: qsTr("Confirm secret recovery phrase")
        opacity: radioButtonCreateWallet.checked ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 500 } }

        wrapMode: TextArea.Wrap
        selectByMouse: true
        clip: true
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

        color: Qt.alpha(Material.accentColor, 0.25)
        opacity: warn ? 1 : 0
        Behavior on opacity { NumberAnimation { } }
        clip: true

        Material.foreground: Material.Pink
        Material.accent: Material.Pink

        Label {
            id: labelWarning

            x: 6
            y: 4
            width: parent.width - 2*x

            text: qsTr("Warning")
            font.pointSize: 14
            font.bold: true
            wrapMode: Text.Wrap
        }

        Label {
            id: labelWarningText

            x: 6
            y: labelWarning.height + 5
            width: parent.width - 2*x

            text: qsTr("You introduced an unconventional secret recovery phrase. "
                     + "If you did it for any special reason, "
                     + "you can continue (only recommended for advanced users). "
                     + "However, if your intention is to use a normal system phrase, "
                     + "you must delete all the additional text and special characters.")
            wrapMode: Text.Wrap
        }

        CheckBox {
            id: checkBoxContinueWithSeedWarning

            x: 6
            y: labelWarningText.y + labelWarningText.height - 1
            width: parent.width - 2*x

            text: qsTr("Continue with the unconventional phrase")

            onCheckedChanged: {
                //updateAcceptButtonStatus()
            }
        }
    } // Rectangle (seed warning)

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

        y: labelEncryptWalletWarning.y + labelEncryptWalletWarning.height + 5
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

        y: textFieldWalletPassword.y + textFieldWalletPassword.height + 5
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

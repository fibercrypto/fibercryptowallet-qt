import QtQml
import QtQuick
import QtQuick.Controls.Material

import FiberCrypto.UI as UI

Page {
    id: pageCreateWallet

    function tryGoNext() {
        if (!buttonNextAction.enabled) {
            return false
        }

        buttonNextAction.clicked()
        return true
    }

    function tryGoBack() {
        if (!buttonPreviousAction.enabled) {
            return false
        }

        buttonPreviousAction.clicked()
        return true
    }

    signal finished()
    signal cancelled()

    Shortcut {
        sequences: [StandardKey.Forward, "Enter", "Return"]
        onActivated: pageCreateWallet.tryGoNext()
    }

    Shortcut {
        sequences: [StandardKey.Back]
        onActivated: pageCreateWallet.tryGoBack()
    }

    footer: ToolBar {
        z: 2
        implicitWidth: parent.width
        Material.theme: applicationWindow.Material.theme
        Material.primary: Qt.alpha(Material.dialogColor, 0.125)
        Material.foreground: applicationWindow.Material.background
        Material.elevation: 0

        Button {
            id: buttonPreviousAction

            width: ~~(parent.width/2)
            height: parent.height
            topInset: 0
            bottomInset: 0

            text: qsTr("Back")
            layer.enabled: false
            Material.elevation: 0
            Material.roundedScale: Material.NotRounded
            Material.background: Material.accentColor

            onClicked: {
                if (stackViewWalletCreationWizard.depth > 1) {
                    stackViewWalletCreationWizard.pop()
                } else {
                    pageCreateWallet.cancelled()
                }
            }
        }

        Button {
            id: buttonNextAction

            x: buttonPreviousAction.width
            width: parent.width - x
            height: parent.height
            topInset: 0
            bottomInset: 0

            text: stackViewWalletCreationWizard.depth === 3 ? qsTr("Finish") :  qsTr("Next")
            enabled: stackViewWalletCreationWizard.currentItem.acceptableInput
            layer.enabled: false
            Material.elevation: 0
            Material.roundedScale: Material.NotRounded
            Material.background: stackViewWalletCreationWizard.currentItem.warnCurrentInput ? (settings.theme === Material.Red ? "#ff0000" : Material.Red) : Material.accentColor

            onClicked: {
                if (stackViewWalletCreationWizard.depth < 3) {
                    stackViewWalletCreationWizard.push([componentWizardPage1, componentWizardPage2, componentWizardPage3][stackViewWalletCreationWizard.depth])
                } else {
                    pageCreateWallet.finished()
                }
            }
        }
    } // Pane (footer)

    StackView {
        id: stackViewWalletCreationWizard

        width: parent.width
        height: parent.height

        initialItem: componentWizardPage1
    }

    Component {
        id: componentWizardPage1

        Item {
            id: itemWizardPage1

            readonly property bool acceptableInput: textFieldWalletName.text // trimmed?
            readonly property bool warnCurrentInput: false

            StackView.onActivated: {
                textFieldWalletName.forceActiveFocus()
            }

            Label {
                id: labelInstruction

                x: 10
                y: 20
                width: parent.width - 2*x
                horizontalAlignment: Label.AlignHCenter
                wrapMode: Label.Wrap

                text: qsTr("Let's start with your wallet's name")
                font.pointSize: Qt.application.font.pointSize * 2
            }

            UI.TextField {
                id: textFieldWalletName

                x: ~~((parent.width - width)/2)
                y: ~~((parent.height - height)/2) > labelInstruction.y + labelInstruction.height + 20 ? ~~((parent.height - height)/2) : labelInstruction.y + labelInstruction.height + 20
                width: parent.width > 540 ? 540 - 40 : parent.width - 40
                placeholderText: qsTr("Wallet's name")
                selectByMouse: true
            }
        }
    } // Component (wizard page 1)

    Component {
        id: componentWizardPage2

        Item {
            id: itemWizardPage2

            readonly property bool acceptableInput: seedGenerator.seed && buttonConfirmSeed.checked // trimmed?
            readonly property bool warnCurrentInput: false

            Label {
                id: labelInstruction

                x: 10
                y: 20
                width: parent.width - 2*x
                horizontalAlignment: Label.AlignHCenter
                wrapMode: Label.Wrap

                text: qsTr("Generate a secret recovery phrase")
                font.pointSize: Qt.application.font.pointSize * 2
            }

            UI.SeedGenerator {
                id: seedGenerator

                x: ~~((parent.width - width)/2)
                y: labelInstruction.y + labelInstruction.height + 40
                width: parent.width > 540 ? 540 - 40 : parent.width - 40
                height: implicitHeight > parent.height - y - buttonConfirmSeed.height - 30 ? parent.height - y - buttonConfirmSeed.height - 30 : implicitHeight
                nextTabItem: buttonConfirmSeed
                seed: /* testing */"pool beam party rice people tomorrow plant zombie planet car juicy stuborn" + (generateSeed24 ? " contest pikachu france tomato glass moon human atom ant cloud house space" : "")
            }

            Button {
                id: buttonConfirmSeed

                x: ~~((parent.width - width)/2)
                y: seedGenerator.y + seedGenerator.height + 26

                text: qsTr("Confirm secret recovery phrase")
                Material.foreground: pageCreateWallet.Material.dialogColor
                Material.background: pageCreateWallet.Material.accentColor
                checkable: true

                contentItem: Label {
                    leftPadding: customCheckIndicatorConfirmSeed.width + 4
                    text: buttonConfirmSeed.text

                    UI.CustomCheckIndicator {
                        id: customCheckIndicatorConfirmSeed
                        x: -4
                        y: ~~((parent.height - height)/2)
                        control: buttonConfirmSeed
                    }
                }

                Connections {
                    target: dialogConfirmSeed

                    function onAccepted() {
                        buttonConfirmSeed.checked = true
                    }

                    function onRejected() {
                        buttonConfirmSeed.checked = false
                    }
                }

                onClicked: {
                    checked = false
                    dialogConfirmSeed.word1Number = seedGenerator.generateSeed12 ? 2  :  4
                    dialogConfirmSeed.word2Number = seedGenerator.generateSeed12 ? 5  : 10
                    dialogConfirmSeed.word3Number = seedGenerator.generateSeed12 ? 9  : 17
                    dialogConfirmSeed.word4Number = seedGenerator.generateSeed12 ? 11 : 23
                    dialogConfirmSeed.open()
                }
            } // Button (confirm seed)
        } // Item (wizard page 2)
    } // Component (wizard page 2)

    Component {
        id: componentWizardPage3

        Item {
            id: itemWizardPage3

            readonly property bool acceptableInput: radioButtonNo.checked || textFieldWalletPassword.text && textFieldWalletPassword.text === textFieldConfirmWalletPassword.text
            readonly property bool warnCurrentInput: false

            Label {
                id: labelInstruction

                x: 10
                y: 20
                width: parent.width - 2*x
                horizontalAlignment: Label.AlignHCenter
                wrapMode: Label.Wrap

                text: qsTr("Secure your wallet with a password?")
                font.pointSize: Qt.application.font.pointSize * 2
            }

            Item {
                id: itemSetPassword

                x: ~~((parent.width - width)/2)
                y: labelInstruction.y + labelInstruction.height + 20
                width: radioButtonYes.width + radioButtonNo.width + 10
                height: radioButtonYes.height

                UI.RadioButton {
                    id: radioButtonYes

                    text: qsTr("Yes")
                    checked: true
                }

                UI.RadioButton {
                    id: radioButtonNo

                    x: radioButtonYes.width + 10
                    text: qsTr("No")
                }
            }

            Label {
                id: labelEncryptWalletWarning

                x: ~~((parent.width - width)/2)
                y: itemSetPassword.y + itemSetPassword.height + 20
                width: parent.width > 440 ? 440 - 40 : parent.width - 40
                height: implicitHeight * opacity
                Behavior on opacity { NumberAnimation { duration: 500; easing.type: Easing.OutQuint } }
                opacity: radioButtonNo.checked ? 1 : 0
                clip: true

                text: qsTr("We suggest that you encrypt each one of your wallets with a password. "
                         + "If you forget your password, you can reset it with your secret recovery phrase. "
                         + "Make sure you have your phrase saved somewhere safe before encrypting your wallet.")
                wrapMode: Label.Wrap
                horizontalAlignment: Label.AlignHCenter
            }

            UI.TextField {
                id: textFieldWalletPassword

                x: ~~((parent.width - width)/2)
                y: labelEncryptWalletWarning.y + labelEncryptWalletWarning.height + 20
                width: parent.width > 540 ? 540 - 40 : parent.width - 40
                placeholderText: qsTr("Wallet's password")
                selectByMouse: true
                echoMode: TextField.Password
                enabled: radioButtonYes.checked
                opacity: 1 - labelEncryptWalletWarning.opacity

                onAccepted: {
                    textFieldConfirmWalletPassword.forceActiveFocus()
                }
            }

            UI.TextField {
                id: textFieldConfirmWalletPassword

                x: ~~((parent.width - width)/2)
                y: textFieldWalletPassword.y + textFieldWalletPassword.height + 20
                width: textFieldWalletPassword.width
                placeholderText: qsTr("Confirm wallet's password")
                selectByMouse: true
                echoMode: TextField.Password
                enabled: textFieldWalletPassword.enabled
                opacity: textFieldWalletPassword.opacity
            }
        } // Item (wizard page 3)
    } // Component (wizard page 3)
}

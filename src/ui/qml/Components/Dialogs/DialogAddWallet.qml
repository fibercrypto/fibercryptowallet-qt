import QtQuick
import QtQuick.Controls.Material

import FiberCrypto.UI as UI

Dialog {
    id: dialogAddWallet

    title: qsTr("Add wallet")
    standardButtons: Dialog.Ok | Dialog.Cancel

    UI.ContentAddWallet {
        id: contentAddWallet
        width: parent.width
        height: parent.height
    }

    Binding {
        target: { dialogAddWallet.visible; return dialogAddWallet.standardButton(Dialog.Ok) }
        property: "text"
        value: contentAddWallet.mode === UI.ContentAddWallet.CreateWallet ? qsTr("Create") : qsTr("Load")
    }

    /*
    onAccepted: {
        var scanA = 0
        if(encryptionEnabled){
            if (mode === CreateLoadWallet.Load){
                scanA = 10
            }
            
            walletModel.addWallet(walletManager.createEncryptedWallet(seed, name, comboBoxWalletType.model[comboBoxWalletType.currentIndex].name, textFieldPassword.text, scanA))
            
        } else {
            
            if (mode === CreateLoadWallet.Load){
                scanA = 10
            }
            walletModel.addWallet(walletManager.createUnencryptedWallet(seed, name, comboBoxWalletType.model[comboBoxWalletType.currentIndex].name, scanA))
        }
        textFieldPassword.text = ""
    }

    function updateAcceptButtonStatus() {

        var walletName = createLoadWallet.name
        var walletSeed = createLoadWallet.seed
        var walletSeedConfirm = createLoadWallet.seedConfirm
        
        var words = walletSeed.split(' ')

        var invalidNumberOfWords = words.length !== 12 && words.length !== 24
        var invalidChars = walletSeed.search("[^a-z ]|[ ]{2}") !== -1
        var unconventionalSeed = invalidNumberOfWords || invalidChars
        var continueWithUnconventionalSeed = checkBoxContinueWithSeedWarning.checked
        
        var seedMatchConfirmation = walletSeed === walletSeedConfirm
        if (createLoadWallet.mode === CreateLoadWallet.Load){
            seedMatchConfirmation = true
        }
        var passwordNeeded = checkBoxEncryptWallet.checked
        var passwordSet = textFieldPassword.text
        var passwordMatchConfirmation = textFieldPassword.text === textFieldConfirmPassword.text

        columnLayoutSeedWarning.warn = walletName && walletSeed && seedMatchConfirmation && !(!unconventionalSeed)

        var okButton = standardButton(Dialog.Ok)

        var isSeedValid = walletManager.verifySeed(createLoadWallet.seed)
        
        okButton.enabled = walletName && walletSeed && seedMatchConfirmation && ((passwordSet && passwordMatchConfirmation) || !passwordNeeded) && (!unconventionalSeed || continueWithUnconventionalSeed) && isSeedValid
    }
    */
}

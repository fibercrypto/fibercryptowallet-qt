import QtQuick
import QtQuick.Controls

import "Pages" as Pages

Item {
    id: applicationWindowContent

    StackView {
        id: stackViewPages
        width: parent.width
        height: parent.height
        initialItem: componentPageCreateWallet
    }

    Component {
        id: componentPageCreateWallet

        Item {
            Pages.PageCreateWallet {
                id: pageCreateWallet
                x: (parent.width - width)/2
                y: (parent.height - height)/2
                width: 400
                height: 400

                onWalletCreationRequested: {
                     stackViewPages.replace(componentPageOverview)
                    // walletManager.createUnencryptedWallet(pageCreateWallet.seed, pageCreateWallet.name, walletManager.getDefaultWalletType() ,0)
                }

                onWalletLoadingRequested:{
                     stackViewPages.replace(componentPageOverview)
                    // walletManager.createUnencryptedWallet(pageCreateWallet.seed, pageCreateWallet.name, walletManager.getDefaultWalletType(), 10)
                }
            }
        }
    } // Component (PageCreateWallet)

    Component {
        id: componentPageOverview

        Pages.PageOverview {
        }
    }
}

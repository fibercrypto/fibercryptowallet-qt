import QtQuick
import QtQuick.Controls

import FiberCrypto.UI as UI

Item {
    id: applicationWindowContent

    enum AvailablePages { CreateWalletPage,  OverviewPage, TestPage }

    property int currentPage: ApplicationWindowContent.AvailablePages.CreateWalletPage

    function testPage() {
        if (stackViewPages.depth > 1) {
            stackViewPages.pop()
        } else {
            applicationWindowContent.currentPage = ApplicationWindowContent.AvailablePages.TestPage
            stackViewPages.push(componentPageTest)
        }
    }

    StackView {
        id: stackViewPages
        width: parent.width
        height: parent.height
        initialItem: componentPageCreateWallet
    }

    Component {
        id: componentPageCreateWallet

        Item {
            UI.PageCreateWallet {
                id: pageCreateWallet
                width: parent.width
                height: parent.height

                onWalletCreationRequested: {
                    stackViewPages.replace(componentPageOverview)
                    applicationWindowContent.currentPage = ApplicationWindowContent.AvailablePages.OverviewPage
                    // walletManager.createUnencryptedWallet(pageCreateWallet.seed, pageCreateWallet.name, walletManager.getDefaultWalletType() ,0)
                }

                onWalletLoadingRequested:{
                    stackViewPages.replace(componentPageOverview)
                    applicationWindowContent.currentPage = ApplicationWindowContent.AvailablePages.OverviewPage
                    // walletManager.createUnencryptedWallet(pageCreateWallet.seed, pageCreateWallet.name, walletManager.getDefaultWalletType(), 10)
                }
            }
        }
    } // Component (PageCreateWallet)

    Component {
        id: componentPageOverview

        UI.PageOverview {
            id: pageOverview
        }
    }

    Component {
        id: componentPageTest

        UI.PageTest {
            id: pageTest
        }
    }
}

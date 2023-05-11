import QtQuick
import QtQuick.Controls.Material

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
        initialItem: componentPageWelcome //componentPageOverview
    }

    Component {
        id: componentPageWelcome

        Item {
            UI.PageWelcome {
                id: pageWelcome
                width: parent.width
                height: parent.height

                onWalletCreationRequested: {
                    stackViewPages.replace(componentPageCreateWallet)
                    applicationWindowContent.currentPage = ApplicationWindowContent.AvailablePages.OverviewPage
                    // walletManager.createUnencryptedWallet(pageWelcome.seed, pageWelcome.name, walletManager.getDefaultWalletType() ,0)
                }

                onWalletLoadingRequested: {
                    stackViewPages.replace(componentPageOverview)
                    applicationWindowContent.currentPage = ApplicationWindowContent.AvailablePages.OverviewPage
                    // walletManager.createUnencryptedWallet(pageWelcome.seed, pageWelcome.name, walletManager.getDefaultWalletType(), 10)
                }
            }
        }
    } // Component (PageWelcome)

    Component {
        id: componentPageCreateWallet

        UI.PageCreateWallet {
            id: pageCreateWallet

            onFinished: {
                stackViewPages.replace(componentPageOverview)
            }

            onCancelled: {
                stackViewPages.replace(componentPageWelcome)
            }
        }
    }

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

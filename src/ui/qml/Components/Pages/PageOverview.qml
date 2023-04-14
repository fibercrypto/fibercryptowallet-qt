import QtQuick
import QtQuick.Controls.Material

import FiberCrypto.UI as UI

Page {
    id: pageOverview

    header: TabBar {
        id: tabBar
        currentIndex: swipeView.currentIndex
        Material.background: pageOverview.Material.dialogColor

        TabButton {
            text: qsTr("Wallets")
        }
        TabButton {
            text: qsTr("Send")
        }
        TabButton {
            text: qsTr("History")
        }
    }

    SwipeView {
        id: swipeView

        width: parent.width
        height: parent.height
        currentIndex: tabBar.currentIndex

        UI.PageWallets { }
        UI.PageSend { }
        UI.PageHistory { }
    }
}

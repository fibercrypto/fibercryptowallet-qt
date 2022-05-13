import QtQuick
import QtQuick.Controls

Page {
    id: pageOverview

    header: TabBar {
        id: tabBar
        currentIndex: swipeView.currentIndex

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
        onCurrentIndexChanged: pageHistory.visible = true

        PageWallets { }
        PageSend { }
        PageHistory { id: pageHistory; visible: false } // TODO: Remove after the bug is solved
    }
}

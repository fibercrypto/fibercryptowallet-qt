import QtQuick
import QtQuick.Controls

Page {

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

        PageWallets { }
        Page {}
        Page {}

//        PageSend { }
//        PageHistory { }
    }
}

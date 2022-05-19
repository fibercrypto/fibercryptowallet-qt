import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

import FiberCrypto.UI as UI

Dialog {
    id: dialogSelectAddressByWallet

    property alias model: listView.model
    property alias filterString: textFieldFilterWallet.text
    property string selectedAddress

    padding: 0
    topPadding: 6
    standardButtons: Dialog.Cancel

    closePolicy: Dialog.CloseOnPressOutside
    onAboutToShow: {
        textFieldFilterWallet.forceActiveFocus()
    }

    Item {
        implicitWidth: 300
        implicitHeight: textFieldFilterWallet.height + 5 + listView.contentHeight
        width: parent.width
        height: parent.height

        UI.TextField {
            id: textFieldFilterWallet

            x: 10
            width: parent.width - 2*x
            placeholderText: qsTr("Filter by wallet name")
            focus: true
            selectByMouse: true
        }

        ListView {
            id: listView

            y: textFieldFilterWallet.height + 5
            width: parent.width
            height: parent.height
            clip: true
            currentIndex: -1

            delegate: MenuItem {
                readonly property string parentWallet: wallet
                readonly property bool matchFilter: !filterString || wallet.toLowerCase().includes(filterString.toLowerCase())

                width: parent.width
                height: matchFilter ? implicitHeight : 0
                Behavior on height { NumberAnimation { easing.type: Easing.OutQuint } }
                focusPolicy: Qt.NoFocus
                text: address
                font.family: "Code New Roman"
                Material.foreground: hovered ? parent.Material.accent : parent.Material.foreground
                highlighted: hovered
                leftPadding: highlighted ? 2*padding : padding // added
                Behavior on leftPadding { NumberAnimation { duration: 500; easing.type: Easing.OutQuint } } // added
            
                onHighlightedChanged: {
                    ListView.view.currentIndex = highlighted ? index : ListView.view.currentIndex
                }

                onTriggered: {
                    selectedAddress = address
                    accept()
                }
            }

            section.property: "wallet"
            section.criteria: ViewSection.FullString
            section.delegate: Label {
                readonly property color textColor: Material.foreground//BUGGY: (ListView.view.currentItem && ListView.view.currentItem.parentWallet === text) ? Material.accent : Material.foreground
                readonly property bool matchFilter: !filterString || section.toLowerCase().includes(filterString.toLowerCase())

                height: matchFilter ? contentHeight * 1.5 : 0
                Behavior on height { NumberAnimation { easing.type: Easing.OutQuint } }
                verticalAlignment: Text.AlignBottom
                text: section
                clip: true
                leftPadding: 12
                font.bold: true
                font.pointSize: Qt.application.font.pointSize * 1.5
                color: textColor
                Behavior on color { ColorAnimation { duration: 150 } }
            }

            ScrollBar.vertical: UI.CustomScrollBar {}
        } // ListView
    } // Item
}

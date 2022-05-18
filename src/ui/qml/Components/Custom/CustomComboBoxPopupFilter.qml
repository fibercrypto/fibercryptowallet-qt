import QtQuick
import QtQuick.Controls

import FiberCrypto.UI as UI

Popup {
    id: customComboBoxPopupFilter

    property ComboBox comboBox: null
    property alias filterText: textFieldFilter.text
    property alias filterPlaceholderText: textFieldFilter.placeholderText

    y: comboBox.editable ? comboBox.height - 5 : 0
    width: comboBox.width
    height: Math.min(contentItem.implicitHeight + topPadding + bottomPadding, Overlay.overlay.height - topMargin - bottomMargin)
    transformOrigin: Item.Top
    topMargin: 12
    bottomMargin: 12
    padding: 0
    topPadding: 6

    onAboutToShow: {
        textFieldFilter.forceActiveFocus()
    }

    contentItem: Item {
        implicitWidth: customComboBoxPopupFilter.width
        implicitHeight: textFieldFilter.height + listView.height
        clip: true

        UI.TextField {
            id: textFieldFilter

            x: 12
            width: parent.width - 2*x
            placeholderText: qsTr("Filter")
            selectByMouse: true
            focus: true
        }

        ListView {
            id: listView

            y: textFieldFilter.height + 5
            width: parent.width
            clip: true
            implicitHeight: contentHeight
            model: comboBox.delegateModel
            currentIndex: comboBox.highlightedIndex
            highlightMoveDuration: 0

            ScrollBar.vertical: UI.CustomScrollBar {}
        }
    }
}

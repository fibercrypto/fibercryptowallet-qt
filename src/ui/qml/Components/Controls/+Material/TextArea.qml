import QtQuick
import QtQuick.Templates as T
import QtQuick.Controls.impl
import QtQuick.Controls.Material
import QtQuick.Controls.Material.impl

T.TextArea {
    id: control

    implicitWidth: Math.max(contentWidth + leftPadding + rightPadding,
                            implicitBackgroundWidth + leftInset + rightInset,
                            placeholder.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(contentHeight + topPadding + bottomPadding,
                             implicitBackgroundHeight + topInset + bottomInset,
                             placeholder.implicitHeight + 1 + topPadding + bottomPadding)

    topPadding: 12
    padding: 4

    color: enabled ? Material.foreground : Material.hintTextColor
    selectionColor: Material.accentColor
    selectedTextColor: Material.primaryHighlightedTextColor
    placeholderTextColor: Material.hintTextColor
    cursorDelegate: CursorDelegate { }

    PlaceholderText {
        id: placeholder

        property bool floatPlaceholderText: !(!control.length && !control.preeditText && (!control.activeFocus || control.horizontalAlignment !== Qt.AlignHCenter))
        readonly property real placeholderTextScaleFactor: 0.9

        x: floatPlaceholderText ? 0 : control.leftPadding//~~((floatPlaceholderText ? 0 : control.leftPadding) - width * (1-scale)/2)
        Behavior on x { NumberAnimation { duration: 250; easing.type: Easing.OutQuint } }
        y: ~~(floatPlaceholderText ? -control.topPadding*(1.20 - placeholderTextScaleFactor) : control.topPadding)
        Behavior on y { NumberAnimation { duration: 250; easing.type: Easing.OutQuint } }
        scale: floatPlaceholderText ? placeholderTextScaleFactor : 1
        Behavior on scale { NumberAnimation { duration: 250; easing.type: Easing.OutQuint } }
        height: control.height - (control.topPadding + control.bottomPadding)
        text: control.placeholderText
        color: floatPlaceholderText && control.activeFocus ? control.Material.accentColor : control.placeholderTextColor
        Behavior on color { ColorAnimation { duration: 250 } }
        verticalAlignment: control.verticalAlignment
        elide: Text.ElideRight
        renderType: control.renderType
    }

    background: Rectangle {
        y: ~~(control.topPadding/2)
        z: -2
        width: control.width
        height: control.height - y
        implicitWidth: 120
        color: control.Material.backgroundColor

        Rectangle { // left
            id: rectangleBackgroundLeft
            width: 1 // use 2 but first we need to set up a behavior like the TextField
            height: parent.height
            // there's a bug if the border's color is fully opaque
            border.color: control.activeFocus ? Qt.alpha(control.Material.accent, 0.99) : control.hovered ? control.Material.primaryTextColor : Material.style === Material.Light ? "#FE9F9F9F" : "#FE7A7A7A"
            Behavior on border.color { ColorAnimation {} }
        }
        Rectangle { // bottom
            y: parent.height - height
            width: parent.width
            height: rectangleBackgroundLeft.width
            border.color: rectangleBackgroundLeft.border.color
        }
        Rectangle { // right
            x: parent.width - width
            width: rectangleBackgroundLeft.width
            height: parent.height
            border.color: rectangleBackgroundLeft.border.color
        }
        Rectangle { // top
            y: 1
            x: parent.width
            width: parent.width - (placeholder.floatPlaceholderText ? placeholder.width : 0)
            Behavior on width { NumberAnimation { duration: 250; easing.type: Easing.OutQuint } }
            height: rectangleBackgroundLeft.width
            transformOrigin: Item.TopLeft
            rotation: 180
            border.color: rectangleBackgroundLeft.border.color
        }
    } // Rectangle (backgrouns)

    Menu {
        id: contextMenu

        focus: false

        ItemDelegate { text: qsTr("Cut");        icon.source: "qrc:/images/icons/actions/content_cut.svg";           onClicked: { control.cut(); contextMenu.close() }       enabled: control.selectedText }
        ItemDelegate { text: qsTr("Copy");       icon.source: "qrc:/images/icons/actions/content_copy.svg";          onClicked: { control.copy(); contextMenu.close() }      enabled: control.selectedText }
        ItemDelegate { text: qsTr("Paste");      icon.source: "qrc:/images/icons/actions/content_paste.svg";         onClicked: { control.paste(); contextMenu.close() }     enabled: control.canPaste }
        MenuSeparator {}
        ItemDelegate { text: qsTr("Select all"); icon.source: "qrc:/images/icons/actions/content_all_selection.svg"; onClicked: { control.selectAll(); contextMenu.close() } enabled: control.selectedText !== control.text }
        MenuSeparator {}
        ItemDelegate { text: qsTr("Undo");       icon.source: "qrc:/images/icons/actions/content_undo.svg";          onClicked: { control.undo(); contextMenu.close() }      enabled: control.canUndo }
        ItemDelegate { text: qsTr("Redo");       icon.source: "qrc:/images/icons/actions/content_redo.svg";          onClicked: { control.redo(); contextMenu.close() }      enabled: control.canRedo }
    }

    onPressed: function(event) {
        if (event.button === Qt.RightButton) {
            control.focus = true
            contextMenu.popup()
        }
    }
}

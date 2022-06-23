import QtQuick
import QtQuick.Templates as T
import QtQuick.Controls
import QtQuick.Controls.impl
import QtQuick.Controls.Material
import QtQuick.Controls.Material.impl

T.TextField {
    id: control

    implicitWidth: implicitBackgroundWidth + leftInset + rightInset
                   || Math.max(contentWidth, placeholder.implicitWidth) + leftPadding + rightPadding
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding,
                             placeholder.implicitHeight + topPadding + bottomPadding)

    topPadding: 16
    bottomPadding: 9

    color: enabled ? Material.foreground : Material.hintTextColor
    selectionColor: Material.accentColor
    selectedTextColor: Material.primaryHighlightedTextColor
    placeholderTextColor: Material.hintTextColor
    verticalAlignment: TextInput.AlignVCenter

    cursorDelegate: CursorDelegate { }

    PlaceholderText {
        id: placeholder

        property bool floatPlaceholderText: !(!control.length && !control.preeditText && (!control.activeFocus || control.horizontalAlignment !== Qt.AlignHCenter))
        readonly property real placeholderTextScaleFactor: 0.9

        x: ~~((floatPlaceholderText ? 0 : control.leftPadding) - width * (1-scale)/2)
        y: ~~(floatPlaceholderText ? -control.topPadding*(1.05 - placeholderTextScaleFactor) : control.topPadding)
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
        y: control.height - height - control.bottomPadding + 8
        implicitWidth: 120
        height: 1
        color: control.hovered ? control.Material.accentColor : control.Material.hintTextColor // accentColor or primaryTextColor?
        Behavior on color { ColorAnimation { duration: 200 } }

        Item {
            id: itemAccentBackground

            property real centerX: width/2

            readonly property bool controlHasActiveFocus: control.activeFocus
            onControlHasActiveFocusChanged: {
                if (controlHasActiveFocus) {
                    animationOnActiveFocusLeft.start()
                    animationOnActiveFocusRight.start()
                } else {
                    animationOnUnactiveFocus.start()
                }
            }

            y: -1
            width: parent.width
            height: 2
            implicitWidth: 120

            Rectangle {
                id: rectangleAccentLeft

                x: itemAccentBackground.centerX
                y: 2
                width: x
                rotation: 180
                transformOrigin: Qt.TopLeftCorner
                height: 2
                color: control.Material.accentColor
                opacity: 0
                onVisibleChanged: if (control.activeFocus) opacity = 1 // ???
            } // Rectangle (left)

            Rectangle {
                id: rectangleAccentRight

                x: itemAccentBackground.centerX
                width: parent.width - x
                height: 2
                color: control.Material.accentColor
                opacity: rectangleAccentLeft.opacity
            } // Rectangle (right)

            SequentialAnimation {
                id: animationOnActiveFocusLeft

                PropertyAction { target: rectangleAccentLeft; property: "width"; value: 0 }
                PropertyAction { target: rectangleAccentLeft; property: "opacity"; value: 1.0 }
                NumberAnimation {
                    target: rectangleAccentLeft
                    property: "width"
                    from: 0
                    to: itemAccentBackground.centerX
                    duration: 350
                    easing.type: Easing.OutQuint
                }
            }

            SequentialAnimation {
                id: animationOnActiveFocusRight

                PropertyAction { target: rectangleAccentRight; property: "width"; value: 0 }
                PropertyAction { target: rectangleAccentRight; property: "opacity"; value: 1.0 }
                NumberAnimation {
                    target: rectangleAccentRight
                    property: "width"
                    from: 0
                    to: itemAccentBackground.width - rectangleAccentRight.x
                    duration: 350
                    easing.type: Easing.OutQuint
                }
            }

            NumberAnimation {
                id: animationOnUnactiveFocus

                target: rectangleAccentLeft
                property: "opacity"
                to: 0.0
                duration: 200

                onFinished: {
                    itemAccentBackground.centerX = itemAccentBackground.width/2
                }
            }
        } // Item (background accent)
    } // Rectangle (decoration background)

    Menu {
        id: contextMenu

        focus: false

        ItemDelegate  { text: qsTr("Cut");        icon.source: "qrc:/images/icons/actions/content_cut.svg";           onClicked: { control.cut(); contextMenu.close() }       enabled: control.selectedText && control.echoMode === TextField.Normal }
        ItemDelegate  { text: qsTr("Copy");       icon.source: "qrc:/images/icons/actions/content_copy.svg";          onClicked: { control.copy(); contextMenu.close() }      enabled: control.selectedText && control.echoMode === TextField.Normal }
        ItemDelegate  { text: qsTr("Paste");      icon.source: "qrc:/images/icons/actions/content_paste.svg";         onClicked: { control.paste(); contextMenu.close() }     enabled: control.canPaste }
        MenuSeparator { }
        ItemDelegate  { text: qsTr("Select all"); icon.source: "qrc:/images/icons/actions/content_all_selection.svg"; onClicked: { control.selectAll(); contextMenu.close() } enabled: control.selectedText !== control.text }
        MenuSeparator { }
        ItemDelegate  { text: qsTr("Undo");       icon.source: "qrc:/images/icons/actions/content_undo.svg";          onClicked: { control.undo(); contextMenu.close() }      enabled: control.canUndo }
        ItemDelegate  { text: qsTr("Redo");       icon.source: "qrc:/images/icons/actions/content_redo.svg";          onClicked: { control.redo(); contextMenu.close() }      enabled: control.canRedo }
    }

    onReleased: function(event) {
        if (event.button === Qt.RightButton) {
            control.focus = true
            contextMenu.popup()
        }
        if (!control.activeFocus) {
            itemAccentBackground.centerX = event.x
        }
    }
}

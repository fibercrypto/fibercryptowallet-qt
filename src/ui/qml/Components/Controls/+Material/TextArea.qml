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

    topPadding: 16
    bottomPadding: 9

    color: enabled ? Material.foreground : Material.hintTextColor
    selectionColor: Material.accentColor
    selectedTextColor: Material.primaryHighlightedTextColor
    placeholderTextColor: Material.hintTextColor
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
        id: rectangleBackground

        y: control.height - height - control.bottomPadding + 8
        implicitWidth: 120
        height: 1
        color: control.hovered ? control.Material.primaryTextColor : control.Material.hintTextColor
        Behavior on color { ColorAnimation {} }

        Rectangle {
            id: accentRect

            readonly property bool controlHasActiveFocus: control.activeFocus

            onControlHasActiveFocusChanged: {
                if (controlHasActiveFocus) {
                    animationOnActiveFocus.start()
                } else {
                    animationOnUnactiveFocus.start()
                }
            }

            y: parent.y
            implicitWidth: 120
            width: control.activeFocus ? parent.width : 0
            height: 2
            anchors.centerIn: parent
            color: control.Material.accentColor

            NumberAnimation {
                id: animationOnActiveFocus

                target: accentRect
                property: "width"
                from: 0.0
                to: accentRect.parent.width
                duration: 350
                easing.type: Easing.OutQuint
            }

            NumberAnimation {
                id: animationOnUnactiveFocus

                target: accentRect
                property: "opacity"
                from: 1.0
                to: 0.0
                duration: 350
                easing.type: Easing.OutQuint

                onFinished: {
                    target.width = 0
                    target.opacity = 1.0
                }
            }
        }
    }

    Menu {
        id: contextMenu

        focus: false

        ItemDelegate { text: qsTr("Cut");        icon.source: "qrc:/images/icons/actions/content_cut.svg";           onClicked: { control.cut(); contextMenu.close() }       enabled: control.selectedText && control.echoMode === TextInput.Normal }
        ItemDelegate { text: qsTr("Copy");       icon.source: "qrc:/images/icons/actions/content_copy.svg";          onClicked: { control.copy(); contextMenu.close() }      enabled: control.selectedText && control.echoMode === TextInput.Normal }
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
        } else {
            console.log(control.focus)
        }
    }
}

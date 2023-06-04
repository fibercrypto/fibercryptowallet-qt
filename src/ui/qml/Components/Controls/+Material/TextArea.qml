// Copyright (C) 2017 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR LGPL-3.0-only OR GPL-2.0-only OR GPL-3.0-only

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
                             implicitBackgroundHeight + topInset + bottomInset)

    leftPadding: Material.textFieldHorizontalPadding
    rightPadding: Material.textFieldHorizontalPadding
    // Need to account for the placeholder text when it's sitting on top.
    topPadding: Material.containerStyle === Material.Filled && placeholderText.length > 0 && (activeFocus || length > 0)
        ? Material.textFieldVerticalPadding + placeholder.largestHeight
        // When the condition above is not met, the text should always sit in the middle
        // of a default-height TextArea, which is just near the top for a higher-than-default one.
        : (implicitBackgroundHeight - placeholder.largestHeight) / 2
    bottomPadding: Material.textFieldVerticalPadding

    color: enabled ? Material.foreground : Material.hintTextColor
    selectionColor: Material.accentColor
    selectedTextColor: Material.primaryHighlightedTextColor
    placeholderTextColor: enabled && activeFocus ? Material.accentColor : Material.hintTextColor

    Material.containerStyle: Material.Outlined

    cursorDelegate: CursorDelegate { }

    FloatingPlaceholderText {
        id: placeholder
        x: control.leftPadding
        width: control.width - (control.leftPadding + control.rightPadding)
        text: control.placeholderText
        font: control.font
        color: control.placeholderTextColor
        elide: Text.ElideRight
        renderType: control.renderType
        // When the TextArea is in a Flickable, the background is reparented to it
        // so that decorations don't move with the content. We need to do the same.
        parent: control.background.parent

        filled: control.Material.containerStyle === Material.Filled
        verticalPadding: control.Material.textFieldVerticalPadding
        controlHasActiveFocus: control.activeFocus
        controlHasText: control.length > 0
        controlImplicitBackgroundHeight: control.implicitBackgroundHeight
        controlHeight: control.height
    }

    background: MaterialTextContainer {
        implicitWidth: 120
        implicitHeight: control.Material.textFieldHeight

        filled: control.Material.containerStyle === Material.Filled
        fillColor: control.Material.textFieldFilledContainerColor
        outlineColor: (enabled && control.hovered) ? control.Material.primaryTextColor : control.Material.hintTextColor
        focusedOutlineColor: control.Material.accentColor
        // When the control's size is set larger than its implicit size, use whatever size is smaller
        // so that the gap isn't too big.
        placeholderTextWidth: Math.min(placeholder.width, placeholder.implicitWidth) * placeholder.scale
        controlHasActiveFocus: control.activeFocus
        controlHasText: control.length > 0
        placeholderHasText: placeholder.text.length > 0
        horizontalPadding: control.Material.textFieldHorizontalPadding
    }

    // added everything bellow
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

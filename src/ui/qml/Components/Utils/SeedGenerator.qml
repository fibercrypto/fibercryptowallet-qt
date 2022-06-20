import QtQuick
import QtQuick.Controls

import FiberCrypto.UI as UI

Item {
    id: seedGenerator

    property alias seed: textAreaSeed.text
    property alias placeholderSeedText: textAreaSeed.placeholderText
    property alias seedReadOnly: textAreaSeed.readOnly
    property alias buttonSeed12Text: buttonSeed12.text
    property alias buttonSeed24Text: buttonSeed24.text

    property bool showModeButtons: true
    property bool defaultSeed12: true
    readonly property bool generateSeed12: buttonSeed12.checked
    readonly property bool generateSeed24: buttonSeed24.checked
    property Item nextTabItem: null

    implicitHeight: buttonSeed12.height + textAreaSeed.height + 5

    ButtonGroup {
        buttons: [buttonSeed12, buttonSeed24]
    }

    Button {
        id: buttonSeed12

        width: ~~(parent.width/2 - 3)
        height: showModeButtons ? implicitHeight : 0
        Behavior on height { NumberAnimation { duration: 500; easing.type: Easing.OutQuint } }

        opacity: showModeButtons ? 1 : 0
        Behavior on opacity { NumberAnimation { } }
        text: qsTr("12 words")
        checkable: true
        checked: defaultSeed12
        highlighted: checked
        flat: true
    }

    Button {
        id: buttonSeed24

        x: buttonSeed12.x + buttonSeed12.width + 6
        y: buttonSeed12.y
        width: buttonSeed12.width
        height: buttonSeed12.height
        opacity: buttonSeed12.opacity
        text: qsTr("24 words")
        checkable: true
        checked: !defaultSeed12
        highlighted: checked
        flat: true
    }

    UI.TextArea {
        id: textAreaSeed

        y: buttonSeed12.y + buttonSeed12.height + 5
        width: parent.width
        height: contentHeight + topPadding + bottomPadding
        wrapMode: TextArea.Wrap
        clip: true
        selectByMouse: true
        placeholderText: qsTr("Secret recovery phrase")
        KeyNavigation.priority: KeyNavigation.BeforeItem
        KeyNavigation.tab: nextTabItem
    }
}

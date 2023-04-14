import QtQuick
import QtQuick.Controls.Material

Rectangle {
    id: indicatorItem

    property Item control
    property bool checked: control.checked

    implicitWidth: 18
    implicitHeight: 18
    radius: width / 2
    border.width: checked ? width / 2 : 2
    border.color: !control.enabled ? control.Material.hintTextColor : applicationWindow.Material.backgroundColor
    color: "transparent"

    Behavior on border.width {
        NumberAnimation {
            duration: 100
            easing.type: Easing.OutCubic
        }
    }

    Behavior on border.color {
        ColorAnimation {
            duration: 100
            easing.type: Easing.OutCubic
        }
    }

    // TODO: This needs to be transparent
    ToolButton {
        id: checkImage

        x: ~~((parent.width - width) / 2)
        y: ~~((parent.height - height) / 2)

        icon.width: 14
        icon.height: 14
        icon.source: "qrc:/qt-project.org/imports/QtQuick/Controls/Material/images/check.png"
        icon.color: Material.accent

        enabled: false
        background: null
        scale: indicatorItem.checked ? 1 : 0
        Behavior on scale { NumberAnimation { duration: 100 } }
    }

    states: [
        State {
            name: "checked"
            when: indicatorItem.checked
        }
    ]

    transitions: Transition {
        SequentialAnimation {
            NumberAnimation {
                target: indicatorItem
                property: "scale"
                // Go down 2 pixels in size.
                to: 1 - 2 / indicatorItem.width
                duration: 120
            }
            NumberAnimation {
                target: indicatorItem
                property: "scale"
                to: 1
                duration: 120
            }
        }
    }
}

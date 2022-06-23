import QtQuick
import QtQuick.Controls.Material

Rectangle {
    id: indicatorItem
    implicitWidth: 18
    implicitHeight: 18
    color: "transparent"
    border.color: !control.enabled ? control.Material.hintTextColor : checked ? "transparent" : applicationWindow.Material.primaryHighlightedTextColor
    border.width: checked ? width / 2 : 2
    radius: 2

    property Item control
    property bool checked: control.checked

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
    Image {
        id: checkImage
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        width: 14
        height: 14
        source: "qrc:/qt-project.org/imports/QtQuick/Controls/Material/images/check.png"
        fillMode: Image.PreserveAspectFit

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

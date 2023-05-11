import QtQuick
import QtQuick.Templates as T
import QtQuick.Controls.Material
import QtQuick.Controls.Material.impl

Rectangle {
    id: indicator
    implicitWidth: 20
    implicitHeight: 20
    radius: width / 2
    border.width: 2
    border.color: !control.enabled ? control.Material.hintTextColor
        : control.checked || control.down ? control.Material.accentColor : control.Material.secondaryTextColor
    color: "transparent"

    property T.AbstractButton control

    Rectangle {
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        width: indicator.control.checked ? 10 : 0
        Behavior on width { NumberAnimation { easing.type: Easing.OutBack } }
        height: width
        radius: width / 2
        color: parent.border.color
    }
}

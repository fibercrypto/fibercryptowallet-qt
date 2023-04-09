import QtQuick
import QtQuick.Controls.Material

CheckDelegate {
    id: root

    text: ""// a role of the model
    font.family: "Code New Roman"
    leftPadding: 20
    scale: 0.85

    LayoutMirroring.enabled: true
    contentItem: Label {
        leftPadding: root.indicator.width + root.spacing
        text: root.text
        verticalAlignment: Qt.AlignVCenter
        color: root.enabled ? root.Material.foreground : root.Material.hintTextColor
    }
}

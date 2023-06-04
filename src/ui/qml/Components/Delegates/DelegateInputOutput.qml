import QtQuick
import QtQuick.Controls.Material

Item {
    id: root

    readonly property real biggestLabel: Math.max(labelCoins.width, labelHours.width)

    implicitHeight: labelHours.y + labelHours.height

    Label {
        id: labelIndex

        text: index + 1 + "."
        font.pointSize: Qt.application.font.pointSize * 0.9
        font.bold: true
    }
    Label {
        id: labelAddress

        x: labelIndex.width + 4
        y: (labelIndex.height - height)/2
        text: address
        font.family: "Code New Roman"
        font.pointSize: Qt.application.font.pointSize * 0.9
        font.bold: true
    }

    Label {
        id: labelCoins

        x: labelIndex.width + 4
        y: labelAddress.height + 4
        text: qsTr("Coins:")
        font.pointSize: Qt.application.font.pointSize * 0.9
        font.bold: true
    }
    Label {
        x: labelCoins.x + biggestLabel + 4
        y: labelCoins.y
        text: addressSky
        font.pointSize: Qt.application.font.pointSize * 0.9
    }

    Label {
        id: labelHours

        x: labelIndex.width + 4
        y: labelCoins.y + labelCoins.height + 4
        text: qsTr("Hours:")
        font.pointSize: Qt.application.font.pointSize * 0.9
        font.bold: true
    }
    Label {
        x: labelCoins.x + biggestLabel + 4
        y: labelHours.y
        text: addressCoinHours
        font.pointSize: Qt.application.font.pointSize * 0.9
    }
}

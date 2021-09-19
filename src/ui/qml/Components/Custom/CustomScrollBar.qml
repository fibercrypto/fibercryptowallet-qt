import QtQuick
import QtQuick.Controls

ScrollBar {
    id: scrollBar

    padding: 2
    contentItem: Rectangle {
        implicitWidth: 6
        implicitHeight: 6
        radius: width/2

        color: scrollBar.pressed ? scrollBar.Material.scrollBarPressedColor :
               scrollBar.interactive && scrollBar.hovered ? scrollBar.Material.scrollBarHoveredColor : scrollBar.Material.scrollBarColor
        opacity: 0.0
    }
    background: Rectangle {
        implicitWidth: 6
        implicitHeight: 6
        radius: width/2

        color: "#0e000000"
        opacity: 0.0
    }
}

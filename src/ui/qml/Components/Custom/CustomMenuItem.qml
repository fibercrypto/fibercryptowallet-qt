import QtQuick
import QtQuick.Controls.Material

MenuItem {
    property alias iconSource: imageIcon.source
    property alias iconSourceSize: imageIcon.sourceSize

    leftPadding: highlighted ? imageIcon.sourceSize.width + 12 : padding
    Behavior on leftPadding { NumberAnimation { duration: 500; easing.type: Easing.OutQuint } }

    Image {
        id: imageIcon

        x: parent.highlighted ? 6 : -width/2
        Behavior on x { NumberAnimation { duration: 500; easing.type: Easing.OutQuint } }
        y: ~~((parent.height - height)/2)
        
        sourceSize: "24x24" // same as Qt.size(24, 24)
        fillMode: Image.PreserveAspectFit

        visible: opacity > 0
        opacity: parent.highlighted ? 1.0 : 0.0
        Behavior on opacity { NumberAnimation { duration: 500; easing.type: Easing.OutQuint } }
    }
}

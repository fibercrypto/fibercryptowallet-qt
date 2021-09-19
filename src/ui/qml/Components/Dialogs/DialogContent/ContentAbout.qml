import QtQuick
import QtQuick.Controls

import "../../Custom" as Custom

Item {
    id: about

    signal licenseRequested()

    function animate() {
        if (imageAppIcon.opacity <= 0.0) {
            imageAppIcon.animate()
        }
    }

    implicitWidth: Math.max(imageAppIcon.width + labelAbout.implicitWidth > 400 ? 400 : imageAppIcon.width + labelAbout.implicitWidth)
    implicitHeight: flickable.contentHeight

    Flickable {
        id: flickable

        width: parent.width
        height: parent.height
        contentWidth: width
        contentHeight: column.height
        clip: true

        Column {
            id: column
            spacing: 10
            width: parent.width

            Image {
                id: imageAppIcon

                function animate() { imageAppIconAnimation.start() }

                anchors.horizontalCenter: parent.horizontalCenter
                fillMode: Image.PreserveAspectFit
                source: "qrc:/images/icons/app/appIcon.png"
                sourceSize: Qt.size(148, 148)
                opacity: 0.0

                SequentialAnimation {
                    id: imageAppIconAnimation
                    loops: 1

                    PauseAnimation { duration: 300 }
                    ParallelAnimation {
                        NumberAnimation {
                            target: imageAppIcon
                            property: "opacity"
                            duration: 300
                            alwaysRunToEnd: true
                            from: 0
                            to: 1
                            easing.type: Easing.OutCubic
                        }
                        NumberAnimation {
                            target: imageAppIcon
                            property: "scale"
                            duration: 500
                            alwaysRunToEnd: true
                            from: 0.9
                            to: 1
                            easing.type: Easing.OutBack
                        }
                    } // ParallelAnimation
                } // SequentialAnimation
            } // Image (app's icon)

            Label {
                id: labelAbout
                width: parent.width
                text: "<p><b>" + Qt.application.name + ' v' + Qt.application.version + "</b><br>"
                    + "<i>" + qsTr("Multi-coin cryptocurrency wallet") + "</i><br>"
                    + "Copyright © 2021 " + Qt.application.organization + "</p><br>"

                    + qsTr("<p><b>License terms and disclaimer</b><br>"
                    + "This program is free software; you can redistribute it and/or modify "
                    + "it under the terms of the <a href=\"License\">GNU General Public License</a> as published by "
                    + "the Free Software Foundation; either version 3 of the License, or "
                    + "(at your option) any later version.<br>"
                    + "This program is distributed in the hope that it will be useful, "
                    + "but WITHOUT ANY WARRANTY; without even the implied warranty of "
                    + "MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the "
                    + "<a href=\"License\">GNU General Public License</a> for more details.<br>"
                    + "You should have received a copy of the <a href=\"License\">GNU General Public License</a> along "
                    + "with this program; if not, see <a href=\"%1\">%1</a>.</p><br>").arg("http://www.gnu.org/licenses/")

                    + qsTr("<b>Contact information:</b> <a href=\"mailto:%1\">%1</a>").arg("simelo@gmail.com")
                wrapMode: Label.Wrap
                onHoveredLinkChanged: {
                    mouseAreaLinkHovered.cursorShape = hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
                }
                onLinkActivated: {
                    if (link === qsTr("License")) {
                        licenseRequested()
                    } else {
                        Qt.openUrlExternally(link)
                    }
                }

                MouseArea {
                    id: mouseAreaLinkHovered
                    anchors.fill: parent
                    acceptedButtons: Qt.NoButton
                }
            } // Label
        } // Column

        ScrollBar.vertical: Custom.CustomScrollBar {}
    } // Flickable
}

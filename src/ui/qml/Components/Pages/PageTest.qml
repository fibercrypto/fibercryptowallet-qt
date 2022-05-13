import QtQuick
import QtQuick.Controls

import FiberCrypto.TestPlugin as TestPlugin

Page {
    id: pageTest

    Material.background: Material.Teal

    header: Column {
        Button {
            text: qsTr("Add [123, Frog]")

            onClicked: {
                templateModel.insertItem(listViewTest.count, 123, "Frog")
            }
        }
        Button {
            text: qsTr("Insert at the begining [456, Bird]")

            onClicked: {
                templateModel.insertItem(0, 456, "Bird")
            }
        }
        Button {
            text: qsTr("Edit third item to [789, Fox]")

            onClicked: {
                templateModel.setModelData(2, 789, TestPlugin.TemplateModel.SomeNumberRole)
                templateModel.setModelData(2, "Fox", TestPlugin.TemplateModel.SomeStringRole)
            }
        }
        Button {
            text: qsTr("Remove 2nd item")

            onClicked: {
                templateModel.removeItem(1)
            }
        }
    }

    ListView {
        id: listViewTest

        width: parent.width
        height: parent.height

        model: templateModel
        delegate: Label {
            width: parent ? parent.width : width
            text: someNumber + " - " + someString
        }
    }

    TestPlugin.TemplateModel {
        id: templateModel
    }
}

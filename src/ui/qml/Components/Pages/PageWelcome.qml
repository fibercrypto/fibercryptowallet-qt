import QtQuick
import QtQuick.Controls.Material

Page {
    id: pageWelcome

    signal walletCreationRequested()
    signal walletLoadingRequested()

    // slideshow (a swipe view)?
    Image {
        id: imageWallpaper

        y: -42
        width: parent.width
        height: ~~(parent.height * 0.4)

        source: "qrc:/images/banners/1" + (Material.theme === Material.Dark ? "-dark" : "") + ".jpg"
        fillMode: Image.PreserveAspectCrop
    }

    Button {
        id: buttonCreateWallet

        x: ~~((parent.width - width)/2)
        y: ~~(imageWallpaper.y + imageWallpaper.height + (parent.height - imageWallpaper.height - height)/2)
        width: parent.width > 540 ? 540 - 40 : parent.width - 40
        height: implicitHeight * 2

        text: qsTr("Create new wallet")
        font.pixelSize: Qt.application.font.pixelSize * 2
        Material.background: Material.accent
        Material.foreground: pageWelcome.Material.background

        onClicked: {
            walletCreationRequested()
        }
    }

    Button {
        id: buttonLoadWallet

        x: ~~((parent.width - width)/2)
        y: ~~(buttonCreateWallet.y + buttonCreateWallet.height + 10)
        width: parent.width > 540 ? 540 - 40 : parent.width - 40

        text: qsTr("Load existing wallet")
        flat: true
        highlighted: true

        onClicked: {
            walletLoadingRequested()
        }
    }
}

import QtQuick
import QtQuick.Controls.Material
import QtCore

import FiberCrypto.UI as UI

Page {
    id: pagePreferences

    enum LogLevel { Debug, Information, Warning, Error, FatalError, Panic }
    enum LogOutput { Stdout, Stderr, None, File }

    // BUG: About the wallet path: What happens on Windows?
    // TODO: Consider using `QtCore.StandardPaths.standardLocations(StandardPaths.AppDataLocation)`

    // This file requires access to `settings` item in the `ApplicationWindow` object,
    // which is provided for being its child

    // These are defaults. Will be restored when the "DEFAULT" button is clicked
    readonly property string defaultWalletPath: ""
    readonly property bool defaultIsLocalWalletEnv: true
    readonly property string defaultNodeUrl: ""
    readonly property int defaultLogLevel: 0
    readonly property int defaultLogOutput: 0
    readonly property string defaultLogOutputFile: ""
    readonly property int defaultCacheLifeTime: 10000
    readonly property int defaultCacheUpdateTime: 1000

    // These are the saved settings, must be applied when the settings are opened or when
    // the user clicks "RESET" and updated when the user clicks "APPLY"
    // TODO: This should be **binded** to backend properties
    property string savedWalletPath: settings.value("skycoin/walletSource/1/Source", "")
    property bool savedIsLocalWalletEnv: settings.value("skycoin/walletSource/1/SourceType", "local") === "local"
    property url savedNodeUrl: settings.value("skycoin/node/address", "")
    property int savedLogLevel: ~~settings.value("skycoin/log/level", 0)
    property int savedLogOutput: ~~settings.value("skycoin/log/output", 0)
    property string savedLogOutputFile: settings.value("skycoin/log/outputFile", "")
    property int savedLifeTime: settings.value("global/cache/lifeTime", 10000)
    property int savedUpdateTime: ~~~~settings.value("global/cache/updateTime", 1000)

    // QtObject{
    //     id: logLevel
    //     property string modifier
    //     property string old
    // }

    // These are the properties that are actually set, so they are aliases of the respective
    // control's properties
    property alias walletPath: textFieldWalletPath.text
    property alias isLocalWalletEnv: switchLocalWalletEnv.checked
    property alias nodeUrl: textFieldNodeUrl.text
    property alias logLevel: comboBoxLogLevel.currentIndex
    property alias logOutput: listViewLogOutput.currentIndex
    property alias logOutputFile: listViewLogOutput.outputFile
    property alias cacheLifeTime: textFieldCacheLifeTime.text
    property alias cacheUpdateTime: textFieldCacheUpdateTime.text

    Component.onCompleted: {
        loadSavedSettings()
    }

    function saveCurrentSettings() {
        settings.setValue("skycoin/walletSource/1/Source", walletPath)
        settings.setValue("skycoin/walletSource/1/SourceType", isLocalWalletEnv ? "local" : "remote")
        settings.setValue("skycoin/node/address", nodeUrl)
        settings.setValue("skycoin/log/level", logLevel)
        settings.setValue("skycoin/log/output", logOutput)
        settings.setValue("global/cache/updateTime", cacheUpdateTime)
        settings.setValue("skycoin/log/outputFile", logOutputFile)
        settings.setValue("global/cache/lifeTime", cacheLifeTime)
        loadSavedSettings()
    }

    function loadSavedSettings() {
        walletPath = savedWalletPath = settings.value("skycoin/walletSource/1/Source", "")
        isLocalWalletEnv = savedIsLocalWalletEnv = settings.value("skycoin/walletSource/1/SourceType", "local") === "local"
        nodeUrl = savedNodeUrl = settings.value("skycoin/node/address", "")
        logLevel = savedLogLevel = ~~settings.value("skycoin/log/level", 0)
        logOutput = savedLogOutput = ~~settings.value("skycoin/log/output", 0)
        logOutputFile = savedLogOutputFile = settings.value("skycoin/log/outputFile", "")
        cacheLifeTime = savedLifeTime = ~~settings.value("global/cache/lifeTime", 10000)
        cacheUpdateTime = savedUpdateTime = ~~settings.value("global/cache/updateTime", 1000)

        updateFooterButtonsStatus()
    }

    function restoreDefaultSettings() {
        walletPath = defaultWalletPath
        isLocalWalletEnv = defaultIsLocalWalletEnv
        nodeUrl = defaultNodeUrl
        cacheLifeTime = defaultCacheLifeTime
        logLevel = defaultLogLevel
        logOutput = defaultLogOutput

        saveCurrentSettings()
    }

    function updateFooterButtonsStatus() {
        if (Component.status === Component.Ready) {
            var configChanged = (walletPath !== savedWalletPath || isLocalWalletEnv !== savedIsLocalWalletEnv || nodeUrl != savedNodeUrl || logLevel != savedLogLevel || logOutput != savedLogOutput || logOutputFile != savedLogOutputFile || cacheLifeTime != savedLifeTime)
            var noDefaultConfig = (walletPath !== defaultWalletPath || isLocalWalletEnv !== defaultIsLocalWalletEnv || nodeUrl !== defaultNodeUrl || logLevel !== defaultLogLevel || logOutput !== defaultLogOutput || logOutputFile !== defaultLogOutputFile || cacheLifeTime !== defaultCacheLifeTime)
            footer.standardButton(Dialog.Apply).enabled = configChanged
            footer.standardButton(Dialog.Discard).enabled = configChanged
            footer.standardButton(Dialog.RestoreDefaults).enabled = noDefaultConfig
        }
    }

    footer: DialogButtonBox {
        standardButtons: Dialog.Apply | Dialog.Discard | Dialog.RestoreDefaults
        Material.roundedScale: Material.NotRounded

        onApplied: {
            saveCurrentSettings()
        }

        onDiscarded: {
            dialogConfirmation.onlyDiscard = true
            dialogConfirmation.open()
        }

        onReset: {
            dialogConfirmation.onlyDiscard = false
            dialogConfirmation.open()
        }
    }

    ScrollView {
        id: scrollView
        width: parent.width
        height: parent.height
        contentHeight: groupBoxGlobalSettings.y + groupBoxGlobalSettings.height

        GroupBox {
            id: groupBoxWalletEnvironment

            x: 10
            y: 10
            width: parent.width - 2*x
            contentHeight: textFieldWalletPath.y + textFieldWalletPath.height
            title: qsTr("Wallet environment settings")

            Switch {
                id: switchLocalWalletEnv

                checked: savedIsLocalWalletEnv
                text: qsTr("Save wallets locally")

                onToggled: {
                    updateFooterButtonsStatus()
                }
            }

            UI.TextField {
                id: textFieldWalletPath

                y: switchLocalWalletEnv.y + switchLocalWalletEnv.height + 10
                width: parent.width
                enabled: isLocalWalletEnv
                selectByMouse: true
                placeholderText: qsTr("Local wallet path")

                onTextChanged: {
                    updateFooterButtonsStatus()
                }
            }
        } // GroupBox (wallet environment settings)

        GroupBox {
            id: groupBoxNetworkSettings

            x: 10
            y: groupBoxWalletEnvironment.y + groupBoxWalletEnvironment.height + 10
            width: parent.width - 2*x
            contentHeight: textFieldNodeUrl.height
            title: qsTr("Network settings")

            UI.TextField {
                id: textFieldNodeUrl

                width: parent.width
                selectByMouse: true
                placeholderText: qsTr("Node URL")

                onTextChanged: {
                    updateFooterButtonsStatus()
                }
            }
        } // GroupBox (network settings)

        GroupBox {
            id: groupBoxGlobalSettings

            x: 10
            y: groupBoxNetworkSettings.y + groupBoxNetworkSettings.height + 10
            width: parent.width - 2*x
            contentHeight: listViewLogOutput.y + listViewLogOutput.height

            title: qsTr("Global settings")

            UI.TextField {
                id: textFieldCacheLifeTime

                width: parent.width/2 - 6

                selectByMouse: true
                placeholderText: qsTr("Cache lifetime")
                onTextChanged: {
                    updateFooterButtonsStatus();
                }
                validator: IntValidator {
                    bottom: 0
                    top: 99999999
                }
            }

            UI.TextField {
                id: textFieldCacheUpdateTime

                x: textFieldCacheLifeTime.x + textFieldCacheLifeTime.width + 12
                width: parent.width - x

                selectByMouse: true
                placeholderText: qsTr("Time to update")

                onTextChanged: {
                    updateFooterButtonsStatus();
                }
                validator: IntValidator {
                    bottom: 0
                    top: 99999999
                }
            }

            Label {
                id: labelLogLevel
                y: textFieldCacheUpdateTime.y + textFieldCacheUpdateTime.height + 10
                text: qsTr("Log level")
            }

            UI.ComboBox {
                id: comboBoxLogLevel

                y: labelLogLevel.y + labelLogLevel.height + 6
                width: parent.width

                readonly property var logLevelString: [ "debug", "info", "warn", "error", "fatal", "panic" ]
                readonly property var logLevelColor: [ Material.Teal, Material.Blue, Material.Amber, Material.DeepOrange, Material.Red, Material.primaryTextColor ]

                currentIndex: savedLogLevel < 0 || savedLogLevel >= count ? defaultLogLevel : savedLogLevel
                onCurrentIndexChanged: {
                    updateFooterButtonsStatus()
                }
                model: [ qsTr("Debug"), qsTr("Information"), qsTr("Warnings"), qsTr("Errors"), qsTr("Fatal errors"), qsTr("Panics") ]
                delegate: MenuItem {
                    width: parent.width
                    text: comboBoxLogLevel.textRole ? (Array.isArray(comboBoxLogLevel.model) ? modelData[comboBoxLogLevel.textRole] : model[comboBoxLogLevel.textRole]) : modelData
                    icon.source: "qrc:/images/icons/status/status_" + comboBoxLogLevel.logLevelString[index] + ".svg"
                    icon.color: Material.accent
                    Material.accent: comboBoxLogLevel.logLevelColor[index]
                    Material.foreground: comboBoxLogLevel.currentIndex === index ? parent.Material.accent : parent.Material.foreground
                    highlighted: comboBoxLogLevel.highlightedIndex === index
                    hoverEnabled: comboBoxLogLevel.hoverEnabled
                    leftPadding: highlighted ? 2*padding : padding // added
                    Behavior on leftPadding { NumberAnimation { duration: 500; easing.type: Easing.OutQuint } } // added
                } // MenuItem (delegate)
            } // ComboBox

            Label {
                id: labelLogOutput
                y: comboBoxLogLevel.y + comboBoxLogLevel.height + 10
                text: qsTr("Log output")
            }

            ListView {
                id: listViewLogOutput

                property alias outputFile: textFieldLogOutputFile.text
                readonly property var logOutputString: [ "stdout", "stderr", "none", "file" ]

                y: labelLogOutput.y + labelLogOutput.height + 6
                width: parent.width
                height: contentHeight

                onCurrentIndexChanged: {
                    updateFooterButtonsStatus()
                }

                spacing: -6
                interactive: false
                model: [ qsTr("Standard output"), qsTr("Standard error output"), qsTr("None"), qsTr("File") ]
                delegate: UI.RadioButton {
                    width: index === PagePreferences.LogOutput.File && textFieldLogOutputFile.enabled ? implicitWidth : parent.width
                    text: modelData
                    checked: savedLogOutput < 0 || savedLogOutput >= ListView.view.count ? index === defaultLogLevel : index === savedLogOutput

                    onCheckedChanged: {
                        if (checked) {
                            ListView.view.currentIndex = index
                            if (index === PagePreferences.LogOutput.File) {
                                textFieldLogOutputFile.forceActiveFocus()
                            }
                        }
                    }
                } // RadioButton (delegate)

                Component.onCompleted: {
                    textFieldLogOutputFile.x += listViewLogOutput.itemAtIndex(3).implicitWidth
                }

                UI.TextField {
                    id: textFieldLogOutputFile

                    y: parent.height - height
                    width: parent.width - x

                    enabled: listViewLogOutput.currentIndex === PagePreferences.LogOutput.File
                    placeholderText: qsTr("Output file")
                    selectByMouse: true
                }
            } // ListView (log output)
        } // GroupBox (global settings)
    } // ScrollView

    // Confirm discarding or reseting:
    Dialog {
        id: dialogConfirmation

        property bool onlyDiscard: true

        x: ~~((parent.width - width)/2)
        y: ~~((parent.height - height)/2)
        width: parent.width > 300 ? 300 - 40 : parent.width - 40
        height: parent.height > implicitHeight + 40 ? implicitHeight : parent.width - 40

        standardButtons: Dialog.Ok | Dialog.Cancel
        // As of Qt 6.5.1, setting a title causes a binding loop
        //title: qsTr("Confirm action")
        modal: true
        focus: visible

        Item {
            implicitWidth: parent.width
            implicitHeight: labelDescription.y + labelDescription.height

            Label {
                id: labelQuestion

                text: (dialogConfirmation.onlyDiscard ? qsTr("Discard all changes?") : qsTr("Restore defaults?"))
                font.bold: true
            }
            Label {
                id: labelDescription

                y: labelQuestion.y + labelQuestion.height + 10
                width: parent.width
                text: qsTr("This action will set the settings to the") + " " + (dialogConfirmation.onlyDiscard ? qsTr("last saved values.") : qsTr("default values."))
                font.italic: true
                wrapMode: Text.Wrap
            }
        }

        Component.onCompleted: {
            standardButton(Dialog.Ok).Material.accent = Material.Red
            standardButton(Dialog.Ok).highlighted = true
            standardButton(Dialog.Ok).text = Qt.binding(function() { return dialogConfirmation.onlyDiscard ? qsTr("Discard") : qsTr("Restore defaults") })
        }

        onAccepted: {
            if (onlyDiscard) {
                loadSavedSettings()
            } else {
                restoreDefaultSettings()
            }
        }
    } // Dialog
}

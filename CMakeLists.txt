cmake_minimum_required(VERSION 3.16)

project(FiberCryptoWallet VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.2 COMPONENTS Quick REQUIRED)

# The C/C++ source files
set(PROJECT_SOURCES
    # Source files
    src/main.cpp
    # Resources
    resources/images/images.qrc
    resources/fonts/fonts.qrc
    resources/i18n/translations.qrc
    resources/qt/qt.qrc
)

# The application
qt_add_executable(appFiberCryptoWallet
    ${PROJECT_SOURCES}
)


# QML modules

qt_add_qml_module(appFiberCryptoWallet
    URI FiberCryptoWallet
    VERSION 1.0
    QML_FILES src/ui/qml/splash.qml src/ui/qml/main.qml
)

# The UI
set(QML_SOURCES
    src/ui/qml/Components/ApplicationWindowContent.qml
    src/ui/qml/Components/Pages/PageWelcome.qml
    src/ui/qml/Components/Pages/PageOverview.qml
    src/ui/qml/Components/Pages/Wallets/PageWallets.qml
    src/ui/qml/Components/Pages/Wallets/PageCreateWallet.qml
    src/ui/qml/Components/Pages/Send/PageSend.qml
    src/ui/qml/Components/Pages/Send/PageSendSimple.qml
    src/ui/qml/Components/Pages/Send/PageSendAdvanced.qml
    src/ui/qml/Components/Pages/History/PageHistory.qml
    src/ui/qml/Components/Pages/History/PageHistoryFilter.qml
    src/ui/qml/Components/Pages/PageTest.qml
    src/ui/qml/Components/Delegates/DelegateWallet.qml
    src/ui/qml/Components/Delegates/DelegateWalletAddress.qml
    src/ui/qml/Components/Delegates/DelegateHistoryList.qml
    src/ui/qml/Components/Delegates/DelegateHistoryFilter.qml
    src/ui/qml/Components/Delegates/DelegateHistoryFilterAddress.qml
    src/ui/qml/Components/Delegates/DelegateTransactionAddress.qml
    src/ui/qml/Components/Delegates/DelegateInputOutput.qml
    src/ui/qml/Components/Delegates/DelegateDestinationList.qml
    src/ui/qml/Components/Dialogs/DialogAbout.qml
    src/ui/qml/Components/Dialogs/DialogAboutQt.qml
    src/ui/qml/Components/Dialogs/DialogAboutLicense.qml
    src/ui/qml/Components/Dialogs/DialogAddWallet.qml
    src/ui/qml/Components/Dialogs/DialogSimpleInput.qml
    src/ui/qml/Components/Dialogs/DialogTransactionDetails.qml
    src/ui/qml/Components/Dialogs/DialogSendTransaction.qml
    src/ui/qml/Components/Dialogs/DialogSelectAddressByWallet.qml
    src/ui/qml/Components/Dialogs/DialogContent/ContentAbout.qml
    src/ui/qml/Components/Dialogs/DialogContent/ContentAboutQt.qml
    src/ui/qml/Components/Dialogs/DialogContent/ContentAboutLicense.qml
    src/ui/qml/Components/Dialogs/DialogContent/ContentAddWallet.qml
    src/ui/qml/Components/Dialogs/DialogContent/ContentTransactionDetails.qml
    src/ui/qml/Components/Dialogs/DialogContent/ContentSimpleInput.qml
    src/ui/qml/Components/Custom/CustomMenuBar.qml
    src/ui/qml/Components/Custom/CustomMenuItem.qml
    src/ui/qml/Components/Custom/CustomComboBoxPopupFilter.qml
    src/ui/qml/Components/Custom/CustomCheckIndicator.qml
    src/ui/qml/Components/Utils/PasswordRequester.qml
    src/ui/qml/Components/Utils/SeedGenerator.qml
    src/ui/qml/Components/Controls/ComboBox.qml
    src/ui/qml/Components/Controls/RadioButton.qml
    src/ui/qml/Components/Controls/ScrollBar.qml
    src/ui/qml/Components/Controls/TextArea.qml
    src/ui/qml/Components/Controls/TextField.qml
    src/ui/qml/Components/Controls/+Material/ComboBox.qml
    src/ui/qml/Components/Controls/+Material/RadioButton.qml
    src/ui/qml/Components/Controls/+Material/RadioIndicator.qml
    src/ui/qml/Components/Controls/+Material/ScrollBar.qml
    src/ui/qml/Components/Controls/+Material/TextArea.qml
    src/ui/qml/Components/Controls/+Material/TextField.qml
)

qt_add_qml_module(FiberCryptoUI
    URI "FiberCrypto.UI"
    VERSION 1.0
    QML_FILES ${QML_SOURCES}
    OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/FiberCrypto/UI
)

qt_add_qml_module(FiberCryptoManagers
    URI "FiberCrypto.Managers"
    VERSION 1.0
    SOURCES src/core/WalletManager/walletmanager.h src/core/WalletManager/walletmanager.cpp
    OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/FiberCrypto/Managers
)

qt_add_qml_module(FiberCryptoTestPlugin
    URI "FiberCrypto.TestPlugin"
    VERSION 1.0
    SOURCES src/models/Template/templatemodel.h src/models/Template/templatemodel.cpp
    OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/FiberCrypto/TestPlugin
)

qt_add_qml_module(FiberCryptoWalletModelPlugin
    URI "FiberCrypto.WalletModel"
    VERSION 1.0
    SOURCES src/models/Wallet/walletmodel.h src/models/Wallet/walletmodel.cpp src/models/Wallet/wallet.h src/models/Wallet/wallet.cpp src/models/Wallet/addressmodel.h src/models/Wallet/addressmodel.cpp src/models/Wallet/address.h src/models/Wallet/address.cpp
    OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/FiberCrypto/WalletModel
)

# Include search paths for QML Type Registrations
target_include_directories(FiberCryptoManagers PRIVATE
    src/core/WalletManager
)

target_include_directories(FiberCryptoTestPlugin PRIVATE
    src/models/Template
)

target_include_directories(FiberCryptoWalletModelPlugin PRIVATE
    src/models/Wallet
)

# Target properties
set_target_properties(appFiberCryptoWallet PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER simelo.fibercryptowallet.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

# Compile definitions
target_compile_definitions(appFiberCryptoWallet
    PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(appFiberCryptoWallet
    PRIVATE Qt6::Quick)

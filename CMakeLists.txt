cmake_minimum_required(VERSION 3.16)

project(FiberCryptoWallet VERSION 0.1 LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(QT NAMES Qt6 Qt5 COMPONENTS Core Quick REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Quick REQUIRED)

set(PROJECT_SOURCES
    # Resources
    src/ui/ui.qrc
    resources/images/images.qrc
    resources/fonts/fonts.qrc
    resources/translations/translations.qrc
    resources/qt/qt.qrc
    # Source files
    src/main.cpp
    src/core/WalletManager/walletmanager.h
    src/core/WalletManager/walletmanager.cpp
)

qt_add_executable(FiberCryptoWallet
    MANUAL_FINALIZATION
    ${PROJECT_SOURCES}
)
# Define target properties for Android with Qt 6 as:
#    set_property(TARGET FiberCryptoWallet APPEND PROPERTY QT_ANDROID_PACKAGE_SOURCE_DIR
#                 ${CMAKE_CURRENT_SOURCE_DIR}/android)
# For more information, see https://doc.qt.io/qt-6/qt-add-executable.html#target-creation

target_compile_definitions(FiberCryptoWallet
  PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(FiberCryptoWallet
  PRIVATE Qt${QT_VERSION_MAJOR}::Core Qt${QT_VERSION_MAJOR}::Quick)

set_target_properties(FiberCryptoWallet PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER simelo.fibercryptowallet.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
)

qt_import_qml_plugins(FiberCryptoWallet)
qt_finalize_executable(FiberCryptoWallet)

target_include_directories(FiberCryptoWallet PRIVATE
    src/core/WalletManager
)

qt_add_qml_module(FiberCryptoWallet
    URI "Backend.Managers"
    VERSION 1.0
    SOURCES src/core/WalletManager/walletmanager.cpp src/core/WalletManager/walletmanager.h
)

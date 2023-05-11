#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QIcon>
#include <QFontDatabase>
#include <QLocale>
#include <QTranslator>

int main(int argc, char *argv[])
{
#ifdef Q_OS_ANDROID // debug only. allow full file access
    freopen("/storage/emulated/0/fibercrypto-log.txt", "w", stdout);
    freopen("/storage/emulated/0/fibercrypto-err.txt", "w", stderr);
#endif

    QGuiApplication app(argc, argv);
    app.setOrganizationName("Simelo.Tech");
    app.setOrganizationDomain("simelo.tech");
    app.setApplicationName("FiberCrypto Wallet");
    app.setApplicationVersion("0.1.0");
    app.setWindowIcon(QIcon(":/images/icons/app/appIcon.png")); // svg

    QFontDatabase::addApplicationFont(":/fonts/hemi-head/hemi-head.ttf");
    QFontDatabase::addApplicationFont(":/fonts/code-new-roman/code-new-roman.otf");

    QTranslator translator;
    const QStringList uiLanguages = QLocale::system().uiLanguages();
    for (const QString &locale : uiLanguages) {
        const QString baseName = app.applicationName().toLower().remove(' ') + QLocale(locale).name();
        if (translator.load(":/i18n/" + baseName)) {
            app.installTranslator(&translator);
            break;
        }
    }

    QQmlApplicationEngine engine;
#ifdef Q_OS_ANDROID
const QUrl url(u"qrc:/FiberCryptoWallet/src/ui/qml/main.qml"_qs);
#else
    const QUrl url(u"qrc:/FiberCryptoWallet/src/ui/qml/splash.qml"_qs);
#endif
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}

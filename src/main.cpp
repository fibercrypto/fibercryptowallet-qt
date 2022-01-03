#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QIcon>
#include <QFontDatabase>
#include <QLocale>
#include <QTranslator>

int main(int argc, char *argv[])
{
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
    const QUrl url(QStringLiteral("qrc:/ui/qml/splash.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}

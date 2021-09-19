#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QIcon>
#include <QFontDatabase>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setOrganizationName("Simelo.Tech");
    app.setOrganizationDomain("simelo.tech");
    app.setApplicationName("FiberCrypto Wallet");
    app.setApplicationVersion("0.1.0");
    app.setWindowIcon(QIcon(":/images/icons/app/appIcon.svg"));

    QFontDatabase::addApplicationFont(":/fonts/code-new-roman/code-new-roman.otf");
    QFontDatabase::addApplicationFont(":/fonts/hemi-head/hemi-head.ttf");

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

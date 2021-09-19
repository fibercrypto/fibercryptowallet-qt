#ifndef WALLETCREATOR_H
#define WALLETCREATOR_H

#include <QtQml>

class WalletCreator : public QObject
{
    Q_OBJECT
    QML_ELEMENT

public:
    enum Mode { Create, Load };
    Q_ENUM(Mode)

    explicit WalletCreator(QObject *parent = nullptr);

    Mode getMode() const;
    void setMode(Mode newMode);

    const QString &getName() const;
    void setName(const QString &newName);

    const QString &getSeed() const;
    void setSeed(const QString &newSeed);

    const QString &getConfirmedSeed() const;
    void setConfirmedSeed(const QString &newConfirmedSeed);

signals:
    void modeChanged();
    void nameChanged();
    void seedChanged();
    void confirmedSeedChanged();

private:
    Mode mode = Create;
    QString name;
    QString seed;
    QString confirmedSeed;

    Q_PROPERTY(Mode mode READ getMode WRITE setMode NOTIFY modeChanged)
    Q_PROPERTY(QString name READ getName WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QString seed READ getSeed WRITE setSeed NOTIFY seedChanged)
    Q_PROPERTY(QString confirmedSeed READ getConfirmedSeed WRITE setConfirmedSeed NOTIFY confirmedSeedChanged)
};

#endif // WALLETCREATOR_H

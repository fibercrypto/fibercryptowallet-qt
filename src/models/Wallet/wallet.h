#ifndef WALLET_H
#define WALLET_H

#include <QObject>
#include <QtQml>

#include "addressmodel.h"

class Wallet : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QString name READ getName WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QString fileName READ getFileName WRITE setFileName NOTIFY fileNameChanged)
    Q_PROPERTY(double sky READ getSky WRITE setSky NOTIFY skyChanged)
    Q_PROPERTY(double coinHours READ getCoinHours WRITE setCoinHours NOTIFY coinHoursChanged)
    Q_PROPERTY(bool encryptionEnabled READ getEncryptionEnabled WRITE setEncryptionEnabled NOTIFY encryptionEnabledChanged)
    Q_PROPERTY(bool encrypted READ getEncrypted WRITE setEncrypted NOTIFY encryptedChanged)
    Q_PROPERTY(bool hasHardwareWallet READ getHasHardwareWallet WRITE setHasHardwareWallet NOTIFY hasHardwareWalletChanged)
    Q_PROPERTY(bool expanded READ getExpanded WRITE setExpanded NOTIFY expandedChanged)
    Q_PROPERTY(AddressModel* addressModel READ getAddressModel WRITE setAddressModel NOTIFY addressModelChanged)

public:
    explicit Wallet(const QString &walletName = QString(), const QString &walletFileName = QString(), double walletSky = 0.0, double walletCoinHours = 0.0, bool walletEncryptionEnabled = false, bool walletEncrypted = false, bool walletHasHardwareWallet = false, bool walletExpanded = false, QObject *parent = nullptr);

    QString getName() const;
    void setName(const QString &value);

    QString getFileName() const;
    void setFileName(const QString &value);

    double getSky() const;
    void setSky(double value);

    double getCoinHours() const;
    void setCoinHours(double value);

    bool getEncryptionEnabled() const;
    void setEncryptionEnabled(bool value);

    bool getEncrypted() const;
    void setEncrypted(bool value);

    bool getExpanded() const;
    void setExpanded(bool value);

    bool getHasHardwareWallet() const;
    void setHasHardwareWallet(bool value);

    AddressModel* getAddressModel() const;
    void setAddressModel(AddressModel *value);

signals:
    void nameChanged(const QString &value);
    void fileNameChanged(const QString &value);
    void skyChanged(double value);
    void coinHoursChanged(double value);
    void encryptionEnabledChanged(bool value);
    void encryptedChanged(bool value);
    void expandedChanged(bool value);
    void hasHardwareWalletChanged(bool value);
    void addressModelChanged();

private:
    QString name;
    QString fileName;
    double sky = 0.0;
    double coinHours = 0.0;
    bool encryptionEnabled = false;
    bool encrypted = false;
    bool hasHardwareWallet = false;
    bool expanded = false;
    AddressModel *addressModel = new AddressModel();
};

#endif // WALLET_H

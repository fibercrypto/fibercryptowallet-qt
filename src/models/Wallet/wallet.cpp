#include "wallet.h"

Wallet::Wallet(const QString &walletName, const QString &walletFileName, double walletSky, double walletCoinHours, bool walletEncryptionEnabled, bool walletEncrypted, bool walletHasHardwareWallet, bool walletExpanded, QObject *parent)
    : QObject(parent), name(walletName), fileName(walletFileName), sky(walletSky), coinHours(walletCoinHours), encryptionEnabled(walletEncryptionEnabled), encrypted(walletEncrypted), hasHardwareWallet(walletHasHardwareWallet), expanded(walletExpanded)
{

}

QString Wallet::getName() const
{
    return name;
}

void Wallet::setName(const QString &value)
{
    if (name != value) {
        name = value;
        emit nameChanged(value);
    }
}

QString Wallet::getFileName() const
{
    return fileName;
}

void Wallet::setFileName(const QString &value)
{
    if (fileName != value) {
        fileName = value;
        emit fileNameChanged(value);
    }
}

double Wallet::getSky() const
{
    return sky;
}

void Wallet::setSky(double value)
{
    if (sky != value) {
        sky = value;
        emit skyChanged(value);
    }
}

double Wallet::getCoinHours() const
{
    return coinHours;
}

void Wallet::setCoinHours(double value)
{
    if (coinHours != value) {
        coinHours = value;
        emit coinHoursChanged(value);
    }
}

bool Wallet::getEncryptionEnabled() const
{
    return encryptionEnabled;
}

void Wallet::setEncryptionEnabled(bool value)
{
    if (encryptionEnabled != value) {
        encryptionEnabled = value;
        emit encryptionEnabledChanged(value);
    }
}

bool Wallet::getEncrypted() const
{
    return encrypted;
}

void Wallet::setEncrypted(bool value)
{
    if (encrypted != value) {
        encrypted = value;
        emit encryptedChanged(value);
    }
}

bool Wallet::getExpanded() const
{
    return expanded;
}

void Wallet::setExpanded(bool value)
{
    if (expanded != value) {
        expanded = value;
        emit expandedChanged(value);
    }
}

bool Wallet::getHasHardwareWallet() const
{
    return hasHardwareWallet;
}

void Wallet::setHasHardwareWallet(bool value)
{
    if (hasHardwareWallet != value) {
        hasHardwareWallet = value;
        emit hasHardwareWalletChanged(value);
    }
}

AddressModel* Wallet::getAddressModel() const
{
    return addressModel;
}

void Wallet::setAddressModel(AddressModel *value)
{
    if (addressModel != value) {
        addressModel = value;
        emit addressModelChanged();
    }
}

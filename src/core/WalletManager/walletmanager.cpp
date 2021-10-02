#include "walletmanager.h"

WalletManager::WalletManager(QObject *parent) : QObject(parent)
{

}

WalletManager::Mode WalletManager::getMode() const
{
    return mode;
}

void WalletManager::setMode(Mode newMode)
{
    if (mode == newMode)
        return;
    mode = newMode;
    emit modeChanged();
}

const QString &WalletManager::getName() const
{
    return name;
}

void WalletManager::setName(const QString &newName)
{
    if (name == newName)
        return;
    name = newName;
    emit nameChanged();
}

const QString &WalletManager::getSeed() const
{
    return seed;
}

void WalletManager::setSeed(const QString &newSeed)
{
    if (seed == newSeed)
        return;
    seed = newSeed;
    emit seedChanged();
}

const QString &WalletManager::getConfirmedSeed() const
{
    return confirmedSeed;
}

void WalletManager::setConfirmedSeed(const QString &newConfirmedSeed)
{
    if (confirmedSeed == newConfirmedSeed)
        return;
    confirmedSeed = newConfirmedSeed;
    emit confirmedSeedChanged();
}

#include "walletcreator.h"

WalletCreator::WalletCreator(QObject *parent) : QObject(parent)
{

}

WalletCreator::Mode WalletCreator::getMode() const
{
    return mode;
}

void WalletCreator::setMode(Mode newMode)
{
    if (mode == newMode)
        return;
    mode = newMode;
    emit modeChanged();
}

const QString &WalletCreator::getName() const
{
    return name;
}

void WalletCreator::setName(const QString &newName)
{
    if (name == newName)
        return;
    name = newName;
    emit nameChanged();
}

const QString &WalletCreator::getSeed() const
{
    return seed;
}

void WalletCreator::setSeed(const QString &newSeed)
{
    if (seed == newSeed)
        return;
    seed = newSeed;
    emit seedChanged();
}

const QString &WalletCreator::getConfirmedSeed() const
{
    return confirmedSeed;
}

void WalletCreator::setConfirmedSeed(const QString &newConfirmedSeed)
{
    if (confirmedSeed == newConfirmedSeed)
        return;
    confirmedSeed = newConfirmedSeed;
    emit confirmedSeedChanged();
}

#include "address.h"

Address::Address(const QString &addressString, double addressSky, double addressCoinHours, QObject *parent)
    : QObject(parent), address(addressString), sky(addressSky), coinHours(addressCoinHours)
{

}

QString Address::getAddress() const
{
    return address;
}

void Address::setAddress(const QString &value)
{
    if (address != value) {
        address = value;
        emit addressChanged(value);
    }
}

double Address::getSky() const
{
    return sky;
}

void Address::setSky(double value)
{
    if (sky != value) {
        sky = value;
        emit skyChanged(value);
    }
}

double Address::getCoinHours() const
{
    return coinHours;
}

void Address::setCoinHours(double value)
{
    if (coinHours != value) {
        coinHours = value;
        emit coinHoursChanged(value);
    }
}

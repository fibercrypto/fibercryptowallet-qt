#include "addressmodel.h"

AddressModel::AddressModel(QObject *parent)
    : QAbstractListModel(parent)
{

}

QHash<int, QByteArray> AddressModel::roleNames() const
{
    return { // the role names as they are going to be used in QML
        { AddressRole, "address" },
        { SkyRole, "addressSky" },
        { CoinHoursRole, "addressCoinHours" }
    };
}

int AddressModel::rowCount(const QModelIndex &parent) const
{
    (void)parent;
    return addressData.count();
}

QVariant AddressModel::data(const QModelIndex &index, int role) const
{
    if (!checkIndex(index, QAbstractItemModel::CheckIndexOption::IndexIsValid | QAbstractItemModel::CheckIndexOption::ParentIsInvalid)) {
        return QVariant();
    }

    return getModelData(index.row(), role);
}

bool AddressModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (!checkIndex(index, QAbstractItemModel::CheckIndexOption::IndexIsValid | QAbstractItemModel::CheckIndexOption::ParentIsInvalid)) {
        return false;
    }

    return setModelData(index.row(), value, role);
}

QVariant AddressModel::getModelData(int row, int role) const
{
    if (row < 0 || row >= addressData.count()) {
        return QVariant();
    }

    switch (role) {
    case AddressRole:
        return addressData[row]->getAddress();
    case SkyRole:
        return addressData[row]->getSky();
    case CoinHoursRole:
        return addressData[row]->getCoinHours();
    default:
        return QVariant();
    }
}

bool AddressModel::setModelData(int row, const QVariant &value, int role)
{
    if (row < 0 || row >= addressData.count()) {
        return false;
    }

    switch (role) {
    case AddressRole:
        addressData[row]->setAddress(value.toString());
        break;
    case SkyRole:
        addressData[row]->setSky(value.toDouble());
        break;
    case CoinHoursRole:
        addressData[row]->setCoinHours(value.toDouble());
        break;
    default:
        break;
    }

    emit dataChanged(index(row), index(row), { role });
    return true;
}

bool AddressModel::insertItem(int row, Address* address)
{
    if (row < 0 || row > addressData.count()) {
        return false;
    }
    beginInsertRows(QModelIndex(), row, row);
    addressData.insert(row, address);
    endInsertRows();
    return true;
}

bool AddressModel::removeItem(int row)
{
    if (row < 0 || row >= addressData.count()) {
        return false;
    }

    beginRemoveRows(QModelIndex(), row, row);
    delete addressData.takeAt(row);
    endRemoveRows();
    return true;
}

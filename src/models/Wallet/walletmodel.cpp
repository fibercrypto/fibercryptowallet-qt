#include "walletmodel.h"

WalletModel::WalletModel(QObject *parent)
    : QAbstractListModel(parent)
{

}

QHash<int, QByteArray> WalletModel::roleNames() const
{
    return { // the role names as they are going to be used in QML
        { NameRole, "name" },
        { FileNameRole, "fileName" },
        { SkyRole, "sky" },
        { CoinHoursRole, "coinHours" },
        { EncryptionEnabledRole, "encryptionEnabled" },
        { HasHardwareWalletRole, "hasHardwareWalletRole" },
        { ExpandedRole, "expanded" }
    };
}

int WalletModel::rowCount(const QModelIndex &parent) const
{
    (void)parent;
    return walletData.count();
}

QVariant WalletModel::data(const QModelIndex &index, int role) const
{
    if (!checkIndex(index, QAbstractItemModel::CheckIndexOption::IndexIsValid | QAbstractItemModel::CheckIndexOption::ParentIsInvalid)) {
        return QVariant();
    }

    return getModelData(index.row(), role);
}

bool WalletModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (!checkIndex(index, QAbstractItemModel::CheckIndexOption::IndexIsValid | QAbstractItemModel::CheckIndexOption::ParentIsInvalid)) {
        return false;
    }

    return setModelData(index.row(), value, role);
}

QVariant WalletModel::getModelData(int row, int role) const
{
    if (row < 0 || row >= walletData.count()) {
        return QVariant();
    }

    switch (role) {
    case NameRole:
        return walletData[row]->getName();
    case FileNameRole:
        return walletData[row]->getFileName();
    case SkyRole:
        return walletData[row]->getSky();
    case CoinHoursRole:
        return walletData[row]->getCoinHours();
    case EncryptionEnabledRole:
        return walletData[row]->getEncryptionEnabled();
    case HasHardwareWalletRole:
        return walletData[row]->getHasHardwareWallet();
    case ExpandedRole:
        return walletData[row]->getExpanded();
    default:
        return QVariant();
    }
}

bool WalletModel::setModelData(int row, const QVariant &value, int role)
{
    if (row < 0 || row >= walletData.count()) {
        return false;
    }

    switch (role) {
    case NameRole:
        walletData[row]->setName(value.toString());
        break;
    case FileNameRole:
        walletData[row]->setFileName(value.toString());
        break;
    case SkyRole:
        walletData[row]->setSky(value.toDouble());
        break;
    case CoinHoursRole:
        walletData[row]->setCoinHours(value.toDouble());
        break;
    case EncryptionEnabledRole:
        walletData[row]->setEncryptionEnabled(value.toBool());
        break;
    case HasHardwareWalletRole:
        walletData[row]->setHasHardwareWallet(value.toBool());
        break;
    case ExpandedRole:
        walletData[row]->setExpanded(value.toBool());
        break;
    default:
        break;
    }

    emit dataChanged(index(row), index(row), { role });
    return true;
}

bool WalletModel::insertItem(int row, Wallet* wallet)
{
    if (row < 0 || row > walletData.count()) {
        return false;
    }
    beginInsertRows(QModelIndex(), row, row);
    walletData.insert(row, wallet);
    endInsertRows();
    return true;
}

bool WalletModel::removeItem(int row)
{
    if (row < 0 || row >= walletData.count()) {
        return false;
    }

    beginRemoveRows(QModelIndex(), row, row);
    delete walletData.takeAt(row);
    endRemoveRows();
    return true;
}

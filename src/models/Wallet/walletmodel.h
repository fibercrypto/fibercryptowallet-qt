#ifndef WALLETMODEL_H
#define WALLETMODEL_H

#include <QAbstractListModel>
#include <QtQml> // for macros that will export data to QML

#include "wallet.h"

// Simple C++ list model that exposes data to QML
// Allows read and write of data, as well as adding and removing rows
// More complex models must subclass QAbstractTableModel or even QAbstractItemModel

class WalletModel : public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT // to export the class to QML

public:
    enum Roles { NameRole = Qt::UserRole + 1, FileNameRole, SkyRole, CoinHoursRole, EncryptionEnabledRole, HasHardwareWalletRole, ExpandedRole };
    Q_ENUM(Roles) // to export the enum to QML

    explicit WalletModel(QObject *parent = nullptr);

protected:
    QHash<int, QByteArray> roleNames() const override;
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    bool setData(const QModelIndex &index, const QVariant &value, int role = Qt::EditRole) override;

public slots: // everything in this block will be exported to QML
    QVariant getModelData(int row, int role) const;
    bool setModelData(int row, const QVariant &value, int role);
    bool insertItem(int row, Wallet *wallet);
    bool removeItem(int row);

private:
    QList<Wallet*> walletData = { // sample
        new Wallet("Wallet for Amazon", "wallet1.wlt", 1.43, 1738.75, false, false, false),
        new Wallet("Wallet for Amazon Prime", "wallet2.wlt", 34.99, 6790.00, true, true, false),
        new Wallet("Wallet for Amazon Prime Ultimate", "wallet3.wlt", 354862.10, 92546846.01, true, true, false)
    };
};

#endif // WALLETMODEL_H

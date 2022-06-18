#ifndef ADDRESSMODEL_H
#define ADDRESSMODEL_H

#include <QAbstractListModel>
#include <QtQml> // for macros that will export data to QML

#include "address.h"

// Simple C++ list model that exposes data to QML
// Allows read and write of data, as well as adding and removing rows
// More complex models must subclass QAbstractTableModel or even QAbstractItemModel

class AddressModel : public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT // to export the class to QML

public:
    enum Roles { AddressRole = Qt::UserRole + 1, SkyRole, CoinHoursRole };
    Q_ENUM(Roles) // to export the enum to QML

    explicit AddressModel(QObject *parent = nullptr);

protected:
    QHash<int, QByteArray> roleNames() const override;
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    bool setData(const QModelIndex &index, const QVariant &value, int role = Qt::EditRole) override;

public slots: // everything in this block will be exported to QML
    QVariant getModelData(int row, int role) const;
    bool setModelData(int row, const QVariant &value, int role);
    bool insertItem(int row, Address *address);
    bool removeItem(int row);

private:
    QList<Address*> addressData = { // sample
        new Address("8dh28rb1iaj83un35jh4s9ai0qy2qw", 1.43, 1738.75),
        new Address("hs8264ishsun8nq0rhq51j3f620m9d", 34.99, 6790.00),
        new Address("s62f9dt24f20ns5n28v6rk50shc6em", 354862.10, 92546846.01)
    };
};

#endif // ADDRESSMODEL_H

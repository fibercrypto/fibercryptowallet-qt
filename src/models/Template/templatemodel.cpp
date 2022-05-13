#include "templatemodel.h"

#include <QDebug>

TemplateModel::TemplateModel(QObject *parent)
    : QAbstractListModel{parent}
{

}

QHash<int, QByteArray> TemplateModel::roleNames() const
{
    return {
        { SomeNumberRole, "someNumber" },
        { SomeStringRole, "someString" }
    };
}

int TemplateModel::rowCount(const QModelIndex &parent) const
{
    (void)parent;
    return someData.count();
}

QVariant TemplateModel::data(const QModelIndex &index, int role) const
{
    if (!checkIndex(index, QAbstractItemModel::CheckIndexOption::IndexIsValid | QAbstractItemModel::CheckIndexOption::ParentIsInvalid)) {
        return QVariant();
    }

    return getModelData(index.row(), role);
}

bool TemplateModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (!checkIndex(index, QAbstractItemModel::CheckIndexOption::IndexIsValid | QAbstractItemModel::CheckIndexOption::ParentIsInvalid)) {
        return false;
    }

    return setModelData(index.row(), value, role);
}

QVariant TemplateModel::getModelData(int row, int role) const
{
    if (row < 0 || row >= someData.count()) {
        return QVariant();
    }

    switch (role) {
    case SomeNumberRole:
        return someData[row].first;
    case SomeStringRole:
        return someData[row].second;
    default:
        return QVariant();
    }
}

bool TemplateModel::setModelData(int row, const QVariant &value, int role)
{
    if (row < 0 || row >= someData.count()) {
        return false;
    }

    switch (role) {
    case SomeNumberRole:
        someData[row].first = value.toInt();
    case SomeStringRole:
        someData[row].second = value.toString();
    default:
        return false;
    }

    qDebug() << someData;
    emit dataChanged(index(row), index(row), { role });
    return true;
}

bool TemplateModel::insertItem(int row, int someNumber, const QString &someString)
{
    if (row < 0 || row > someData.count()) {
        return false;
    }
    beginInsertRows(QModelIndex(), someData.count(), someData.count());
    someData.insert(row, { someNumber, someString });
    endInsertRows();
    emit dataChanged(index(row), index(row), { SomeNumberRole, SomeStringRole });
    return true;
}

bool TemplateModel::removeItem(int row)
{
    if (row < 0 || row >= someData.count()) {
        return false;
    }

    beginRemoveRows(QModelIndex(), row, row);
    someData.remove(row);
    endRemoveRows();
    return true;
}

#ifndef TEMPLATEMODEL_H
#define TEMPLATEMODEL_H

#include <QAbstractListModel>
#include <QtQml> // for macros that will export data to QML

// Simple C++ list model that exposes data to QML
// Allows read and write of data, as well as adding and removing rows
// More complex models must subclass QAbstractTableModel or even QAbstractItemModel

class TemplateModel : public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT // to export the class to QML

public:
    enum Roles { SomeNumberRole = Qt::UserRole + 1, SomeStringRole};
    Q_ENUM(Roles) // to export the enum to QML

    explicit TemplateModel(QObject *parent = nullptr);

protected:
    QHash<int, QByteArray> roleNames() const override;
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    bool setData(const QModelIndex &index, const QVariant &value, int role = Qt::EditRole) override;

public slots: // everything in this block will be exported to QML
    QVariant getModelData(int row, int role) const;
    bool setModelData(int row, const QVariant &value, int role);
    bool insertItem(int row, int someNumber, const QString &someString);
    bool removeItem(int row);

private:
    QList<QPair<int, QString>> someData = { // sample data
        { 65424, "Tree" },
        { 5064, "Cat" },
        { 90164, "Dog" },
        { 9648, "Person" }
    };
};

#endif // TEMPLATEMODEL_H

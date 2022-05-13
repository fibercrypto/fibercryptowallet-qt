#ifndef TEMPLATEMODEL_H
#define TEMPLATEMODEL_H

#include <QAbstractListModel>
#include <QtQml>

class TemplateModel : public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT

public:
    enum Roles { SomeNumberRole = Qt::UserRole + 1, SomeStringRole};
    Q_ENUM(Roles)

    explicit TemplateModel(QObject *parent = nullptr);

protected:
    QHash<int, QByteArray> roleNames() const;
    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
    bool setData(const QModelIndex &index, const QVariant &value, int role = Qt::EditRole);

public slots:
    QVariant getModelData(int row, int role) const;
    bool setModelData(int row, const QVariant &value, int role);
    bool insertItem(int row, int someNumber, const QString &someString);
    bool removeItem(int row);

private:
    QList<QPair<int, QString>> someData = {
        { 65424, "Tree" },
        { 5064, "Cat" },
        { 90164, "Dog" },
        { 9648, "Person" }
    };
};

#endif // TEMPLATEMODEL_H

#ifndef ADDRESS_H
#define ADDRESS_H

#include <QObject>
#include <QtQml>

class Address : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QString address READ getAddress WRITE setAddress NOTIFY addressChanged)
    Q_PROPERTY(double sky READ getSky WRITE setSky NOTIFY skyChanged)
    Q_PROPERTY(double coinHours READ getCoinHours WRITE setCoinHours NOTIFY coinHoursChanged)

public:
    explicit Address(const QString &addressString = QString(), double addressSky = 0.0, double addressCoinHours = 0.0, QObject *parent = nullptr);

    QString getAddress() const;
    void setAddress(const QString &value);

    double getSky() const;
    void setSky(double value);

    double getCoinHours() const;
    void setCoinHours(double value);

signals:
    void addressChanged(const QString &value);
    void skyChanged(double value);
    void coinHoursChanged(double value);

private:
    QString address;
    double sky = 0.0;
    double coinHours = 0.0;
};

#endif // ADDRESS_H

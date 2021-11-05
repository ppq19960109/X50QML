#include "qmldevstate.h"

QMap<int,QDevAttr> QmlDevState::attrMap;
//QVariantMap QmlDevState::stateMap;
QmlDevState* QmlDevState::qmlDevState;
QmlDevState::QmlDevState(QObject *parent) : QObject(parent)
{
    qmlDevState=this;
    myName="DevState";

    QDevAttr devAttr;
    devAttr.name="HoodSpeed";
    devAttr.uartByteLen=1;
    QmlDevState::attrMap[0x31]=devAttr;
    qmlDevState->setState(devAttr.name,3);

    devAttr.name="HoodLight";
    devAttr.uartByteLen=1;
    QmlDevState::attrMap[0x32]=devAttr;
    qmlDevState->setState(devAttr.name,0);

    devAttr.name="StOvState";
    devAttr.uartByteLen=1;
    QmlDevState::attrMap[0x41]=devAttr;
    qmlDevState->setState(devAttr.name,0);
}

int QmlDevState::uartStatusCb(const char* value,const int value_len)
{
    for (int i = 0; i < value_len; ++i)
    {
        if(attrMap.contains(value[i]))
        {
            int attrVal=0;
            for (int j = 0; j < attrMap[value[i]].uartByteLen; ++j)
            {
                attrVal = (attrVal << 8) + value[i+1+j];
            }
            qmlDevState->setState(attrMap[value[i]].name,attrVal);
        }
    }
    return 0;
}

int QmlDevState::setUartData(const QString &name, const int value)
{
    QMap<int, QDevAttr>::iterator iter = attrMap.begin();
    while (iter != attrMap.end())
    {
        qDebug() << "iter key" << iter.key() ; // 迭代器
        QDevAttr devAttr=iter.value();
        if(name==devAttr.name)
        {
            uartData.append(iter.key());
            for (int i = 0; i < devAttr.uartByteLen; ++i)
            {
                uartData.append(value >> (8 * (devAttr.uartByteLen - 1 - i)));
            }
        }
        iter++;
    }
}

int QmlDevState::sendUartData()
{
    qDebug() << "sendUartData:" << uartData.toHex() ;
    uartData.clear();
}


void QmlDevState::setName(const QString &name)
{
    qDebug()<<"QmlDevState::setName"<<name;
    if(myName!=name){
        qDebug()<<"emit nameChanged";
        myName=name;
        emit nameChanged(name);
    }
}

QString QmlDevState::getName() const
{
    qDebug()<<"QmlDevState::getName";
    return myName;
}

void QmlDevState::setState(const QString& name,const QVariant value)
{
    //    if(stateMap.contains(name))
    //    {
    stateMap[name]=value;
    qDebug()<<"QmlDevState::setState: "<<stateMap[name];
    emit stateChanged(name,value);
    //    }
}

QVariantMap QmlDevState::getState() const
{
    qDebug()<<"QmlDevState::getState";
    return stateMap;
}

//QmlDevState *QmlDevState::qmlAttachedProperties(QObject *object)
//{
//    return new QmlDevState(object);
//}

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

    devAttr.name="StOvMode";
    devAttr.uartByteLen=1;
    QmlDevState::attrMap[0x43]=devAttr;
    qmlDevState->setState(devAttr.name,0);

    devAttr.name="StOvSetTemp";
    devAttr.uartByteLen=2;
    QmlDevState::attrMap[0x44]=devAttr;
    qmlDevState->setState(devAttr.name,0);

    devAttr.name="StOvSetTimer";
    devAttr.uartByteLen=2;
    QmlDevState::attrMap[0x46]=devAttr;
    qmlDevState->setState(devAttr.name,0);

    devAttr.name="RightStOvState";
    devAttr.uartByteLen=1;
    QmlDevState::attrMap[0x52]=devAttr;
    qmlDevState->setState(devAttr.name,0);

    devAttr.name="RightStOvSetTemp";
    devAttr.uartByteLen=2;
    QmlDevState::attrMap[0x53]=devAttr;
    qmlDevState->setState(devAttr.name,0);

    devAttr.name="RightStOvSetTimer";
    devAttr.uartByteLen=2;
    QmlDevState::attrMap[0x55]=devAttr;
    qmlDevState->setState(devAttr.name,0);

    QVariantMap info;
    info.insert("dishCook", 0);
    info.insert("dishCookTime", 120);
    info.insert("dishName", "清蒸鱼");
    info.insert("imgSource", "/images/peitu01.png");
    info.insert("cookSteps", "[{\"device\":0,\"mode\":5,\"temp\":100,\"time\":90}]");
    info.insert("details", "食材：\n鸡蛋2个，蛤蜊50g，盐2g，油3滴葱花30g\n步骤：\n1、鱼片加入适量鸡蛋，料酒、升降、盐，醋、糖，搅拌均匀后加一点淀粉（淀粉加水）增加粘度\n2、鱼片加入适量鸡蛋，料酒、升降、盐，醋、糖，搅拌均匀后加一点淀粉（淀粉加水）增加粘度\n3、鱼片加入适量鸡蛋，料酒、升降、盐，醋、糖，搅拌均匀后加一点淀粉（淀粉加水）增加粘度");
    info.insert("collection", 0);
    info.insert("time", 0);

    recipe[0].append(info);
    info["dishCook"]=1;
    info["dishName"]="烤鱼";
    recipe[0].append(info);
    info["dishCook"]=2;
    info["dishName"]="红烧鱼";
    recipe[0].append(info);
    info["dishCook"]=1;
    info["dishName"]="烤面包";
    recipe[0].append(info);

    info["dishCook"]=0;
    info["dishName"]="烤面包";
    recipe[1].append(info);

    history.append(info);
    history.append(info);
    history.append(info);
    history.append(info);
    history.append(info);
    history.append(info);
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

int QmlDevState::setUartData(const QString &name, QVariantList value)
{
    QMap<int, QDevAttr>::iterator iter = attrMap.begin();
    while (iter != attrMap.end())
    {
        qDebug() << "iter key" << iter.key() ; // 迭代器
        QDevAttr devAttr=iter.value();
        if(name==devAttr.name)
        {
            uartData.append(iter.key());
            if(value.length()==1)
            {
                int val=value.at(0).toInt();
                for (int i = 0; i < devAttr.uartByteLen; ++i)
                {
                    uartData.append((int)val >> (8 * (devAttr.uartByteLen - 1 - i)));
                }
            }
            else
            {
                char val;
                for (int i = 0; i < value.length(); ++i)
                {
                    val=value[i].toInt();
                    uartData.append(val);
                }
            }
        }
        iter++;
    }
    return 0;
}

int QmlDevState::sendUartData()
{
    qDebug() << "sendUartData:" << uartData.toHex() ;
    uartData.clear();
}

QVariantList QmlDevState::getRecipe(const int index)
{
    return recipe[index];
}

QVariantList QmlDevState::getHistory()
{
    return history;
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
    //    qDebug()<<"QmlDevState::setState: "<<stateMap[name];
    emit stateChanged(name,value);
    //    }
}

QVariantMap QmlDevState::getState() const
{
    //    qDebug()<<"QmlDevState::getState";
    return stateMap;
}

//QmlDevState *QmlDevState::qmlAttachedProperties(QObject *object)
//{
//    return new QmlDevState(object);
//}

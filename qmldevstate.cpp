#include "qmldevstate.h"
//#include<QtAlgorithms>
#include<algorithm>
//using namespace std;



QmlDevState* QmlDevState::qmlDevState;
QmlDevState::QmlDevState(QObject *parent) : QObject(parent)
{

    stateTypeMap.insert("WifiState",LINK_VALUE_TYPE_NUM);
    stateTypeMap.insert("WifiEnable",LINK_VALUE_TYPE_NUM);
    stateTypeMap.insert("WifiScanR",LINK_VALUE_TYPE_STRING);
    stateTypeMap.insert("WifiCurConnected",LINK_VALUE_TYPE_STRUCT);

    stateTypeMap.insert("CookRecipe",LINK_VALUE_TYPE_STRUCT);
    stateTypeMap.insert("CookHistory",LINK_VALUE_TYPE_STRUCT);

    connect(&client, SIGNAL(sendData(QJsonValue&)), this,SLOT(readData(QJsonValue&)));

    qmlDevState=this;
    myName="DevState";

    setState("HoodSpeed",3);
    qmlDevState->setState("HoodLight",0);

    qmlDevState->setState("StOvState",0);
    qmlDevState->setState("StOvMode",0);
    qmlDevState->setState("StOvSetTemp",0);
    qmlDevState->setState("StOvSetTimer",0);

    qmlDevState->setState("RStOvState",0);
    qmlDevState->setState("RStOvSetTemp",0);
    qmlDevState->setState("RStOvSetTimer",0);

    qmlDevState->setState("cnt",0);
    qmlDevState->setState("current",0);
    qmlDevState->setState("remind",false);
    qmlDevState->setState("RemindText","");

    qmlDevState->setState("RStoveTimingState",0);
    qmlDevState->setState("RStoveTimingLeft",110);

//    QVariantMap info;
//    info.insert("id", 0);
//    info.insert("cookType", 0);
//    info.insert("cookTime", 120);
//    info.insert("dishName", "清蒸鱼");
//    info.insert("imgUrl", "/images/peitu01.png");
//    info.insert("cookSteps", "[{\"device\":0,\"mode\":5,\"temp\":100,\"time\":90}]");
//    info.insert("details", "食材：\n鸡蛋2个，蛤蜊50g，盐2g，油3滴葱花30g\n步骤：\n1、鱼片加入适量鸡蛋，料酒、升降、盐，醋、糖，搅拌均匀后加一点淀粉（淀粉加水）增加粘度\n2、鱼片加入适量鸡蛋，料酒、升降、盐，醋、糖，搅拌均匀后加一点淀粉（淀粉加水）增加粘度\n3、鱼片加入适量鸡蛋，料酒、升降、盐，醋、糖，搅拌均匀后加一点淀粉（淀粉加水）增加粘度");
//    info.insert("collect", false);
//    info.insert("timestamp", 0);

//    recipe[0].append(info);
//    info["cookType"]=1;
//    info["dishName"]="烤鱼";
//    recipe[0].append(info);
//    info["cookType"]=2;
//    info["dishName"]="红烧鱼";
//    recipe[0].append(info);
//    info["cookType"]=1;
//    info["dishName"]="烤面包";
//    recipe[0].append(info);

//    info["cookType"]=0;
//    info["dishName"]="烤面包0";
//    recipe[1].append(info);

//    history.append(info);
//    info["id"]=1;
//    info["dishName"]="烤面包1";
//    history.append(info);
//    info["id"]=2;
//    info["dishName"]="烤面包2";
//    history.append(info);
//    info["id"]=3;
//    info["dishName"]="烤面包3";
//    history.append(info);
//    info["id"]=4;
//    info["dishName"]="烤面包4";
//    history.append(info);
//    info["id"]=5;
//    info["dishName"]="烤面包5";
//    history.append(info);
}

QVariantList QmlDevState::getRecipe(const int index)
{
    return recipe[index];
}

bool compareId(const QVariant &s1, const QVariant &s2)
{
    QVariantMap m1=qvariant_cast<QVariantMap>(s1);
    QVariantMap m2=s2.value<QVariantMap>();
    return m1["seqid"] < m2["seqid"];
}

bool compareTime(const QVariant &s1, const QVariant &s2)
{
    QVariantMap m1=qvariant_cast<QVariantMap>(s1);
    QVariantMap m2=s2.value<QVariantMap>();
    return m1["timestamp"] > m2["timestamp"];
}

QVariantList QmlDevState::getHistory()
{
    return history;
}

int QmlDevState::setSingleHistory(QVariantMap single)
{
    qDebug()<< "setSingleHistory" << single;

    QVariantList::iterator iter;
    for (iter = history.begin(); iter != history.end(); ++iter)
    {
        QVariantMap cur=(*iter).toMap();
        if(single["id"]==cur["id"])
        {
            single["timestamp"]= QDateTime::currentDateTime().toSecsSinceEpoch();
            *iter=single;
            qDebug() << *iter;
            break;
        }
    }

    if(iter == history.end())
    {
        return -1;
    }
    std::sort(history.begin(), history.end(), compareTime);
    return 0;
}

int QmlDevState::addSingleHistory(QVariantMap single)
{
    int i;
    qDebug() << "addSingleHistory" << single;
    single["timestamp"]= QDateTime::currentDateTime().toSecsSinceEpoch();
    if(getHistoryCount()>=MAX_HISTORY)
    {
        int lastIndex=lastHistory(false);
        history[lastIndex]=single;
    }
    else
    {;
        QJsonObject Data;
        Data.insert("dishName", single["dishName"].toString());
        Data.insert("imgUrl", single["imgUrl"].toString());
        Data.insert("details", single["details"].toString());
        Data.insert("cookSteps", single["cookSteps"].toString());
        Data.insert("timestamp", single["timestamp"].toInt());
        Data.insert("collect", single["collect"].toInt());
        Data.insert("cookTime", single["cookTime"].toInt());
        Data.insert("cookType", single["cookType"].toInt());
        sendJsonToServer("SET",Data);
    }
    return 0;
}

int QmlDevState::lastHistory(bool collect)
{
    for (int i = history.size() -1;i > 0; --i)
    {
        QVariantMap cur=history[i].toMap();
        if(cur["collect"]==collect)
        {
            return i;
        }
    }
    return -1;
}

int QmlDevState::getHistoryCount()
{
    int count=0;
    QVariantList::iterator iter;
    for (iter = history.begin(); iter != history.end(); ++iter)
    {
        QVariantMap cur=(*iter).toMap();
        if(cur["collect"] == true)
        {
            ++count;
        }
    }
    return history.size()-count;
}

int QmlDevState::removeHistory(int index)
{
    history.removeAt(index);
    //    sort(history.begin(), history.end(), compareTime);
    return 0;
}

int QmlDevState::setCollect(int index, bool collect)
{
    qDebug()<< "setCollect" << index << "," << collect;

    QVariantMap cur=history[index].toMap();

    int lastIndex=-1;
    if(collect)
    {
        if(history.size()-getHistoryCount()>=MAX_COLLECT)
        {
            lastIndex=lastHistory(true);
        }
    }
    else
    {
        if(getHistoryCount()>=MAX_HISTORY)
        {
            lastIndex=lastHistory(false);
        }
    }

    cur["time"]= QDateTime::currentDateTime().toSecsSinceEpoch();
    cur["collect"]=collect;
    history[index]=cur;
    if(lastIndex < 0 || lastIndex==index)
    {

    }
    else
    {
        history.removeAt(lastIndex);
        qDebug() << "removeAt "<< lastIndex << " , " << history[index];
    }

    qDebug() << history[index];
    std::sort(history.begin(), history.end(), compareTime);
    return 0;
}

int QmlDevState::sendToServer(QString data)
{
    QByteArray msg= data.toUtf8();
    return client.sendMessage(msg);
}

int QmlDevState::sendJsonToServer(QString type, QJsonObject json)
{
    QJsonObject root;
    root.insert("Type", type);
    root.insert("Data", json);
    QByteArray data=QJsonDocument(root).toJson(QJsonDocument::Compact);
    return sendToServer(QString(data));
}

void QmlDevState::readData(QJsonValue &data)
{
    qDebug()<< "readData" << data;
    QJsonObject object =data.toObject();

    QString key;
    enum LINK_VALUE_TYPE value_type;
    QVariantMap::iterator it;
    for(it=stateTypeMap.begin(); it!=stateTypeMap.end(); it++){

        key=it.key();
        value_type=(enum LINK_VALUE_TYPE)it.value().toInt();

        if(object.contains(it.key()))
        {
            qInfo()<<"key:"<<key<<"value type:"<<value_type;
            QJsonValue value =object.value(it.key());
            if(LINK_VALUE_TYPE_NUM==value_type)
            {
                setState(key,value.toInt());
                qInfo()<<"key:"<<key<<"value:"<<value.toInt();
            }
            else if(LINK_VALUE_TYPE_STRING==value_type)
            {
                setState(key,value.toString());
                qInfo()<<"key:"<<key<<"value:"<<value.toString();
            }
            else if(LINK_VALUE_TYPE_STRUCT==value_type)
            {
                QJsonObject object_struct =value.toObject();
                if(key=="WifiCurConnected")
                {
                    QJsonValue ssid =object_struct.value("ssid");
                    QJsonValue bssid =object_struct.value("bssid");
                    QJsonValue ip_address =object_struct.value("ip_address");
                    QJsonValue mac_address =object_struct.value("mac_address");
                    setState("bssid",bssid.toString());
                    qInfo()<<"key:"<<"bssid"<<"value:"<<bssid.toString();
                }
                else if(key=="CookRecipe" || key=="CookHistory")
                {
                    QJsonArray array =value.toArray();
                    QVariantMap info;

                    if(key=="CookRecipe")
                    {
                        recipe[0].clear();
                    }
                    else
                    {
                        history.clear();
                    }

                    for(int i=0;i<array.size();++i)
                    {
                        QJsonObject obj_array=array.at(i).toObject();
                        QJsonValue id =obj_array.value("id");
                        QJsonValue seqid =obj_array.value("seqid");
                        QJsonValue dishName =obj_array.value("dishName");
                        QJsonValue imgUrl =obj_array.value("imgUrl");
                        QJsonValue cookSteps =obj_array.value("cookSteps");
                        QJsonValue details =obj_array.value("details");
                        QJsonValue collect =obj_array.value("collect");
                        QJsonValue timestamp =obj_array.value("timestamp");
                        QJsonValue cookType =obj_array.value("cookType");
                        QJsonValue cookTime =obj_array.value("cookTime");

                        info.insert("id",id.toInt());
                        info.insert("seqid",seqid.toInt());
                        info.insert("dishName",dishName.toString());
                        info.insert("imgUrl",imgUrl.toString());
                        info.insert("cookSteps",cookSteps.toString());
                        info.insert("details",details.toString());
                        info.insert("collect",collect.toInt());
                        info.insert("timestamp",timestamp.toInt());
                        info.insert("cookType",cookType.toInt());
                        info.insert("cookTime",cookTime.toInt());
                        if(key=="CookRecipe")
                        {
                            recipe[0].append(info);
                        }
                        else
                        {
                            history.append(info);
                            std::sort(history.begin(), history.end(), compareId);
                        }
                        qInfo()<<key <<":"<<info;
                    }
                }
            }
            else
            {

            }
        }
    }
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

void QmlDevState::setState(QString name,QVariant value)
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

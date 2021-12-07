#include "qmldevstate.h"
//#include<QtAlgorithms>
#include<algorithm>
//using namespace std;


//QmlDevState* QmlDevState::qmlDevState;
QmlDevState::QmlDevState(QObject *parent) : QObject(parent)
{
    stateTypeMap.insert("SoftVersion",LINK_VALUE_TYPE_STRING);

    stateTypeMap.insert("WifiState",LINK_VALUE_TYPE_NUM);
    stateTypeMap.insert("WifiEnable",LINK_VALUE_TYPE_NUM);
    stateTypeMap.insert("WifiScanR",LINK_VALUE_TYPE_STRING);
    stateTypeMap.insert("WifiCurConnected",LINK_VALUE_TYPE_STRUCT);

    stateTypeMap.insert("CookRecipe",LINK_VALUE_TYPE_STRUCT);
    stateTypeMap.insert("CookHistory",LINK_VALUE_TYPE_STRUCT);
    stateTypeMap.insert("InsertHistory",LINK_VALUE_TYPE_STRUCT);
    stateTypeMap.insert("DeleteHistory",LINK_VALUE_TYPE_STRUCT);
    stateTypeMap.insert("UpdateHistory",LINK_VALUE_TYPE_STRUCT);

    stateTypeMap.insert("OTAState",LINK_VALUE_TYPE_NUM);
    stateTypeMap.insert("OTAProgress",LINK_VALUE_TYPE_NUM);
    stateTypeMap.insert("OTANewVersion",LINK_VALUE_TYPE_STRING);

    stateTypeMap.insert("ProductCategory",LINK_VALUE_TYPE_STRING);
    stateTypeMap.insert("ProductModel",LINK_VALUE_TYPE_STRING);
    stateTypeMap.insert("DeviceName",LINK_VALUE_TYPE_STRING);
    stateTypeMap.insert("QrCode",LINK_VALUE_TYPE_STRING);

    stateTypeMap.insert("AfterSalesPhone",LINK_VALUE_TYPE_STRING);
    stateTypeMap.insert("AfterSalesQrCode",LINK_VALUE_TYPE_STRING);

    stateTypeMap.insert("LStOvMode",LINK_VALUE_TYPE_NUM);
    stateTypeMap.insert("LStOvState",LINK_VALUE_TYPE_NUM);
    stateTypeMap.insert("LStOvOperation",LINK_VALUE_TYPE_NUM);
    stateTypeMap.insert("LStOvSetTimer",LINK_VALUE_TYPE_NUM);
    stateTypeMap.insert("LStOvSetTimerLeft",LINK_VALUE_TYPE_NUM);
    stateTypeMap.insert("LStOvSetTemp",LINK_VALUE_TYPE_NUM);
    stateTypeMap.insert("LStOvRealTemp",LINK_VALUE_TYPE_NUM);
    stateTypeMap.insert("LStOvOrderTimer",LINK_VALUE_TYPE_NUM);
    stateTypeMap.insert("LStOvOrderTimerLeft",LINK_VALUE_TYPE_NUM);

    stateTypeMap.insert("RStOvState",LINK_VALUE_TYPE_NUM);
    stateTypeMap.insert("RStOvOperation",LINK_VALUE_TYPE_NUM);
    stateTypeMap.insert("RStOvSetTimer",LINK_VALUE_TYPE_NUM);
    stateTypeMap.insert("RStOvSetTimerLeft",LINK_VALUE_TYPE_NUM);
    stateTypeMap.insert("RStOvSetTemp",LINK_VALUE_TYPE_NUM);
    stateTypeMap.insert("RStOvRealTemp",LINK_VALUE_TYPE_NUM);
    stateTypeMap.insert("RStOvOrderTimer",LINK_VALUE_TYPE_NUM);
    stateTypeMap.insert("RStOvOrderTimerLeft",LINK_VALUE_TYPE_NUM);

    stateTypeMap.insert("MultiStageState",LINK_VALUE_TYPE_STRUCT);

#ifndef USE_RK3308
    setState("LStOvMode",0);
    setState("LStOvState",0);
    setState("LStOvSetTimerLeft",0);
    setState("LStOvRealTemp",0);
    setState("LStOvOrderTimerLeft",0);

    setState("RStOvState",0);
    setState("RStOvSetTimerLeft",0);
    setState("RStOvRealTemp",0);
    setState("RStOvOrderTimerLeft",0);

    setState("cnt",0);
    setState("current",0);
#endif
    connect(&client, SIGNAL(sendData(const QJsonValue&)), this,SLOT(readData(const QJsonValue&)));

    myName="DevState";

    QVariantMap info;
    info.insert("id", 0);
    info.insert("cookType", 0);
    info.insert("cookTime", 120);

    info.insert("dishName", "清蒸鱼");
    info.insert("imgUrl", "/images/peitu01.png");
    info.insert("cookSteps", "[{\"device\":0,\"mode\":5,\"temp\":100,\"time\":90}]");
    info.insert("details", "食材：\n鸡蛋2个，蛤蜊50g，盐2g，油3滴葱花30g\n步骤：\n1、鱼片加入适量鸡蛋，料酒、升降、盐，醋、糖，搅拌均匀后加一点淀粉（淀粉加水）增加粘度\n2、鱼片加入适量鸡蛋，料酒、升降、盐，醋、糖，搅拌均匀后加一点淀粉（淀粉加水）增加粘度\n3、鱼片加入适量鸡蛋，料酒、升降、盐，醋、糖，搅拌均匀后加一点淀粉（淀粉加水）增加粘度");
    info.insert("collect", false);
    info.insert("timestamp", 0);

    recipe[0].append(info);
    info["cookType"]=1;
    info["dishName"]="烤鱼";
    recipe[0].append(info);
    info["cookType"]=2;
    info["dishName"]="红烧鱼";
    recipe[0].append(info);
    info["cookType"]=1;

    info["dishName"]="烤面包";
    recipe[0].append(info);

    info["cookType"]=0;
    info["dishName"]="烤面包0";
    recipe[1].append(info);
}

QVariantList QmlDevState::getRecipe(const int index)
{
    return recipe[index];
}
QVariantList QmlDevState::getHistory()
{
    return history;
}


int QmlDevState::insertHistory(QVariantMap single)
{
    int ret=-1;
    qDebug() << "insertHistory" << single;

    single["timestamp"]= QDateTime::currentDateTime().toSecsSinceEpoch();
    int id=compareHistoryCollect(single);
    if(id>=0)
    {
        QJsonObject Data;
        QJsonObject item;
        item.insert("id", id);
        item.insert("timestamp", single["timestamp"].toInt());
        Data.insert("UpdateHistory", item);
        ret=sendJsonToServer("SET",Data);
    }
    else
    {
        if(getHistoryCount()>=MAX_HISTORY)
        {
            int id=lastHistoryId(false);
            if(id>=0)
                ret=deleteHistory(id);
        }
        QJsonObject Data;
        QJsonObject item;
        item.insert("dishName", single["dishName"].toString());
        item.insert("imgUrl", single["imgUrl"].toString());
        item.insert("details", single["details"].toString());
        item.insert("cookSteps", single["cookSteps"].toString());
        item.insert("timestamp", single["timestamp"].toInt());
        item.insert("collect", single["collect"].toInt());
        item.insert("cookTime", single["cookTime"].toInt());
        item.insert("cookType", single["cookType"].toInt());

        Data.insert("InsertHistory", item);
        ret=sendJsonToServer("SET",Data);
    }
    return ret;
}
int QmlDevState::deleteHistory(int id)
{
    QJsonObject Data;

    Data.insert("DeleteHistory", id);
    return sendJsonToServer("SET",Data);
}

int QmlDevState::setCollect(const int index,const bool collect)
{
    int ret=-1;
    qDebug()<< "setCollect" << index << "," << collect;

    QVariantMap cur=history[index].toMap();

    int lastId=-1;
    if(collect)
    {
        if(history.size()-getHistoryCount()>=MAX_COLLECT)
        {
            lastId=lastHistoryId(true);
        }
    }
    else
    {
        if(getHistoryCount()>=MAX_HISTORY)
        {
            lastId=lastHistoryId(false);
        }
    }

    QJsonObject Data;
    QJsonObject item;
    item.insert("id", cur["id"].toInt());
    item.insert("collect", collect);
    Data.insert("UpdateHistory", item);
    ret=sendJsonToServer("SET",Data);

    if(lastId < 0 || lastId==cur["id"])
    {

    }
    else
    {
        qDebug() << "removeAt "<< lastId;
        ret=deleteHistory(lastId);
    }

    return ret;
}

void QmlDevState::setHistory(const QVariantMap &history)
{
    emit historyChanged(history);
}

int QmlDevState::coverHistory(const QJsonObject &object, QVariantMap &info)
{
    QJsonValue id =object.value("id");
    QJsonValue seqid =object.value("seqid");
    QJsonValue dishName =object.value("dishName");
    QJsonValue imgUrl =object.value("imgUrl");
    QJsonValue cookSteps =object.value("cookSteps");
    QJsonValue details =object.value("details");
    QJsonValue collect =object.value("collect");
    QJsonValue timestamp =object.value("timestamp");
    QJsonValue cookType =object.value("cookType");
    QJsonValue cookTime =object.value("cookTime");

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
    return 0;
}
bool compareId(const QVariant &s1, const QVariant &s2)
{
    QVariantMap m1=qvariant_cast<QVariantMap>(s1);
    QVariantMap m2=s2.value<QVariantMap>();
    if(m1["collect"]==m2["collect"])
    {
        return m1["seqid"] > m2["seqid"];
    }
    else
    {
        if(m1["collect"]>0)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
}

bool compareTime(const QVariant &s1, const QVariant &s2)
{
    QVariantMap m1=qvariant_cast<QVariantMap>(s1);
    QVariantMap m2=s2.value<QVariantMap>();
    return m1["timestamp"] > m2["timestamp"];
}

int QmlDevState::compareHistoryCollect(const QVariantMap& single)
{
    for (int i = 0;i < history.size(); ++i)
    {
        QVariantMap cur=history[i].toMap();
        if(cur["collect"]==0)
            continue;
        qDebug() << "compareHistoryCollect" << cur["id"];

        if(cur["dishName"]==single["dishName"]&&cur["imgUrl"]==single["imgUrl"]&&cur["details"]==single["details"]&&cur["cookSteps"]==single["cookSteps"])
        {
            return cur["id"].toInt();
        }
    }
    return -1;
}


int QmlDevState::lastHistoryId(const int collect)
{
    for (int i = history.size() -1;i > 0; --i)
    {
        QVariantMap cur=history[i].toMap();
        qDebug() << "lastHistoryId" << cur["collect"] << "collect" << collect;
        if(cur["collect"]==collect)
        {
            return cur["id"].toInt();
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

int QmlDevState::getHistoryIndex(const int id)
{
    for (int i = 0;i < history.size(); ++i)
    {
        QVariantMap cur=history[i].toMap();
        if(cur["id"]==id)
        {
            return i;
        }
    }
    return -1;
}

int QmlDevState::sendToServer(const QString& data)
{
    QByteArray msg= data.toUtf8();
    return client.sendMessage(msg);
}

int QmlDevState::sendJsonToServer(const QString& type,const QJsonObject& json)
{
    QJsonObject root;
    root.insert("Type", type);
    root.insert("Data", json);
    QByteArray data=QJsonDocument(root).toJson(QJsonDocument::Compact);
    return sendToServer(QString(data));
}

void QmlDevState::readData(const QJsonValue &data)
{
    qDebug()<< "readData" << data  << endl;
    QJsonObject object =data.toObject();

    QString key;
    enum LINK_VALUE_TYPE value_type;
    QVariantMap::iterator it;
    for(it=stateTypeMap.begin(); it!=stateTypeMap.end(); it++){

        key=it.key();
        value_type=(enum LINK_VALUE_TYPE)it.value().toInt();

        if(object.contains(it.key()))
        {
            qDebug()<<"key:"<<key<<"value type:"<<value_type<< endl;
            QJsonValue value =object.value(it.key());
            if(LINK_VALUE_TYPE_NUM==value_type)
            {
                setState(key,value.toInt());
                qDebug()<<"key:"<<key<<"value:"<<value.toInt();
            }
            else if(LINK_VALUE_TYPE_STRING==value_type)
            {
                setState(key,value.toString());
                qDebug()<<"key:"<<key<<"value:"<<value.toString();
                if("QrCode"==key)
                {
                    QrcodeEn::encodeImage("http://club.marssenger.com/hxr/download.html?pk=a1n3oZED0Y8&dn=X5B-ChengWei-01",4,key+".png");
                }
                else if("AfterSalesQrCode"==key)
                {
                    QrcodeEn::encodeImage("http://club.marssenger.com/hxr/download.html?pk=a1n3oZED0Y8",4,key+".png");
                }
            }
            else if(LINK_VALUE_TYPE_STRUCT==value_type)
            {

                if(key=="WifiCurConnected")
                {
                    QJsonObject object_struct =value.toObject();
                    QJsonValue ssid =object_struct.value("ssid");
                    QJsonValue bssid =object_struct.value("bssid");
                    QJsonValue ip_address =object_struct.value("ip_address");
                    QJsonValue mac_address =object_struct.value("mac_address");
                    setState("bssid",bssid.toString());
                    qDebug()<<"key:"<<"bssid"<<"value:"<<bssid.toString();
                }
                else if(key=="CookRecipe" || key=="CookHistory")
                {
                    QJsonArray array =value.toArray();
                    QVariantMap info;

                    if(key=="CookRecipe")
                    {
                        recipe[0].clear();
                        qDebug()<<"CookRecipe size:" <<array.size() << endl;
                    }
                    else
                    {
                        history.clear();
                        qDebug()<<"CookHistory size:" <<array.size() << endl;
                    }

                    for(int i=0;i<array.size();++i)
                    {
                        QJsonObject obj_array=array.at(i).toObject();
                        coverHistory(obj_array,info);
                        if(key=="CookRecipe")
                        {
                            recipe[0].append(info);
                        }
                        else
                        {
                            history.append(info);
                            std::sort(history.begin(), history.end(), compareId);
                        }
                        qDebug()<<key <<":"<<info<< endl;
                    }
                }
                else if(key=="InsertHistory")
                {
                    QVariantMap info;
                    QJsonObject object_struct =value.toObject();
                    coverHistory(object_struct,info);
                    history.append(info);
                    std::sort(history.begin(), history.end(), compareId);
                    setHistory(info);
                }
                else if(key=="DeleteHistory")
                {
                    int id=value.toInt();
                    int index=getHistoryIndex(id);
                    QVariantMap cur=history[index].toMap();
                    if(index>=0)
                        history.removeAt(index);
                    setHistory(cur);
                }
                else if(key=="UpdateHistory")
                {
                    QJsonObject object_struct =value.toObject();
                    QJsonValue id =object_struct.value("id");
                    int index=getHistoryIndex(id.toInt());
                    if(index<0)
                        continue;
                    QVariantMap cur=history[index].toMap();
                    if(object_struct.contains("seqid"))
                    {
                        QJsonValue seqid =object_struct.value("seqid");
                        cur["seqid"]=seqid.toInt();
                    }
                    if(object_struct.contains("collect"))
                    {
                        QJsonValue collect =object_struct.value("collect");
                        cur["collect"]=collect.toInt();
                    }
                    if(object_struct.contains("timestamp"))
                    {
                        QJsonValue timestamp =object_struct.value("timestamp");
                        cur["timestamp"]=timestamp.toInt();
                    }
                    history[index]=cur;

                    std::sort(history.begin(), history.end(), compareId);
                    setHistory(cur);
                }
            }
        }
        else
        {

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

void QmlDevState::setState(const QString& name,const QVariant& value)
{
    //    if(stateMap.contains(name))
    //    {
    stateMap[name]=value;
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

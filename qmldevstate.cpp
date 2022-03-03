#include "qmldevstate.h"
//#include<QtAlgorithms>
#include<algorithm>
//using namespace std;


//QmlDevState* QmlDevState::qmlDevState;
QmlDevState::QmlDevState(QObject *parent) : QObject(parent)
{
    //    stateTypeMap.insert("APPBind",LINK_VALUE_TYPE_NUM);
    stateTypeMap.insert("SteamStart",LINK_VALUE_TYPE_NULL);
    stateTypeMap.insert("ProductionTest",LINK_VALUE_TYPE_NULL);
    stateTypeMap.insert("ElcSWVersion",LINK_VALUE_TYPE_STRING);
    stateTypeMap.insert("ComSWVersion",LINK_VALUE_TYPE_STRING);
    stateTypeMap.insert("Reset",LINK_VALUE_TYPE_NUM);
    stateTypeMap.insert("ErrorCodeShow",LINK_VALUE_TYPE_NUM);
    stateTypeMap.insert("SysPower",LINK_VALUE_TYPE_NUM);

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
    stateTypeMap.insert("ProductKey",LINK_VALUE_TYPE_STRING);
    stateTypeMap.insert("DeviceName",LINK_VALUE_TYPE_STRING);
    stateTypeMap.insert("ProductSecret",LINK_VALUE_TYPE_STRING);
    stateTypeMap.insert("DeviceSecret",LINK_VALUE_TYPE_STRING);
    stateTypeMap.insert("QrCode",LINK_VALUE_TYPE_STRING);
    stateTypeMap.insert("UpdateLog",LINK_VALUE_TYPE_STRING);

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
    stateTypeMap.insert("LStOvDoorState",LINK_VALUE_TYPE_NUM);

    stateTypeMap.insert("RStOvState",LINK_VALUE_TYPE_NUM);
    stateTypeMap.insert("RStOvOperation",LINK_VALUE_TYPE_NUM);
    stateTypeMap.insert("RStOvSetTimer",LINK_VALUE_TYPE_NUM);
    stateTypeMap.insert("RStOvSetTimerLeft",LINK_VALUE_TYPE_NUM);
    stateTypeMap.insert("RStOvSetTemp",LINK_VALUE_TYPE_NUM);
    stateTypeMap.insert("RStOvRealTemp",LINK_VALUE_TYPE_NUM);
    stateTypeMap.insert("RStOvOrderTimer",LINK_VALUE_TYPE_NUM);
    stateTypeMap.insert("RStOvOrderTimerLeft",LINK_VALUE_TYPE_NUM);
    stateTypeMap.insert("RStOvDoorState",LINK_VALUE_TYPE_NUM);

    stateTypeMap.insert("MultiMode",LINK_VALUE_TYPE_NUM);
    stateTypeMap.insert("MultiStageState",LINK_VALUE_TYPE_STRUCT);
    stateTypeMap.insert("CookbookName",LINK_VALUE_TYPE_STRING);

    stateTypeMap.insert("LStoveStatus",LINK_VALUE_TYPE_NUM);
    stateTypeMap.insert("RStoveStatus",LINK_VALUE_TYPE_NUM);
    stateTypeMap.insert("RStoveTimingState",LINK_VALUE_TYPE_NUM);
    stateTypeMap.insert("RStoveTimingOpera",LINK_VALUE_TYPE_NUM);
    stateTypeMap.insert("RStoveTimingSet",LINK_VALUE_TYPE_NUM);
    stateTypeMap.insert("RStoveTimingLeft",LINK_VALUE_TYPE_NUM);

    stateTypeMap.insert("HoodStoveLink",LINK_VALUE_TYPE_NUM);
    stateTypeMap.insert("HoodLightLink",LINK_VALUE_TYPE_NUM);
    stateTypeMap.insert("HoodOffTimer",LINK_VALUE_TYPE_NUM);
    stateTypeMap.insert("HoodOffLeftTime",LINK_VALUE_TYPE_NUM);
    stateTypeMap.insert("SteamOffTime",LINK_VALUE_TYPE_NUM);
    stateTypeMap.insert("SteamOffLeftTime",LINK_VALUE_TYPE_NUM);
    stateTypeMap.insert("HoodSpeed",LINK_VALUE_TYPE_NUM);

    localConnected=0;
    connect(&client, SIGNAL(sendData(const QJsonValue&)), this,SLOT(readData(const QJsonValue&)));
    connect(&client, &LocalClient::sendConnected, this,&QmlDevState::setLocalConnected);

#ifndef USE_RK3308
    setState("SysPower",1);

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
    setState("current",1);

    setState("HoodSpeed",2);
    setState("UpdateLog","1、新增：产品详情页视频展示功能；\n2、新增：网站前台版权标识样式切换功能\n3、优化：会员中心社会化登陆功能，用户可通过扫码关注设定的公众号登录；\n4、优化：安装商城模块后，可在网站后台内容管理中直接添加和编辑商品；\n5、优化：用户购买版权标识修改许可后，后台版权");

    QVariantMap info;
    info.insert("id", 0);
    info.insert("cookType", 0);
    info.insert("cookPos", 0);
    info.insert("dishName", "清蒸鱼");
    info.insert("imgUrl", "recipes/Vegetables/蒜蓉粉丝娃娃菜.png");
    info.insert("cookSteps", "[{\"device\":0,\"mode\":35,\"temp\":100,\"time\":90}]");
    info.insert("details", "食材：\n鸡蛋2个，蛤蜊50g，盐2g，油3滴葱花30g\n步骤：\n1、鱼片加入适量鸡蛋，料酒、升降、盐，醋、糖，搅拌均匀后加一点淀粉（淀粉加水）增加粘度\n2、鱼片加入适量鸡蛋，料酒、升降、盐，醋、糖，搅拌均匀后加一点淀粉（淀粉加水）增加粘度\n3、鱼片加入适量鸡蛋，料酒、升降、盐，醋、糖，搅拌均匀后加一点淀粉（淀粉加水）增加粘度");
    info.insert("collect", 0);
    info.insert("timestamp", 0);

    recipe[0].append(info);
    info["cookType"]=1;
    info["dishName"]="桂花蜂蜜烤南瓜";
    recipe[0].append(info);
    info["cookType"]=2;
    info["dishName"]="腊肉蒸芋艿";
    recipe[0].append(info);
    info["cookType"]=1;

    info["dishName"]="蒜香茄子";
    recipe[0].append(info);

    info["cookType"]=0;
    info["dishName"]="蒜蓉粉丝娃娃菜";
    recipe[1].append(info);

    info.insert("imgUrl", "");
    history.append(info);
    info["dishName"]="烤豆腐";
    history.append(info);
#endif
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

QVariantList QmlDevState::getRecipe(const int index)
{
    return recipe[index];
}
QVariantList QmlDevState::getHistory()
{
    return history;
}


int QmlDevState::deleteHistory(int id)
{
    QJsonObject Data;
    QJsonArray array;
    array.append(id);
    Data.insert("DeleteHistory", array);
    return sendJsonToServer("SET",Data);
}

void QmlDevState::sortHistory()
{
    std::sort(history.begin(), history.end(), compareId);
}

int QmlDevState::setCollect(const int index,const int collect)
{
    int ret=-1;
    qDebug()<< "setCollect" << index << "," << collect;

    QVariantMap cur=history[index].toMap();

    QJsonObject Data;
    QJsonObject item;
    item.insert("id", cur["id"].toInt());
    item.insert("collect", collect);
    Data.insert("UpdateHistory", item);
    ret=sendJsonToServer("SET",Data);

    return ret;
}


void QmlDevState::setHistory(const QString& action,const QVariantMap &history)
{
    emit historyChanged(action,history);
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
    QJsonValue recipeType =object.value("recipeType");
    QJsonValue cookPos =object.value("cookPos");

    info.insert("id",id.toInt());
    info.insert("seqid",seqid.toInt());
    info.insert("dishName",dishName.toString());
    info.insert("imgUrl",imgUrl.toString());
    info.insert("cookSteps",cookSteps.toString());
    info.insert("details",details.toString());
    info.insert("collect",collect.toInt());
    info.insert("timestamp",timestamp.toInt());
    info.insert("cookType",cookType.toInt());
    info.insert("recipeType",recipeType.toInt());
    info.insert("cookPos",cookPos.toInt());
    return 0;
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
                    QrcodeEn::encodeImage(value.toString(),4,key+".png");
                }
                else if("AfterSalesQrCode"==key)
                {
                    QrcodeEn::encodeImage(value.toString(),4,key+".png");
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
                else if(key=="MultiStageState")
                {
                    QJsonObject object_struct =value.toObject();
                    QJsonValue cnt =object_struct.value("cnt");
                    QJsonValue current =object_struct.value("current");

                    setState("cnt",cnt.toInt());
                    setState("current",current.toInt());
                }
                else if(key=="CookRecipe" || key=="CookHistory")
                {
                    QJsonArray array =value.toArray();
                    QVariantMap info;

                    if(key=="CookRecipe")
                    {
                        for(int i=0;i< (int)(sizeof(recipe)/sizeof(recipe[0]));++i)
                            recipe[i].clear();
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
                            recipe[info["recipeType"].toInt()-1].append(info);
                        }
                        else
                        {
                            history.append(info);
                            //                            std::sort(history.begin(), history.end(), compareId);
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
                    //                    std::sort(history.begin(), history.end(), compareId);
                    setHistory(key,info);
                }
                else if(key=="DeleteHistory")
                {
                    QJsonArray array=value.toArray();
                    QVariantMap cur;
                    for(int i=0;i<array.size();++i)
                    {
                        int id=array.at(i).toInt();
                        int index=getHistoryIndex(id);
                        cur=history[index].toMap();
                        if(index>=0)
                        {
                            history.removeAt(index);
                            break;
                        }
                    }
                    setHistory(key,cur);
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

                    //                    std::sort(history.begin(), history.end(), compareId);
                    setHistory(key,cur);
                }
            }
            else if(LINK_VALUE_TYPE_NULL==value_type)
            {
                setState(key,0);
            }
        }
        else
        {

        }
    }
}


void QmlDevState::setLocalConnected(const int connected)
{
    qDebug()<<"setLocalConnected:"<<connected;

    localConnected=connected;
    emit localConnectedChanged(connected);

}

int QmlDevState::getLocalConnected() const
{
    qDebug()<<"getLocalConnected";
    return localConnected;
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

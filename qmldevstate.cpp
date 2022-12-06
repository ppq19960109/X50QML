#include "qmldevstate.h"
//#include<QtAlgorithms>
#include<algorithm>
//using namespace std;


//QmlDevState* QmlDevState::qmlDevState;
QmlDevState::QmlDevState(QObject *parent) : QObject(parent)
{
    //    QProcess::execute("cd /oem && ./logoapp");
    readRecipeDetails();
    readPanguRecipes();

    stateType.append(QPair<QString,int>("WifiCurConnected",LINK_VALUE_TYPE_STRUCT));
    stateType.append(QPair<QString,int>("WifiState",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("WifiEnable",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("WifiScanR",LINK_VALUE_TYPE_STRING));

    stateType.append(QPair<QString,int>("MultiMode",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("MultiStageState",LINK_VALUE_TYPE_STRUCT));
    stateType.append(QPair<QString,int>("CookbookName",LINK_VALUE_TYPE_STRING));

    stateType.append(QPair<QString,int>("LStOvDoorState",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("LStOvMode",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("LStOvState",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("LStOvSetTemp",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("LStOvRealTemp",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("LStOvSetTimer",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("LStOvOrderTimer",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("LStOvSetTimerLeft",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("LStOvOrderTimerLeft",LINK_VALUE_TYPE_NUM));

    stateType.append(QPair<QString,int>("RStOvDoorState",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("RStOvMode",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("RStOvState",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("RStOvSetTemp",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("RStOvRealTemp",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("RStOvOrderTimer",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("RStOvSetTimer",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("RStOvSetTimerLeft",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("RStOvOrderTimerLeft",LINK_VALUE_TYPE_NUM));

    stateType.append(QPair<QString,int>("LStoveStatus",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("RStoveStatus",LINK_VALUE_TYPE_NUM));
    //    stateType.append(QPair<QString,int>("LStoveFireStatus",LINK_VALUE_TYPE_NUM));
    //    stateType.append(QPair<QString,int>("RStoveFireStatus",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("RStoveTimingOpera",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("RStoveTimingSet",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("RStoveTimingLeft",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("RStoveTimingState",LINK_VALUE_TYPE_NUM));

    //    stateType.append(QPair<QString,int>("HoodStoveLink",LINK_VALUE_TYPE_NUM));
    //    stateType.append(QPair<QString,int>("HoodLightLink",LINK_VALUE_TYPE_NUM));
    //    stateType.append(QPair<QString,int>("HoodOffTimer",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("HoodOffLeftTime",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("HoodSpeed",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("HoodLight",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("HoodOffRemind",LINK_VALUE_TYPE_NUM));

    stateType.append(QPair<QString,int>("PwrSWVersion",LINK_VALUE_TYPE_STRING));
    stateType.append(QPair<QString,int>("ComSWVersion",LINK_VALUE_TYPE_STRING));
    stateType.append(QPair<QString,int>("SysPower",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("ErrorCode",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("ErrorCodeShow",LINK_VALUE_TYPE_NUM));


    stateType.append(QPair<QString,int>("CookRecipe",LINK_VALUE_TYPE_STRUCT));
    stateType.append(QPair<QString,int>("CookHistory",LINK_VALUE_TYPE_STRUCT));
    stateType.append(QPair<QString,int>("InsertHistory",LINK_VALUE_TYPE_STRUCT));
    stateType.append(QPair<QString,int>("DeleteHistory",LINK_VALUE_TYPE_STRUCT));
    stateType.append(QPair<QString,int>("UpdateHistory",LINK_VALUE_TYPE_STRUCT));

    stateType.append(QPair<QString,int>("OTAState",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("OTAProgress",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("OTANewVersion",LINK_VALUE_TYPE_STRING));

    stateType.append(QPair<QString,int>("ProductCategory",LINK_VALUE_TYPE_STRING));
    stateType.append(QPair<QString,int>("ProductModel",LINK_VALUE_TYPE_STRING));
    stateType.append(QPair<QString,int>("ProductKey",LINK_VALUE_TYPE_STRING));
    stateType.append(QPair<QString,int>("DeviceName",LINK_VALUE_TYPE_STRING));
    stateType.append(QPair<QString,int>("ProductSecret",LINK_VALUE_TYPE_STRING));
    stateType.append(QPair<QString,int>("DeviceSecret",LINK_VALUE_TYPE_STRING));
    stateType.append(QPair<QString,int>("QrCode",LINK_VALUE_TYPE_STRING));
    stateType.append(QPair<QString,int>("UpdateLog",LINK_VALUE_TYPE_STRING));
    //    stateType.append(QPair<QString,int>("BindTokenState",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("QuadInfo",LINK_VALUE_TYPE_STRING));

    stateType.append(QPair<QString,int>("Reset",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("AlarmStatus",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("Alarm",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("SteamStart",LINK_VALUE_TYPE_NULL));
    stateType.append(QPair<QString,int>("DemoStart",LINK_VALUE_TYPE_NULL));
    stateType.append(QPair<QString,int>("ProductionTest",LINK_VALUE_TYPE_NULL));

    stateType.append(QPair<QString,int>("LoadPowerState",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("PCBInput",LINK_VALUE_TYPE_ARRAY));

    stateType.append(QPair<QString,int>("PushRod",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("Weight",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("RCookbookName",LINK_VALUE_TYPE_STRING));

    localConnected=0;
    connect(&client, SIGNAL(sendData(QByteArray)), this,SLOT(readData(QByteArray)));
    connect(&client, &LocalClient::sendConnected, this,&QmlDevState::setLocalConnected);

    setState("HoodSpeed",0);
    setState("HoodLight",0);
    setState("RStoveStatus",0);
    setState("Weight",1);
    setState("PushRod",0);
#ifndef USE_RK3308
    setState("SysPower",1);
    setState("LoadPowerState",7);

    setState("RStoveStatus",1);
    setState("RStoveTimingLeft",50);

    setState("LStOvMode",0);
    setState("LStOvState",0);
    setState("LStOvSetTimer",0);
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
    info.insert("seqid", 3);
    info.insert("recipeid", 426);
    info.insert("cookPos", 0);
    info.insert("dishName", "清蒸鱼");
    info.insert("cookSteps", "[{\"device\":0,\"mode\":35,\"number\":1,\"temp\":100,\"time\":90}]");
    info.insert("collect", 0);
    info.insert("timestamp", 0);
    info.insert("recipeType", 1);

    recipe[0].append(info);
    info["recipeid"]=427;
    info["dishName"]="桂花蜂蜜烤南瓜";
    recipe[0].append(info);
    info["recipeid"]=118;
    info["dishName"]="腊肉蒸芋艿";
    recipe[0].append(info);
    info["recipeid"]=118;
    info["dishName"]="蒜香茄子";
    recipe[0].append(info);

    info["recipeid"]=427;
    info["dishName"]="蒜蓉粉丝娃娃菜";
    recipe[1].append(info);

    history.append(info);
    info["dishName"]="烤豆腐";
    history.append(info);
    info["dishName"]="烤豆腐2";
    history.append(info);
    info["dishName"]="烤豆腐3";
    history.append(info);
    info["dishName"]="烤豆腐4";
    history.append(info);
    info["dishName"]="烤豆腐5";
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

void QmlDevState::startLocalConnect()
{
    client.startConnectTimer();
}


void QmlDevState::setHistory(QString& action,QVariantMap& history)
{
    emit historyChanged(action,history);
}

int QmlDevState::coverHistory(QJsonObject& object, QVariantMap& info)
{
    QJsonValue id =object.value("id");
    QJsonValue seqid =object.value("seqid");
    QJsonValue dishName =object.value("dishName");
    QJsonValue cookSteps =object.value("cookSteps");
    QJsonValue collect =object.value("collect");
    QJsonValue timestamp =object.value("timestamp");
    QJsonValue recipeid =object.value("recipeid");
    QJsonValue recipeType =object.value("recipeType");
    QJsonValue cookPos =object.value("cookPos");

    info.insert("id",id.toInt());
    info.insert("seqid",seqid.toInt());
    info.insert("dishName",dishName.toString());
    info.insert("cookSteps",cookSteps.toString());
    info.insert("collect",collect.toInt());
    info.insert("timestamp",timestamp.toInt());
    info.insert("recipeid",recipeid.toInt());
    info.insert("recipeType",recipeType.toInt());
    info.insert("cookPos",cookPos.toInt());
    return 0;
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

QVariantList QmlDevState::getRecipeDetails(const int recipeid)
{
    return recipeMap[recipeid];
}
QVariantList QmlDevState::getPanguRecipe(const int index)
{
    return panguRecipes[index];
}
void QmlDevState::executeShell(const QString cmd)
{
    qDebug() << "executeShell:" << cmd;
    //    QProcess::execute(cmd);
    //    QProcess::startDetached("cmd");
    //    process.start(cmd);
    //    qDebug() << "executeShell system:" << cmd.toUtf8().data();
    system(cmd.toUtf8().data());
}

QString QmlDevState::getNetworkMac()
{
    foreach (QNetworkInterface netInterface, QNetworkInterface::allInterfaces())
    {
        //设备名
        qDebug() << "Device:" << netInterface.name();

        //MAC地址
        qDebug() << "HardwareAddress:" << netInterface.hardwareAddress();
        if(netInterface.name()=="wlan0")
            return netInterface.hardwareAddress();
        //        QList<QNetworkAddressEntry> entryList = netInterface.addressEntries();

        //        //遍历每一个IP地址(每个包含一个IP地址，一个子网掩码和一个广播地址)
        //        foreach(QNetworkAddressEntry entry, entryList)
        //        {
        //            //IP地址
        //            qDebug() << "IP Address:" << entry.ip().toString();

        //            //子网掩码
        //            qDebug() << "Netmask:" << entry.netmask().toString();

        //            //广播地址
        //            qDebug() << "Broadcast:" << entry.broadcast().toString();
        //        }
    }
    return "";
}

void QmlDevState::selfStart()
{
    emit rebootChanged(1);
}

void QmlDevState::readRecipeDetails()
{
    QFile file("RecipesDetails.json");
    if(!file.open(QIODevice::ReadOnly | QIODevice::Text))
    {
        return;
    }
    QByteArray allArray = file.readAll();
    file.close();

    QJsonParseError error;
    QJsonDocument doucment = QJsonDocument::fromJson(allArray,&error);
    if(error.error!=QJsonParseError::NoError)
    {
        qDebug() << "QJsonDocument fromJson:"<< error.error<< ","<<error.errorString();
        return;
    }
    QJsonObject object = doucment.object();
    QJsonArray recipes = object.value("recipes").toArray();
    qDebug()<<"recipes:"<<recipes.size();
    for(int i=0;i<recipes.size();++i)
    {
        QJsonObject obj=recipes.at(i).toObject();
        QJsonValue imgUrl =obj.value("imgUrl");
        QJsonValue details =obj.value("details");
        QJsonValue recipeid =obj.value("recipeid");
        QVariantList list;
        list.append(imgUrl.toString());
        list.append(details.toString());
        recipeMap.insert(recipeid.toInt(),list);
    }
    //    qDebug()<<"recipeMap:"<<recipeMap;
}

void QmlDevState::readPanguRecipes()
{
    QFile file("RecipesPangu.json");
    if(!file.open(QIODevice::ReadOnly | QIODevice::Text))
    {
        return;
    }
    QByteArray allArray = file.readAll();
    file.close();

    QJsonParseError error;
    QJsonDocument doucment = QJsonDocument::fromJson(allArray,&error);
    if(error.error!=QJsonParseError::NoError)
    {
        qDebug() << "QJsonDocument fromJson:"<< error.error<< ","<<error.errorString();
        return;
    }
    QJsonObject object = doucment.object();
    QJsonArray recipes = object.value("recipes").toArray();
    qDebug()<<"recipes:"<<recipes.size();
    for(int i=0;i<recipes.size();++i)
    {
        QJsonObject obj=recipes.at(i).toObject();
        QJsonValue dishName =obj.value("dishName");
        QJsonValue imgUrl =obj.value("imgUrl");
        QJsonValue cookSteps =obj.value("cookSteps");
        QJsonValue details =obj.value("details");
        QJsonValue cookType =obj.value("cookType");
        QJsonValue repeat =obj.value("repeat");
        int recipeType =obj.value("recipeType").toInt();
        QVariantMap info;
        info.insert("dishName",dishName.toString());
        info.insert("imgUrl",imgUrl.toString());
        info.insert("details",details.toString());
        info.insert("cookType",cookType.toInt());
        info.insert("recipeType",recipeType);
        info.insert("cookSteps",cookSteps.toArray());
        info.insert("repeat",repeat.toInt());
        panguRecipes[recipeType-1].append(info);
    }
//    qDebug()<<"panguRecipes:"<<panguRecipes[0];
}

int QmlDevState::sendToServer(QString data)
{
    //    QByteArray msg= data.toUtf8();
    return client.sendMessage(data);
}

int QmlDevState::sendJsonToServer(const QString type,QJsonObject& json)
{
    QJsonObject root;
    root.insert("Type", type);
    root.insert("Data", json);
    QByteArray data=QJsonDocument(root).toJson(QJsonDocument::Compact);
    return sendToServer(QString(data));
}

int QmlDevState::uds_json_parse(const char *value,const int value_len)
{
    QJsonParseError error;
    //    QJsonDocument doucment = QJsonDocument::fromJson(QByteArray(value,value_len),&error);
    QJsonDocument doucment = QJsonDocument::fromJson(QByteArray::fromRawData(value,value_len),&error);
    if(error.error!=QJsonParseError::NoError)
    {
        qDebug() << "QJsonDocument fromJson:"<< error.error<< ","<<error.errorString();
        return -1;
    }
    //    if (!doucment.isObject())
    //    {
    //        qDebug() << "JSON Parse Error:";
    //        return -1;
    //    }
    QJsonObject object = doucment.object();
    QJsonValue Type = object.value(JSONTYPE);
    //    if (!Type.isString())
    //    {
    //        qDebug() << "Type is NULL";
    //        return -1;
    //    }

    //    QJsonValue Data =object.value(DATA);
    //    if (!Data .isObject())
    //    {
    //        qDebug() << "Data is NULL";
    //        return -1;
    //    }
    QJsonObject Data =object.value(JSONDATA).toObject();
    if (TYPE_EVENT== Type.toString())
    {
        parsingData(Data);
    }

    return 0;
}

void QmlDevState::readData(QByteArray bytes)
{
    const unsigned char*data=(const unsigned char*)bytes.constData();
    int len=bytes.size();

    static unsigned short msg_len;
    //    int encry, seqid;
    //unsigned char verify;
    for (int i = 0; i < len; ++i)
    {
        if (data[i] == FRAME_HEADER && data[i + 1] == FRAME_HEADER)
        {
            //            encry = data[i + 2];
            //            seqid = (data[i + 3] << 8) + data[i + 4];
            msg_len = (data[i + 5] << 8) + data[i + 6];
            if (data[i + 6 + msg_len + 2] != FRAME_TAIL || data[i + 6 + msg_len + 3] != FRAME_TAIL)
            {
                continue;
            }
            //verify = data[i + 6 + msg_len +1];
            //            printf("uds_recv encry:%d seqid:%d msg_len:%d", encry, seqid, msg_len);

            //            if (CheckSum((unsigned char *)&data[i + 2], msg_len + 5) != verify)
            //            {
            //                qDebug() << "CheckSum error...";
            //                continue;
            //            }
            if (msg_len > 0)
            {
                if (uds_json_parse((const char *)&data[i + 6 +1], msg_len) == 0)
                {
                    i += 6 + msg_len + 3;
                }
            }
        }
    }
}

void QmlDevState::parsingData(QJsonObject& object)
{
    //    qDebug()<< "parsingData" << object << endl;

    QString key;
    enum LINK_VALUE_TYPE value_type;
    QVector<QPair<QString,int>>::iterator it;
    for(it=stateType.begin(); it!=stateType.end(); ++it){

        key=it->first;
        value_type=(enum LINK_VALUE_TYPE)it->second;
        //        qDebug()<<"readData key:"<<key<<"value type:"<<value_type;
        if(object.contains(key))
        {
            QJsonValue value =object.value(key);

            if(LINK_VALUE_TYPE_NUM==value_type)
            {
                //                qDebug()<<"key:"<<key<<"value:"<<value.toInt();
#ifdef SYSPOWER_RK3308
                if(key=="SysPower")
                    setState(key,1);
                else if(key=="ErrorCodeShow")
                    setState(key,0);
                else
                {
#endif    
                    if("LStOvDoorState"==key || "LStOvMode"==key ||"LStOvState"==key ||"LStOvSetTemp"==key ||"LStOvRealTemp"==key ||"LStOvSetTimer"==key ||"LStOvOrderTimer"==key ||"LStOvSetTimerLeft"==key ||"RStOvDoorState"==key ||"RStOvMode"==key ||"RStOvState"==key ||"RStOvSetTemp"==key ||"RStOvRealTemp"==key ||"RStOvOrderTimer"==key ||"RStOvSetTimer"==key ||"RStOvSetTimerLeft"==key ||"RStOvOrderTimerLeft"==key||"MultiMode"==key||"HoodSpeed"==key||"HoodLight"==key)
                    {
                        if(stateMap[key]==value.toInt())
                            continue;
                    }
                    setState(key,value.toInt());
#ifdef SYSPOWER_RK3308
                }
#endif
            }
            else if(LINK_VALUE_TYPE_STRING==value_type)
            {
                //                qDebug()<<"key:"<<key<<"value:"<<value.toString();
                if("QrCode"==key)
                {
                    QrcodeEn::encodeImage(value.toString(),6,key+".png");
                }
                else
                    setState(key,value.toString());

                //                else if("AfterSalesQrCode"==key)
                //                {
                //                    QrcodeEn::encodeImage(value.toString(),6,key+".png");
                //                }
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
                    setState("ssid",ssid.toString());
                    setState("bssid",bssid.toString());
                    //                    qDebug()<<"key:"<<"bssid"<<"value:"<<bssid.toString();
                }
                else if(key=="MultiStageState")
                {
                    QJsonObject object_struct =value.toObject();
                    QJsonValue cnt =object_struct.value("cnt");
                    QJsonValue current =object_struct.value("current");
                    QJsonValue remind =object_struct.value("remind");
                    QJsonValue RemindText =object_struct.value("RemindText");

                    setState("cnt",cnt.toInt());
                    setState("current",current.toInt());
                    setState("RemindText",RemindText.toString());
                    setState("remind",remind.toInt());
                }
                else if(key=="CookRecipe" || key=="CookHistory")
                {
                    QJsonArray array =value.toArray();
                    QVariantMap info;

                    if(key=="CookRecipe")
                    {
                        for(int i=0;i< (int)(sizeof(recipe)/sizeof(recipe[0]));++i)
                            recipe[i].clear();
                        //                        qDebug()<<"CookRecipe size:" <<array.size() << endl;
                    }
                    else
                    {
                        history.clear();
                        //                        qDebug()<<"CookHistory size:" <<array.size() << endl;
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
                        //                        qDebug()<<key <<":"<<info<< endl;
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
                        //                        qDebug()<<"DeleteHistory index:"<<index;
                        if(index<0)
                        {
                            break;
                        }
                        cur=history[index].toMap();
                        history.removeAt(index);
                        setHistory(key,cur);
                    }
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
                    if(object_struct.contains("dishName"))
                    {
                        QJsonValue dishName =object_struct.value("dishName");
                        cur["dishName"]=dishName.toString();
                    }
                    history[index]=cur;

                    //                    std::sort(history.begin(), history.end(), compareId);
                    setHistory(key,cur);
                }
            }
            else if(LINK_VALUE_TYPE_NULL==value_type)
            {
                setState(key,-1);
            }
            else if(LINK_VALUE_TYPE_ARRAY==value_type)
            {
                QJsonArray array=value.toArray();
                setState(key,array);
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

    //    qDebug()<<"setState name:"<<name << "value:" << value;
    //    if(stateMap.contains(name))
    //        qDebug()<< "old value:" << stateMap[name];

    stateMap[name]=value;
    emit stateChanged(name,value);
    //    }
}

QVariantMap QmlDevState::getState()
{
    //    qDebug()<<"QmlDevState::getState";
    return stateMap;
}

//QmlDevState *QmlDevState::qmlAttachedProperties(QObject *object)
//{
//    return new QmlDevState(object);
//}

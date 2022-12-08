#include "qmldevstate.h"
//#include<QtAlgorithms>
#include<algorithm>
//using namespace std;

QmlDevState::QmlDevState(QObject *parent) : QObject(parent)
{
    //    QProcess::execute("cd /oem && ./logoapp");
    readRecipeDetails();

    stateType.append(QPair<QString,int>("SysPower",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("PwrSWVersion",LINK_VALUE_TYPE_STRING));
    stateType.append(QPair<QString,int>("ComSWVersion",LINK_VALUE_TYPE_STRING));
    stateType.append(QPair<QString,int>("ErrorCode",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("ErrorCodeShow",LINK_VALUE_TYPE_NUM));

    stateType.append(QPair<QString,int>("WifiCurConnected",LINK_VALUE_TYPE_STRUCT));
    stateType.append(QPair<QString,int>("WifiState",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("WifiEnable",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("WifiScanR",LINK_VALUE_TYPE_STRING));

    stateType.append(QPair<QString,int>("OTAState",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("OTAProgress",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("OTANewVersion",LINK_VALUE_TYPE_STRING));
    stateType.append(QPair<QString,int>("OTAPowerState",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("OTAPowerProgress",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("OTAPowerNewVersion",LINK_VALUE_TYPE_STRING));
    stateType.append(QPair<QString,int>("OTASlientUpgrade",LINK_VALUE_TYPE_NUM));

    stateType.append(QPair<QString,int>("LMultiMode",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("LMultiStageState",LINK_VALUE_TYPE_STRUCT));
    stateType.append(QPair<QString,int>("LCookbookID",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("LCookbookName",LINK_VALUE_TYPE_STRING));
    stateType.append(QPair<QString,int>("RMultiMode",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("RMultiStageState",LINK_VALUE_TYPE_STRUCT));

    stateType.append(QPair<QString,int>("LStOvDoorState",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("LStOvMode",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("LStOvState",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("LStOvSetTemp",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("LStOvRealTemp",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("LStOvSetTimer",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("LStOvOrderTimer",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("LStOvSetTimerLeft",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("LStOvOrderTimerLeft",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("LStOvPauseTimerLeft",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("LSteamGear",LINK_VALUE_TYPE_NUM));

    stateType.append(QPair<QString,int>("RStOvDoorState",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("RStOvMode",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("RStOvState",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("RStOvSetTemp",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("RStOvRealTemp",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("RStOvOrderTimer",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("RStOvSetTimer",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("RStOvSetTimerLeft",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("RStOvOrderTimerLeft",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("RStOvPauseTimerLeft",LINK_VALUE_TYPE_NUM));

    stateType.append(QPair<QString,int>("LStoveStatus",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("RStoveStatus",LINK_VALUE_TYPE_NUM));

    stateType.append(QPair<QString,int>("LStoveTimingSet",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("LStoveTimingLeft",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("LStoveTimingState",LINK_VALUE_TYPE_NUM));
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
    stateType.append(QPair<QString,int>("PCBInput",LINK_VALUE_TYPE_ARRAY));

    stateType.append(QPair<QString,int>("SmartSmokeSwitch",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("RAuxiliarySwitch",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("RAuxiliaryTemp",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("CookingCurveSwitch",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("LOilTemp",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("ROilTemp",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("OilTempSwitch",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("RMovePotLowHeatSwitch",LINK_VALUE_TYPE_NUM));

    stateType.append(QPair<QString,int>("NtpTimestamp",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("CookAssistRemind",LINK_VALUE_TYPE_NUM));
    localConnected=0;
    connect(&client, SIGNAL(sendData(const QByteArray)), this,SLOT(readData(const QByteArray)));
    connect(&client, &LocalClient::sendConnected, this,&QmlDevState::setLocalConnected);

    setState("LCookbookName","");
    setState("HoodSpeed",0);
    setState("HoodLight",0);
    setState("RStoveStatus",0);
    setState("ProductCategory","集成灶");
    setState("ProductModel","IIZ(T/Y)—X8GCZ01");
    setState("SmartSmokeSwitch",0);
    setState("LStoveStatus",0);
    setState("RStoveStatus",0);
    setState("LOilTemp",0);
    setState("ROilTemp",0);
    setState("LStoveTimingState",0);
    setState("RStoveTimingState",0);
    setState("LStOvState",0);
    setState("RStOvState",0);
    setState("LStoveTimingState",0);
    setState("LStoveTimingLeft",0);
    setState("LStoveTimingSet",0);
    setState("RMovePotLowHeatSwitch",0);
    setState("ComSWVersion","1.0");
    setState("PwrSWVersion","1.0");
    setState("RMultiMode",0);
#ifndef USE_TCP
#ifndef USE_RK3308
    setState("SysPower",1);
    setState("OTASlientUpgrade",0);
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

    setState("HoodSpeed",2);
    setState("UpdateLog","1、新增：产品详情页视频展示功能；\n2、新增：网站前台版权标识样式切换功能\n3、优化：会员中心社会化登陆功能，用户可通过扫码关注设定的公众号登录；\n4、优化：安装商城模块后，可在网站后台内容管理中直接添加和编辑商品；\n5、优化：用户购买版权标识修改许可后，后台版权");
#endif
#endif
}


QVariantList QmlDevState::getRecipe(const int index)
{
    return recipe[index];
}

QString QmlDevState::getRecipeName(const int recipeId)
{
    int i,j;
    for(i=0;i<6;++i)
    {
        for(j=0;j<recipe[i].size();++j)
        {
            QVariantMap cur=recipe[i][j].toMap();
            if(cur["recipeid"]==recipeId)
                return cur["dishName"].toString();
        }
    }
    return "";
}

QVariantList QmlDevState::getTempRecipes(const int index)
{
    return tempRecipes[index];
}

void QmlDevState::startLocalConnect()
{
    client.startConnectTimer();
}

int QmlDevState::executeQProcess(const QString cmd,const QStringList list)
{
    qDebug() << "executeQProcess:" << cmd << "list:" << list;
    //    process.start(cmd,list);
    //    return 0;
    return QProcess::startDetached(cmd,list);
}

int QmlDevState::executeShell(const QString cmd)
{
    qDebug() << "executeShell:" << cmd;
    //    QProcess::execute(cmd);
    //    qDebug() << "executeShell system:" << cmd.toUtf8().data();
    return system(cmd.toUtf8().constData());
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
        qDebug() << "file open error";
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

    QJsonValue url=object.value("marsUrl");
    if(url==QJsonValue::Undefined)
        marsUrl="http://mcook.marssenger.com";
    else
        marsUrl=url.toString();

    QJsonArray recipes = object.value("recipes").toArray();
    qDebug()<<"recipes:"<<recipes.size();
    for(int i=0;i<recipes.size();++i)
    {
        QJsonObject obj=recipes.at(i).toObject();
        QJsonValue imgUrl =obj.value("imgUrl");
        QJsonValue ingredients =obj.value("ingredients");
        QJsonArray details =obj.value("details").toArray();
        QJsonValue recipeid =obj.value("recipeid");
        QJsonValue dishName =obj.value("dishName");
        QJsonValue cookSteps =obj.value("cookSteps");
        QJsonValue recipeType =obj.value("recipeType");
        QJsonValue cookPos =obj.value("cookPos");
        //        QVariantList detailslist;
        //        for(int j=0;j<details.size();++j)
        //        {
        //            detailslist.append(details.at(j).toString());
        //        }
        //        list.append(detailslist);
        //         qDebug()<<"detailslist:"<<detailslist;

        QVariantMap info;
        info.insert("imgUrl",imgUrl.toString());
        info.insert("ingredients",ingredients.toString());
        info.insert("details",details);
        info.insert("recipeid",recipeid.toInt());
        info.insert("dishName",dishName.toString());
        info.insert("cookSteps",cookSteps.toString());
        info.insert("cookPos",cookPos.toInt());

        recipe[recipeType.toInt()-1].append(info);
    }
    //        qDebug()<<"recipeMap:"<<recipeMap;
    recipes = object.value("tempRecipes").toArray();
    qDebug()<<"tempRecipes:"<<recipes.size();
    for(int i=0;i<recipes.size();++i)
    {
        QJsonObject obj=recipes.at(i).toObject();
        QJsonValue imgUrl =obj.value("imgUrl");
        QJsonValue ingredients =obj.value("ingredients");
        QJsonArray details =obj.value("details").toArray();
        QJsonValue dishName =obj.value("dishName");
        QJsonValue temp =obj.value("temp");
        QJsonValue recipeType =obj.value("recipeType");
        QJsonValue cookPos =obj.value("cookPos");

        QVariantMap info;
        info.insert("imgUrl",imgUrl.toString());
        info.insert("ingredients",ingredients.toString());
        info.insert("details",details);
        info.insert("dishName",dishName.toString());
        info.insert("temp",temp.toInt());
        info.insert("cookPos",cookPos.toInt());

        tempRecipes[recipeType.toInt()-1].append(info);
    }
}

int QmlDevState::sendToServer(QString data)
{
    return client.sendMessage(data);
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
    if (!doucment.isObject())
    {
        qDebug() << "JSON Parse Error:";
        return -1;
    }
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
    QJsonObject Data =object.value(DATA).toObject();
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

void QmlDevState::parsingData(const QJsonObject& object)
{
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
                    if("LStOvState"==key ||"LStOvDoorState"==key || "LStOvMode"==key ||"LStOvSetTemp"==key ||"LStOvRealTemp"==key ||"LStOvSetTimer"==key ||"LStOvOrderTimer"==key ||"LStOvSetTimerLeft"==key ||"LStOvOrderTimerLeft"==key ||"LSteamGear"==key ||"RStOvState"==key ||"RStOvDoorState"==key ||"RStOvMode"==key ||"RStOvSetTemp"==key ||"RStOvRealTemp"==key ||"RStOvOrderTimer"==key ||"RStOvSetTimer"==key ||"RStOvSetTimerLeft"==key ||"RStOvOrderTimerLeft"==key||"LMultiMode"==key||"HoodSpeed"==key||"HoodLight"==key)
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
                if("LCookbookName"==key)
                {
                    if(stateMap[key]==value.toString())
                        continue;
                }
                setState(key,value.toString());

                if("QrCode"==key)
                {
                    QrcodeEn::encodeImage(value.toString(),6,key+".png");
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
                    setState("Wifissid",ssid.toString());
                    setState("Wifibssid",bssid.toString());
                }
                else if(key=="LMultiStageState")
                {
                    QJsonObject object_struct =value.toObject();
                    QJsonValue cnt =object_struct.value("cnt");
                    QJsonValue current =object_struct.value("current");
                    QJsonValue remind =object_struct.value("remind");
                    QJsonValue RemindText =object_struct.value("RemindText");

                    setState("LMultiTotalStep",cnt.toInt());
                    setState("LMultiCurrentStep",current.toInt());
                    setState("LMultiRemindText",RemindText.toString());
                    setState("LMultiRemind",remind.toInt());
                }
                else if(key=="RMultiStageState")
                {
                    QJsonObject object_struct =value.toObject();
                    QJsonValue cnt =object_struct.value("cnt");
                    QJsonValue current =object_struct.value("current");
                    QJsonValue remind =object_struct.value("remind");
                    QJsonValue RemindText =object_struct.value("RemindText");

                    setState("RMultiTotalStep",cnt.toInt());
                    setState("RMultiCurrentStep",current.toInt());
                    setState("RMultiRemindText",RemindText.toString());
                    setState("RMultiRemind",remind.toInt());
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
    stateMap[name]=value;
    emit stateChanged(name,value);
}

QVariantMap QmlDevState::getState() const
{
    //    qDebug()<<"QmlDevState::getState";
    return stateMap;
}

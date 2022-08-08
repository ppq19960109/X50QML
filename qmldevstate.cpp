#include "qmldevstate.h"
//#include<QtAlgorithms>
#include<algorithm>
//using namespace std;

QmlDevState::QmlDevState(QObject *parent) : QObject(parent)
{
    //    QProcess::execute("cd /oem && ./logoapp");
    readRecipeDetails();

    stateType.append(QPair<QString,int>("Reset",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("DemoStart",LINK_VALUE_TYPE_NULL));
    stateType.append(QPair<QString,int>("ProductionTest",LINK_VALUE_TYPE_NULL));

    stateType.append(QPair<QString,int>("WifiCurConnected",LINK_VALUE_TYPE_STRUCT));
    stateType.append(QPair<QString,int>("WifiState",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("WifiEnable",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("WifiScanR",LINK_VALUE_TYPE_STRING));

    stateType.append(QPair<QString,int>("ElcSWVersion",LINK_VALUE_TYPE_STRING));
    stateType.append(QPair<QString,int>("ComSWVersion",LINK_VALUE_TYPE_STRING));
    stateType.append(QPair<QString,int>("SysPower",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("ErrorCode",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("ErrorCodeShow",LINK_VALUE_TYPE_NUM));

    stateType.append(QPair<QString,int>("CookRecipe",LINK_VALUE_TYPE_STRUCT));

    stateType.append(QPair<QString,int>("OTAState",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("OTAProgress",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("OTANewVersion",LINK_VALUE_TYPE_STRING));

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
    stateType.append(QPair<QString,int>("RStOvRealTemp",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("RStOvOrderTimer",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("RStOvSetTimer",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("RStOvSetTemp",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("RStOvSetTimerLeft",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("RStOvOrderTimerLeft",LINK_VALUE_TYPE_NUM));

    stateType.append(QPair<QString,int>("LStoveStatus",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("RStoveStatus",LINK_VALUE_TYPE_NUM));
    //    stateType.append(QPair<QString,int>("LStoveFireStatus",LINK_VALUE_TYPE_NUM));
    //    stateType.append(QPair<QString,int>("RStoveFireStatus",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("LStoveTimingSet",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("LStoveTimingLeft",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("LStoveTimingState",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("RStoveTimingSet",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("RStoveTimingLeft",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("RStoveTimingState",LINK_VALUE_TYPE_NUM));

    stateType.append(QPair<QString,int>("HoodStoveLink",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("HoodLightLink",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("HoodOffTimer",LINK_VALUE_TYPE_NUM));
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
    stateType.append(QPair<QString,int>("BindTokenState",LINK_VALUE_TYPE_NUM));
    stateType.append(QPair<QString,int>("QuadInfo",LINK_VALUE_TYPE_STRING));

    stateType.append(QPair<QString,int>("PCBInput",LINK_VALUE_TYPE_ARRAY));

    stateType.append(QPair<QString,int>("SmartSmoke",LINK_VALUE_TYPE_NUM));

    localConnected=0;
    connect(&client, SIGNAL(sendData(const QJsonValue)), this,SLOT(readData(const QJsonValue)));
    connect(&client, &LocalClient::sendConnected, this,&QmlDevState::setLocalConnected);

    setState("HoodSpeed",0);
    setState("HoodLight",0);
    setState("RStoveStatus",0);
    setState("ProductCategory","集成灶");
    setState("ProductModel","IIZ(T/Y)—X8GCZ01");
    setState("SmartSmoke",0);
    setState("LStOvState",0);
    setState("LStoveTimingState",0);
    setState("LStoveTimingLeft",0);
    setState("LStoveTimingSet",0);
#ifndef USE_TCP
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
    info.insert("recipeid", 117);
    info.insert("cookPos", 0);
    info.insert("dishName", "清蒸鱼");
    info.insert("cookSteps", "[{\"device\":0,\"mode\":35,\"number\":1,\"temp\":100,\"time\":90}]");
    info.insert("collect", 0);
    info.insert("timestamp", 0);
    info.insert("recipeType", 1);

    recipe[0].append(info);
    info["recipeid"]=426;
    info["dishName"]="桂花蜂蜜烤南瓜蜂蜜烤南";
    recipe[0].append(info);
    info["recipeid"]=118;
    info["dishName"]="腊肉蒸芋艿";
    recipe[0].append(info);
    info["recipeid"]=426;
    info["dishName"]="蒜香茄子";
    recipe[0].append(info);
    info["recipeid"]=1006;
    info["dishName"]="蒜香茄子";
    recipe[0].append(info);
    info["recipeid"]=427;
    info["dishName"]="蒜香茄子";
    recipe[0].append(info);

    info["recipeid"]=118;
    info["dishName"]="蒜蓉粉丝娃娃菜";
    recipe[1].append(info);

    info["recipeid"]=427;
    info["dishName"]="蒜蓉粉丝娃菜";
    recipe[1].append(info);
#endif
#endif
}


QVariantList QmlDevState::getRecipe(const int index)
{
    return recipe[index];
}

void QmlDevState::startLocalConnect()
{
    client.startConnectTimer();
}

int QmlDevState::coverHistory(const QJsonObject &object, QVariantMap &info)
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

QVariantList QmlDevState::getRecipeDetails(const int recipeid)
{
    return recipeMap[recipeid];
}

void QmlDevState::executeShell(const QString &cmd)
{
    qDebug() << "executeShell:" << cmd;
    //    QProcess::execute(cmd);
    //    QProcess::startDetached("cmd");
    //    process.start(cmd);
    //    qDebug() << "executeShell system:" << cmd.toUtf8().data();
    system(cmd.toUtf8().data());
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
        QJsonValue ingredients =obj.value("ingredients");
        QJsonArray details =obj.value("details").toArray();
        QJsonValue recipeid =obj.value("recipeid");
        QVariantList list;
        list.append(imgUrl.toString());
        list.append(ingredients.toString());
        list.append(details);
        //        QVariantList detailslist;
        //        for(int j=0;j<details.size();++j)
        //        {
        //            detailslist.append(details.at(j).toString());
        //        }
        //        list.append(detailslist);
        //         qDebug()<<"detailslist:"<<detailslist;
        recipeMap.insert(recipeid.toInt(),list);
    }
    //        qDebug()<<"recipeMap:"<<recipeMap;
}

int QmlDevState::sendToServer(const QString& data)
{
    QByteArray msg= data.toUtf8();
    return client.sendMessage(msg);
}

void QmlDevState::readData(const QJsonValue data)
{
    qDebug()<< "readData" << data  << endl;
    QJsonObject object =data.toObject();

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
#endif    
                    setState(key,value.toInt());
            }
            else if(LINK_VALUE_TYPE_STRING==value_type)
            {
                //                qDebug()<<"key:"<<key<<"value:"<<value.toString();
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
                    setState("ssid",ssid.toString());
                    setState("bssid",bssid.toString());
                    qDebug()<<"key:"<<"bssid"<<"value:"<<bssid.toString();
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
                else if(key=="CookRecipe")
                {
                    QJsonArray array =value.toArray();
                    QVariantMap info;

                    for(int i=0;i< (int)(sizeof(recipe)/sizeof(recipe[0]));++i)
                        recipe[i].clear();
                    qDebug()<<"CookRecipe size:" <<array.size() << endl;


                    for(int i=0;i<array.size();++i)
                    {
                        QJsonObject obj_array=array.at(i).toObject();
                        coverHistory(obj_array,info);

                        recipe[info["recipeType"].toInt()-1].append(info);
                        qDebug()<<key <<":"<<info<< endl;
                    }
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

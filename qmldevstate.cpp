#include "qmldevstate.h"


QmlDevState* QmlDevState::qmlDevState;
QmlDevState::QmlDevState(QObject *parent) : QObject(parent)
{
    qmlDevState=this;
    myName="DevState";

    qmlDevState->setState("HoodSpeed",3);
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

    QVariantMap info;
    info.insert("id", 0);
    info.insert("dishCook", 0);
    info.insert("dishCookTime", 120);
    info.insert("dishName", "清蒸鱼");
    info.insert("imgSource", "/images/peitu01.png");
    info.insert("cookSteps", "[{\"device\":0,\"mode\":5,\"temp\":100,\"time\":90}]");
    info.insert("details", "食材：\n鸡蛋2个，蛤蜊50g，盐2g，油3滴葱花30g\n步骤：\n1、鱼片加入适量鸡蛋，料酒、升降、盐，醋、糖，搅拌均匀后加一点淀粉（淀粉加水）增加粘度\n2、鱼片加入适量鸡蛋，料酒、升降、盐，醋、糖，搅拌均匀后加一点淀粉（淀粉加水）增加粘度\n3、鱼片加入适量鸡蛋，料酒、升降、盐，醋、糖，搅拌均匀后加一点淀粉（淀粉加水）增加粘度");
    info.insert("collection", false);
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
    info["dishName"]="烤面包0";
    recipe[1].append(info);

    history.append(info);
    info["id"]=1;
    info["dishName"]="烤面包1";
    history.append(info);
    info["id"]=2;
    info["dishName"]="烤面包2";
    history.append(info);
    info["id"]=3;
    info["dishName"]="烤面包3";
    history.append(info);
    info["id"]=4;
    info["dishName"]="烤面包4";
    history.append(info);
    info["id"]=5;
    info["dishName"]="烤面包5";
    history.append(info);
}


int QmlDevState::sendUartData()
{
    qDebug() << "sendUartData:" ;
}

QVariantList QmlDevState::getRecipe(const int index)
{
    return recipe[index];
}

bool compareId(const QVariant &s1, const QVariant &s2)
{
    QVariantMap m1=qvariant_cast<QVariantMap>(s1);
    QVariantMap m2=s2.value<QVariantMap>();
    return m1["id"] < m2["id"];
}

bool compareTime(const QVariant &s1, const QVariant &s2)
{
    QVariantMap m1=qvariant_cast<QVariantMap>(s1);
    QVariantMap m2=s2.value<QVariantMap>();
    return m1["time"] > m2["time"];
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
            single["time"]= QDateTime::currentDateTime().toSecsSinceEpoch();
            *iter=single;
            qDebug() << *iter;
            break;
        }
    }

    if(iter == history.end())
    {
        return -1;
    }
    sort(history.begin(), history.end(), compareTime);
    return 0;
}

int QmlDevState::addSingleHistory(QVariantMap single)
{
    int i;
    qDebug() << "addSingleHistory" << single;
    single["time"]= QDateTime::currentDateTime().toSecsSinceEpoch();
    if(getHistoryCount()>=MAX_HISTORY)
    {
        int lastIndex=lastHistory(false);
        history[lastIndex]=single;
    }
    else
    {
        sort(history.begin(), history.end(), compareId);
        for ( i = 0; i < history.size(); ++i)
        {
            QVariantMap cur=history[i].toMap();
            if(cur["id"]!=i)
            {
                single["id"]=i;
                break;
            }
        }
        if(i == history.size())
        {
            single["id"]=i;
        }
        history.append(single);
    }
    sort(history.begin(), history.end(), compareTime);
    return 0;
}

int QmlDevState::lastHistory(bool collect)
{
    for (int i = history.size() -1;i > 0; --i)
    {
        QVariantMap cur=history[i].toMap();
        if(cur["collection"]==collect)
        {
            return i;
        }
    }
}

int QmlDevState::getHistoryCount()
{
    int count=0;
    QVariantList::iterator iter;
    for (iter = history.begin(); iter != history.end(); ++iter)
    {
        QVariantMap cur=(*iter).toMap();
        if(cur["collection"] == true)
        {
            ++count;
        }
    }
    return history.size()-count;
}

void QmlDevState::clearHistory()
{
    history.clear();
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
    cur["collection"]=collect;
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
    sort(history.begin(), history.end(), compareTime);
    return 0;
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

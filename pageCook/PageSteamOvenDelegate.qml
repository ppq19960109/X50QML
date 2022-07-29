import QtQuick 2.7
import QtQuick.Controls 2.2
import "../"
import "qrc:/CookFunc.js" as CookFunc
Item {

    property alias modeModel:modePathView.model
    //    property alias tempModel:tempPathView.model
    //    property alias timeModel:timePathView.model
    property alias modeItemCount:modePathView.pathItemCount
    property alias tempItemCount:tempPathView.pathItemCount
    property alias timeItemCount:timePathView.pathItemCount
    property alias modeWidth:modePathView.width
    property alias tempWidth:tempPathView.width
    property alias timeWidth:timePathView.width
    property alias steamGearVisible:steamGearPathView.visible
    property int modeIndex:-1
    property int tempIndex:-1
    property int timeIndex:-1
    property int steamGearIndex:-1

    readonly property var workModeImg: ["", "icon_1", "icon_1","icon_4", "icon_35", "icon_36", "icon_38", "icon_40", "icon_42", "icon_68", "icon_1", "icon_68"]

    function getCurrentSteamOven()
    {
        var steps={}
        steps.mode=workModeNumberEnum[modePathView.model[modePathView.currentIndex].modelData]
        steps.temp=tempPathView.model[tempPathView.currentIndex]
        steps.time=timePathView.model[timePathView.currentIndex]
        if(steamGearPathView.interactive)
            steps.gear=steamGearPathView.currentIndex

        return steps
    }
    function modeChange(index,tempIndex,timeIndex,steamGearIndex)
    {
        if(index===0)
        {
            steamGearPathView.model=["1档","2档","3档"]
            steamGearPathView.interactive=true
            if(steamGearIndex!=null)
            {
                steamGearPathView.currentIndex=steamGearIndex
            }
        }
        else
        {
            steamGearPathView.model=["—"]
            steamGearPathView.interactive=false
        }
        var modeItem=modePathView.model[index]

        var minTemp=modeItem.minTemp
        var maxTemp=modeItem.maxTemp
        var tempArray=[]
        for(var i=minTemp; i<= maxTemp; ++i) {
            tempArray.push(i)
        }
        tempPathView.model=tempArray
        if(tempIndex!=null)
        {
            tempPathView.currentIndex=tempIndex-modeItem.minTemp
        }
        else
        {
            tempPathView.currentIndex=modeItem.temp-modeItem.minTemp
        }

        var maxTime=modeItem.maxTime
        if(maxTime==null)
        {
            maxTime=300
        }
        var timeArray = []
        for(i=1; i<= 120; ++i) {
            timeArray.push(i)
        }
        for(i=125; i<= maxTime; i+=5) {
            timeArray.push(i)
        }
        timePathView.model=timeArray
        if(timeIndex!=null)
        {
            timePathView.currentIndex=CookFunc.getCookTimeIndex(timeIndex)
        }
        else
        {
            timePathView.currentIndex=CookFunc.getCookTimeIndex(modeItem.time)
        }
    }
    Component.onCompleted:{

        if(modeIndex>=0)
        {
            modePathView.currentIndex=modeIndex
            modeChange(modeIndex,tempIndex,timeIndex,steamGearIndex)
        }
        else
        {
            modeChange(modePathView.currentIndex)
        }
    }
    PageDivider{
        anchors.top:parent.top
        anchors.topMargin:parent.height/2-30
    }
    PageDivider{
        anchors.top:parent.top
        anchors.topMargin:parent.height/2+30
    }
    Row {
        width: parent.width
        height:parent.height
        spacing: 20

        PageCookPathView {
            id:modePathView
            width: 291
            height:parent.height
            delegateType:1
            currentIndex:0
            pathItemCount:3
            Image {
                anchors.fill: parent
                visible: parent.moving
                asynchronous:true
                smooth:false
                source: themesPicturesPath+"steamoven/"+"mode_roll_background.png"
            }
            onIndexChanged: {
                console.log("model onValueChanged:",index,model[index].modelData)
                modeChange(index)
            }
        }
        PageCookPathView {
            id:tempPathView
            width: 180
            height:parent.height
            Image {
                anchors.fill: parent
                visible: parent.moving
                asynchronous:true
                smooth:false
                anchors.centerIn: parent
                source: themesPicturesPath+"steamoven/"+"roll_background.png"
            }
            Text{
                text:qsTr("℃")
                color:themesTextColor
                font.pixelSize: 24
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: 60
            }
        }
        PageCookPathView {
            id:timePathView
            width: 180
            height:parent.height
            Image {
                anchors.fill: parent
                visible: parent.moving
                asynchronous:true
                smooth:false
                anchors.centerIn: parent
                source: themesPicturesPath+"steamoven/"+"roll_background.png"
            }
            Text{
                text:qsTr("分钟")
                color:themesTextColor
                font.pixelSize: 24
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: 65
            }
        }
        PageCookPathView {
            id:steamGearPathView
            width: 180
            height:parent.height
            pathItemCount:3
            model:["1档","2档","3档"]
            Image {
                anchors.fill: parent
                visible: parent.moving
                asynchronous:true
                smooth:false
                anchors.centerIn: parent
                source: themesPicturesPath+"steamoven/"+"roll_background.png"
            }
            Text{
                visible: modePathView.currentIndex==0
                text:qsTr("蒸汽")
                color:themesTextColor
                font.pixelSize: 24
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: 60
            }
        }
    }
}

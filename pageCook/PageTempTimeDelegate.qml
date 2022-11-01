import QtQuick 2.12
import QtQuick.Controls 2.5
import "../"
import "qrc:/CookFunc.js" as CookFunc
Item {
    property alias tempItemCount:tempPathView.pathItemCount
    property alias timeItemCount:timePathView.pathItemCount
    property alias tempWidth:tempPathView.width
    property alias timeWidth:timePathView.width
    property int mode:-1
    property string modeName
    property int tempIndex:-1
    property int timeIndex:-1

    function getCurrentState()
    {
        var steps={}
        steps.temp=tempPathView.model[tempPathView.currentIndex]
        steps.time=timePathView.model[timePathView.currentIndex]
        return steps
    }
    function modeChange(mode,tempIndex,timeIndex)
    {
//        console.log("modeChange:",mode,tempIndex,timeIndex,steamGearIndex)
        var modeItem=CookFunc.getWorkModeModel(mode)

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
          modeChange(mode,tempIndex,timeIndex)
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
        spacing: 50
        Text{
            width: 180
            text:modeName==null?CookFunc.workModeName(mode):modeName
            color:"#fff"
            font.pixelSize: 30
            anchors.verticalCenter: parent.verticalCenter
            horizontalAlignment:Text.AlignHCenter
            verticalAlignment:Text.AlignVCenter
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
            Text{
                text:qsTr("温度")
                color:themesTextColor2
                font.pixelSize: 30
                anchors.horizontalCenter:parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: -40
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
            Text{
                text:qsTr("时间")
                color:themesTextColor2
                font.pixelSize: 30
                anchors.horizontalCenter:parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: -40
            }
        }
    }
}

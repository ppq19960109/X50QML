import QtQuick 2.12
import QtQuick.Controls 2.5

import "qrc:/pageCook"
import "../"
import "qrc:/SendFunc.js" as SendFunc
Item {
    property var lTimingLeft: QmlDevState.state.LStoveTimingLeft
    property var rTimingLeft: QmlDevState.state.RStoveTimingLeft
    property bool userCancel:false
    Connections { // 将目标对象信号与槽函数进行连接
        target: QmlDevState
        onStateChanged: { // 处理目标对象信号的槽函数
            console.log("PageCloseHeat:",key)
            //            if("LStoveTimingState"==key)
            //            {
            //                if(value===timingStateEnum.STOP && rTimingState===timingStateEnum.STOP)
            //                {
            //                    backPrePage()
            //                }
            //            }
            //            else
            if("RStoveTimingState"==key)
            {
                if(userCancel==true && value===timingStateEnum.STOP && lTimingState===timingStateEnum.STOP)
                {
                    backPrePage()
                }
                userCancel=false
            }
        }
    }

    function stopTurnOffFire(dir)
    {
        var Data={}
        if(dir===cookWorkPosEnum.LEFT)
        {
            Data.LStoveTimingOpera = timingOperationEnum.CANCEL
        }
        else
        {
            Data.RStoveTimingOpera = timingOperationEnum.CANCEL
        }
        Data.DataReportReason=0
        SendFunc.setToServer(Data)
        userCancel=true
    }
    Component{
        id:component_closeHeatReset
        PageDialogConfirm{
            hintCenterText:""
            cancelText:""
            confirmText:""
            onCancel:{
                loaderMainHide()
            }
            onConfirm:{
                if(cancelText!="")
                {
                    stopTurnOffFire(cookWorkPos)
                }
                loaderMainHide()
            }
        }
    }
    function loaderCloseHeatReset(hintCenterText,cancelText,confirmText,cookWorkPos){
        loaderManual.sourceComponent = component_closeHeatReset
        loaderManual.item.hintCenterText=hintCenterText
        loaderManual.item.cancelText=cancelText
        loaderManual.item.confirmText=confirmText
        loaderManual.item.cookWorkPos=cookWorkPos
    }
    PageBackBar{
        id:topBar
        anchors.top:parent.top
        name:"定时关火"
        centerText:oilTempSwitch?("左灶油温:"+(lOilTemp>=0?lOilTemp:"-")+"℃"+"    右灶油温:"+(rOilTemp>=0?rOilTemp:"-")+"℃"):""
    }

    Repeater {
        model: ["左灶","右灶"]
        PageButtonBar{
            visible: {
                if(index==0)
                {
                    return lTimingState===timingStateEnum.RUN||lTimingState===timingStateEnum.PAUSE
                }
                else
                {
                    return rTimingState===timingStateEnum.RUN||lTimingState===timingStateEnum.PAUSE
                }
            }
            anchors.verticalCenter: row.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: index==0?-440:440
            orientation:true
            space:54
            models: ["重置","取消"]
            onClick: {
                if(clickIndex==0)
                {
                    let timingTime
                    if(index==0)
                    {
                        timingTime=lTimingLeft
                    }
                    else
                    {
                        timingTime=rTimingLeft
                    }
                    loaderCloseHeat(index,startTurnOffFire,timingTime)
                }
                else
                    loaderCloseHeatReset("是否取消"+modelData+"定时关火？","否","是",index)
            }
        }
    }

    Row {
        id:row
        width: 309*2+124
        height: 309
        anchors.top: topBar.bottom
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 124

        Repeater {
            model: ["左灶","右灶"]
            Button{
                property int timingState: {
                    if(index==0)
                    {
                        return lTimingState
                    }
                    else
                    {
                        return rTimingState
                    }
                }
                width: 309
                height: width

                background:Image {
                    asynchronous:true
                    smooth:false
                    source: themesPicturesPath+"icon_close_heat_background.png"
                }
                Item
                {
                    id:timing
                    visible: timingState===timingStateEnum.STOP||timingState===timingStateEnum.CONFIRM
                    anchors.fill: parent
                    Text{
                        text:modelData
                        color:timingState===timingStateEnum.STOP?"#fff":themesTextColor
                        font.pixelSize: 40
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: 105
                    }
                    Text{
                        text:timingState===timingStateEnum.STOP?"定时关火":"关火完成"
                        color:timingState===timingStateEnum.STOP?"#fff":themesTextColor
                        font.pixelSize: 30
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: 157
                    }
                }
                Item
                {
                    visible:!timing.visible
                    anchors.fill: parent
                    Text{
                        text:modelData+"将在"
                        color:"#fff"
                        font.pixelSize: 30
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: 90
                    }
                    Text{
                        text:{
                            let timingTime
                            if(index==0)
                            {
                                timingTime=lTimingLeft
                            }
                            else
                            {
                                timingTime=rTimingLeft
                            }
                            return  generateTwoTime(Math.floor(timingTime/60))+":"+generateTwoTime(timingTime%60)
                        }

                        color:themesTextColor
                        font.pixelSize: 50
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: 135
                    }
                    Text{
                        text:"后关火"
                        color:"#fff"
                        font.pixelSize: 30
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: 188
                    }
                }
                PageCirBar{
                    width: 240
                    height: width
                    anchors.centerIn: parent
                    runing:true
                    canvasDiameter:width
                    percent:{
                        let timingTimeSet
                        let timingTimeLeft
                        if(index==0)
                        {
                            timingTimeLeft=lTimingLeft
                            timingTimeSet=QmlDevState.state.LStoveTimingSet
                        }
                        else
                        {
                            timingTimeLeft=rTimingLeft
                            timingTimeSet=QmlDevState.state.RStoveTimingSet
                        }
                        return  100-Math.floor(100*timingTimeLeft/timingTimeSet)
                    }
                }
                onClicked: {
                    if(index==0)
                    {
                        if(QmlDevState.state.LStoveStatus===0)
                        {
                            loaderCloseHeatReset("左灶未开启\n开启后才可设置定时关火","","好的",index)
                        }
                        else
                        {
                            if(lTimingState===timingStateEnum.STOP)
                                loaderCloseHeat(index,startTurnOffFire)
                        }
                    }
                    else
                    {
                        if(QmlDevState.state.RStoveStatus===0)
                        {
                            loaderCloseHeatReset("右灶未开启\n开启后才可设置定时关火","","好的",index)
                        }
                        else
                        {
                            if(rTimingState===timingStateEnum.STOP)
                                loaderCloseHeat(index,startTurnOffFire)
                        }
                    }
                }
            }
        }
    }

}

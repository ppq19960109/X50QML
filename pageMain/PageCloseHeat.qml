import QtQuick 2.12
import QtQuick.Controls 2.5

import "qrc:/pageCook"
import "../"
import "qrc:/SendFunc.js" as SendFunc
Item {
    property var lTimingLeft: QmlDevState.state.LStoveTimingLeft
    property var rTimingLeft: QmlDevState.state.RStoveTimingLeft

    Component{
        id:component_closeHeat
        Item {
            property int cookWorkPos:0
            property var clickFunc:null
            Component.onCompleted: {
                let i
                let hourArray = []
                for(i=0; i<= 2; ++i) {
                    hourArray.push(i)
                }
                hourPathView.model=hourArray
                let minuteArray = []
                for(i=0; i< 60; ++i) {
                    minuteArray.push(i)
                }
                minutePathView.model=minuteArray
            }
            Component.onDestruction: {
                clickFunc=null
            }

            //内容
            Rectangle{
                width:730
                height: 350
                anchors.centerIn: parent
                anchors.margins: 20
                color: "#333333"
                radius: 10

                PageCloseButton {
                    anchors.top:parent.top
                    anchors.right:parent.right
                    onClicked: {
                        loaderMainHide()
                    }
                }

                PageDivider{
                    width: parent.width-40
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter:row.verticalCenter
                    anchors.verticalCenterOffset:-30
                }
                PageDivider{
                    width: parent.width-40
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter:row.verticalCenter
                    anchors.verticalCenterOffset:30
                }

                Row {
                    id:row
                    width: parent.width
                    height:222
                    anchors.top: parent.top
                    anchors.topMargin: 50
                    anchors.left:parent.left
                    anchors.leftMargin: 30
                    spacing: 10

                    Text{
                        width:130
                        color:"#fff"
                        font.pixelSize: 30
                        anchors.verticalCenter: parent.verticalCenter
                        horizontalAlignment:Text.AlignHCenter
                        verticalAlignment:Text.AlignVCenter
                        text:qsTr(cookWorkPos==0?"左灶将在":"右灶将在")
                    }
                    PageCookPathView {
                        id:hourPathView
                        width: 200
                        height:parent.height
                        pathItemCount:3
                        currentIndex:0
                        Image {
                            anchors.fill: parent
                            visible: parent.moving
                            asynchronous:true
                            smooth:false
                            anchors.centerIn: parent
                            source: themesPicturesPath+"steamoven/"+"roll_background.png"
                        }
                        Text{
                            text:qsTr("小时")
                            color:themesTextColor
                            font.pixelSize: 24
                            anchors.centerIn: parent
                            anchors.horizontalCenterOffset: 60
                        }
                    }
                    PageCookPathView {
                        id:minutePathView
                        width: 200
                        height:parent.height
                        pathItemCount:3
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
                            anchors.horizontalCenterOffset: 60
                        }
                    }
                    Text{
                        width:100
                        color:"#fff"
                        font.pixelSize: 30
                        anchors.verticalCenter: parent.verticalCenter
                        horizontalAlignment:Text.AlignHCenter
                        verticalAlignment:Text.AlignVCenter
                        text:qsTr("后关火")
                    }
                }

                PageButtonBar{
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 20

                    space:80
                    models: ["取消","开始"]
                    onClick: {
                        if(clickIndex==0)
                        {
                            loaderMainHide()
                        }
                        else
                        {
                            if(clickFunc==null)
                                return
                            if(clickFunc(cookWorkPos,hourPathView.currentIndex*60+minutePathView.currentIndex)===0)
                            {
                                loaderMainHide()
                            }
                        }
                    }
                }
            }
        }
    }

    function loaderCloseHeat(cookWorkPos,clickFunc)
    {
        loaderManual.sourceComponent = component_closeHeat
        loaderManual.item.cookWorkPos=cookWorkPos
        loaderManual.item.clickFunc=clickFunc
    }

    function startTurnOffFire(dir,time)
    {
        if(time === 0)
            return
        let Data={}
        if(dir===cookWorkPosEnum.LEFT)
        {
            Data.LStoveTimingOpera = timingOperationEnum.START
            Data.LStoveTimingSet = time
        }
        else
        {
            Data.RStoveTimingOpera = timingOperationEnum.START
            Data.RStoveTimingSet = time
        }
        Data.DataReportReason=0
        SendFunc.setToServer(Data)
        return 0
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
    }

    Repeater {
        model: ["左灶","右灶"]
        PageButtonBar{
            visible: {
                if(index==0)
                {
                    return lTimingState!==timingStateEnum.STOP
                }
                else
                {
                    return rTimingState!==timingStateEnum.STOP
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
                    loaderCloseHeat(index,startTurnOffFire)
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
                width: 309
                height: width

                background:Image {
                    asynchronous:true
                    smooth:false
                    source: themesPicturesPath+"icon_close_heat_background.png"
                }
                Item
                {
                    id:timingState
                    visible: {
                        if(index==0)
                        {
                            return lTimingState===timingStateEnum.STOP
                        }
                        else
                        {
                            return rTimingState===timingStateEnum.STOP
                        }
                    }
                    anchors.fill: parent
                    Text{
                        text:modelData
                        color:"#fff"
                        font.pixelSize: 40
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: 105
                    }
                    Text{
                        text:"定时关火"
                        color:"#fff"
                        font.pixelSize: 30
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: 157
                    }
                }
                Item
                {
                    visible:!timingState.visible
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

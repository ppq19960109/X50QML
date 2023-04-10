import QtQuick 2.12
import QtQuick.Controls 2.5
import "../"
import "qrc:/SendFunc.js" as SendFunc
Item {
    property string name: "PageAICook"

    function close_heat_run_cancel(index,pos)
    {
        if(pos>0)
            stopCloseHeat((index))
    }

    function closeHoodSpeed()
    {
        SendFunc.setHoodSpeed(0)
    }

    PageTabBar{
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        currentIndex:0
    }

    Flickable{
        width: 474
        height:51
        contentWidth: width
        contentHeight: height
        flickableDirection:Flickable.VerticalFlick
        clip: true
        anchors.horizontalCenter: parent.horizontalCenter

        Button{
            width: parent.width
            height:parent.height

            background:Image {
                asynchronous:true
                smooth:false
                anchors.centerIn: parent
                source: themesPicturesPath+"ai/cook_assist_close.png"
            }
            onClicked: {
                push_page(pageSmartCook)
            }
        }

        onVerticalOvershootChanged: {
            //            console.log("onVerticalOvershootChanged:",contentY,originY,verticalOvershoot)
            if(verticalOvershoot<-13)
                push_page(pageSmartCook)
        }
        //        onMovementEnded:{//onMovementStarted onMovementEnded
        //            console.log("onMovementEnded:",contentY,originY,verticalOvershoot,atYBeginning,atYEnd)
        //            push_page(pageSmartCook)
        //        }
    }

    Image {
        asynchronous:true
        smooth:false
        anchors.centerIn: parent
        source:themesPicturesPath+"ai/center_background.png"
        Text{
            visible: hoodSpeed===4 && (testMode==true||smartSmokeSwitch===0) && QmlDevState.state.StirFryTimerLeft>0
            text:QmlDevState.state.StirFryTimerLeft+"分钟"
            color:themesTextColor
            font.pixelSize: 26
            anchors.right: grid.right
            anchors.rightMargin: 5
            anchors.bottom: grid.top
            anchors.bottomMargin: -15
        }
        Grid{
            id:grid
            width: 80*3+70*2
            height: 100*2+30
            rows: 2
            rowSpacing: 30
            columns: 3
            columnSpacing: 70
            anchors.centerIn: parent
            Repeater {
                model: [{"background":"ai.png","text":"智能排烟"}, {"background":"light.png","text":"照明"},{"background":"stir_fry.png","text":"爆炒"}, {"background":"high_speed.png","text":"高速"}, {"background":"medium_speed.png","text":"中速"}, {"background":"low_speed.png","text":"低速"}]
                Button {
                    width: 80
                    height:100
                    background: null
                    property bool curState:{
                        switch (index){
                        case 0:
                            return smartSmokeSwitch
                        case 1:
                            return QmlDevState.state.HoodLight
                        case 2:
                        case 3:
                        case 4:
                        case 5:
                            return hoodSpeed===(6-index) && (testMode==true||smartSmokeSwitch===0)
                        }
                        return false
                    }
                    Item{
                        width: parent.width
                        height:width

                        Image {
                            asynchronous:true
                            smooth:false
                            anchors.centerIn: parent
                            source: themesPicturesPath+"/ai/"+(parent.parent.curState?"check_":"")+modelData.background
                        }
                    }
                    Text{
                        text:modelData.text
                        color:curState?themesTextColor:"#fff"
                        font.pixelSize: 24
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                    }
                    onClicked: {
                        switch (index){
                        case 0:
                            SendFunc.setSmartSmoke(!smartSmokeSwitch)
                            break
                        case 1:
                            SendFunc.setHoodLight(!QmlDevState.state.HoodLight)
                            break
                        case 2:
                        case 3:
                        case 4:
                        case 5:
                            if(hoodSpeed===6-index)
                            {
                                if(testMode==false && smartSmokeSwitch>0)
                                    SendFunc.setSmartSmoke(0)
                                else
                                {
                                    if((lStOvState===workStateEnum.WORKSTATE_STOP||lStOvState===workStateEnum.WORKSTATE_RESERVE||lStOvState===workStateEnum.WORKSTATE_FINISH||lStOvState===workStateEnum.WORKSTATE_PAUSE_RESERVE) && (rStOvState===workStateEnum.WORKSTATE_STOP||rStOvState===workStateEnum.WORKSTATE_RESERVE||rStOvState===workStateEnum.WORKSTATE_FINISH||rStOvState===workStateEnum.WORKSTATE_PAUSE_RESERVE) && (lStoveStatus > 0 || rStoveStatus >0))
                                    {
                                        loaderManualConfirmShow("灶具工作中，\n建议开启烟机，便于散热","icon_warn.png","立即关闭",closeHoodSpeed)
                                    }
                                    else
                                        SendFunc.setHoodSpeed(0)
                                }
                            }
                            else
                                SendFunc.setHoodSpeed(6-index)
                            break
                        }
                        SendFunc.setBuzControl(buzControlEnum.SHORT)
                    }
                }
            }
        }
    }
    Image {
        asynchronous:true
        smooth:false
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 20
        source:themesPicturesPath+"ai/stove_bg.png"
        Text{
            text:{
                if(lStoveStatus>0 && oilTempSwitch)
                {
                    if(lOilTemp>=220 && lFlashAnimation.flash)
                        return "油温过高"
                    else
                        return (lOilTemp<0?"-":lOilTemp)+"℃"
                }
                else
                    return "左灶"
            }
            color:{
                if(lStoveStatus>0)
                {
                    if(lOilTemp>=220)
                        return "#B44F23"
                    else if(lOilTemp>=170)
                        return "#B19A56"
                    else
                        return "#5AA5BE"
                }
                return "#fff"
            }
            font.pixelSize: {
                if(lStoveStatus>0 && oilTempSwitch)
                    if(lOilTemp>=220 && lFlashAnimation.flash)
                        28
                    else
                        32
                else
                    34
            }
            anchors.top: parent.top
            anchors.topMargin: 25
            anchors.horizontalCenter: parent.horizontalCenter
        }
        PageFlashAnimation {
            id:lFlashAnimation
            running: lStoveStatus>0 && oilTempSwitch && lOilTemp>=220
        }
        PageRotationImg {
            asynchronous:true
            smooth:true
            visible: lStoveStatus>0 && oilTempSwitch
            anchors.centerIn: left_stove
            source: {
                if(lOilTemp>=220)
                    return themesPicturesPath+"ai/high_temp.png"
                else if(lOilTemp>=170)
                    return themesPicturesPath+"ai/medium_temp.png"
                else
                    return themesPicturesPath+"ai/low_temp.png"
            }
            duration:9000
        }
        Image {
            id:left_stove
            asynchronous:true
            smooth:false
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 100
            source: themesPicturesPath+"ai/stove_open.png"
        }

        Button{
            width: 120
            height:35
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 215
            background: Rectangle{
                color: "#535353"
                radius: height/2
            }
            Text{
                text:{
                    if(lTimingState===timingStateEnum.RUN)
                    {
                        var timingTime=QmlDevState.state.LStoveTimingLeft
                        return generateTwoTime(Math.floor(timingTime/60))+":"+generateTwoTime(timingTime%60)
                    }
                    return "定时关火"
                }
                color:lTimingState===timingStateEnum.RUN?themesTextColor:"#fff"
                font.pixelSize: 20
                //font.bold: true
                anchors.centerIn: parent
            }
            onClicked: {
                if(lTimingState===timingStateEnum.RUN)
                {
                    loaderCloseHeat(cookWorkPosEnum.LEFT,startTurnOffFire,QmlDevState.state.LStoveTimingLeft,close_heat_run_cancel,["取消定时","开始"])
                }
                else
                {
                    if(lStoveStatus===0)
                    {
                        loaderWarnConfirmShow("左灶未开启\n开启后才可设置定时关火")
                    }
                    else
                        loaderCloseHeat(cookWorkPosEnum.LEFT,startTurnOffFire,null,null)
                }
            }
        }
    }
    Image {
        asynchronous:true
        smooth:false
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 20
        source:themesPicturesPath+"ai/stove_bg.png"
        Text{
            text:{
                if(rStoveStatus>0 && oilTempSwitch)
                {
                    if(rOilTemp>=220 && rFlashAnimation.flash)
                        return "油温过高"
                    else
                        return (rOilTemp<0?"-":rOilTemp)+"℃"
                }
                else
                    return "右灶"
            }
            color:{
                if(rStoveStatus>0)
                {
                    if(rOilTemp>=220)
                        return "#B44F23"
                    else if(rOilTemp>=170)
                        return "#B19A56"
                    else
                        return "#5AA5BE"
                }
                return "#fff"
            }
            font.pixelSize: {
                if(rStoveStatus>0 && oilTempSwitch)
                    if(rOilTemp>=220 && lFlashAnimation.flash)
                        28
                    else
                        32
                else
                    34
            }
            anchors.top: parent.top
            anchors.topMargin: 25
            anchors.horizontalCenter: parent.horizontalCenter
        }
        PageFlashAnimation {
            id:rFlashAnimation
            running: rStoveStatus>0 && oilTempSwitch && rOilTemp>=220
        }
        PageRotationImg {
            asynchronous:true
            smooth:true
            visible: rStoveStatus>0 && oilTempSwitch
            anchors.centerIn: right_stove
            source: {
                if(rOilTemp>=220)
                    return themesPicturesPath+"ai/high_temp.png"
                else if(rOilTemp>=170)
                    return themesPicturesPath+"ai/medium_temp.png"
                else
                    return themesPicturesPath+"ai/low_temp.png"
            }
            duration:9000
        }
        Image {
            id:right_stove
            asynchronous:true
            smooth:false
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 100
            source: themesPicturesPath+"ai/stove_open.png"
        }

        Button{
            width: 120
            height:35
            anchors.right: parent.right
            anchors.rightMargin: 15
            anchors.top: parent.top
            anchors.topMargin: 215
            background: Rectangle{
                color: "#535353"
                radius: height/2
            }
            Text{
                text:{
                    if(rTimingState===timingStateEnum.RUN)
                    {
                        var timingTime=QmlDevState.state.RStoveTimingLeft
                        return generateTwoTime(Math.floor(timingTime/60))+":"+generateTwoTime(timingTime%60)
                    }
                    return "定时关火"
                }
                color:rTimingState===timingStateEnum.RUN?themesTextColor:"#fff"
                font.pixelSize: 20
                //font.bold: true
                anchors.centerIn: parent
            }
            onClicked: {
                if(rTimingState===timingStateEnum.RUN)
                {
                    loaderCloseHeat(cookWorkPosEnum.RIGHT,startTurnOffFire,QmlDevState.state.RStoveTimingLeft,close_heat_run_cancel,["取消定时","开始"])
                }
                else
                {
                    if(rStoveStatus===0)
                    {
                        loaderWarnConfirmShow("右灶未开启\n开启后才可设置定时关火")
                    }
                    else
                        loaderCloseHeat(cookWorkPosEnum.RIGHT,startTurnOffFire,null,null)
                }
            }
        }
        Button{
            width: 140
            height:35
            anchors.left: parent.left
            anchors.leftMargin: 15
            anchors.top: parent.top
            anchors.topMargin: 215
            background: Rectangle{
                color: "#535353"
                radius: height/2
            }
            Text{
                text:{
                    if(auxiliarySwitch > 0)
                    {
                        var str
                        switch(rAuxiliaryTemp)
                        {
                        case 200:
                            str="爆炒"
                            break
                        case 170:
                            str="煎炸"
                            break
                        case 150:
                            str="小炒"
                            break
                        case 70:
                            str="慢煮"
                            break
                        default:
                            str=""
                            break
                        }
                        return str+rAuxiliaryTemp+"℃"
                    }
                    return "辅助控温"
                }
                color:auxiliarySwitch > 0?themesTextColor:"#fff"
                font.pixelSize: 20
                //font.bold: true
                anchors.centerIn: parent
            }
            onClicked: {
                loaderManual.sourceComponent = component_temp
            }
        }
    }
    Component{
        id:component_temp
        Item {
            property var clickFunc:null
            property var cancelFunc:null
            property int curIndex:-1
            Component.onCompleted: {

            }
            Component.onDestruction: {
                clickFunc=null
                cancelFunc=null
            }

            //内容
            Rectangle{
                width:860
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
                Text{
                    text:"辅助控温"
                    color:"#fff"
                    font.pixelSize: 32
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 32
                }
                Row {
                    id:row
                    width: parent.width-80
                    height:87
                    anchors.top: parent.top
                    anchors.topMargin: 120
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 20
                    Repeater {
                        model: [{"text1":"200℃","text2":"爆炒"}, {"text1":"170℃","text2":"煎炸"},{"text1":"150℃","text2":"小炒"},{"text1":"70℃","text2":"慢煮"}]
                        Button{
                            width: 122
                            height:87
                            background: Rectangle{
                                radius: 10
                                color: curIndex==index?themesTextColor:"#4E4E4E"
                            }
                            Text{
                                text:modelData.text1
                                color:"#fff"
                                font.pixelSize: 30
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.top: parent.top
                                anchors.topMargin: 15
                            }
                            Text{
                                text:modelData.text2
                                color:"#fff"
                                font.pixelSize: 24
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.top: parent.top
                                anchors.topMargin: 45
                            }
                            onClicked: {
                                curIndex=index
                            }
                        }
                    }
                    Button{
                        width: 220
                        height:87
                        background: Rectangle{
                            radius: 10
                            color: "#4E4E4E"
                        }
                        Text{
                            text:"+自定义温度"
                            color:"#fff"
                            font.pixelSize: 30
                            anchors.centerIn: parent
                        }
                        onClicked: {
                            loaderTempControl(null)
                        }
                    }
                }

                PageButtonBar{
                    id:btnBar
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 30

                    space:80
                    models: ["取消控温","确认"]
                    onClick: {
                        if(clickIndex==0)
                        {
                            if(auxiliarySwitch > 0)
                                SendFunc.tempControlRquest(0)
                        }
                        else
                        {
                            var temp=0
                            switch(curIndex)
                            {
                            case 0:
                                temp=200
                                break
                            case 1:
                                temp=170
                                break
                            case 2:
                                temp=150
                                break
                            case 3:
                                temp=70
                                break
                            }
                            if(temp!=0)
                                SendFunc.tempControlRquest(temp)
                        }
                        loaderMainHide()
                    }
                }
            }
        }
    }
}

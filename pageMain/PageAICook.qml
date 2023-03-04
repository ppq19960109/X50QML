import QtQuick 2.12
import QtQuick.Controls 2.5
import "../"
import "qrc:/SendFunc.js" as SendFunc
Item {
    property string name: "PageAICook"
    property int left_percent:{
        if(lOilTemp<100)
            left_fire.source=themesPicturesPath+"ai/small_fire.png"
        else if(lOilTemp>170)
            left_fire.source=themesPicturesPath+"ai/big_fire.png"
        else
            left_fire.source=themesPicturesPath+"ai/medium_fire.png"

        if(lOilTemp<=50)
            return 1
        else if(lOilTemp>=250)
            return 100
        else
            return 100*(lOilTemp-50)/200
    }
    property int right_percent:{
        if(rOilTemp<100)
            right_fire.source=themesPicturesPath+"ai/small_fire.png"
        else if(rOilTemp>170)
            right_fire.source=themesPicturesPath+"ai/big_fire.png"
        else
            right_fire.source=themesPicturesPath+"ai/medium_fire.png"

        if(rOilTemp<=50)
            return 1
        else if(rOilTemp>=250)
            return 100
        else
            return 100*(rOilTemp-50)/200
    }
    onLeft_percentChanged: {
        left_canvas.requestPaint()
    }
    onRight_percentChanged: {
        right_canvas.requestPaint()
    }
    function close_heat_cancel(index)
    {
        if(index===0)
        {
            leftCloseHeatSwitch.checked=false
        }
        else
        {
            rightCloseHeatSwitch.checked=false
        }
    }
    function close_heat_run_cancel(index,pos)
    {
        if(pos>0)
            stopCloseHeat((index))
    }

    function closeHoodSpeed()
    {
        SendFunc.setHoodSpeed(0)
    }

    Connections { // 将目标对象信号与槽函数进行连接
        target: QmlDevState
        onStateChanged: { // 处理目标对象信号的槽函数
            //            console.log("page PageAICook:",key,value)
            if("LStoveTimingState"==key)
            {
                if(value===timingStateEnum.RUN)
                    leftCloseHeatSwitch.checked=true
                else
                    leftCloseHeatSwitch.checked=false
            }
            else if("RStoveTimingState"==key)
            {
                if(value===timingStateEnum.RUN)
                    rightCloseHeatSwitch.checked=true
                else
                    rightCloseHeatSwitch.checked=false
            }
        }
    }
    Component.onCompleted: {
        if(lTimingState===timingStateEnum.RUN)
            leftCloseHeatSwitch.checked=true
        else
            leftCloseHeatSwitch.checked=false
        if(rTimingState===timingStateEnum.RUN)
            rightCloseHeatSwitch.checked=true
        else
            rightCloseHeatSwitch.checked=false
        if(systemSettings.firstAI==true)
        {
            systemSettings.firstAI=false
            loaderManual.sourceComponent = component_help
        }
    }

    StackView.onActivated:{
        console.log("StackView.onActivated...")
        aiState=true
    }
    StackView.onDeactivated:{
        console.log("StackView.onDeactivated...")
        aiState=false
    }
    Component{
        id:component_help
        Rectangle{
            property int num:0
            color: "#000"
            Component.onCompleted: {
                num=0
            }
            Image {
                asynchronous:true
                smooth:false
                source: themesPicturesPath+"ai/help"+num+".png"
            }
            Button {
                width:140
                height: 50
                visible: num>0
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: {
                    switch(num)
                    {
                    case 1:
                        return -290
                    case 2:
                        return -210
                    case 3:
                        return 250
                    }
                    return 0
                }
                anchors.verticalCenterOffset: {
                    switch(num)
                    {
                    case 1:
                        return 130
                    case 2:
                        return 130
                    case 3:
                        return 110
                    }
                    return 0
                }
                background: Rectangle{
                    color:"transparent"
                    radius: 25
                    border.color: themesTextColor2
                }
                Text{
                    text:"上一步"
                    color:themesTextColor2
                    font.pixelSize: 30
                    anchors.centerIn: parent
                }
                onClicked: {
                    if(num>0)
                        --num
                }
            }
            Button {
                width:140
                height: 50
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: {
                    switch(num)
                    {
                    case 0:
                        return -360
                    case 1:
                        return 50
                    case 2:
                        return 120
                    case 3:
                        return 440
                    }
                    return 0
                }
                anchors.verticalCenterOffset: {
                    switch(num)
                    {
                    case 0:
                        return 130
                    case 1:
                        return 130
                    case 2:
                        return 130
                    case 3:
                        return 110
                    }
                    return 0
                }
                background: Rectangle{
                    color:"#fff"
                    radius: 25
                }
                Text{
                    text:num==3?"完成":"下一步"
                    color:"#000"
                    font.pixelSize: 30
                    anchors.centerIn: parent
                }
                onClicked: {
                    if(num==3)
                        loaderManual.sourceComponent = null
                    else
                        ++num
                }
            }
        }
    }

    PageTabBar{
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        currentIndex:0
    }

    Flickable{
        width: 370
        height:60
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
    Button{
        width: 40
        height:40
        anchors.top: parent.top
        anchors.topMargin: 8
        anchors.left: parent.left
        anchors.leftMargin: 15
        background:Image {
            asynchronous:true
            smooth:false
            anchors.centerIn: parent
            source: themesPicturesPath+"ai/icon_help.png"
        }
        onClicked: {
            loaderManual.sourceComponent = component_help
        }
    }
    Text{
        visible: hoodSpeed===4 && (testMode==true||smartSmokeSwitch===0) && QmlDevState.state.StirFryTimerLeft>0
        text:QmlDevState.state.StirFryTimerLeft+"分钟"
        color:themesTextColor
        font.pixelSize: 26
        anchors.right: grid.right
        anchors.rightMargin: 5
        anchors.bottom: grid.top
        anchors.bottomMargin: 0
    }
    Grid{
        id:grid
        width: 80*3+40*2
        height: 100*2+20
        rows: 2
        rowSpacing: 20
        columns: 3
        columnSpacing: 40
        anchors.centerIn: parent
        Repeater {
            model: [{"background":"light.png","text":"照明"}, {"background":"ai.png","text":"智能排烟"}, {"background":"stir_fry.png","text":"爆炒"}, {"background":"high_speed.png","text":"高速"}, {"background":"medium_speed.png","text":"中速"}, {"background":"low_speed.png","text":"低速"}]
            Item {
                width: 80
                height:100
                Button{
                    property bool curState:{
                        switch (index){
                        case 0:
                            return QmlDevState.state.HoodLight
                        case 1:
                            return smartSmokeSwitch
                        case 2:
                        case 3:
                        case 4:
                        case 5:
                            return hoodSpeed===(6-index) && (testMode==true||smartSmokeSwitch===0)
                        }
                        return false
                    }

                    width: parent.width
                    height:width

                    background: Image {
                        asynchronous:true
                        smooth:false
                        anchors.centerIn: parent
                        source: {
                            return themesPicturesPath+"/ai/"+(parent.curState?"checked_background.png":"uncheck_background.png")
                        }
                    }
                    Image {
                        asynchronous:true
                        smooth:false
                        anchors.centerIn: parent
                        source: themesPicturesPath+"/ai/"+modelData.background
                    }
                    onClicked: {
                        switch (index){
                        case 0:
                            SendFunc.setHoodLight(!QmlDevState.state.HoodLight)
                            break
                        case 1:
                            SendFunc.setSmartSmoke(!smartSmokeSwitch)
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
                Text{
                    text:modelData.text
                    color:"#fff"
                    font.pixelSize: 24
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                }
            }
        }
    }
    Item {
        id: left_content
        width: 340
        height: parent.height
        anchors.left: parent.left
        Text{
            id:left_stove
            text:"左灶"
            color:"#fff"
            font.pixelSize: 24
            anchors.top: parent.top
            anchors.topMargin: 306
            anchors.left: parent.left
            anchors.leftMargin: 63
        }
        Image {
            asynchronous:true
            smooth:false
            anchors.left:parent.left
            anchors.leftMargin: 175
            anchors.verticalCenter: parent.verticalCenter
            source: themesPicturesPath+"ai/left_temp_arc.png"
        }
        Image {
            id:left_fire
            visible: oilTempSwitch && lStoveStatus>0 && lOilTemp>0
            asynchronous:true
            smooth:false
            anchors.left:parent.left
            anchors.leftMargin: 60
            anchors.top: parent.top
            anchors.topMargin: 126
            source: themesPicturesPath+"ai/small_fire.png"
        }
        Text{
            id:left_temp
            text:oilTempSwitch?((lOilTemp>=0?lOilTemp:"-")+"℃"):"关"
            color:(oilTempSwitch && lOilTemp>=220)?"red":"#fff"
            font.pixelSize: 35
            anchors.top: parent.top
            anchors.topMargin: 60
            anchors.horizontalCenter: left_stove.horizontalCenter
            textFormat: Text.RichText
            lineHeight:0.75
        }
        Text{
            visible: (oilTempSwitch && lOilTemp>=220)
            text:"油温过高"
            color:"red"
            font.pixelSize: 24
            anchors.top: left_temp.bottom
            anchors.topMargin: 0
            anchors.horizontalCenter: left_temp.horizontalCenter
        }
        Text{
            text:"定时\n关火"
            color:"#fff"
            font.pixelSize: 24
            anchors.top: parent.top
            anchors.topMargin: 235
            anchors.left: parent.left
            anchors.leftMargin: 130
        }
        Text{
            visible: lTimingState===timingStateEnum.RUN
            text:{
                var timingTime=QmlDevState.state.LStoveTimingLeft
                return generateTwoTime(Math.floor(timingTime/60))+":"+generateTwoTime(timingTime%60)
            }
            color:themesTextColor
            font.pixelSize: 36
            anchors.top: parent.top
            anchors.topMargin: 240
            anchors.left: parent.left
            anchors.leftMargin: 20
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    loaderCloseHeat(cookWorkPosEnum.LEFT,startTurnOffFire,QmlDevState.state.LStoveTimingLeft,close_heat_run_cancel,["取消定时","开始"])
                }
            }
        }
        PageSwitch {
            id:leftCloseHeatSwitch
            visible: lTimingState!==timingStateEnum.RUN
            checked: false
            anchors.top: parent.top
            anchors.topMargin: 240
            anchors.left: parent.left
            anchors.leftMargin: 30
            source: themesPicturesPath+(checked ?"ai/icon_aiopen.png":"ai/icon_aiclose.png")
            onClicked: {
                if(checked==true)
                {
                    if(lStoveStatus===0)
                    {
                        checked=false
                        loaderWarnConfirmShow("左灶未开启\n开启后才可设置定时关火")
                    }
                    else
                        loaderCloseHeat(cookWorkPosEnum.LEFT,startTurnOffFire,null,close_heat_cancel)
                }
                else
                {
                    stopCloseHeat(cookWorkPosEnum.LEFT)
                }
            }
        }
        Canvas{
            property int r:204//-10
            id: left_canvas
            width: parent.width
            height: parent.height
            anchors.centerIn: parent
            onPaint: {
                var ctx = getContext("2d")
                ctx.clearRect(0, 0, parent.width, parent.height)
                ctx.lineWidth = 20
                ctx.lineCap="round"

                ctx.beginPath()
                ctx.strokeStyle = "#CFCDCD"
                ctx.arc(parent.width/2-135, parent.height/2, r, 0.32*Math.PI, -0.32*Math.PI,true)
                ctx.stroke()
                ctx.closePath()
                if(oilTempSwitch===0)
                    return

                // var grd=ctx.createRadialGradient(parent.width/2-135, parent.height/2,190,parent.width/2-135, parent.height/2,230);
                var grd = ctx.createConicalGradient(parent.width/2-135, parent.height/2, -0.5*Math.PI)
                grd.addColorStop(0,"#0B6BB8");
                grd.addColorStop(0.5,"#FF0000");
                grd.addColorStop(1,"#0B6BB8");

                ctx.beginPath()
                ctx.strokeStyle =grd
                var percentArc=0.64*left_percent/100
                ctx.arc(parent.width/2-135, parent.height/2, r, 0.32*Math.PI, (0.32-percentArc)*Math.PI,true)

                ctx.stroke()
                ctx.closePath()
            }
        }
        //        Slider {
        //            anchors.left: parent.left
        //            anchors.bottom: parent.bottom
        //            anchors.bottomMargin: 100
        //            stepSize: 2
        //            from:50
        //            to: 250
        //            value: 50
        //            onValueChanged: {
        //                console.log("slider:",value)
        //                left_percent=100*(value-50)/200
        //                left_canvas.requestPaint()
        //                if(value==from)
        //                    QmlDevState.setState("OilTempSwitch",0)
        //                else
        //                    QmlDevState.setState("OilTempSwitch",1)
        //            }
        //        }
    }
    Item {
        id: right_content
        width: 340
        height: parent.height
        anchors.right: parent.right
        Text{
            id:right_stove
            text:"右灶"
            color:"#fff"
            font.pixelSize: 24
            anchors.top: parent.top
            anchors.topMargin: 306
            anchors.right: parent.right
            anchors.rightMargin: 63
        }
        Image {
            id:right_arc
            asynchronous:true
            smooth:false
            anchors.right:parent.right
            anchors.rightMargin: 175
            anchors.verticalCenter: parent.verticalCenter
            source: themesPicturesPath+"ai/right_temp_arc.png"
        }
        Image {
            id:right_fire
            visible: oilTempSwitch && rStoveStatus>0 && rOilTemp>0
            asynchronous:true
            smooth:false
            anchors.right:parent.right
            anchors.rightMargin: 60
            anchors.top: parent.top
            anchors.topMargin: 126
            source: themesPicturesPath+"ai/small_fire.png"
        }
        Text{
            id:right_temp
            text:oilTempSwitch?((rOilTemp>=0?rOilTemp:"-")+"℃"):"关"
            color:(oilTempSwitch && rOilTemp>=220)?"red":"#fff"
            font.pixelSize: 35
            anchors.top: parent.top
            anchors.topMargin: 60
            anchors.horizontalCenter: right_stove.horizontalCenter
        }
        Text{
            visible: (oilTempSwitch && rOilTemp>=220)||(auxiliarySwitch>0 && rightAuxiliaryName!="")
            text:(auxiliarySwitch>0 && rightAuxiliaryName!="")?rightAuxiliaryName:"油温过高"
            color:(auxiliarySwitch>0 && rightAuxiliaryName!="")?themesTextColor:"red"
            font.pixelSize: 24
            anchors.top: right_temp.bottom
            anchors.topMargin: 0
            anchors.horizontalCenter: right_temp.horizontalCenter
        }
        Text{
            text:"定时\n关火"
            color:"#fff"
            font.pixelSize: 24
            anchors.top: parent.top
            anchors.topMargin: 235
            anchors.right: parent.right
            anchors.rightMargin: 130
        }
        Text{
            visible: rTimingState===timingStateEnum.RUN
            text:{
                var timingTime=QmlDevState.state.RStoveTimingLeft
                return generateTwoTime(Math.floor(timingTime/60))+":"+generateTwoTime(timingTime%60)
            }
            color:themesTextColor
            font.pixelSize: 36
            anchors.top: parent.top
            anchors.topMargin: 240
            anchors.right: parent.right
            anchors.rightMargin: 20
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    loaderCloseHeat(cookWorkPosEnum.RIGHT,startTurnOffFire,QmlDevState.state.RStoveTimingLeft,close_heat_run_cancel,["取消定时","开始"])
                }
            }
        }
        PageSwitch {
            id:rightCloseHeatSwitch
            visible: rTimingState!==timingStateEnum.RUN
            checked: false
            anchors.top: parent.top
            anchors.topMargin: 240
            anchors.right: parent.right
            anchors.rightMargin: 30
            source: themesPicturesPath+(checked ?"ai/icon_aiopen.png":"ai/icon_aiclose.png")
            onClicked: {
                if(checked==true)
                {
                    if(rStoveStatus===0)
                    {
                        checked=false
                        loaderWarnConfirmShow("右灶未开启\n开启后才可设置定时关火")
                    }
                    else
                        loaderCloseHeat(cookWorkPosEnum.RIGHT,startTurnOffFire,null,close_heat_cancel)
                }
                else
                {
                    stopCloseHeat(cookWorkPosEnum.RIGHT)
                }
            }
        }
        //        Path
        //        {
        //            id:path
        //            startX: 0; startY: 0
        //            PathAngleArc
        //            {
        //                radiusX: 114; radiusY: 175
        //                startAngle:90
        //                sweepAngle:360
        //            }
        //        }
        Canvas{
            property int r: 204//-10
            id: right_canvas
            width: parent.width
            height: parent.height
            anchors.centerIn: parent
            onPaint: {
                var ctx = getContext("2d")
                ctx.clearRect(0, 0, parent.width, parent.height)
                ctx.lineWidth = 20
                ctx.lineCap="round"

                ctx.beginPath()
                ctx.strokeStyle = "#CFCDCD"
                ctx.arc(parent.width/2+135, parent.height/2, r, 0.68*Math.PI, 1.32*Math.PI)
                ctx.stroke()
                ctx.closePath()
                if(oilTempSwitch===0)
                    return
                //                var grd=ctx.createRadialGradient(parent.width/2+135, parent.height/2,190,parent.width/2+135, parent.height/2,230);
                var grd = ctx.createConicalGradient(parent.width/2+135, parent.height/2, -0.5*Math.PI)
                grd.addColorStop(0,"#0B6BB8");
                grd.addColorStop(0.5,"#FF0000");
                grd.addColorStop(1,"#0B6BB8");

                ctx.beginPath()
                ctx.strokeStyle =grd

                var percentArc=0.64*right_percent/100
                ctx.arc(parent.width/2+135, parent.height/2, r, 0.68*Math.PI, (0.68+percentArc)*Math.PI)
                //                ctx.path=path
                ctx.stroke()
                ctx.closePath()
            }
        }
        //        Slider {
        //            anchors.right: parent.right
        //            anchors.bottom: parent.bottom
        //            anchors.bottomMargin: 100
        //            stepSize: 2
        //            from:50
        //            to: 250
        //            value: 50
        //            onValueChanged: {
        //                console.log("slider:",value)
        //                right_percent=100*(value-50)/200
        //                right_canvas.requestPaint()
        //            }
        //        }
        Button{
            width: 70
            height:40
            anchors.top: parent.top
            anchors.topMargin: 25
            anchors.right: right_arc.left
            anchors.rightMargin: -20
            background:Rectangle {
                color: (auxiliarySwitch===1 && rAuxiliaryTemp===200)?themesTextColor:"#7174AC"
                radius: 6
            }
            Text{
                text:"爆炒"
                color:"#fff"
                font.pixelSize: 20
                anchors.centerIn: parent
            }
            onClicked: {
                if(auxiliarySwitch===0 || rAuxiliaryTemp!==200)
                    SendFunc.tempControlRquest(200)
                else
                    SendFunc.tempControlRquest(0)
                SendFunc.setBuzControl(buzControlEnum.SHORT)
            }
        }
        Button{
            width: 70
            height:40
            anchors.top: parent.top
            anchors.topMargin: 100
            anchors.right: right_arc.left
            anchors.rightMargin: 5
            background:Rectangle {
                color: (auxiliarySwitch===1 && rAuxiliaryTemp===170)?themesTextColor:"#7174AC"
                radius: 6
            }
            Text{
                text:"煎炸"
                color:"#fff"
                font.pixelSize: 20
                anchors.centerIn: parent
            }
            onClicked: {
                if(auxiliarySwitch===0 || rAuxiliaryTemp!==170)
                    SendFunc.tempControlRquest(170)
                else
                    SendFunc.tempControlRquest(0)
                SendFunc.setBuzControl(buzControlEnum.SHORT)
            }
        }
        Button{
            width: 70
            height:40
            anchors.top: parent.top
            anchors.topMargin: 180
            anchors.right: right_arc.left
            anchors.rightMargin: 20
            background:Rectangle {
                color: (auxiliarySwitch===1 && rAuxiliaryTemp===150)?themesTextColor:"#7174AC"
                radius: 6
            }
            Text{
                text:"小炒"
                color:"#fff"
                font.pixelSize: 20
                anchors.centerIn: parent
            }
            onClicked: {
                if(auxiliarySwitch===0 || rAuxiliaryTemp!==150)
                    SendFunc.tempControlRquest(150)
                else
                    SendFunc.tempControlRquest(0)
                SendFunc.setBuzControl(buzControlEnum.SHORT)
            }
        }
        Button{
            width: 70
            height:40
            anchors.top: parent.top
            anchors.topMargin: 260
            anchors.right: right_arc.left
            anchors.rightMargin: 5
            background:Rectangle {
                color: (auxiliarySwitch===1 && rAuxiliaryTemp===95)?themesTextColor:"#7174AC"
                radius: 6
            }
            Text{
                text:"煲汤"
                color:"#fff"
                font.pixelSize: 20
                anchors.centerIn: parent
            }
            onClicked: {
                if(auxiliarySwitch===0 || rAuxiliaryTemp!==95)
                    SendFunc.tempControlRquest(95)
                else
                    SendFunc.tempControlRquest(0)
                SendFunc.setBuzControl(buzControlEnum.SHORT)
            }
        }
        Button{
            width: 70
            height:40
            anchors.top: parent.top
            anchors.topMargin: 335
            anchors.right: right_arc.left
            anchors.rightMargin: -30
            background:Rectangle {
                color: (auxiliarySwitch===1 && rAuxiliaryTemp===70)?themesTextColor:"#7174AC"
                radius: 6
            }
            Text{
                text:"慢煮"
                color:"#fff"
                font.pixelSize: 20
                anchors.centerIn: parent
            }
            onClicked: {
                if(auxiliarySwitch===0 || rAuxiliaryTemp!==70)
                    SendFunc.tempControlRquest(70)
                else
                    SendFunc.tempControlRquest(0)
                SendFunc.setBuzControl(buzControlEnum.SHORT)
            }
        }
    }
}

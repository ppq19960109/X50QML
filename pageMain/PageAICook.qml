import QtQuick 2.12
import QtQuick.Controls 2.5
import "../"
import "qrc:/SendFunc.js" as SendFunc
Item {
    property string name: "PageAICook"
    property int left_percent:{
        if(lOilTemp<50)
            return 0
        else if(lOilTemp>250)
            return 100
        else
            return 100*(lOilTemp-50)/200
    }
    property int right_percent:{
        if(rOilTemp<50)
            return 0
        else if(rOilTemp>250)
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
    }
    PageTabBar{
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        currentIndex:0
    }
    Button{
        width: 370
        height:60
        anchors.horizontalCenter: parent.horizontalCenter

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
    Text{
        visible: hoodSpeed===4 && (testMode==true||smartSmokeSwitch===0)
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
                                    SendFunc.setHoodSpeed(0)
                            }
                            else
                                SendFunc.setHoodSpeed(6-index)
                            break
                        }
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
            anchors.leftMargin: 135
            anchors.verticalCenter: parent.verticalCenter
            source: themesPicturesPath+"ai/"+(oilTempSwitch?"left_temp_arc.png":"left_temp_arc_close.png")
        }
        Text{
            text:oilTempSwitch?(lOilTemp>=0?lOilTemp:"-")+"℃":"关"
            color:"#fff"
            font.pixelSize: 40
            anchors.top: parent.top
            anchors.topMargin: 50
            anchors.left: parent.left
            anchors.leftMargin: 46
        }
        Text{
            text:"定时\n关火"
            color:"#fff"
            font.pixelSize: 24
            anchors.verticalCenter: parent.verticalCenter
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
            anchors.topMargin: 120
            anchors.left: parent.left
            anchors.leftMargin: 50
        }
        PageSwitch {
            id:leftCloseHeatSwitch
            checked: false
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 30
            onClicked: {
                if(checked==true)
                {
                    if(QmlDevState.state.LStoveStatus===0)
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
            property int r:210//-10
            id: left_canvas
            visible: oilTempSwitch
            width: parent.width
            height: parent.height
            anchors.centerIn: parent
            onVisibleChanged: {
                left_canvas.requestPaint()
            }
            onPaint: {
                if(!visible)
                    return
                var ctx = getContext("2d")
                ctx.clearRect(0, 0, parent.width, parent.height)
                ctx.lineWidth = 60

                //ctx.lineCap="round"
                ctx.beginPath()
                ctx.strokeStyle ="#FFFFFF"
                //0.71 1.288 0.29 -0.288
                var percentArc=0.578*left_percent/100
                ctx.arc(parent.width/2-135, parent.height/2, r, (0.29-percentArc)*Math.PI, (0.285-percentArc)*Math.PI,true)

                //                ctx.path=path
                ctx.stroke()
                ctx.closePath()
            }
        }
        //        Slider {
        //            anchors.left: parent.left
        //            anchors.bottom: parent.bottom
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
            anchors.rightMargin: 135
            anchors.verticalCenter: parent.verticalCenter
            source: themesPicturesPath+"ai/"+(oilTempSwitch?"right_temp_arc.png":"right_temp_arc_close.png")
        }
        Text{
            text:oilTempSwitch?(rOilTemp>=0?rOilTemp:"-")+"℃":"关"
            color:"#fff"
            font.pixelSize: 40
            anchors.top: parent.top
            anchors.topMargin: 50
            anchors.right: parent.right
            anchors.rightMargin: 46
        }
        Text{
            text:"定时\n关火"
            color:"#fff"
            font.pixelSize: 24
            anchors.verticalCenter: parent.verticalCenter
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
            anchors.topMargin: 120
            anchors.right: parent.right
            anchors.rightMargin: 50
        }
        PageSwitch {
            id:rightCloseHeatSwitch
            checked: false
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 30
            onClicked: {
                if(checked==true)
                {
                    if(QmlDevState.state.RStoveStatus===0)
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
            property int r: 210//-10
            id: right_canvas
            visible: oilTempSwitch
            width: parent.width
            height: parent.height
            anchors.centerIn: parent
            onVisibleChanged: {
                right_canvas.requestPaint()
            }
            onPaint: {
                if(!visible)
                    return
                var ctx = getContext("2d")
                ctx.clearRect(0, 0, parent.width, parent.height)
                ctx.lineWidth = 60

                //ctx.lineCap="round"
                ctx.beginPath()
                ctx.strokeStyle ="#FFFFFF"
                //0.71 1.288
                var percentArc=0.578*right_percent/100
                ctx.arc(parent.width/2+135, parent.height/2, r, (0.71+percentArc)*Math.PI, (0.715+percentArc)*Math.PI)

                //                ctx.path=path
                ctx.stroke()
                ctx.closePath()
            }
        }
        //        Slider {
        //            anchors.right: parent.right
        //            anchors.bottom: parent.bottom
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
            width: 60
            height:30
            anchors.top: parent.top
            anchors.topMargin: 30
            anchors.right: right_arc.left
            anchors.rightMargin: -20
            background:Rectangle {
                color: (auxiliarySwitch===1 && rAuxiliaryTemp===220)?themesTextColor:"#434343"
                radius: 6
            }
            Text{
                text:"爆炒"
                color:"#fff"
                font.pixelSize: 20
                anchors.centerIn: parent
            }
            onClicked: {
                if(auxiliarySwitch===0 || rAuxiliaryTemp!==220)
                    SendFunc.tempControlRquest(220)
                else
                    SendFunc.tempControlRquest(0)
            }
        }
        Button{
            width: 60
            height:30
            anchors.top: parent.top
            anchors.topMargin: 70
            anchors.right: right_arc.left
            anchors.rightMargin: 0
            background:Rectangle {
                color: (auxiliarySwitch===1 && rAuxiliaryTemp===200)?themesTextColor:"#434343"
                radius: 6
            }
            Text{
                text:"煎炸"
                color:"#fff"
                font.pixelSize: 20
                anchors.centerIn: parent
            }
            onClicked: {
                if(auxiliarySwitch===0 || rAuxiliaryTemp!==200)
                    SendFunc.tempControlRquest(200)
                else
                    SendFunc.tempControlRquest(0)
            }
        }
        Button{
            width: 60
            height:30
            anchors.top: parent.top
            anchors.topMargin: 110
            anchors.right: right_arc.left
            anchors.rightMargin: 5
            background:Rectangle {
                color: (auxiliarySwitch===1 && rAuxiliaryTemp===180)?themesTextColor:"#434343"
                radius: 6
            }
            Text{
                text:"小炒"
                color:"#fff"
                font.pixelSize: 20
                anchors.centerIn: parent
            }
            onClicked: {
                if(auxiliarySwitch===0 || rAuxiliaryTemp!==180)
                    SendFunc.tempControlRquest(180)
                else
                    SendFunc.tempControlRquest(0)
            }
        }
        Button{
            width: 60
            height:30
            anchors.top: parent.top
            anchors.topMargin: 290
            anchors.right: right_arc.left
            anchors.rightMargin: 5
            background:Rectangle {
                color: (auxiliarySwitch===1 && rAuxiliaryTemp===100)?themesTextColor:"#434343"
                radius: 6
            }
            Text{
                text:"煲汤"
                color:"#fff"
                font.pixelSize: 20
                anchors.centerIn: parent
            }
            onClicked: {
                if(auxiliarySwitch===0 || rAuxiliaryTemp!==100)
                    SendFunc.tempControlRquest(100)
                else
                    SendFunc.tempControlRquest(0)
            }
        }
        Button{
            width: 60
            height:30
            anchors.top: parent.top
            anchors.topMargin: 360
            anchors.right: right_arc.left
            anchors.rightMargin: -40
            background:Rectangle {
                color: (auxiliarySwitch===1 && rAuxiliaryTemp===60)?themesTextColor:"#434343"
                radius: 6
            }
            Text{
                text:"慢煮"
                color:"#fff"
                font.pixelSize: 20
                anchors.centerIn: parent
            }
            onClicked: {
                if(auxiliarySwitch===0 || rAuxiliaryTemp!==60)
                    SendFunc.tempControlRquest(60)
                else
                    SendFunc.tempControlRquest(0)
            }
        }
    }
}

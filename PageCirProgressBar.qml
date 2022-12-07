import QtQuick 2.12
import QtQuick.Controls 2.5
import "qrc:/SendFunc.js" as SendFunc
Item {
    id:root
    property int device
    property real percent:0
    property int roate:0
    property int reserveFlash:0

    property int workState
    property color workColor
    property int orderTimeLeft:0
    property int setTimeLeft:0

    property alias workMode:mode.text
    property alias canvasDiameter:canvas.width

    property alias workTime:time.text
    property alias workTemp:temp.text

    signal confirm(int index)
    function updatePaint()
    {
        canvas.requestPaint()
    }
    onWorkStateChanged: {

        if(!(workState === workStateEnum.WORKSTATE_FINISH||workState === workStateEnum.WORKSTATE_STOP||workState === workStateEnum.WORKSTATE_PREHEAT))
            updatePaint()
    }
    onPercentChanged: {
        if(workState !== workStateEnum.WORKSTATE_STOP && workState !== workStateEnum.WORKSTATE_FINISH && workState !== workStateEnum.WORKSTATE_PREHEAT)
        {
            updatePaint()
        }
    }

    SequentialAnimation {
        id:seqAnimation
        running: workState === workStateEnum.WORKSTATE_RESERVE||workState === workStateEnum.WORKSTATE_PAUSE_RESERVE||workState === workStateEnum.WORKSTATE_PAUSE
        loops:Animation.Infinite
        NumberAnimation { target: root; property: "reserveFlash"; from:0;to: 1; duration: 1000 ;easing.type: Easing.Linear}
        NumberAnimation { target: root; property: "reserveFlash"; from:1;to: 0; duration: 1000 ;easing.type: Easing.Linear}
//        Component.onDestruction: {
//            seqAnimation.stop()
//        }
    }

    Image {
        width: 310
        height: width
        visible:workState !== workStateEnum.WORKSTATE_PREHEAT
        anchors.centerIn: parent
        source: "qrc:/x50/icon_runing_background.png"
    }

    property int lineWidth:30
    property real r: canvas.width/2-lineWidth/2
    Canvas{
        id: canvas
        visible: !(workState === workStateEnum.WORKSTATE_FINISH||workState === workStateEnum.WORKSTATE_CLEAN_FINISH||workState === workStateEnum.WORKSTATE_STOP||workState === workStateEnum.WORKSTATE_PREHEAT)
        width: canvasDiameter
        height: width
//        canvasSize.width:canvasDiameter
//        canvasSize.height:canvasDiameter
        contextType:"2d"
        //renderStrategy:Canvas.Cooperative//Threaded Cooperative
        //renderTarget:Canvas.FramebufferObject
        anchors.centerIn: parent
        onPaint: {
            if(workState === workStateEnum.WORKSTATE_FINISH||workState === workStateEnum.WORKSTATE_CLEAN_FINISH||workState === workStateEnum.WORKSTATE_STOP||workState === workStateEnum.WORKSTATE_PREHEAT)
            {
                return
            }
            var ctx = getContext("2d") //getContext("2d") context
            ctx.save()
            ctx.clearRect(0, 0, canvas.width, canvas.height)
            //            if(workState === workStateEnum.WORKSTATE_FINISH||workState === workStateEnum.WORKSTATE_STOP||workState === workStateEnum.WORKSTATE_PREHEAT)
            //            {
            //                ctx.restore()
            //                return
            //            }
            var gr
            ctx.translate(canvas.width/2,canvas.height/2)
            //            ctx.lineWidth = 0
            //            if(workState !== workStateEnum.WORKSTATE_PREHEAT)
            //            {
            //                //显示外圈
            //                ctx.beginPath()
            //                ctx.lineWidth = lineWidth
            //                ctx.strokeStyle = "#333333"
            //                //            ctx.fillStyle = '#596767'
            //                ctx.arc(0, 0, r, 0, 2*Math.PI)
            //                ctx.closePath()
            //                ctx.stroke()
            //                //            ctx.fill()
            //            }

            gr = ctx.createConicalGradient(0, 0, 0.5*Math.PI)
            ctx.lineCap="round"
            ctx.lineWidth = lineWidth
            ctx.beginPath()
            //                if(workState === workStateEnum.WORKSTATE_PREHEAT)
            //                {
            //                    ctx.rotate(roate*Math.PI/180);
            //                    if(device==cookWorkPosEnum.LEFT)
            //                    {
            //                        gr.addColorStop(1, "#00EF832B");
            //                        gr.addColorStop(0, "#FFEF832B");
            //                    }
            //                    else
            //                    {
            //                        gr.addColorStop(1, "#00DE932F");
            //                        gr.addColorStop(0, "#FFDE932F");
            //                    }

            //                    ctx.strokeStyle =gr
            //                    ctx.arc(0, 0, r, (-0.5+0.04)*Math.PI, (1.5-0.04)*Math.PI)
            //                    ctx.stroke()
            //                }
            //                else
            //                {
            if(device==cookWorkPosEnum.LEFT)
            {
                gr.addColorStop(1, "#A0420F")
                gr.addColorStop(0, "#E68855")
            }
            else
            {
                gr.addColorStop(0, "#DE932F");
                //                        gr.addColorStop(1, "#DE932F");
            }
            ctx.strokeStyle =gr
            if(percent==0)
            {
                ctx.arc(0, 0, r, -0.5*Math.PI, 1.5*Math.PI)
            }
            else
            {
                ctx.arc(0, 0, r, (-0.5+0.04)*Math.PI, (1.5-0.04-1.92*percent/100)*Math.PI)
            }
            //                }
            ctx.stroke()
//            ctx.closePath()
            //                var rad=(1.5-2*percent/100)*Math.PI
            //                console.log("radian:",rad,"r:",r,"Angle",360*percent/100)
            //                var x = Math.cos(rad)*r
            //                var y = Math.sin(rad)*r

            //                ctx.beginPath()
            //                ctx.fillStyle = '#E68855'
            //                ctx.arc(x, y, lineWidth, 0, 2*Math.PI)
            //                ctx.closePath()
            //                ctx.fill()


            //            var rad=(2*percent/100-0.5)*Math.PI
            //            console.log("radian:",rad,"r:",r,"Angle",360*percent/100)
            //                var x = Math.cos(rad)*r
            //                var y = Math.sin(rad)*r

            //                ctx.beginPath()
            //                ctx.fillStyle = 'blue'
            //                ctx.arc(x, y, lineWidth, 0, 2*Math.PI)
            //                ctx.closePath()
            //                ctx.fill()

            //显示百分数
            //                ctx.font = "30px sans-serif"
            //                ctx.textAlign = 'center'
            //                ctx.fillStyle = "blue"
            //                ctx.fillText(percent + '%', 0, 0)

            ctx.restore()
            gr=null
            ctx=null
        }
    }

    Item{
        //                width:canvas.width
        //                height: canvas.height
        anchors.fill: parent

        Text{
            id:state
            color:(workState === workStateEnum.WORKSTATE_FINISH||workState === workStateEnum.WORKSTATE_CLEAN_FINISH) ?workColor:"#D7D7D7"
            visible: workState !== workStateEnum.WORKSTATE_STOP
            font.pixelSize:(workState === workStateEnum.WORKSTATE_FINISH||workState === workStateEnum.WORKSTATE_CLEAN_FINISH) ? 45:32
            anchors.top:parent.top
            anchors.topMargin: 75
            anchors.horizontalCenter: parent.horizontalCenter
            //            horizontalAlignment :Text.AlignHCenter
            //            verticalAlignment :Text.AlignHCenter
            text: workStateArray[workState]
        }
        Item
        {
            visible: !(workState === workStateEnum.WORKSTATE_FINISH||workState === workStateEnum.WORKSTATE_CLEAN_FINISH||workState === workStateEnum.WORKSTATE_STOP)
            anchors.top:parent.top
            anchors.topMargin:115
            anchors.horizontalCenter: parent.horizontalCenter

            Text{
                id:time
//                textFormat: Text.RichText
                anchors.top:parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset:(workState === workStateEnum.WORKSTATE_RESERVE||workState === workStateEnum.WORKSTATE_PAUSE_RESERVE)?0:-20
                color:workColor
                font.pixelSize: 70
                //                font.bold: (workState === workStateEnum.WORKSTATE_RUN|| workState === workStateEnum.WORKSTATE_PAUSE)?true:false
                visible: !((workState === workStateEnum.WORKSTATE_PAUSE_RESERVE||workState === workStateEnum.WORKSTATE_PAUSE) && reserveFlash==false)
            }
            Text{
                visible: (workState === workStateEnum.WORKSTATE_RESERVE && reserveFlash) || (workState === workStateEnum.WORKSTATE_PAUSE_RESERVE && reserveFlash==true)
                anchors.top:parent.top
                anchors.topMargin: -5
                anchors.horizontalCenter: parent.horizontalCenter
                color:workColor
                font.pixelSize: 70
                text: qsTr(":")//：:
            }
            Text{
                visible: !(workState === workStateEnum.WORKSTATE_RESERVE || workState === workStateEnum.WORKSTATE_PAUSE_RESERVE || (workState === workStateEnum.WORKSTATE_PAUSE && reserveFlash==false))
                anchors.left: time.right
                anchors.leftMargin: 5
                anchors.bottom: time.bottom
                anchors.bottomMargin: 7
                color:"#D7D7D7"
                font.pixelSize: workState === workStateEnum.WORKSTATE_PREHEAT?44:30
                text: workState === workStateEnum.WORKSTATE_PREHEAT?qsTr("℃"):qsTr("分钟")
            }
        }
        Button{
            visible: workState === workStateEnum.WORKSTATE_FINISH && device != 0
            width:120
            height: 50
            anchors.top: parent.top
            anchors.topMargin: 145
            anchors.horizontalCenter: parent.horizontalCenter
            background:Rectangle{
                color:"#484848"
                radius: 8
            }
            Text{
                color:"white"
                font.pixelSize: 28
                anchors.centerIn: parent
                //                horizontalAlignment :Text.AlignHCenter
                //                verticalAlignment :Text.AlignHCenter
                text: qsTr("清洁模式")
            }
            onClicked:{
                confirm(1)
            }
        }
        Button{
           visible: workState === workStateEnum.WORKSTATE_FINISH || workState === workStateEnum.WORKSTATE_CLEAN_FINISH
            width:120
            height: 50
            anchors.top: parent.top
            anchors.topMargin: 205
            anchors.horizontalCenter: parent.horizontalCenter
            background:Rectangle{
                color:"#484848"
                radius: 8
            }
            Text{
                color:"white"
                font.pixelSize: 28
                anchors.centerIn: parent
                //                horizontalAlignment :Text.AlignHCenter
                //                verticalAlignment :Text.AlignHCenter
                text: qsTr("返回")
            }
            onClicked:{
                confirm(0)
            }
        }
        Image {
            visible: workState === workStateEnum.WORKSTATE_STOP
            anchors.top:parent.top
            anchors.topMargin:90
            anchors.horizontalCenter: parent.horizontalCenter
            source: themesImagesPath+"icon-cookadd.png"
        }
        Text{
            id:mode
            width:200
            visible: workState !== workStateEnum.WORKSTATE_FINISH && workState !== workStateEnum.WORKSTATE_CLEAN_FINISH
            color:themesTextColor2
            font.pixelSize: workState === workStateEnum.WORKSTATE_STOP?32:30
            anchors.top:parent.top
            anchors.topMargin: workState === workStateEnum.WORKSTATE_STOP?200:194
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment:Text.AlignHCenter
            verticalAlignment:Text.AlignVCenter
            elide: Text.ElideRight
        }
        Text{
            id:temp
            visible: !(workState === workStateEnum.WORKSTATE_FINISH||workState === workStateEnum.WORKSTATE_CLEAN_FINISH||workState === workStateEnum.WORKSTATE_STOP)
            anchors.top: parent.top
            anchors.topMargin: 230
            anchors.horizontalCenter: parent.horizontalCenter
            color:themesTextColor2
            font.pixelSize: 26
            //            horizontalAlignment :Text.AlignHCenter
            //            verticalAlignment :Text.AlignHCenter
        }

    }

}

import QtQuick 2.12
import QtQuick.Controls 2.5
import "../"
import "qrc:/SendFunc.js" as SendFunc
Item {
    Component.onCompleted: {
        aiState=true
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
            source: themesPicturesPath+"ai/cook_assist_btn.png"
        }
        onClicked: {
            replace_page(pageHood)
        }
    }
    Grid{
        width: 79*3+38*2
        height: 100*2+19
        rows: 2
        rowSpacing: 19
        columns: 3
        columnSpacing: 38
        anchors.centerIn: parent
        Repeater {
            model: [{"background":"light.png","text":"照明"}, {"background":"ai.png","text":"智能排烟"}, {"background":"stir_fry.png","text":"爆炒"}, {"background":"high_speed.png","text":"高速"}, {"background":"medium_speed.png","text":"中速"}, {"background":"low_speed.png","text":"低速"}]
            Item {
                width: 79
                height:100
                Button{
                    property bool curState:{
                        switch (index){
                        case 0:
                            return QmlDevState.state.HoodLight
                        case 1:
                            return smartSmokeSwitch
                        case 2:
                            return hoodSpeed===4
                        case 3:
                            return hoodSpeed===3
                        case 4:
                            return hoodSpeed===2
                        case 5:
                            return hoodSpeed===1
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
                            if(hoodSpeed===4)
                                SendFunc.setHoodSpeed(0)
                            else
                                SendFunc.setHoodSpeed(4)
                            break
                        case 3:
                            if(hoodSpeed===3)
                                SendFunc.setHoodSpeed(0)
                            else
                                SendFunc.setHoodSpeed(3)
                            break
                        case 4:
                            if(hoodSpeed===2)
                                SendFunc.setHoodSpeed(0)
                            else
                                SendFunc.setHoodSpeed(2)
                            break
                        case 5:
                            if(hoodSpeed===1)
                                SendFunc.setHoodSpeed(0)
                            else
                                SendFunc.setHoodSpeed(1)
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
            source: themesPicturesPath+"ai/"+"left_temp_arc.png"
        }
        Text{
            text:"120℃"
            color:"#fff"
            font.pixelSize: 40
            anchors.top: parent.top
            anchors.topMargin: 106
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
        PageSwitch {
            id:leftTempSwitch
            checked: false
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 30
            onClicked: {

            }
        }
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
            source: themesPicturesPath+"ai/"+"right_temp_arc.png"
        }
        Text{
            text:"120℃"
            color:"#fff"
            font.pixelSize: 40
            anchors.top: parent.top
            anchors.topMargin: 106
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
        PageSwitch {
            id:rightTempSwitch
            checked: false
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 30
            onClicked: {

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
            id: canvas
            visible: true
            width: parent.width
            height: parent.height
            anchors.centerIn: parent

            onPaint: {
                var ctx = getContext("2d")
                ctx.clearRect(0, 0, canvas.width, canvas.height)
                ctx.lineWidth = 60

                //ctx.lineCap="round"
                ctx.beginPath()
                ctx.strokeStyle ="#FFFFFF"
                //0.71 1.288
                var percentArc=0.578*percent/100
                ctx.arc(canvas.width/2+135, canvas.height/2, r, (0.71+percentArc)*Math.PI, (0.715+percentArc)*Math.PI)

                //                ctx.path=path
                ctx.stroke()
                ctx.closePath()
            }
        }
        Slider {
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            stepSize: 2
            from:50
            to: 250
            value: 30
            onValueChanged: {
                console.log("slider:",value)
                percent=100*(value-50)/200
                canvas.requestPaint()
            }
        }
        Button{
            width: 60
            height:30
            anchors.top: parent.top
            anchors.topMargin: 30
            anchors.right: right_arc.left
            anchors.rightMargin: -20
            background:Rectangle {
                color: "#434343"
                radius: 6
            }
            Text{
                text:"爆炒"
                color:"#fff"
                font.pixelSize: 20
                anchors.centerIn: parent
            }
            onClicked: {

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
                color: "#434343"
                radius: 6
            }
            Text{
                text:"煎炸"
                color:"#fff"
                font.pixelSize: 20
                anchors.centerIn: parent
            }
            onClicked: {

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
                color: "#434343"
                radius: 6
            }
            Text{
                text:"小炒"
                color:"#fff"
                font.pixelSize: 20
                anchors.centerIn: parent
            }
            onClicked: {

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
                color: "#434343"
                radius: 6
            }
            Text{
                text:"煲汤"
                color:"#fff"
                font.pixelSize: 20
                anchors.centerIn: parent
            }
            onClicked: {

            }
        }        Button{
            width: 60
            height:30
            anchors.top: parent.top
            anchors.topMargin: 360
            anchors.right: right_arc.left
            anchors.rightMargin: -40
            background:Rectangle {
                color: "#434343"
                radius: 6
            }
            Text{
                text:"慢煮"
                color:"#fff"
                font.pixelSize: 20
                anchors.centerIn: parent
            }
            onClicked: {

            }
        }
    }
    property int percent:0
}

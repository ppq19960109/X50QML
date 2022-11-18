import QtQuick 2.12
import QtQuick.Controls 2.5
import "../"
import "qrc:/SendFunc.js" as SendFunc
Item {
    property string name: "PageHood"
    PageBackBar{
        id:topBar
        anchors.top:parent.top
        name:qsTr("烟机灶具")
        centerText:QmlDevState.state.OilTempSwitch?("左灶油温:"+QmlDevState.state.LOilTemp+"℃"+"    右灶油温:"+QmlDevState.state.ROilTemp+"℃"):""
    }
    PageTabBar{
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        currentIndex:0
    }
    Row {
        width: 200*5+20*4
        height: 260
        anchors.top: topBar.bottom
        anchors.topMargin: 26
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 20
        Repeater {
            model: [{"background":"smart_smoke_background.png","text":"智能排烟"}, {"background":"stir_fried_background.png","text":"爆炒"}]
            Button{
                width: 200
                height:parent.height
                anchors.verticalCenter: parent.verticalCenter

                background:Rectangle {
                    color: "#000"
                    border{
                        width: 1
                        color: "#858585"
                    }
                    radius: 4
                }
                Text{
                    text:modelData.text
                    color:"#fff"
                    font.pixelSize: 34
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 26
                }
                Image {
                    asynchronous:true
                    smooth:false
                    anchors.top: parent.top
                    anchors.topMargin: 83
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: themesPicturesPath+modelData.background
                    Image {
                        id:rotation1
                        visible: {
                            if(index==0)
                            {
                                return smartSmokeSwitch
                            }
                            else
                            {
                                return hoodSpeed===4
                            }
                        }
                        asynchronous:true
//                        smooth:false
                        source: themesPicturesPath+"icon_runing.png"
                        RotationAnimation on rotation {
                            from: 0
                            to: 360
                            duration: 8000 //旋转速度，默认250
                            loops: Animation.Infinite //一直旋转
                            running: rotation1.visible
                        }
                    }
                }
                onClicked: {
                    if(index==0)
                    {
                        if(smartSmokeSwitch===0)
                            SendFunc.setSmartSmoke(1)
                        else
                            SendFunc.setSmartSmoke(0)
                    }
                    else
                    {
                        if(hoodSpeed===4)
                            SendFunc.setHoodSpeed(0)
                        else
                            SendFunc.setHoodSpeed(4)
                    }
                }
            }
        }

        Rectangle{
            width: 200
            height:parent.height
            anchors.verticalCenter: parent.verticalCenter

            color: "#000"
            border{
                width: 1
                color: "#858585"
            }
            radius: 4
            Text{
                text:"风速"
                color:"#fff"
                font.pixelSize: 34
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 26
            }
            Column {

                width: 90
                height: 45*3+15*2
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom:parent.bottom
                anchors.bottomMargin: 13
                spacing: 15
                Repeater {
                    model: ["高", "中", "低"]
                    Button{
                        width: parent.width
                        height:45
                        background:Rectangle {
                            id:hoodSpeedBackground
                            color: (hoodSpeed===(3-index) && (testMode==true||smartSmokeSwitch===0))?themesTextColor:"#191919"
                            radius: 20
                        }
                        Text{
                            text:modelData
                            color:(hoodSpeed===(3-index) && (testMode==true||smartSmokeSwitch===0))?"#fff":"#7C7C7C"
                            font.pixelSize: 30
                            anchors.centerIn: parent
                        }
                        onClicked: {
                            if(hoodSpeed!==(3-index))
                                SendFunc.setHoodSpeed(3-index)
                            else
                            {
                                if(testMode==false && smartSmokeSwitch>0)
                                    SendFunc.setSmartSmoke(0)
                                else
                                    SendFunc.setHoodSpeed(0)
                            }
                        }
                    }
                }
            }
        }
        Repeater {
            model: [{"background":"turn_off_fire_background.png","text":"定时关火"}, {"background":"intelligent_cooking.png","text":"智慧烹饪"}]
            Button{
                width: 200
                height:parent.height
                anchors.verticalCenter: parent.verticalCenter

                background:Rectangle {
                    color: "#000"
                    border{
                        width: 1
                        color: "#858585"
                    }
                    radius: 4
                }
                Text{
                    text:modelData.text
                    color:"#fff"
                    font.pixelSize: 34
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 26
                }
                Image {
                    asynchronous:true
                    smooth:false
                    anchors.top: parent.top
                    anchors.topMargin: 83
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: themesPicturesPath+modelData.background
                    Image {
                        id:rotation2
                        visible: {
                            if(index==0)
                            {
                                return lTimingState===timingStateEnum.RUN||rTimingState===timingStateEnum.RUN
                            }
                            else
                            {
                                return false
                            }
                        }
                        asynchronous:true
//                        smooth:false
                        source: themesPicturesPath+"icon_runing.png"
                        RotationAnimation on rotation {
                            from: 0
                            to: 360
                            duration: 8000 //旋转速度，默认250
                            loops: Animation.Infinite //一直旋转
                            running:rotation2.visible
                        }
                    }
                }
                Text{
                    visible: index==0 && rotation2.visible
                    text:{
                        if(index==0)
                        {
                            return  closeHeatShortTime()
                        }
                        else
                        {
                            return ""
                        }
                    }
                    color:themesTextColor
                    font.pixelSize: 28
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 220
                }
                onClicked: {
                    if(index==0)
                    {
                        push_page(pageCloseHeat)
                    }
                    else
                    {
                        push_page(pageSmartCook)
                    }
                }
            }
        }

    }

}

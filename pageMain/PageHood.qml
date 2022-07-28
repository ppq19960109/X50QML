import QtQuick 2.7
import QtQuick.Controls 2.2
import "../"
Item {
    Component.onCompleted: {

    }

    PageBackBar{
        id:topBar
        anchors.top:parent.top
        name:qsTr("烟机灶具")
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
                        asynchronous:true
                        smooth:false
                        source: themesPicturesPath+"icon_runing.png"
                        RotationAnimation on rotation {
                            from: 0
                            to: 360
                            duration: 8000 //旋转速度，默认250
                            loops: Animation.Infinite //一直旋转
                            running:true
                        }
                    }
                }
                onClicked: {
                    if(index==0)
                    {

                    }
                    else
                    {

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
                            color: "#191919"
                            radius: 20
                        }
                        Text{
                            text:modelData
                            color:"#7C7C7C"
                            font.pixelSize: 30
                            anchors.centerIn: parent
                        }
                        onClicked: {
                            console.log("onClicked index",index)
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
                        asynchronous:true
                        smooth:false
                        source: themesPicturesPath+"icon_runing.png"
                        RotationAnimation on rotation {
                            from: 0
                            to: 360
                            duration: 8000 //旋转速度，默认250
                            loops: Animation.Infinite //一直旋转
                            running:true
                        }
                    }
                }
                Text{
                    visible: index==0
                    text:"00:30"
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

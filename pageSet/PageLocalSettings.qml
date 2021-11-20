import QtQuick 2.0
import QtQuick.Controls 2.2
Rectangle {
    color:"#000"
    Component.onCompleted: {


    }
    ToolBar {
        id:topBar
        width:parent.width
        anchors.top:parent.top
        height:96
        background:Rectangle{
            color:"#000"
        }
        Image {
            anchors.fill: parent
            source: "/images/main_menu/zhuangtai_bj.png"
        }
        //back图标
        TabButton {
            id:goBack
            width:80
            height:parent.height
            anchors.left:parent.left
            anchors.verticalCenter: parent.verticalCenter
            Image{
                anchors.centerIn: parent
                source: "/images/fanhui.png"
            }
            background: Rectangle {
                opacity: 0
            }
            onClicked: {
                backPrePage()
            }
        }

        Text{
            id:pageName
            width:100
            //            height:parent.height
            color:"#9AABC2"
            font.pixelSize: 40
            anchors.left:goBack.right
            anchors.verticalCenter: parent.verticalCenter
            text:qsTr("本机设置")
        }

    }
    //内容
    Rectangle{
        width:parent.width-100
        anchors.top:topBar.bottom
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        color:"#000"

        Rectangle{
            width:parent.width
            height: parent.height/2
            anchors.top: parent.top

            color:"transparent"
            Text{
                anchors.bottom: startImg.top
                anchors.left: parent.left
                color:"#fff"
                text:qsTr("亮度")
                font.pixelSize:40
            }
            Image{
                id:startImg
                source: "/images/icon_setting_bright_min.png"
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
            }
            PageSlider {
                anchors.left:startImg.right
                anchors.right:endImg.left
                anchors.verticalCenter: parent.verticalCenter
                stepSize: 1
                from: 40
                to: 250
                value: 100
                //                displayText:value+"min"
                onValueSlider: {
                    console.log("lightSlider:",value)
                }
            }
            Image{
                id:endImg
                source: "/images/icon_setting_bright_max.png"
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
            }

        }

        Rectangle{
            width:parent.width
            height: parent.height/2
            anchors.bottom: parent.bottom
            color:"transparent"
            Text{
                anchors.bottom: startText.top
                anchors.left: parent.left
                color:"#fff"
                text:qsTr("休眠")
                font.pixelSize:40
            }
            Text{
                id:startText
                color:"#fff"
                text:qsTr("1min")
                font.pixelSize:40
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
            }
            PageSlider {
                anchors.left:startText.right
                anchors.right:endText.left
                anchors.verticalCenter: parent.verticalCenter
                stepSize: 1
                from: 1
                to: 5
                value: 3
                displayText:value+"min"
                onValueSlider: {
                    console.log("dormantSlider:",value)
                }
            }
            Text{
                id:endText
                color:"#fff"
                text:qsTr("5min")
                font.pixelSize:40
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}


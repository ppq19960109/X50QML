import QtQuick 2.7
import QtQuick.Controls 2.2
import "../"
import "qrc:/SendFunc.js" as SendFunc
Item {

    PageBackBar{
        id:topBar
        anchors.bottom:parent.bottom
        name:qsTr("本机设置")
        leftBtnText:qsTr("")
        rightBtnText:qsTr("")
        onClose:{
            backPrePage()
        }
    }
    //内容
    Item{
        width:parent.width-100
//        height: parent.height-topBar.height-100
        anchors.bottom:topBar.top
        anchors.bottomMargin: 20
        anchors.top: parent.top
        anchors.topMargin: 60
        anchors.horizontalCenter: parent.horizontalCenter

        Item{
            width:parent.width
            height: parent.height/2
            anchors.top: parent.top
            Text{
                anchors.bottom: startImg.top
                anchors.left: parent.left
                color:"#fff"
                text:qsTr("亮度")
                font.pixelSize:40
            }
            Image{
                id:startImg
                asynchronous:true
                smooth:false
                source: "qrc:/x50/set/icon_light_small.png"
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
            }
            PageSlider {
                id:lightSlider
                anchors.left:startImg.right
                anchors.leftMargin: 20
                anchors.right:endImg.left
                anchors.rightMargin: 20
                anchors.verticalCenter: parent.verticalCenter
                stepSize: 2
                from: 1
                to: 255
                value: Backlight.backlightGet()

                onValueSlider: {
//                    console.log("lightSlider:",value)
                    systemSettings.brightness=value
                }
            }
            Image{
                id:endImg
                asynchronous:true
                smooth:false
                source: "qrc:/x50/set/icon_light_big.png"
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
            }

        }

        Item{
            width:parent.width
            height: parent.height/2
            anchors.bottom: parent.bottom
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
                text:qsTr("1分钟")
                font.pixelSize:35
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
            }
            PageSlider {
                anchors.left:startText.right
                anchors.right:endText.left
                anchors.leftMargin: 20
                anchors.rightMargin: 20
                anchors.verticalCenter: parent.verticalCenter
                stepSize: 1
                from: 1
                to: 5
                value: systemSettings.sleepTime
                displayText:value+"分钟"
                onValueSlider: {
//                    console.log("dormantSlider:",value)
                    systemSettings.sleepTime=value
                }
            }
            Text{
                id:endText
                color:"#fff"
                text:qsTr("5分钟")
                font.pixelSize:35
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}


import QtQuick 2.12
import QtQuick.Controls 2.5
import "../"
import "qrc:/pageSet"
Item{
    property var containerqml: null

    Item{
        width:parent.width-100
        height: parent.height
        anchors.centerIn: parent
        Text {
            anchors.top: parent.top
            anchors.topMargin: 40
            anchors.horizontalCenter: parent.horizontalCenter
            color:"#FFF"
            font.pixelSize: 40
            text: qsTr("调节背光设置，背光是否随设置亮暗变化
    ")
        }
        Text{
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            color:"#fff"
            text:qsTr("亮度")
            font.pixelSize:30
        }
        Image{
            asynchronous:true
            source: themesPicturesPath+"icon_light_small.png"
            anchors.right: lightSlider.left
            anchors.rightMargin:15
            anchors.verticalCenter: parent.verticalCenter
        }
        PageSlider {
            id:lightSlider
            width: 590
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            stepSize: 2
            from: 1
            to: 255
            value: Backlight.backlightGet()
            onValueChanged: {
                systemSettings.brightness=value
            }
        }
        Image{
            asynchronous:true
            source: themesPicturesPath+"icon_light_big.png"
            anchors.left: lightSlider.right
            anchors.leftMargin:15
            anchors.verticalCenter: parent.verticalCenter
        }
    }
    PageButtonBar{
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20

        space:150
        models: ["成功","失败"]
        onClick:{
            if(clickIndex==0)
            {
                containerqml.clickedLightFunc(1)
            }
            else
            {
                containerqml.clickedLightFunc(-1)
            }
            Backlight.backlightSet(systemSettings.brightness)
            backPrePage()
        }
    }
}

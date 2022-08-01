import QtQuick 2.7
import QtQuick.Controls 2.2
import "qrc:/pageSet"
Item{
    property var containerqml: null

    Item{
        width:parent.width-100
        height: parent.height
        anchors.centerIn: parent
        Text {
            width: parent.width
//            height: 50
            anchors.top: parent.top
            anchors.topMargin: 40
            color:"#FFF"
            font.pixelSize: 40
            text: qsTr("调节背光设置，背光是否随设置亮暗变化
    ")
//            horizontalAlignment:Text.AlignHCenter
//            verticalAlignment:Text.AlignVCenter
        }
        Image{
            id:startImg
            asynchronous:true
            smooth:false
            cache:false
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
                Backlight.backlightSet(value)
            }
        }
        Image{
            id:endImg
            asynchronous:true
            smooth:false
            cache:false
            source: "qrc:/x50/set/icon_light_big.png"
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
        }
    }
    Button{
        width:100
        height:50
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: -150
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        background:Rectangle{
            radius: 8
            color:themesTextColor2
        }
        Text{
            text:"成功"
            color:"#fff"
            font.pixelSize: 40
            anchors.centerIn: parent
        }
        onClicked: {
            containerqml.clickedLightFunc(1)
            Backlight.backlightSet(systemSettings.brightness)
            backPrePage()
        }
    }
    Button{
        width:100
        height:50
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: 150
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        background:Rectangle{
            radius: 8
            color:themesTextColor2
        }
        Text{
            text:"失败"
            color:"#fff"
            font.pixelSize: 40
            anchors.centerIn: parent
        }
        onClicked: {
            containerqml.clickedLightFunc(-1)
            Backlight.backlightSet(systemSettings.brightness)
            backPrePage()
        }
    }
}

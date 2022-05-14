import QtQuick 2.7
import QtQuick.Controls 2.2
import "qrc:/pageSet"
Item{
    Item{
        width:parent.width-100
        height: parent.height
        anchors.centerIn: parent

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
            from: 40
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
        width:100+50
        height:50+50
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        background:Rectangle{
            width:100
            height:50
            anchors.centerIn: parent
            radius: 8
            color:themesTextColor2
        }
        Text{
            text:"退出"
            color:"#fff"
            font.pixelSize: 40
            anchors.centerIn: parent
        }
        onClicked: {
            Backlight.backlightSet(systemSettings.brightness)
            backPrePage()
        }
    }
}

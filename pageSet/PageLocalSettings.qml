import QtQuick 2.7
import QtQuick.Controls 2.2
import "../"
Item {
    Item {
        anchors.fill: parent
        anchors.margins: 40
        ScrollView{
            id:scrollView
            anchors.fill: parent
            contentWidth :availableWidth
            contentHeight:500
            clip: true
            ScrollBar.vertical: ScrollBar {
                parent: scrollView.parent
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.right
                anchors.leftMargin: 20

                background:Rectangle{
                    implicitWidth: 4
                    color:"#313131"
                    radius: implicitWidth / 2
                }
                contentItem: Rectangle {
                    implicitWidth: 4
                    radius: implicitWidth / 2
                    color: themesTextColor
                }
            }

            Item{
                id:light
                width:parent.width
                height: 100
                anchors.top: parent.top
                Text{
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    color:"#fff"
                    text:qsTr("亮度")
                    font.pixelSize:30
                }
                Image{
                    asynchronous:true
                    cache:false
                    source: themesPicturesPath+"icon_light_small.png"
                    anchors.right: lightSlider.left
                    anchors.rightMargin:15
                    anchors.verticalCenter: parent.verticalCenter
                }
                PageSlider {
                    id:lightSlider
                    width: 590
                    anchors.left:parent.left
                    anchors.leftMargin: 150
                    anchors.verticalCenter: parent.verticalCenter
                    stepSize: 2
                    from: 1
                    to: 255
                    value: Backlight.backlightGet()

                    onValueChanged: {
                        console.log("lightSlider:",value)
                        systemSettings.brightness=value
                    }
                }
                Image{
                    asynchronous:true
                    cache:false
                    source: themesPicturesPath+"icon_light_big.png"
                    anchors.left: lightSlider.right
                    anchors.leftMargin:15
                    anchors.verticalCenter: parent.verticalCenter
                }
                PageDivider{
                    anchors.bottom: parent.bottom
                }
            }
            Item{
                id:screenSwitch
                width:parent.width
                height: 100
                anchors.top: light.bottom
                Text{
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    color:"#fff"
                    text:qsTr("息屏")
                    font.pixelSize:30
                }
                PageSwitch {
                    anchors.left:parent.left
                    anchors.leftMargin: 720
                    anchors.verticalCenter: parent.verticalCenter
                    checked:true

                    onCheckedChanged: {
                        console.log("onCheckedChanged:", checked)
                    }
                }
                PageDivider{
                    anchors.bottom: parent.bottom
                }
            }
            Item{
                id:screen
                width:parent.width
                height: 100
                anchors.top: screenSwitch.bottom

                Text{
                    color:"#fff"
                    text:qsTr("1分钟")
                    font.pixelSize:30
                    anchors.right: screenSlider.left
                    anchors.rightMargin:15
                    anchors.verticalCenter: parent.verticalCenter
                }
                PageSlider {
                    id:screenSlider
                    width: 590
                    anchors.left:parent.left
                    anchors.leftMargin: 150
                    anchors.verticalCenter: parent.verticalCenter
                    stepSize: 1
                    from: 1
                    to: 5
                    value: systemSettings.sleepTime
                    displayText:value+"分钟"
                    onValueChanged: {
                        console.log("screenSlider:",value)
                        systemSettings.sleepTime=value
                    }
                }
                Text{
                    color:"#fff"
                    text:qsTr("5分钟")
                    font.pixelSize:30
                    anchors.left: screenSlider.right
                    anchors.leftMargin:15
                    anchors.verticalCenter: parent.verticalCenter
                }
                PageDivider{
                    anchors.bottom: parent.bottom
                }
            }
            Button{
                id:time
                width: parent.width
                height: 100
                anchors.top: screen.bottom

                PageDivider{
                    anchors.bottom: parent.bottom
                }
                background:null
                Text{
                    text:"时间"
                    color:"#fff"
                    font.pixelSize: 30
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left

                }
                Text{
                    text:"13:14"
                    color:"#fff"
                    font.pixelSize: 30
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 70
                }
                Image {
                    asynchronous:true
                    smooth:false
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 35
                    source: themesPicturesPath+"icon_more.png"
                }

                onClicked: {
                }
            }
            Button{
                width: parent.width
                height: 100
                anchors.top: time.bottom

                PageDivider{
                    anchors.bottom: parent.bottom
                }
                background:null
                Text{
                    text:"屏保"
                    color:"#fff"
                    font.pixelSize: 30
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left

                }
                Text{
                    text:"时钟"
                    color:"#fff"
                    font.pixelSize: 30
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 70
                }
                Image {
                    asynchronous:true
                    smooth:false
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 35
                    source: themesPicturesPath+"icon_more.png"
                }

                onClicked: {
                }
            }
        }
    }
}


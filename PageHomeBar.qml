import QtQuick 2.12
import QtQuick.Controls 2.5

ToolBar {
    id:root
    background: null
    //    PageFps{
    //        width: parent.width
    //        height: 20
    //        anchors.top: parent.top
    //    }
    Text {
        id: clock
        width: parent.width
        height: 55
        anchors.top: parent.top
        text: qsTr(gTimeText)
        font.pixelSize: 30
        color:themesTextColor2
        horizontalAlignment:Text.AlignHCenter
        verticalAlignment:Text.AlignVCenter
    }
    Image{
        anchors.left: parent.left
        source: themesPicturesPath+"icon_newline2.png"
    }
    Column {
        width: parent.width
        anchors.top: clock.bottom
        anchors.bottom:parent.bottom
        spacing: 0
        ToolButton {
            width: parent.width
            height:86
            background: null
            Image{
                anchors.top: parent.top
                source: themesPicturesPath+"icon_newline.png"
            }
            Image{
                anchors.centerIn: parent
                source: themesPicturesPath+(wifiConnected==true?"icon_wifi_connected.png":"icon_wifi_disconnect.png")
            }
            onClicked: {
                openWifiPage()
            }
        }
        ToolButton {
            width: parent.width
            height:86
            background: null
            Image{
                anchors.top: parent.top
                source: themesPicturesPath+"icon_newline.png"
            }
            Image{
                anchors.centerIn: parent
                source: themesPicturesPath+"icon_set.png"
            }
            onClicked: {
                if(isExistView("PageSet")==null)
                    push_page(pageSet)
            }
        }
        ToolButton {
            width: parent.width
            height:86
            background: null
            Image{
                anchors.top: parent.top
                source: themesPicturesPath+"icon_newline.png"
            }
            Image{
                visible: gTimerLeft==0
                anchors.centerIn: parent
                source: themesPicturesPath+"icon_alarm.png"
            }
            Text{
                visible: gTimerLeft>0 && flashAnimation.flash==0
                text:gTimerLeftText
                color:themesTextColor
                font.pixelSize: 24
                anchors.centerIn: parent
                PageFlashAnimation {
                    id:flashAnimation
                    running: parent.visible && timer_alarm.running==false
                }
            }
            onClicked: {
                loaderManual.sourceComponent = pageTimer
            }
        }
        ToolButton {
            width: parent.width
            height:86
            background: null
            Image{
                anchors.top: parent.top
                source: themesPicturesPath+"icon_newline.png"
            }
            Image{
                anchors.centerIn: parent
                source: themesPicturesPath+(stackView.depth>1?"icon_home.png":"icon_sleep.png")
            }
            onClicked: {
                if(stackView.depth>1)
                    backTopPage()
                else
                    screenSleep()
            }
        }
    }
}

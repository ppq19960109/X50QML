import QtQuick 2.12
import QtQuick.Controls 2.5
import "pageCook"
Item {
    Component.onCompleted: {
        var i
        var array = []
        for(i=0; i< 24; ++i) {
            array.push(i)
        }
        hourPathView.model=array
        array = []
        for(i=0; i< 60; ++i) {
            array.push(i)
        }
        minutePathView.model=array
    }
    MouseArea{
        anchors.fill: parent
    }
    //内容
    Rectangle{
        width:510
        height: 350
        anchors.centerIn: parent
        color: "#333333"
        radius: 10

        PageCloseButton {
            anchors.top:parent.top
            anchors.right:parent.right
            onClicked: {
                loaderMainHide()
            }
        }
        Text{
            color:"#fff"
            font.pixelSize: 24
            anchors.top: parent.top
            anchors.topMargin: 15
            anchors.horizontalCenter: parent.horizontalCenter
            text:qsTr("时钟设置")
        }
        PageDivider{
            width: parent.width-40
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter:row.verticalCenter
            anchors.verticalCenterOffset:-20
        }
        PageDivider{
            width: parent.width-40
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter:row.verticalCenter
            anchors.verticalCenterOffset:20
        }

        Row {
            id:row
            width: parent.width
            height:205
            anchors.top: parent.top
            anchors.topMargin: 60
            anchors.left: parent.left
            anchors.leftMargin: 30
            spacing: 10

            PageCookPathView {
                id:hourPathView
                width: 220
                height:parent.height
                currentIndex:0
                Image {
                    anchors.fill: parent
                    visible: parent.moving
                    anchors.centerIn: parent
                    source: themesPicturesPath+"steamoven/"+"roll_background.png"
                }
                Text{
                    text:qsTr("时")
                    color:themesTextColor
                    font.pixelSize: 24
                    anchors.centerIn: parent
                    anchors.horizontalCenterOffset: 50
                }
            }
            PageCookPathView {
                id:minutePathView
                width: 220
                height:parent.height
                Image {
                    anchors.fill: parent
                    visible: parent.moving
                    anchors.centerIn: parent
                    source: themesPicturesPath+"steamoven/"+"roll_background.png"
                }
                Text{
                    text:qsTr("分")
                    color:themesTextColor
                    font.pixelSize: 24
                    anchors.centerIn: parent
                    anchors.horizontalCenterOffset: 50
                }
            }
        }
        Item {
            width:105+140*2
            height: 50
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
            Button {
                width:140
                height: 50
                anchors.left: parent.left
                background: Rectangle{
                    color:themesTextColor2
                    radius: 25
                }
                Text{
                    text:qsTr("取消")
                    color:"#000"
                    font.pixelSize: 34
                    anchors.centerIn: parent
                }
                onClicked: {
                    loaderMainHide()
                }
            }
            Button {
                width:140
                height: 50
                anchors.right: parent.right
                background: Rectangle{
                    color:themesTextColor2
                    radius: 25
                }
                Text{
                    text:qsTr("确认")
                    color:"#000"
                    font.pixelSize: 34
                    anchors.centerIn: parent
                }
                onClicked: {
                    if(wifiConnected==false)
                    {
                        Backlight.setClockTime(hourPathView.currentIndex,minutePathView.currentIndex)
                        var date=new Date()
                        gHours=date.getHours()
                        gMinutes=date.getMinutes()
                    }
                    loaderMainHide()
                }
            }
        }
    }
}

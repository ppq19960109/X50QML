import QtQuick 2.12
import QtQuick.Controls 2.5

Item {
    Rectangle {
        implicitWidth: parent.width
        implicitHeight:55
        color: "#1A1A1A"
        Rectangle{
            width: parent.width
            height: 1
            anchors.bottom: parent.bottom
            color: "#3A3A3A"
        }

        ToolBar {
            implicitWidth: parent.width
            implicitHeight:parent.height

            background:null
            //back图标
            ToolButton {
                id:backBtn
                width:80
                height:parent.height
                anchors.left:parent.left
                anchors.verticalCenter: parent.verticalCenter

                background: Image{
                    asynchronous:true
                    smooth:false
                    anchors.centerIn: parent
                    source: themesPicturesPath+"back_button_background.png"
                }
                onClicked: {
                    loaderMainHide()
                }
            }

            Text{
                anchors.centerIn: parent
                color:themesTextColor2
                font.pixelSize: 30
                text: "WIFI"
            }
            ToolButton{
                width:150
                height:parent.height
                anchors.right:parent.right
                anchors.verticalCenter: parent.verticalCenter

                background:Text{
                    color:themesTextColor2
                    font.pixelSize: 30
                    anchors.centerIn:parent
                    text: "跳过"
                }

                onClicked: {
                    loaderMainHide()
                }
            }
        }
    }
    Rectangle {
        anchors.bottom: parent.bottom
        implicitWidth: parent.width
        implicitHeight: 345
        color: "#1A1A1A"

        Image {
            anchors.top:parent.top
            anchors.topMargin: 45
            anchors.horizontalCenter: parent.horizontalCenter
            source: themesPicturesPath+"icon_wifi.png"
        }

        Text{
            anchors.centerIn: parent
            color:"#fff"
            font.pixelSize: 30
            text:"连接网络 一键烹饪健康"
        }
        Button {
            width:140+10
            height:50+10
            anchors.bottom:parent.bottom
            anchors.bottomMargin: 50
            anchors.horizontalCenter: parent.horizontalCenter
            Text{
                anchors.centerIn: parent
                color:"#000"
                font.pixelSize: 30
                text:"去联网"
            }
            background: Rectangle {
                width:140
                height:50
                anchors.centerIn: parent
                color:themesTextColor2
                radius: height/2
            }
            onClicked: {
                if(isExistView("PageSet")==null)
                    push_page(pageSet,{pageSetIndex:4})
                loaderMainHide()
            }
        }
    }
}
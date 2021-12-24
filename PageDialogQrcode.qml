import QtQuick 2.0
import QtQuick.Controls 2.2
Rectangle {
    property alias hintTopText: hintTop.text
    signal cancel()
    MouseArea{
        anchors.fill: parent
        hoverEnabled:true
        propagateComposedEvents: true
        onPressed: {
            mouse.accepted = true
        }
    }
    anchors.fill: parent
    color: "transparent"
    Rectangle {
        anchors.fill: parent
        color: "#000"
        opacity: 0.6
    }
    Rectangle {
        width:640
        height: 400
        anchors.centerIn: parent
        color: "transparent"
//        radius: 16
        Image {
            anchors.fill: parent
            source: "/x50/main/圆角矩形 3209.png"
        }
        Button {
            width:closeImg.width+60
            height:closeImg.height+60
            anchors.top:parent.top
//            anchors.topMargin: 33
            anchors.right:parent.right
//            anchors.rightMargin: 33

            Image {
                id:closeImg
                anchors.centerIn: parent
                source: "/x50/icon/icon_close.png"
            }
            background: Rectangle {
                color:"transparent"
            }
            onClicked: {
                cancel()
            }
        }
        Text{
            id:hintTop
            anchors.top: parent.top
            anchors.topMargin: 40
            anchors.horizontalCenter: parent.horizontalCenter
            color:"white"
            font.pixelSize: 40
        }

        Image{
            id:qrCodeImg
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: -qrCodeImg.width/2-20
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 30
            source: "file:QrCode.png"
        }

        Text{
            anchors.top: qrCodeImg.top
            anchors.left: qrCodeImg.right
            anchors.leftMargin: 20
            anchors.right: parent.right
            color:"white"
            font.pixelSize: 35
            //                font.letterSpacing : 5
//            font.bold :true
            lineHeight: 1.5

            wrapMode:Text.WordWrap
            text:"1、下载官方APP\n2、官方APP绑定设备"
        }
    }
}

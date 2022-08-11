import QtQuick 2.7
import QtQuick.Controls 2.2
Item {
    property alias hintTopText: hintTop.text
    signal cancel()
    MouseArea{
        anchors.fill: parent
        //        hoverEnabled:true
        //        propagateComposedEvents: true
        //        onPressed: {
        //            mouse.accepted = true
        //        }
    }
    anchors.fill: parent

    Rectangle {
        width:640
        height: 400
        anchors.centerIn: parent
        color: themesPopupWindowColor
        radius: 16

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
                source: themesImagesPath+"icon-window-close.png"
            }
            background: Item {}
            onClicked: {
                cancel()
            }
        }
        Text{
            id:hintTop
            anchors.top: parent.top
            anchors.topMargin: 50
            anchors.horizontalCenter: parent.horizontalCenter
            color:"white"
            font.pixelSize: 40
        }
        Image{
            id:qrCodeImg
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: -120
            anchors.top: hintTop.bottom
            anchors.topMargin: 40
            sourceSize.width: 218
            sourceSize.height: 218
            //cache:false
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

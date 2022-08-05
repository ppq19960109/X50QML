import QtQuick 2.7
import QtQuick.Controls 2.2
Item {
    property alias hintTopText: hintTop.text
    signal cancel()
    MouseArea{
        anchors.fill: parent
    }
    anchors.fill: parent

    Rectangle {
        width:730
        height: 350
        anchors.centerIn: parent
        color: themesPopupWindowColor
        radius: 10

        PageCloseButton {
            anchors.top:parent.top
            anchors.right:parent.right
            onClicked: {
                 cancel()
            }
        }
        Text{
            id:hintTop
            anchors.top: parent.top
            anchors.topMargin: 30
            anchors.horizontalCenter: parent.horizontalCenter
            color:"white"
            font.pixelSize: 30
        }
        Image{
            id:qrcode
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: -120
            anchors.top: parent.top
            anchors.topMargin: 100
            sourceSize.width: 180
            sourceSize.height: 180
            asynchronous:true
            smooth:false
            cache:false
            source: "file:QrCode.png"
        }

        Text{
            anchors.left: qrcode.right
            anchors.leftMargin: 20
            anchors.verticalCenter: qrcode.verticalCenter
            color:"white"
            font.pixelSize: 30
            lineHeight: 1.3
            wrapMode:Text.WrapAnywhere
            text:"下载火粉APP   绑定设备\n海量智慧菜谱  一键烹饪"
        }
        Button {
            width:140+10
            height:50+10
            anchors.bottom:parent.bottom
            anchors.bottomMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
            Text{
                anchors.centerIn: parent
                color:"#000"
                font.pixelSize: 30
                text:"好的"
            }
            background: Rectangle {
                width:140
                height:50
                anchors.centerIn: parent
                color:themesTextColor2
                radius: height/2
            }
            onClicked: {
                cancel()
            }
        }
    }
}

import QtQuick 2.7
import QtQuick.Controls 2.2

Rectangle {
    property alias hintTopText: hintTop.text
    property alias hintBottomText: hintBottom.text
    property alias cancelText: cancelBtnText.text
    property alias confirmText: confirmBtnText.text
    property alias hintHeight: hint.height
    signal cancel()
    signal confirm()
    MouseArea{
        anchors.fill: parent
    }
    anchors.fill: parent
    color: "transparent"
    Rectangle {
        anchors.fill: parent
        color: "#000"
        opacity: 0.6
    }
    Rectangle {
        id:hint
        anchors.centerIn: parent
        implicitWidth: 680
        implicitHeight: 360
        color: "#596767"
        radius: 16
        PageGradient{
            anchors.fill: parent
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
            width:parent.width
            visible: hintTop.text!=""
            color:"white"
            font.pixelSize: 40
            anchors.top: parent.top
            anchors.topMargin: 50
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            wrapMode:Text.Wrap
        }

        Text{
            id:hintBottom
            visible: hintBottom.text!=""
            width:parent.width
            color:"white"
            font.pixelSize: 35
            anchors.top: parent.top
            anchors.topMargin: 130
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            wrapMode:Text.WrapAnywhere
        }
        Button {
            id:cancelBtn
            width: 175+20
            height: 65+20
            anchors.bottom:parent.bottom
            anchors.bottomMargin: 40
            anchors.left: parent.left
            anchors.leftMargin: 130
            Text{
                id:cancelBtnText
                anchors.centerIn: parent
                color:"white"
                font.pixelSize: 30
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text:"取消"
            }
            background: Rectangle {
                width:175
                height:65
                anchors.centerIn: parent
                color:"transparent"
                border.color:"#FFF"
                radius: 8
            }
            onClicked: {
                cancel()
            }
        }

        Button {
            id:confirmBtn
            width:175+20
            height:65+20
            anchors.bottom:parent.bottom
            anchors.bottomMargin: 40
            anchors.right: parent.right
            anchors.rightMargin: 130

            Text{
                id:confirmBtnText
                anchors.centerIn: parent
                color:"#00E6B6"
                font.pixelSize: 30

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            background: Rectangle {
                width:175
                height:65
                anchors.centerIn: parent
                color:"transparent"
                border.color:"#00E6B6"
                radius: 8
            }
            onClicked: {
                confirm()
            }
        }
    }
}

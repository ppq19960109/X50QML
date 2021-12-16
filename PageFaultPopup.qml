import QtQuick 2.7
import QtQuick.Controls 2.2

Rectangle {
    property alias hintTopText: hintTop.text
    property alias hintTopImgSrc:hintTopImg.source
    property alias hintCenterText: hintCenter.text
    property alias hintBottomText: hintBottom.text
    property alias hintHeight: hint.height
    signal cancel()

    anchors.fill: parent
    color: "#000"
    opacity: 0.6
    Rectangle {
        id:hint
        anchors.centerIn: parent
        implicitWidth: 600
        implicitHeight: 292
        color: "#000"
        radius: 16

        Button {
//            width:50
//            height:50
            anchors.top:parent.top
            anchors.topMargin: 33
            anchors.right:parent.right
            anchors.rightMargin: 33

            Image {
                anchors.centerIn: parent
                source: "/x50/icon/icon_close@2x.png"
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
            visible: hintTop.text!=""
            width:parent.width
            color:"white"
            font.pixelSize: 40
            anchors.top: parent.top
            anchors.topMargin: 65
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            wrapMode:Text.Wrap
        }
        Image{
            id:hintTopImg
            visible:hintTopImg.source!=""
            anchors.top: parent.top
            anchors.topMargin: 65
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text{
            id:hintCenter
            visible: hintCenter.text!=""
            width:parent.width
            color:"white"
            font.pixelSize: 40
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            wrapMode:Text.Wrap
        }
        Text{
            id:hintBottom
            visible: hintBottom.text!=""
            width:parent.width
            color:"white"
            font.pixelSize: 34
            anchors.top: parent.top
            anchors.topMargin: 145
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            wrapMode:Text.WrapAnywhere
        }
    }
}

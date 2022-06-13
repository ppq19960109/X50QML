import QtQuick 2.7
import QtQuick.Controls 2.2

Item {
    property alias hintTopImgSrc: hintTopImg.source
    property alias hintBottomText: hintBottom.text
    property alias hintHeight: hint.height
    signal cancel()
    MouseArea{
        anchors.fill: parent
    }
    anchors.fill: parent

    Rectangle {
        id:hint
        anchors.centerIn: parent
        implicitWidth: 600
        implicitHeight: 292
        color: themesPopupWindowColor
        radius: 16

        Button {
            width:closeImg.width+60
            height:closeImg.height+60
            anchors.top:parent.top
            anchors.right:parent.right
            Image {
                id:closeImg
                asynchronous:true
                smooth:false
                cache:false
                anchors.centerIn: parent
                source: themesImagesPath+"icon-window-close.png"
            }
            background: Item {}
            onClicked: {
                cancel()
            }
        }

        Image{
            id:hintTopImg
            asynchronous:true
            smooth:false
            cache:false
            visible:hintTopImg.source!=""
            anchors.top: parent.top
            anchors.topMargin: 65
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text{
            id:hintBottom
            visible: hintBottom.text!=""
            width:parent.width
            color:"white"
            font.pixelSize: 40
            anchors.top: parent.top
            anchors.topMargin: 160
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode:Text.Wrap
        }
    }
}

import QtQuick 2.7
import QtQuick.Controls 2.2

Item {
    property alias closeVisible: closeBtn.visible
    property alias hintTopText: hintTop.text
    property alias hintTopImgSrc:hintTopImg.source
    property alias hintCenterText: hintCenter.text
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
//        PageDialogGradient{
//            anchors.fill: parent
//        }
        Button {
            id:closeBtn
            visible: true
            enabled: visible
            width:closeImg.width+60
            height:closeImg.height+60
            anchors.top:parent.top
//            anchors.topMargin: 33
            anchors.right:parent.right
//            anchors.rightMargin: 33

            Image {
                id:closeImg
                asynchronous:true
                smooth:false
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
            asynchronous:true
            smooth:false
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
            anchors.topMargin: 150
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            wrapMode:Text.WrapAnywhere
        }
    }
}

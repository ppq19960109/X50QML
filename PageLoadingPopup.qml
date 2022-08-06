import QtQuick 2.7
import QtQuick.Controls 2.2

Item {
    property alias closeVisible: closeBtn.visible
    property alias hintImgSrc: hintImg.source
    property alias hintText: hintBottomText.text
    property alias hintWidth: hint.width
    property alias hintHeight: hint.height
    signal cancel()
    MouseArea{
        anchors.fill: parent
    }
    anchors.fill: parent

    Rectangle {
        id:hint
        anchors.centerIn: parent
        implicitWidth: 730
        implicitHeight: 350
        color: themesPopupWindowColor
        radius: 10

        PageCloseButton {
            id:closeBtn
            anchors.top:parent.top
            anchors.right:parent.right
            onClicked: {
                cancel()
            }
        }

        PageRotationImg {
            id:hintImg
            visible:hintImg.source!=""
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -60
            source: themesPicturesPath+"icon_loading_big.png"
        }
        Text{
            id:hintBottomText
            visible: hintBottomText.text!=""
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 40
            color:"white"
            font.pixelSize: 30
            wrapMode:Text.WrapAnywhere
        }
    }
}

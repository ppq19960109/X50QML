import QtQuick 2.7
import QtQuick.Controls 2.2
import "qrc:/SendFunc.js" as SendFunc
Item {
    property alias topImageSrc: topImage.source
    property alias hintTopText: hintTop.text
    property alias hintBottomText: hintBottom.text
    property alias cancelText: cancelBtnText.text
    property alias confirmText: confirmBtnText.text
    property alias hintHeight: hint.height
    signal cancel(int index)
    signal confirm()

    MouseArea{
        anchors.fill: parent
    }
    anchors.fill: parent

    Rectangle {
        id:hint
        anchors.centerIn: parent
        implicitWidth: 820
        implicitHeight: 350
        color: themesPopupWindowColor
        radius: 10

        PageCloseButton {
            anchors.top:parent.top
            anchors.right:parent.right
            onClicked: {
                cancel(0)
            }
        }
        Image {
            id:topImage
            anchors.top:parent.top
            anchors.topMargin: 34
            anchors.horizontalCenter: parent.horizontalCenter
            asynchronous:true
            smooth:false
            source: themesPicturesPath+"icon_error.png"
        }
        Text{
            id:hintTop
            visible: hintTop.text!=""
            width:parent.width
            color:"white"
            font.pixelSize: 40
            anchors.top: parent.top
            anchors.topMargin: 115
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode:Text.WrapAnywhere
        }

        Text{
            id:hintBottom
            visible: hintBottom.text!=""
            width:parent.width
            color:"white"
            font.pixelSize: 35
            anchors.top: parent.top
            anchors.topMargin: 175
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode:Text.WrapAnywhere
        }
        Button {
            id:cancelBtn
            visible: cancelBtnText.text!=""
            width:140+10
            height:50+10
            anchors.bottom:parent.bottom
            anchors.bottomMargin: 25
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: -130
            Text{
                id:cancelBtnText
                anchors.centerIn: parent
                color:"#000"
                font.pixelSize: 30
                text:""
            }
            background: Rectangle {
                width:140
                height:50
                anchors.centerIn: parent
                color:themesTextColor2
                radius: height/2
            }
            onClicked: {
                cancel(1)
            }
        }
        Button {
            width:140+10
            height:50+10
            anchors.bottom:parent.bottom
            anchors.bottomMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: cancelBtn.visible ? 130 : 0
            Text{
                id:confirmBtnText
                anchors.centerIn: parent
                color:"#000"
                font.pixelSize: 30
                text:""
            }
            background: Rectangle {
                width:140
                height:50
                anchors.centerIn: parent
                color:themesTextColor2
                radius: height/2
            }
            onClicked: {
                confirm()
            }
        }
    }
}

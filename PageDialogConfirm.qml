import QtQuick 2.12
import QtQuick.Controls 2.5

Item {
    property int cookWorkPos:0
    property alias topImageSrc: topImage.source
    property alias hintTopText: hintTop.text
    property alias hintCenterText: hintCenter.text
    property alias cancelText: cancelBtnText.text
    property alias confirmText: confirmBtnText.text
    property alias hintWidth: hint.width
    property alias hintHeight: hint.height
    property int confirmBtnWidth:0
    property int cancelBtnWidth:0

    signal cancel(int index)
    signal confirm()
    MouseArea{
        anchors.fill: parent
    }
    anchors.fill: parent
    Rectangle{
        anchors.fill: parent
        color: "#000"
        opacity: 0.6
    }
    Rectangle {
        id:hint
        anchors.centerIn: parent
        implicitWidth: 730
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
            visible: hintTop.text==""
            anchors.top:parent.top
            anchors.topMargin: 45
            anchors.horizontalCenter: parent.horizontalCenter
            source: themesPicturesPath+"icon_warn.png"
        }

        Text{
            id:hintTop
            visible: text!=""
            width:parent.width
            anchors.top: parent.top
            anchors.topMargin: 35
            color:"#fff"
            font.pixelSize: 30
            horizontalAlignment: Text.AlignHCenter
            wrapMode:Text.WrapAnywhere
            text:""
        }

        Text{
            id:hintCenter
            visible: text!=""
            width:parent.width-60
            anchors.centerIn: parent
            color:"#fff"
            font.pixelSize: 30
            horizontalAlignment: Text.AlignHCenter
            wrapMode:Text.WrapAnywhere
            lineHeight:1.3
            text:""
        }
        Button {
            id:cancelBtn
            visible: cancelBtnText.text!=""
            width:140+10+cancelBtnWidth
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
                width:140+cancelBtnWidth
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
            width:140+10+confirmBtnWidth
            height:50+10
            anchors.bottom:parent.bottom
            anchors.bottomMargin: 25
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
                width:140+confirmBtnWidth
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

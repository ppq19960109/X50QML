import QtQuick 2.12
import QtQuick.Controls 2.5

Item {
    property alias hintTopText: hintTop.text
    property alias hintBottomText: hintBottom.text
    property alias cancelText: cancelBtnText.text
    property alias confirmText: confirmBtnText.text
    property alias hintWidth: hint.width
    property alias hintHeight: hint.height
    property alias closeBtnVisible: closeBtn.visible
    signal cancel(int flag)
    signal confirm()
    MouseArea{
        anchors.fill: parent
    }
    anchors.fill: parent

    Rectangle {
        id:hint
        anchors.centerIn: parent
        implicitWidth: 680
        implicitHeight: 360
        color: themesPopupWindowColor
        radius: 16
        //        PageGradient{
        //            anchors.fill: parent
        //        }
        Button {
            id:closeBtn
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
                cancel(0)
            }
        }

        Text{
            id:hintTop
            width:parent.width
            visible: hintTop.text!=""
            color:"#FFF"
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
            color:"#FFF"
            font.pixelSize: 35
            anchors.top: parent.top
            anchors.topMargin: 130
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            lineHeight :1.1
            wrapMode:Text.WrapAnywhere
        }
        Button {
            id:cancelBtn
            visible: confirmBtnText.text!=""
            width: 176+15
            height: 64+15
            anchors.bottom:parent.bottom
            anchors.bottomMargin: 40
            anchors.left: parent.left
            anchors.leftMargin: 105
            Text{
                id:cancelBtnText
                anchors.centerIn: parent
                color:themesTextColor2
                font.pixelSize: 30
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text:"取消"
            }
            background: Rectangle {
                width:176
                height:64
                anchors.centerIn: parent
                color:"transparent"
                border.color:themesTextColor2
                radius: 32
            }
            onClicked: {
                cancel(1)
            }
        }

        Button {
            id:confirmBtn
            visible: confirmBtnText.text!=""
            width:176+15
            height:64+15
            anchors.bottom:parent.bottom
            anchors.bottomMargin: 40
            anchors.right: parent.right
            anchors.rightMargin: 105

            Text{
                id:confirmBtnText
                anchors.centerIn: parent
                color:"#000"
                font.pixelSize: 30

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            background: Rectangle {
                width:176
                height:64
                anchors.centerIn: parent
                color:themesTextColor2
                radius: 32
            }
            onClicked: {
                confirm()
            }
        }
    }
}

import QtQuick 2.7
import QtQuick.Controls 2.2

Item {
    property alias hintTopText: hintTop.text
    property alias hintCenterText: hintCenter.text
    property alias confirmText: confirmBtnText.text
    property alias hintHeight: hint.height
    property var confirmFunc:null
    signal cancel()
    signal confirm()
    MouseArea{
        anchors.fill: parent
    }
    anchors.fill: parent

    Rectangle {
        id:hint
        anchors.centerIn: parent
        implicitWidth: 600
        implicitHeight: 305
        color: themesPopupWindowColor
        radius: 16
        //        PageGradient{
        //            anchors.fill: parent
        //        }
        Button {
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
                cache:false
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
            width:parent.width
            visible: hintTop.text!=""
            color:"white"
            font.pixelSize: 34
            anchors.top: parent.top
            anchors.topMargin: 70
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            lineHeight :1.2
            wrapMode:Text.WrapAnywhere
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

        Button {
            id:confirmBtn
            visible: confirmBtnText.text!=""
            width:176+15
            height:64+15
            anchors.bottom:parent.bottom
            anchors.bottomMargin: 45
            anchors.horizontalCenter: parent.horizontalCenter

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
                if(confirmFunc!=null)
                    confirmFunc()
            }
        }
    }
}

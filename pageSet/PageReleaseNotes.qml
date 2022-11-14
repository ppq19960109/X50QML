import QtQuick 2.12
import QtQuick.Controls 2.5
import "../"
Item {
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
            anchors.top:parent.top
            anchors.right:parent.right
            onClicked: {
                loaderMainHide()
            }
        }
        Text{
            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
            text:"V"+get_current_version()+" 更新日志"
            color:"#fff"
            font.pixelSize: 30
        }

        PageScrollBarText{
            width: parent.width-120
            height: 190
            anchors.top: parent.top
            anchors.topMargin: 75
            anchors.horizontalCenter: parent.horizontalCenter
            text:QmlDevState.state.UpdateLog
        }
        Button {
            width:140+10
            height:50+10
            anchors.bottom:parent.bottom
            anchors.bottomMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
            Text{
                id:confirmBtnText
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
                loaderMainHide()
            }
        }
    }
}

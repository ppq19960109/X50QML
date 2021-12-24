import QtQuick 2.2
import QtQuick.Controls 2.2
import "../"
Item {
    Component.onCompleted: {


    }
    Image {
        anchors.fill: parent
        source: "/x50/main/背景.png"
    }
    PageBackBar{
        id:topBar
        width:parent.width
        anchors.bottom:parent.bottom
        height:80
        name:qsTr("版本说明")
        leftBtnText:qsTr("")
        rightBtnText:qsTr("")
        onClose:{
            backPrePage()
        }
    }

    Rectangle{
        width:parent.width
        anchors.bottom:topBar.top
        anchors.top: parent.top

        color:"transparent"
        Text{
            id:version
            text:QmlDevState.state.SoftVersion+"\n更新日志\n"
            color:"#fff"
            font.pixelSize: 35
            lineHeight:1.2
            anchors.left: parent.left
            anchors.leftMargin: 50
            anchors.top: parent.top
            anchors.topMargin: 60
            wrapMode:Text.Wrap
        }
    }
}

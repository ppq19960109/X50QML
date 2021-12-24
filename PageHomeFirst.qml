import QtQuick 2.2
import QtQuick.Controls 2.2

Item {
    //    width:parent.width
    //    height: parent.height
    anchors.fill: parent

    Row {
        anchors.fill: parent
        anchors.topMargin: 50
        anchors.bottomMargin: 50
        spacing: 10
        anchors.leftMargin: 75
        anchors.rightMargin: 75

        Button{
            width: 325
            height:parent.height
            Image {
                anchors.fill: parent
                source: "qrc:/x50/main/圆角矩形 3209.png"
            }
            background:Rectangle{
                color:"transparent"
                radius: 16
            }
            Text{
                color:"#FFF"
                text:qsTr("左腔")
                font.pixelSize:50
                anchors.top: parent.top
                anchors.topMargin: 30
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Text{
                color:"#FFF"
                text:qsTr("蒸烤一体")
                font.pixelSize:32
                anchors.top: parent.top
                anchors.topMargin: 100
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Image {
                anchors.bottom: parent.bottom
                anchors.bottomMargin: -30
                anchors.horizontalCenter: parent.horizontalCenter
                source: "qrc:/x50/main/烤鸡.png"
            }
            onClicked: {
                load_page("pageSteamBakeBase",JSON.stringify({"device":leftDevice}))
            }
        }
        Button{
            width: 325
            height:parent.height
            Image {
                anchors.fill: parent
                source: "qrc:/x50/main/圆角矩形 3209.png"
            }
            background:Rectangle{
                color:"transparent"
                radius: 16
            }
            Text{
                color:"#FFF"
                text:qsTr("右腔")
                font.pixelSize:50
                anchors.top: parent.top
                anchors.topMargin: 30
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Text{
                color:"#FFF"
                text:qsTr("便捷速蒸")
                font.pixelSize:32
                anchors.top: parent.top
                anchors.topMargin: 100
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Image {
                anchors.bottom: parent.bottom
                anchors.bottomMargin: -30
                anchors.horizontalCenter: parent.horizontalCenter
                source: "qrc:/x50/main/icon_蒸包子.png"
            }
            onClicked: {
                load_page("pageSteamBakeBase",JSON.stringify({"device":rightDevice}))
            }
        }
    }
}

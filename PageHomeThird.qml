import QtQuick 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.1

Item {
    width:parent.width
    height: parent.height
    //        anchors.fill: parent
    Row {
        anchors.fill: parent
        anchors.topMargin: 40
        anchors.leftMargin: 60

        spacing: 0

        Button{
            width: 225
            height:parent.height

            background:Rectangle{
                radius: 10
                color:"transparent"
            }
            Image {
                source: "qrc:/x50/main/定时关火.png"
            }
            Text{
                text:"定时关火"
                color:"#FFF"
                font.pixelSize: 40
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 55
            }

            onClicked: {
                load_page("pageCloseHeat")
            }
        }

        Button{
            width: 225
            height:parent.height
            background:Rectangle{
                radius: 10
                color:"transparent"
            }
            Image {
                source: "qrc:/x50/main/设置.png"
            }
            Text{
                text:"设置"
                color:"#FFF"
                font.pixelSize: 40
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 55
            }

            onClicked: {
                load_page("pageSet")
            }
        }

    }
}

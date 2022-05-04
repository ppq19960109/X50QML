import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Item {
    anchors.fill: parent
    Row {
        width: parent.width-120
        anchors.centerIn: parent

        spacing: 20

        Button{
            width: 210
            height:312

            background:Image {
                asynchronous:true
                smooth:false
                source: themesImagesPath+"homethird-button1-background.png"
            }
            Text{
                text:"定时关火"
                color:"#FFF"
                font.pixelSize: 40
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 45
            }

            onClicked: {
                load_page("pageCloseHeat")
            }
        }

        Button{
            width: 210
            height:312
            background:Image {
                asynchronous:true
                smooth:false
                source: themesImagesPath+"homethird-button2-background.png"
            }
            Text{
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 45
                color:"#FFF"
                font.pixelSize: 40
                text:qsTr("设置")
            }

            onClicked: {
                load_page("pageSet")
            }
        }

    }
}

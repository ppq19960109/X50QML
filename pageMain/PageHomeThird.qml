import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Item {
    anchors.fill: parent
    Row {
        anchors.fill: parent
        anchors.leftMargin: 60
        anchors.topMargin: 40
        spacing: 0

        Button{
            width: 225
            height:325

            background:Image {
                asynchronous:true
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
            height:325
            background:Image {
                asynchronous:true
                source: "qrc:/x50/main/设置.png"
            }
            Text{
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 55
                color:"#FFF"
                font.pixelSize: 40
                text:qsTr("设置")
            }

            onClicked: {
                load_page("pageSet")
            }
        }

        //        Button{
        //            width: 225
        //            height:325
        //            background:Image {
        //        asynchronous:true
        //                source: "qrc:/x50/main/设置.png"
        //            }
        //            Text{
        //                text:"主题"
        //                color:"#FFF"
        //                font.pixelSize: 40
        //                anchors.horizontalCenter: parent.horizontalCenter
        //                anchors.top: parent.top
        //                anchors.topMargin: 55
        //            }

        //            onClicked: {
        //                load_page("pageThemes")
        //            }
        //        }

    }
}

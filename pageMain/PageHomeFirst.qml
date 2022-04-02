import QtQuick 2.7
import QtQuick.Controls 2.2
//import QtQuick.Controls.Material 2.2
//import QtQuick.Controls.Universal 2.2

Item {
    anchors.fill: parent

    Row {
        anchors.fill: parent
        spacing: 10
        anchors.leftMargin: 70
        anchors.rightMargin: 70

        Button{
            width: 325
            height:width
            anchors.verticalCenter: parent.verticalCenter
            //            highlighted: true
            //             Material.accent: Material.Green
            //             Universal.accent: Universal.Indigo

            background:Image {
                anchors.fill: parent
                asynchronous:true
                source: themesImagesPath+"homefirst-button-background.png"
            }
            Item {
                anchors.fill: parent
                Text{
                    color:"#FFF"
                    text:"左腔蒸烤"
                    font.pixelSize:50
                    anchors.top: parent.top
                    anchors.topMargin: 50
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Image {
                    asynchronous:true
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: -30
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: "qrc:/x50/main/烤鸡.png"
                }
            }
            onClicked: {
                load_page("pageSteamBakeBase",JSON.stringify({"device":leftDevice}))
            }
        }
        Button{
            width: 325
            height:width
            anchors.verticalCenter: parent.verticalCenter

            background:Image {
                asynchronous:true
                anchors.fill: parent
                source: themesImagesPath+"homefirst-button-background.png"
            }

            Item {
                anchors.fill: parent
                Text{
                    anchors.top: parent.top
                    anchors.topMargin: 50
                    anchors.horizontalCenter: parent.horizontalCenter
                    color:"#FFF"
                    font.pixelSize:50
                    text:qsTr("右腔速蒸")
                }
                Image {
                    asynchronous:true
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: -30
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: "qrc:/x50/main/icon_蒸包子.png"
                }
            }
            onClicked: {
                load_page("pageSteamBakeBase",JSON.stringify({"device":rightDevice}))
            }
        }
    }
}

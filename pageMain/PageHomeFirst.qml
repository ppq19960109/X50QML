import QtQuick 2.12
import QtQuick.Controls 2.5
//import QtQuick.Controls.Material 2.2
//import QtQuick.Controls.Universal 2.2

Item {
//    anchors.fill: parent
//    width: 800
//    height: 400
    Row {
        anchors.centerIn: parent
        spacing: 40

        Button{
            width: 324
            height:312
//            anchors.verticalCenter: parent.verticalCenter
            //            highlighted: true
            //             Material.accent: Material.Green
            //             Universal.accent: Universal.Indigo

            background:Image {
                anchors.fill: parent
                smooth:false
                asynchronous:true
                source: themesImagesPath+"homefirst-button1-background.png"
            }

            Image {
                asynchronous:true
                smooth:false
                anchors.top: parent.top
                anchors.topMargin: 40
                anchors.horizontalCenter: parent.horizontalCenter
                source: themesImagesPath+"homefirst-button1-image.png"
            }

            onClicked: {
                load_page("pageSteamBakeBase",{"device":cookWorkPosEnum.LEFT})
            }
        }
        Button{
            width: 324
            height:312
//            anchors.verticalCenter: parent.verticalCenter

            background:Image {
                asynchronous:true
                smooth:false
                anchors.fill: parent
                source: themesImagesPath+"homefirst-button2-background.png"
            }

            Image {
                asynchronous:true
                smooth:false
                anchors.top: parent.top
                anchors.topMargin: 40
                anchors.horizontalCenter: parent.horizontalCenter
                source: themesImagesPath+"homefirst-button2-image.png"
            }

            onClicked: {
                load_page("pageSteamBakeBase",{"device":cookWorkPosEnum.RIGHT})
            }
        }
    }
}

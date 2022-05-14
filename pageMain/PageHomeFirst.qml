import QtQuick 2.7
import QtQuick.Controls 2.2
//import QtQuick.Controls.Material 2.2
//import QtQuick.Controls.Universal 2.2

Item {
    anchors.fill: parent

    Row {
        anchors.centerIn: parent
        spacing: 40

        Button{
            width: 324
            height:312
            anchors.verticalCenter: parent.verticalCenter
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
                anchors.topMargin: 42
                anchors.horizontalCenter: parent.horizontalCenter
                source: themesImagesPath+"homefirst-button1-image.png"
            }

            onClicked: {
                load_page("pageSteamBakeBase",JSON.stringify({"device":leftDevice}))
            }
        }
        Button{
            width: 324
            height:312
            anchors.verticalCenter: parent.verticalCenter

            background:Image {
                asynchronous:true
                smooth:false
                anchors.fill: parent
                source: themesImagesPath+"homefirst-button2-background.png"
            }

//            Image {
//                asynchronous:true
//                smooth:false
//                anchors.top: parent.top
//                anchors.topMargin: 31
//                anchors.horizontalCenter: parent.horizontalCenter
//                source: themesImagesPath+"homefirst-button2-image.png"
//            }
            Text{
                text:"右腔冰蒸"
                color:"#fff"
                font.pixelSize: 50
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 31
            }

            onClicked: {
                load_page("pageMultistageIce")
//                load_page("pageSteamBakeBase",JSON.stringify({"device":rightDevice}))
            }
        }
    }
}

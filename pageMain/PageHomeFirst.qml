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
            width: 300
            height:width
            anchors.verticalCenter: parent.verticalCenter
            //            highlighted: true
            //             Material.accent: Material.Green
            //             Universal.accent: Universal.Indigo

            background:Image {
                anchors.fill: parent
                asynchronous:true
                source: themesImagesPath+"homefirst-button1-background.png"
            }

            Image {
                asynchronous:true
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
            width: 300
            height:width
            anchors.verticalCenter: parent.verticalCenter

            background:Image {
                asynchronous:true
                anchors.fill: parent
                source: themesImagesPath+"homefirst-button2-background.png"
            }

                Image {
                    asynchronous:true
                    anchors.top: parent.top
                    anchors.topMargin: 42
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: themesImagesPath+"homefirst-button2-image.png"
                }

            onClicked: {
                load_page("pageSteamBakeBase",JSON.stringify({"device":rightDevice}))
            }
        }
    }
}

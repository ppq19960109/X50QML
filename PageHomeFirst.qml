import QtQuick 2.2
import QtQuick.Controls 2.2


Item {
    width:parent.width
    height: parent.height
    //        anchors.fill: parent
    Row {
        anchors.fill: parent
        anchors.topMargin: 20
        spacing: 30
        anchors.leftMargin: (parent.width-steam.width-bake.width-spacing)/2

        Button{
            id:steam
            width: 357
            height:parent.height

            background:Rectangle{
                color:"transparent"
            }

            Image{
                source: "images/main_menu/zheng_bj.png"
                anchors.fill: parent
            }

            Text{
                color:"#fff"
                text:qsTr("蒸箱")
                font.pixelSize:fontSize
                anchors.bottom:parent.bottom
                anchors.bottomMargin: 20
                anchors.horizontalCenter:parent.horizontalCenter
            }

            onClicked: {
                load_page("PageSteamBakeBase")
            }
        }
        Button{
            id:bake
            width: 357
            height:parent.height

            background:Rectangle{
                color:"transparent"
                Image{
                    source: "images/main_menu/kao_bj.png"
                    anchors.fill: parent
                }
            }
            Text{
                color:"#fff"
                text:qsTr("烤箱")
                font.pixelSize:fontSize
                anchors.bottom:parent.bottom
                anchors.bottomMargin: 20
                anchors.horizontalCenter:parent.horizontalCenter
            }

        }
    }
}

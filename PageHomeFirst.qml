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
        spacing: 48
        anchors.leftMargin: 72
        anchors.rightMargin: 80

        Button{
            width: 300
            height:parent.height

            background:Rectangle{
                color:"#fff"
                radius: 10
            }

            Text{
                color:"#000"
                text:qsTr("左腔蒸烤")
                font.pixelSize:40
                anchors.centerIn: parent
            }

            onClicked: {
                load_page("pageSteamBakeBase",JSON.stringify({"device":0}))
            }
        }
        Button{

            width: 300
            height:parent.height

            background:Rectangle{
                color:"#fff"
                radius: 10
            }
            Text{
                color:"#000"
                text:qsTr("右腔速蒸")
                font.pixelSize:40
                anchors.centerIn: parent
            }
            onClicked: {
                load_page("pageSteamBakeBase",JSON.stringify({"device":1}))
            }
        }
    }
}

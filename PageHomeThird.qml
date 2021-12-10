import QtQuick 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.1

Item {
    width:parent.width
    height: parent.height
    //        anchors.fill: parent
    Row {
        anchors.fill: parent
        anchors.topMargin: 50
        anchors.bottomMargin: 50
        anchors.leftMargin: 76
        anchors.rightMargin: 76
        spacing: 30

        Button{
            width: 196
            height:parent.height

            background:Rectangle{
                radius: 10
                color:"#fff"
            }

            Text{
                text:"定时关火"
                color:"#000"
                font.pixelSize: 40
                anchors.centerIn: parent
            }

            onClicked: {
                load_page("pageCloseHeat")
            }
        }

        Button{
            width: 196
            height:parent.height
            background:Rectangle{
                radius: 10
                color:"#fff"
            }
            Text{
                text:"设置"
                color:"#000"
                font.pixelSize: 40
                anchors.centerIn: parent
            }

            onClicked: {
                load_page("pageSet")
            }
        }

    }
}

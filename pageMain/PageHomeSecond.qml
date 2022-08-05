import QtQuick 2.7
import QtQuick.Controls 2.2

Item {
//    anchors.fill: parent
//    width: 800
//    height: 400
    Row {
        anchors.centerIn: parent
        spacing: 20
        Button{
            width: 210
            height:312
//            anchors.verticalCenter: parent.verticalCenter

            background:Image {
                asynchronous:true
                smooth:false
                source: themesImagesPath+"homesecond-button1-background.png"
            }
            Text{
                text:"智慧菜谱"
                color:"#fff"
                font.pixelSize: 40
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 45
            }

            onClicked: {
                load_page("pageSmartRecipes")
            }
        }

        Button{
            width: 210
            height:312
//            anchors.verticalCenter: parent.verticalCenter

            background:Image {
                asynchronous:true
                smooth:false
                source: themesImagesPath+"homesecond-button2-background.png"
            }
            Text{
                text:"烹饪历史"
                color:"#fff"
                font.pixelSize: 40
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 45
            }

            onClicked: {
                load_page("pageCookHistory")
            }
        }

        Button{
            width: 210
            height:312
//            anchors.verticalCenter: parent.verticalCenter

            background:Image {
                asynchronous:true
                smooth:false
                source: themesImagesPath+"homesecond-button3-background.png"
            }
            Text{
                text:"多段烹饪"
                color:"#fff"
                font.pixelSize: 40
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 45
            }

            onClicked: {
                load_page("pageMultistageSet")
            }
        }
    }
}

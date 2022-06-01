import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Item {
//    anchors.fill: parent
//    width: 800
//    height: 400
    RowLayout {
        anchors.fill: parent

        anchors.leftMargin: 60
        anchors.rightMargin: 60

        spacing: 20
        Button{
            Layout.preferredWidth: 210
            Layout.preferredHeight:312
            Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter

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
            Layout.preferredWidth: 210
            Layout.preferredHeight:312
            Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter

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
                load_page("pageCookHistory",JSON.stringify({"device":cookWorkPosEnum.ALL}))
            }
        }

        Button{
            Layout.preferredWidth: 210
            Layout.preferredHeight:312
            Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter

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

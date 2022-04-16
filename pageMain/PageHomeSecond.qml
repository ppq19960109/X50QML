import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Item {
    anchors.fill: parent
    RowLayout {
        anchors.fill: parent

        anchors.leftMargin: 70
        anchors.rightMargin: 70

        spacing: 0
        Button{
            Layout.preferredWidth: 196
            Layout.preferredHeight:300
            Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter

            background:Image {
                asynchronous:true
                source: themesImagesPath+"homesecond-button1-background.png"
            }
            Text{
                text:"智能菜谱"
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
            Layout.preferredWidth: 196
            Layout.preferredHeight:300
            Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter

            background:Image {
                asynchronous:true
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
                load_page("pageCookHistory",JSON.stringify({"device":allDevice}))
            }
        }

        Button{
            Layout.preferredWidth: 196
            Layout.preferredHeight:300
            Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter

            background:Image {
                asynchronous:true
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

import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Item {
    anchors.fill: parent
    RowLayout {
        anchors.fill: parent

        anchors.leftMargin: 60
        anchors.rightMargin: 60

        spacing: 0
        Button{
            Layout.preferredWidth: 225
            Layout.preferredHeight:325
            Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter

            background:Image {
                asynchronous:true
                source: "qrc:/x50/main/智慧菜谱.png"
            }
            Text{
                text:"智能菜谱"
                color:"#fff"
                font.pixelSize: 40
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 55
            }

            onClicked: {
                load_page("pageSmartRecipes")
            }
        }

        Button{
            Layout.preferredWidth: 225
            Layout.preferredHeight:325
            Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter

            background:Image {
                asynchronous:true
                source: "qrc:/x50/main/烹饪历史.png"
            }
            Text{
                text:"烹饪历史"
                color:"#fff"
                font.pixelSize: 40
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 55
            }

            onClicked: {
                load_page("pageCookHistory",JSON.stringify({"device":allDevice}))
            }
        }

        Button{
            Layout.preferredWidth: 225
            Layout.preferredHeight:325
            Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter

            background:Image {
                asynchronous:true
                source: "qrc:/x50/main/多段烹饪.png"
            }
            Text{
                text:"多段烹饪"
                color:"#fff"
                font.pixelSize: 40
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 55
            }

            onClicked: {
                load_page("pageMultistageSet")
            }
        }
    }
}

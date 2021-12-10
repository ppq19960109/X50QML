import QtQuick 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.1

Item {
    width:parent.width
    height: parent.height
    //        anchors.fill: parent
    RowLayout {
        anchors.fill: parent
        anchors.topMargin: 50
        anchors.bottomMargin: 50
        anchors.leftMargin: 76
        anchors.rightMargin: 76
        spacing: 30
        Button{
            Layout.preferredWidth: 196
            Layout.preferredHeight:parent.height
            Layout.alignment: Qt.AlignHCenter

            background:Rectangle{
                radius: 10
                color:"#fff"
            }
            Text{
                text:"智能菜谱"
                color:"#000"
                font.pixelSize: 40
                anchors.centerIn: parent
            }

            onClicked: {
                 load_page("pageSmartRecipes")
            }
        }

        Button{
            Layout.preferredWidth: 196
            Layout.preferredHeight:parent.height
            Layout.alignment: Qt.AlignHCenter
            background:Rectangle{
                radius: 10
                color:"#fff"
            }

            Text{
                text:"烹饪历史"
                color:"#000"
                font.pixelSize: 40
                anchors.centerIn: parent
            }

            onClicked: {
                load_page("pageCookHistory")
            }
        }

        Button{
            Layout.preferredWidth: 196
            Layout.preferredHeight:parent.height
            Layout.alignment: Qt.AlignHCenter

            background:Rectangle{
                radius: 10
                color:"#fff"
            }

            Text{
                text:"多段烹饪"
                color:"#000"
                font.pixelSize: 40
                anchors.centerIn: parent
            }

            onClicked: {
                load_page("pageSteamBakeMultistage")
            }
        }
    }
}

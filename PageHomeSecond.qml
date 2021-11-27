import QtQuick 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.1

Item {
    width:parent.width
    height: parent.height
    //        anchors.fill: parent
    RowLayout {
        anchors.fill: parent
        anchors.topMargin: 20
        anchors.leftMargin: 50
        anchors.rightMargin: 50

        Button{
            id:smartRecipe
            Layout.preferredWidth: 210
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
            id:cookHistroy
            Layout.preferredWidth: 210
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
            id:multistageCooking
            Layout.preferredWidth: 210
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

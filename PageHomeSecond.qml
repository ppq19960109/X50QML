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


        Button{
            id:smartRecipe
            //            width: 235
            //            height:parent.height
            Layout.preferredWidth: 240
            Layout.preferredHeight:parent.height
            Layout.alignment: Qt.AlignHCenter

            background:Rectangle{
                color:"transparent"
            }

            Image{
                source: "images/main_menu/zhinengcaipu.png"
            }
            Text{
                text:"智能菜谱"
                color:"#fff"
                font.pixelSize: fontSize
                anchors.bottom:parent.bottom
                anchors.bottomMargin: 60
                anchors.horizontalCenter:parent.horizontalCenter
            }

            onClicked: {
                //            load_page("pageSetupCookBook")
            }
        }

        Button{
            id:myRecond
            //            width: 235
            //            height:parent.height
            Layout.preferredWidth: 240
            Layout.preferredHeight:parent.height
            Layout.alignment: Qt.AlignHCenter
            background:Rectangle{
                color:"transparent"
                Image{
                    source: "images/main_menu/wodejilu.png"
                }
            }

            Text{
                text:"我的记录"
                color:"#fff"
                font.pixelSize: fontSize
                anchors.bottom:parent.bottom
                anchors.bottomMargin: 60
                anchors.horizontalCenter:parent.horizontalCenter
            }

            onClicked: {
                //                load_page("pageMyCookRecord")
            }
        }

        Button{
            id:setCenter
            //            width: 235
            //            height:parent.height
            Layout.preferredWidth: 240
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

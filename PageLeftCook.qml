import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
Item {

    Component.onCompleted: {


    }
    Component.onDestruction: {
        console.log("PageLeftCook onDestruction")
    }
    ToolBar {
        id:topBar
        width:parent.width
        anchors.bottom:parent.bottom
        height:96
        background:Rectangle{
            color:"#000"
        }

        //back图标
        TabButton {
            id:goBack
            width:80
            height:parent.height
            anchors.left:parent.left
            anchors.verticalCenter: parent.verticalCenter
            Image{
                anchors.centerIn: parent
                source: "/images/fanhui.png"
            }
            background: Rectangle {
                opacity: 0
            }
            onClicked: {
               closeLoaderMain()
            }
        }

    }
    //内容
    Rectangle{
        width:parent.width
        anchors.bottom:topBar.top
        anchors.top: parent.top

        color:"#000"

        GridLayout{
            width:parent.width-60
            height: parent.height-50
            anchors.centerIn: parent
            rows: 2
            columns: 2
            rowSpacing: 10
            columnSpacing: 10

            Button{
                Layout.preferredWidth: 220
                Layout.preferredHeight:160
                Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter
                background:Rectangle{
                    radius: 10
                    color:"#fff"
                }
                Text{
                    text:"左腔烹饪"
                    color:"#000"
                    font.pixelSize: 35
                    anchors.centerIn: parent
                }

                onClicked: {
                    closeLoaderMain()
                    load_page("pageSteamBakeBase",JSON.stringify({"device":leftDevice}))
                }
            }
            Button{
                Layout.preferredWidth: 220
                Layout.preferredHeight:160
                Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter
                background:Rectangle{
                    radius: 10
                    color:"#fff"
                }
                Text{
                    text:"智慧菜谱"
                    color:"#000"
                    font.pixelSize: 35
                    anchors.centerIn: parent
                }

                onClicked: {
                    closeLoaderMain()
                    load_page("pageSmartRecipes")
                }
            }
            Button{
                Layout.preferredWidth: 220
                Layout.preferredHeight:160
                Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter
                background:Rectangle{
                    radius: 10
                    color:"#fff"
                }
                Text{
                    text:"烹饪历史"
                    color:"#000"
                    font.pixelSize: 35
                    anchors.centerIn: parent
                }

                onClicked: {
                    closeLoaderMain()
                    load_page("pageCookHistory",JSON.stringify({"device":leftDevice}))
                }
            }
            Button{
                Layout.preferredWidth: 220
                Layout.preferredHeight:160
                Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter
                background:Rectangle{
                    radius: 10
                    color:"#fff"
                }
                Text{
                    text:"多段烹饪"
                    color:"#000"
                    font.pixelSize: 35
                    anchors.centerIn: parent
                }

                onClicked: {
                    closeLoaderMain()
                    load_page("pageSteamBakeMultistage")
                }
            }

        }
    }
}


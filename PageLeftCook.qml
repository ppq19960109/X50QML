import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
Item {

    Component.onCompleted: {


    }
    Component.onDestruction: {
        console.log("PageLeftCook onDestruction")
    }
    Image {
        anchors.fill: parent
        source: "/x50/main/背景.png"
    }
    PageBackBar{
        id:topBar
        width:parent.width
        anchors.bottom:parent.bottom
        height:80
        name:qsTr("")
        leftBtnText:qsTr("")
        rightBtnText:qsTr("")
        onClose:{
            closeLoaderMain()
        }
    }
    //内容
    Rectangle{
        width:parent.width
        anchors.bottom:topBar.top
        anchors.top: parent.top
        color:"transparent"

        GridLayout{
            width:parent.width-160
            height: parent.height-60
            anchors.centerIn: parent
            rows: 2
            columns: 2
            rowSpacing: 20
            columnSpacing: 40

            Button{
                Layout.preferredWidth: 300
                Layout.preferredHeight:160
//                Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter
                background:Rectangle{
                    radius: 10
                    color:"transparent"
                    border.color: "#97A3A1"
                }
                Text{
                    text:"左腔烹饪"
                    color:"#FFF"
                    font.pixelSize: 35
                    anchors.centerIn: parent
                }

                onClicked: {
                    closeLoaderMain()
                    load_page("pageSteamBakeBase",JSON.stringify({"device":leftDevice}))
                }
            }
            Button{
                Layout.preferredWidth: 300
                Layout.preferredHeight:160
                Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter
                background:Rectangle{
                    radius: 10
                    color:"transparent"
                    border.color: "#97A3A1"
                }
                Text{
                    text:"智慧菜谱"
                    color:"#FFF"
                    font.pixelSize: 35
                    anchors.centerIn: parent
                }

                onClicked: {
                    closeLoaderMain()
                    load_page("pageSmartRecipes")
                }
            }
            Button{
                Layout.preferredWidth: 300
                Layout.preferredHeight:160
                Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter
                background:Rectangle{
                    radius: 10
                    color:"transparent"
                    border.color: "#97A3A1"
                }
                Text{
                    text:"烹饪历史"
                    color:"#FFF"
                    font.pixelSize: 35
                    anchors.centerIn: parent
                }

                onClicked: {
                    closeLoaderMain()
                    load_page("pageCookHistory",JSON.stringify({"device":leftDevice}))
                }
            }
            Button{
                Layout.preferredWidth: 300
                Layout.preferredHeight:160
                Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter
                background:Rectangle{
                    radius: 10
                    color:"transparent"
                    border.color: "#97A3A1"
                }
                Text{
                    text:"多段烹饪"
                    color:"#FFF"
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


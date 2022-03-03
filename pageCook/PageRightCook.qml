import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import "../"
Item {

    Component.onCompleted: {

    }
    Image {
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
            height: parent.height
            anchors.centerIn: parent
            rows: 1
            columns: 2
            rowSpacing: 0
            columnSpacing: 40

            Button{
                Layout.preferredWidth: 300
                Layout.preferredHeight:160
                Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter
                background:PageGradient{
                    anchors.fill: parent
                }
                Text{
                    text:"右腔速蒸"
                    color:"#FFF"
                    font.pixelSize: 35
                    anchors.centerIn: parent
                }

                onClicked: {
                    closeLoaderMain()
                    load_page("pageSteamBakeBase",JSON.stringify({"device":rightDevice}))
                }
            }
            Button{
                Layout.preferredWidth: 300
                Layout.preferredHeight:160
                Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter

                background:PageGradient{
                    anchors.fill: parent
                }
                Text{
                    text:"烹饪历史"
                    color:"#FFF"
                    font.pixelSize: 35
                    anchors.centerIn: parent
                }

                onClicked: {
                    closeLoaderMain()
                    load_page("pageCookHistory",JSON.stringify({"device":rightDevice}))
                }
            }

        }
    }
}


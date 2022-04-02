import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import "../"
Item {

    Component.onCompleted: {


    }
    Component.onDestruction: {
        console.log("PageLeftCook onDestruction")
    }
    Image {
        cache:false
        asynchronous:true
        source: themesImagesPath+"applicationwindow-background.png"
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

        Button{
            width: 300
            height:340
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 80

            background:PageGradient{
                anchors.fill: parent
            }
            Text{
                color:"#FFF"
                text:qsTr("左腔蒸烤")
                font.pixelSize:35
                anchors.top: parent.top
                anchors.topMargin: 30
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Image {
                cache:false
                asynchronous:true
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 50
                anchors.horizontalCenter: parent.horizontalCenter
                source: "qrc:/x50/main/烤鸡.png"
            }
            onClicked: {
                closeLoaderMain()
                load_page("pageSteamBakeBase",JSON.stringify({"device":leftDevice}))
            }
        }

        GridLayout{
            width:300
            height: 340
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 80
            rows: 3
            columns: 1
            rowSpacing: 0
            columnSpacing: 0

            Button{
                Layout.preferredWidth: 300
                Layout.preferredHeight:100
                Layout.maximumHeight:100
                Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter
                background:PageGradient{
                    anchors.fill: parent
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
                Layout.preferredHeight:100
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
                    load_page("pageCookHistory",JSON.stringify({"device":leftDevice}))
                }
            }
            Button{
                Layout.preferredWidth: 300
                Layout.preferredHeight:100
                Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter
                background:PageGradient{
                    anchors.fill: parent
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


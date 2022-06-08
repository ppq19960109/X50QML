import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import "../"
Rectangle {
    color: themesWindowBackgroundColor
    Component.onCompleted: {
    }
    Component.onDestruction: {
        console.log("PageLeftCook onDestruction")
    }
    PageBackBar{
        id:topBar
        anchors.bottom:parent.bottom
        name:qsTr("")
        leftBtnText:qsTr("")
        rightBtnText:qsTr("")
        onClose:{
            loaderMainHide()
        }
    }
    //内容
    Item{
        width:parent.width
        anchors.bottom:topBar.top
        anchors.top: parent.top

        Button{
            width: 300
            height:340
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 80

            background:Image{
                asynchronous:true
                smooth:false
                cache:false
                source: "qrc:/x50/steam/left-cook-background2.png"
            }
            Text{
                color:"#FFF"
                text:qsTr("左腔蒸烤")
                font.pixelSize:50
                anchors.top: parent.top
                anchors.topMargin: 196
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Image {
                cache:false
                asynchronous:true
                smooth:false
                anchors.top: parent.top
                anchors.topMargin: 70
                anchors.horizontalCenter: parent.horizontalCenter
                source: themesImagesPath+"icon-cookadd.png"
            }
            onClicked: {
                load_page("pageSteamBakeBase",JSON.stringify({"device":cookWorkPosEnum.LEFT}))
                loaderMainHide()
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
                background:Image{
                    asynchronous:true
                    smooth:false
                    cache:false
                    source: "qrc:/x50/steam/left-cook-background1.png"
                }
                Text{
                    text:"智慧菜谱"
                    color:"#FFF"
                    font.pixelSize: 35
                    anchors.centerIn: parent
                }

                onClicked: {
                    loaderMainHide()
                    load_page("pageSmartRecipes")
                }
            }
            Button{
                Layout.preferredWidth: 300
                Layout.preferredHeight:100
                Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter
                background:Image{
                    asynchronous:true
                    smooth:false
                    cache:false
                    source: "qrc:/x50/steam/left-cook-background1.png"
                }
                Text{
                    text:"烹饪历史"
                    color:"#FFF"
                    font.pixelSize: 35
                    anchors.centerIn: parent
                }

                onClicked: {
                    load_page("pageCookHistory",JSON.stringify({"device":cookWorkPosEnum.LEFT}))
                    loaderMainHide()
                }
            }
            Button{
                Layout.preferredWidth: 300
                Layout.preferredHeight:100
                Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter
                background:Image{
                    asynchronous:true
                    smooth:false
                    cache:false
                    source: "qrc:/x50/steam/left-cook-background1.png"
                }
                Text{
                    text:"多段烹饪"
                    color:"#FFF"
                    font.pixelSize: 35
                    anchors.centerIn: parent
                }

                onClicked: {
                    load_page("pageMultistageSet")
                    loaderMainHide()
                }
            }

        }
    }
}


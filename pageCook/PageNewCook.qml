import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import "../"
Rectangle {
    property int cookDir: -1
    color: themesWindowBackgroundColor
//    Component.onCompleted: {
//    }
//    Component.onDestruction: {
//    }
    PageBackBar{
        id:topBar
        anchors.bottom:parent.bottom
        name:qsTr("")
        leftBtnText:qsTr("")
        rightBtnText:qsTr("")
        onClose:{
            loaderNewCookHide()
        }
    }
    //内容
    Item{
        id:left
        visible: cookDir===cookWorkPosEnum.LEFT
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
                load_page("pageSteamBakeBase",{"device":cookWorkPosEnum.LEFT})
                loaderNewCookHide()
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
                    loaderNewCookHide()
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
                    load_page("pageCookHistory",{"cookPos":cookWorkPosEnum.LEFT})
                    loaderNewCookHide()
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
                    loaderNewCookHide()
                }
            }

        }
    }
    //内容
    Item{
        id:right
        visible: cookDir===cookWorkPosEnum.RIGHT
        width:parent.width
        anchors.bottom:topBar.top
        anchors.top: parent.top

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
                background:Image{
                    asynchronous:true
                    smooth:false
                    cache:false
                    source: "qrc:/x50/steam/right-cook-background.png"
                }
                Text{
                    text:"右腔速蒸"
                    color:"#FFF"
                    font.pixelSize: 35
                    anchors.centerIn: parent
                }

                onClicked: {
                    load_page("pageSteamBakeBase",{"device":cookWorkPosEnum.RIGHT})
                    loaderNewCookHide()
                }
            }
            Button{
                Layout.preferredWidth: 300
                Layout.preferredHeight:160
                Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter

                background:Image{
                    asynchronous:true
                    smooth:false
                    cache:false
                    source: "qrc:/x50/steam/right-cook-background.png"
                }
                Text{
                    text:"烹饪历史"
                    color:"#FFF"
                    font.pixelSize: 35
                    anchors.centerIn: parent
                }

                onClicked: {
                    load_page("pageCookHistory",{"cookPos":cookWorkPosEnum.RIGHT})
                    loaderNewCookHide()
                }
            }

        }
    }
}


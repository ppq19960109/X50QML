import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import "../"
Rectangle {
    color:themesWindowBackgroundColor
    Component.onCompleted: {

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
                    load_page("pageSteamBakeBase",JSON.stringify({"device":cookWorkPosEnum.RIGHT}))
                    loaderMainHide()
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
                    load_page("pageCookHistory",JSON.stringify({"device":cookWorkPosEnum.RIGHT}))
                    loaderMainHide()
                }
            }

        }
    }
}


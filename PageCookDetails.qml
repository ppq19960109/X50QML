import QtQuick 2.0
import QtQuick.Controls 2.2
import "pageSteamAndBake"
Item {
    property var root
    property var cookSteps

    Component.onCompleted: {
        console.log("state",state,typeof state)
        root=JSON.parse(state)

        cookSteps=JSON.parse(root.cookSteps)

        if(root.imgUrl!=="")
        {
            recipe.visible=true
            recipeImg.source="file:"+root.imgUrl
            dishName.text=root.dishName
            details.text=root.details

            cookSteps[0].dishName=root.dishName
        }
        else
        {
            noRecipe.visible=true
            listView.model=cookSteps
            listView.height=cookSteps.length*100
        }
        permitSteamStartStatus(1)
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
        name:"详情"
        leftBtnText:qsTr("启动")
        rightBtnText:qsTr("预约")
        onClose:{
            permitSteamStartStatus(0)
             backPrePage()
        }

        onLeftClick:{
           startCooking(root,cookSteps,0)
        }
        onRightClick:{
             load_page("pageSteamBakeReserve",JSON.stringify(root))
        }
    }

    //内容
    Rectangle{
        id:recipe
        visible:false
        enabled: visible
        width:parent.width
        anchors.bottom:topBar.top
        anchors.top: parent.top
        color:"transparent"

        Rectangle{
            id:leftContent
            width:300
            height:parent.height
            color:"transparent"
            Rectangle{
                width:220
                height:330
                anchors.centerIn: parent
                color:"transparent"
                Image{
                    id:recipeImg
                    anchors.fill: parent
                }
                Text{
                    id:dishName
                    anchors.bottom:parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: 40
                    color:"#fff"
                }
            }
        }

        Rectangle{

            height:parent.height
            anchors.left: leftContent.right
            anchors.right: parent.right
            color:"transparent"

            Flickable {
                id: flick
                width: parent.width - 80
                height: parent.height - 80
                anchors.verticalCenter: parent.verticalCenter
                contentWidth: details.width
                contentHeight: details.height
                clip: true
                Text {
                    id: details
                    width: flick.width
                    //                    height: flick.height
                    font.pixelSize: 30
                    lineHeight: 1.2
                    color:"#fff"
                    //                                        clip :true
                    wrapMode: Text.WordWrap
                    //                    elide: Text.ElideRight
                }

                ScrollBar.vertical: ScrollBar {
                    parent: flick.parent
                    anchors.top: flick.top
                    anchors.left: flick.right
                    anchors.leftMargin: 40
                    anchors.bottom: flick.bottom
                    background:Rectangle{
                        implicitWidth: 4
                        color:"#000"
                        radius: width / 2
                    }
                    contentItem: Rectangle {
                        implicitWidth: 4
                        implicitHeight: 100
                        radius: width / 2
                        color: "#00E6B6"
                    }
                }
            }
        }
    }

    Rectangle{
        id:noRecipe
        visible:false
        enabled: visible
        width:parent.width
        anchors.bottom:topBar.top
        anchors.top: parent.top
        color:"transparent"

        Component {
            id: multiDelegate
            PageMultistageDelegate {
                nameText:leftWorkModeFun(modelData.mode)+"-"+modelData.temp+"℃"+"-"+modelData.time+"分钟"
//                modeIndex:modelData.mode
//                tempIndex:modelData.temp+"℃"
//                timeIndex:modelData.time+"分钟"
                closeVisible:false
            }
        }
        ListView {
            id: listView
            width: parent.width
//            anchors.fill: parent
//            anchors.topMargin: 50
//            height: listView.model.length*100
            anchors.centerIn: parent
            interactive: false
            delegate: multiDelegate
//            model:

            focus: true
        }

    }
}

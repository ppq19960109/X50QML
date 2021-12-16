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
            recipeImg.source=root.imgUrl
            dishName.text=root.dishName
            cookTime.text="烹饪用时："+root.cookTime+"分钟"
            details.text=root.details

            cookSteps[0].dishName=root.dishName
        }
        else
        {
            noRecipe.visible=true
            listView.model=cookSteps
        }
    }
    ToolBar {
        id:topBar
        width:parent.width
        anchors.bottom: parent.bottom
        height:96
        background:Rectangle{
            color:"#000"
        }
        Image {
            anchors.fill: parent
            source: "/images/main_menu/zhuangtai_bj.png"
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
                backPrePage()
            }
        }

        Text{
            id:name
            width:80
            color:"#9AABC2"
            font.pixelSize: 40
            anchors.left:goBack.right
            anchors.verticalCenter: parent.verticalCenter
            text:qsTr("详情")
        }

        //启动
        TabButton{
            id:startBtn
            width:160
            height:parent.height
            anchors.right:reserve.left
            background:Rectangle{
                color:"transparent"
            }
            Text{
                color:"#ECF4FC"
                font.pixelSize: 40
                anchors.centerIn:parent
                text:qsTr("启动")
            }
            onClicked: {
                startCooking(root,cookSteps,0)
            }
        }
        //预约
        TabButton{
            id:reserve
            width:160
            height:parent.height
            anchors.right:parent.right
            anchors.rightMargin: 10
            background:Rectangle{
                color:"transparent"
            }
            Text{
                color:"#ECF4FC"
                font.pixelSize: 40
                anchors.centerIn:parent
                text:qsTr("预约")
            }
            onClicked: {
                load_page("pageSteamBakeReserve",JSON.stringify(root))
            }
        }
    }
    //内容
    Rectangle{
        id:recipe
        visible:false
        width:parent.width
        anchors.bottom:topBar.top
        anchors.top: parent.top
        color:"#000"

        Rectangle{
            id:leftContent
            width:250
            height:parent.height
            color:"#000"
            Rectangle{
                width:parent.width
                height:300
                anchors.centerIn: parent
                color:"#000"
                Image{
                    id:recipeImg
                    anchors.top:parent.top
                    anchors.bottom: dishName.top
                    anchors.horizontalCenter: parent.horizontalCenter
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
            color:"#000"

            Text{
                id:cookTime
                anchors.top:parent.top
                anchors.left:parent.left

                font.pixelSize: 40
                color:"#fff"
            }
            Flickable {
                id: flick
                width: parent.width
                anchors.top:cookTime.bottom
                anchors.bottom: parent.bottom
                contentWidth: details.width
                contentHeight: details.height
                clip: true
                Text {
                    id: details
                    width: flick.width
                    //                    height: flick.height
                    font.pixelSize: 34
                    color:"#fff"
                    //                                        clip :true
                    wrapMode: Text.WordWrap
                    //                    elide: Text.ElideRight
                }
            }
        }
    }

    Rectangle{
        id:noRecipe
        visible:false
        width:parent.width
        anchors.bottom:topBar.top
        anchors.top: parent.top
        color:"#000"

        Component {
            id: multiDelegate
            PageMultistageDelegate {
                modeIndex:modelData.mode
                tempIndex:modelData.temp+"℃"
                timeIndex:modelData.time+"分钟"
                closeVisible:false

                onClose:{

                }
                onConfirm:{

                }
            }
        }
        ListView {
            id: listView
            width: parent.width
            height: 300
//            anchors.fill: parent
            anchors.centerIn: parent
            interactive: false
            delegate: multiDelegate
//            model:

            focus: true
        }

    }
}

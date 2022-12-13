import QtQuick 2.12
import QtQuick.Controls 2.5

import "qrc:/pageCook"
import "../"
import "qrc:/CookFunc.js" as CookFunc
import "qrc:/SendFunc.js" as SendFunc
Item {
    property var root
    property var cookSteps
    property int current_weight:0
    property var weight:QmlDevState.state.Weight
    Connections { // 将目标对象信号与槽函数进行连接
        id:connections
        enabled:false
        target: QmlDevState
        onStateChanged: { // 处理目标对象信号的槽函数
            if("SteamStart"==key)
            {
                startPanguCooking(root,cookSteps)
            }
        }
    }
    StackView.onActivated:{
        connections.enabled=true
    }
    StackView.onDeactivated:{
        connections.enabled=false
    }
    function getCookTime(cookSteps)
    {
        var cookTime=0;
        for(var i = 0; i < cookSteps.length; ++i)
        {
            cookTime+=cookSteps[i].time
        }
        return cookTime;
    }

    Component.onCompleted: {
        cookSteps=root.cookSteps

        if(root.recipeType>0)
        {
            recipeImg.source="file:"+root.imgUrl
            details.text=root.details

            recipe.visible=true
            topBar.name=root.dishName

            //                cookTime.text="烹饪用时："+getCookTime(cookSteps)+"分钟"
            if(root.reserve)
                topBar.rightBtnText="预约"
        }
        else
        {
            noRecipe.visible=true
            listView.model=cookSteps
            listView.height=cookSteps.length*100
        }
    }

    PageBackBar{
        id:topBar
        anchors.bottom:parent.bottom
        name:"详情"
        //        leftBtnText:qsTr("启动")
        //        rightBtnText:qsTr("预约")
        onClose:{
            backPrePage()
        }
        onLeftClick:{
            startPanguCooking(root,cookSteps)
        }
        onRightClick:{
            load_page("pagePanguReserve",{"root":root})
        }
    }

    //内容
    Item{
        id:recipe
        visible:false
        enabled: visible
        width:parent.width
        anchors.bottom:topBar.top
        anchors.top: parent.top

        Item{
            id:leftContent
            width:220+60
            height:parent.height

            Image{
                id:recipeImg
                width: 220
                height: 330
                sourceSize.width: 220
                sourceSize.height: 330
                anchors.centerIn: parent
                cache:false
                asynchronous:true
                smooth:false
            }
            Image{
                visible: !weightItem.visible
                asynchronous:true
                smooth:false
                cache:false
                anchors.top: recipeImg.top
                anchors.topMargin: 10
                anchors.left: recipeImg.left
                anchors.leftMargin: -20
                source: themesImagesPanguPath+"weight.png"
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        console.log("weightItem...")
                        weightItem.visible=true
                    }
                }
            }
            Item
            {
                id:weightItem
                visible: false
                anchors.fill: recipeImg
                Image{
                    asynchronous:true
                    smooth:false
                    cache:false
                    source: themesImagesPanguPath+"weight_recipe.png"
                }
                Button {
                    id:closeBtn
                    width:closeImg.width+30
                    height:closeImg.height+30
                    anchors.top:parent.top
                    anchors.right:parent.right

                    Image {
                        id:closeImg
                        anchors.centerIn: parent
                        source: themesImagesPath+"icon-window-close.png"
                    }
                    background: Item {}
                    onClicked: {
                        weightItem.visible=false
                    }
                }
                Rectangle{
                    width: 160
                    height: 50
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.centerIn: parent
                    color: themesTextColor
                    radius: 5
                    Text{
                        anchors.centerIn: parent
                        font.pixelSize: 40
                        color:"#fff"
                        text: (weight-current_weight)+"g"
                    }
                }
                Button {
                    width:125
                    height: 55
                    anchors.top:parent.top
                    anchors.topMargin: 240
                    anchors.horizontalCenter: parent.horizontalCenter
                    background: Rectangle{
                        color:"#fff"
                        radius: 8
                    }
                    Text{
                        text:"清零"
                        color:"#000"
                        font.pixelSize: 32
                        anchors.centerIn: parent
                    }
                    onClicked: {
                        current_weight=weight
                    }
                }
            }
        }

        Item{
            //            height:parent.height
            anchors.top:parent.top
            anchors.topMargin: 20
            anchors.bottom:parent.bottom
            anchors.bottomMargin: 20
            anchors.left: leftContent.right

            anchors.right: parent.right
            anchors.rightMargin: 40
            Text{
                id:cookTime
                anchors.top:parent.top
                //                anchors.topMargin: 5
                anchors.left: parent.left
                font.pixelSize: 40
                color:"#fff"
            }

            PageScrollBarText{
                id: details
                width: parent.width
                anchors.top: cookTime.bottom
                anchors.topMargin: 15
                anchors.bottom: parent.bottom
                scrollBarLeftMargin:5
            }
        }
    }

    Item{
        id:noRecipe
        visible:false
        enabled: visible
        width:parent.width
        anchors.bottom:topBar.top
        anchors.top: parent.top

        Component {
            id: multiDelegate
            PageMultistageDelegate {
                nameText:CookFunc.leftWorkModeName(modelData.mode)+"-"+modelData.temp+"℃"+"-"+modelData.time+"分钟"
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
        }

    }
}

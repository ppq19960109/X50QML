import QtQuick 2.7
import QtQuick.Controls 2.2

import "qrc:/pageCook"
import "../"
import "qrc:/CookFunc.js" as CookFunc
import "qrc:/SendFunc.js" as SendFunc
Item {
    property var root
    property var cookSteps
    property int cookPos:0

    Connections { // 将目标对象信号与槽函数进行连接
        id:connections
        enabled:false
        target: QmlDevState
        onStateChanged: { // 处理目标对象信号的槽函数
            if("SteamStart"==key)
            {
                startCooking(root,cookSteps,0)
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
        for(var i = 0; i < cookSteps.length; i++)
        {
            cookTime+=cookSteps[i].time
        }
        return cookTime;
    }

    Component.onCompleted: {
        console.log("state",state,typeof state)
        root=JSON.parse(state)

        cookSteps=JSON.parse(root.cookSteps)

        if(root.recipeType>0)
        {
            var recipeDetail=QmlDevState.getRecipeDetails(root.recipeid)
            if(recipeDetail.length!=0)
            {
                recipeImg.source="file:"+recipeDetail[0]
                details.text=recipeDetail[1]
            }

            recipe.visible=true
            dishName.text="菜名："+root.dishName
            cookTime.text="烹饪用时："+getCookTime(cookSteps)+"分钟"
//            cookSteps[0].dishName=root.dishName
        }
        else
        {
            noRecipe.visible=true
            listView.model=cookSteps
            listView.height=cookSteps.length*100
            cookPos=root.cookPos
        }
        SendFunc.permitSteamStartStatus(1)
    }

    PageBackBar{
        id:topBar
        anchors.bottom:parent.bottom
        name:"详情"
        leftBtnText:qsTr("启动")
        rightBtnText:qsTr("预约")
        onClose:{
            SendFunc.permitSteamStartStatus(0)
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
                sourceSize.width: 220
                sourceSize.height: 330
                anchors.centerIn: parent
                cache:false
                asynchronous:true
            }
            Image{
                asynchronous:true
                anchors.top: recipeImg.top
                anchors.left: recipeImg.left
                sourceSize.width: 88
                sourceSize.height: 48
                source: themesImagesPath+cookModeImg[CookFunc.getCookType(root.cookSteps)]
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
            anchors.rightMargin: 30
            Text{
                id:dishName
                anchors.top:parent.top
                anchors.left: parent.left
                font.pixelSize: 40
                color:"#fff"
            }
            Text{
                id:cookTime
                anchors.top:dishName.bottom
                //                anchors.topMargin: 5
                anchors.left: parent.left
                font.pixelSize: 40
                color:"#fff"
            }

            PageScrollBarText{
                id: details
                width: parent.width
                anchors.top: cookTime.bottom
                anchors.topMargin: 10
                anchors.bottom: parent.bottom
                scrollBarLeftMargin:10
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
                nameText:(cookPos>0?rightWorkMode:CookFunc.leftWorkModeFun(modelData.mode))+"-"+modelData.temp+"℃"+"-"+modelData.time+"分钟"

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

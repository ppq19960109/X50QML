import QtQuick 2.7
import QtQuick.Controls 2.2

import "qrc:/SendFunc.js" as SendFunc
import "../"
Item {
    property bool edit: false
    property int cookPos: allDevice
    //    property int historyCurrentIndex:0
    //    property alias historyModel:recipeListView.model

    Connections { // 将目标对象信号与槽函数进行连接
        id:connections
        enabled:false
        target: QmlDevState
        onStateChanged: { // 处理目标对象信号的槽函数
            if("SteamStart"==key)
            {
                var root=recipeListView.model.get(recipeListView.currentIndex)
                startCooking(root,JSON.parse(root.cookSteps))
            }
        }
    }
    StackView.onActivated:{
        connections.enabled=true
    }
    StackView.onDeactivated:{
        connections.enabled=false
    }
    Component.onCompleted: {
        console.log("state",state,typeof state)
        var root=JSON.parse(state)
        cookPos=root.device

        QmlDevState.sortHistory()
        getHistory(cookPos)
        SendFunc.permitSteamStartStatus(1)
    }
    ListModel {
        id:historyModel
    }
    function getHistory(pos)
    {
        historyModel.clear()
        var historys=QmlDevState.getHistory();
        if(historys.length===0)
        {
            noHistory.visible=true
            recipeListView.visible=false

            return
        }
        noHistory.visible=false
        recipeListView.visible=true

        for(var i = 0; i < historys.length; ++i) {
            if(pos ===allDevice || historys[i].cookPos===pos)
            {
                console.log("getHistory ",JSON.stringify(historys[i]))
                historyModel.append(historys[i])
            }
        }
    }

    function changeHistory(action,value)
    {
        var i
        if(action=="InsertHistory")
        {
            historyModel.append(value)
        }
        else if(action=="DeleteHistory")
        {
            for( i = 0; i < historyModel.count; ++i) {
                if(value.id==historyModel.get(i).id)
                {
                    historyModel.remove(i,1)
                    console.warn("PageCookHistory DeleteHistory",value.id,i)
                    break
                }
            }
        }
        else if(action=="UpdateHistory")
        {
            for( i = 0; i < historyModel.count; ++i) {
                if(value.id==historyModel.get(i).id)
                {
                    historyModel.set(i,value)
                    break
                }
            }
        }
    }

    Connections { // 将目标对象信号与槽函数进行连接
        target: QmlDevState
        onHistoryChanged: { // 处理目标对象信号的槽函数
            console.warn("PageCookHistory onHistoryChanged...")
            changeHistory(action,history)
        }
    }

    PageBackBar{
        id:topBar
        anchors.bottom:parent.bottom
        name:qsTr("烹饪历史")
        leftBtnText:edit?qsTr("完成"):qsTr("管理")
        leftBtnOpacity:noHistory.visible==true?0.6:1
        rightBtnText:qsTr("详情")
        rightBtnOpacity:noHistory.visible==true?0.6:edit===true?0.6:1
        onLeftClick:{
            if(noHistory.visible==false)
                edit=!edit
        }
        onRightClick:{
            if(noHistory.visible==false && edit===false)
                load_page("pageCookDetails",JSON.stringify(recipeListView.model.get(recipeListView.currentIndex)))
        }
        onClose:{
            backPrePage()
        }
    }
    //内容
    Item{
        width:parent.width
        anchors.bottom:topBar.top
        anchors.top: parent.top

        Text{
            id:noHistory
            visible: false
            anchors.centerIn: parent
            text:"暂无烹饪历史"
            font.pixelSize: 40
            horizontalAlignment:Text.AlignHCenter
            verticalAlignment:Text.AlignVCenter
            color:"#fff"
        }

        ListView{
            id: recipeListView
            visible: false
            model:historyModel
            width:parent.width
            //            height:parent.height
            anchors.bottom:parent.bottom
            anchors.bottomMargin: 20
            anchors.top: parent.top
            anchors.topMargin: 20
            //            highlightRangeMode: ListView.ApplyRange//StrictlyEnforceRange ApplyRange
            //                        boundsBehavior:Flickable.StopAtBounds
            clip: true
            currentIndex:0
            delegate: Item{
                width:parent.width
                height:100
                PageDivider{
                    anchors.bottom:parent.bottom
                }
                Text{
                    id:number
                    width:60
                    height:100
                    anchors.left: parent.left
                    anchors.leftMargin: 40
                    text: index+1+"、"
                    font.pixelSize: 40
                    horizontalAlignment:Text.AlignHCenter
                    verticalAlignment:Text.AlignVCenter
                    color:recipeListView.currentIndex===index?themesTextColor:"#FFF"
                }
                Button {
                    height:parent.height
                    anchors.left:number.right
                    anchors.right:collection.left
                    background: Item{}
                    Text{
                        width : parent.width
                        anchors.centerIn: parent
                        text: dishName
                        font.pixelSize: 40

                        //                        horizontalAlignment:Text.AlignHCenter
                        //                        verticalAlignment:Text.AlignHCenter
                        color:recipeListView.currentIndex===index?themesTextColor:"#fff"
                    }
                    onClicked: {
                        recipeListView.currentIndex=index
                    }
                }
                Button {
                    id:collection
                    width:200
                    height:parent.height
                    anchors.right: parent.right
                    background: Image{
                        visible: edit
                        cache:false
                        asynchronous:true
                        anchors.centerIn: parent
                        source: themesImagesPath+"icon_cook_delete.png"
                    }
                    Text{
                        anchors.centerIn: parent
                        visible: edit==false
                        text: collect===0?"收藏":"已收藏"
                        font.pixelSize: 40

                        horizontalAlignment:Text.AlignHCenter
                        verticalAlignment:Text.AlignHCenter
                        color:recipeListView.currentIndex===index?themesTextColor:collect===0?"#FFF":"#E5B9A1"
                    }
                    onClicked: {
                        console.log("onClicked",id,collect)
                        recipeListView.currentIndex=index
                        if(edit)
                        {
                            QmlDevState.deleteHistory(id)
                            //                            historyCurrentIndex=recipeListView.currentIndex-1
                        }
                        else
                        {
                            QmlDevState.setCollect(index,!collect)
                            //                            historyCurrentIndex=recipeListView.currentIndex
                        }
                    }
                }
            }
        }

    }
}

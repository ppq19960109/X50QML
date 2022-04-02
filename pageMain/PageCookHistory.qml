import QtQuick 2.7
import QtQuick.Controls 2.2

import "../"
Item {
    property bool edit: false
    property int cookPos: allDevice
    property int historyCurrentIndex:0
    //    property alias historyModel:recipeListView.model
    Component.onCompleted: {
        console.log("state",state,typeof state)
        var root=JSON.parse(state)
        cookPos=root.device

        QmlDevState.sortHistory()
        getHistory(cookPos)
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
        width:parent.width
        anchors.bottom:parent.bottom
        height:80
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
    Rectangle{
        width:parent.width
        anchors.bottom:topBar.top
        anchors.top: parent.top
        color:"transparent"

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
            highlightRangeMode: ListView.StrictlyEnforceRange
            //            boundsBehavior:Flickable.StopAtBounds
            clip: true
            currentIndex:0
            delegate: Rectangle{
                width:parent.width
                height:100
                color:"transparent"
                PageDivider{
                    anchors.horizontalCenter: parent.horizontalCenter
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
                    color:recipeListView.currentIndex===index?"#00E6B6":"#FFF"
                }
                Button {
                    height:parent.height
                    anchors.left:number.right
                    anchors.right:collection.left
                    background: Rectangle{
                        color:"transparent"
                    }
                    Text{
                        width : parent.width;
                        anchors.centerIn: parent
                        text: dishName
                        font.pixelSize: 40

                        //                        horizontalAlignment:Text.AlignHCenter
                        verticalAlignment:Text.AlignHCenter
                        color:recipeListView.currentIndex===index?"#00E6B6":"#fff"
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
                    background: Rectangle{
                        color:"transparent"
                    }
                    Image{
                        visible: edit
                        cache:false
                        asynchronous:true
                        anchors.centerIn: parent
                        source: "qrc:/x50/icon/icon_delete.png"
                    }
                    Text{
                        anchors.centerIn: parent
                        visible: edit==false
                        text: collect===0?"收藏":"已收藏"
                        font.pixelSize: 40

                        horizontalAlignment:Text.AlignHCenter
                        verticalAlignment:Text.AlignHCenter
                        color:recipeListView.currentIndex===index?"#00E6B6":collect===0?"#FFF":"#FFB613"
                    }
                    onClicked: {
                        if(edit)
                        {
                            QmlDevState.deleteHistory(id)
                            historyCurrentIndex=recipeListView.currentIndex-1
                        }
                        else
                        {
                            QmlDevState.setCollect(index,!collect)
                            historyCurrentIndex=recipeListView.currentIndex
                        }
                    }
                }
            }
        }

    }
}

import QtQuick 2.2
import QtQuick.Controls 2.2

Item {
    property bool edit: false
    property int cookPos: allDevice

    Component.onCompleted: {
        console.log("state",state,typeof state)
        var root=JSON.parse(state)
        cookPos=root.device

        QmlDevState.sortHistory()
        getHistory(cookPos)
    }
    function getHistory(pos)
    {
        var historyModel=[]
        var historys=QmlDevState.getHistory();
        if(historys.length===0)
        {
            noHistory.visible=true
            recipeListView.model=historyModel
            return
        }
        recipeListView.visible=true
        for(var i = 0; i < historys.length; ++i) {
            if(pos ===allDevice || historys[i].cookPos===pos)
            {
                console.log("getHistory recipe",JSON.stringify(historys[i]))
                historyModel.push(historys[i])
            }
        }
        recipeListView.model=historyModel
    }

    Connections { // 将目标对象信号与槽函数进行连接
        target: QmlDevState
        onHistoryChanged: { // 处理目标对象信号的槽函数
            console.warn("PageCookHistory onHistoryChanged...")
            getHistory(cookPos)
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
                backPrePage();
            }
        }

        Text{
            id:name
            width:80
            color:"#9AABC2"
            font.pixelSize: 40
            anchors.left:goBack.right
            anchors.verticalCenter: parent.verticalCenter
            text:qsTr("烹饪历史")
        }
        //编辑
        TabButton{
            width:160
            height:parent.height
            anchors.right:details.left
            background:Rectangle{
                color:"transparent"
            }
            Text{
                color:"#ECF4FC"
                font.pixelSize: 40
                anchors.centerIn:parent
                text:edit?qsTr("取消编辑"):qsTr("编辑")
            }
            onClicked: {
                edit=!edit
            }
        }
        //详情
        TabButton{
            id:details
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
                text:qsTr("详情")
            }
            onClicked: {
                load_page("pageCookDetails",JSON.stringify(recipeListView.model[recipeListView.currentIndex]))
            }
        }
    }

    //内容
    Rectangle{
        width:parent.width
        anchors.bottom:topBar.top
        anchors.top: parent.top
        color:"#000"

        Text{
            id:noHistory
            visible: false
            anchors.centerIn: parent
            text:"暂无烹饪历史"
            font.pixelSize: 50
            horizontalAlignment:Text.AlignHCenter
            verticalAlignment:Text.AlignVCenter
            color:"#fff"
        }

        ListView{
            id: recipeListView
            visible: false
//            model:historyModel
            width:parent.width
            height:parent.height

            //            highlightRangeMode: ListView.StrictlyEnforceRange
            boundsBehavior:Flickable.StopAtBounds
            clip: true
            currentIndex:0
            delegate: Rectangle{
                width:parent.width
                height:96
                color:"#000"
                Text{
                    id:number
                    width : 96
                    height: 96
                    anchors.left: parent.left
                    text: index+1
                    font.pixelSize: 40
                    horizontalAlignment:Text.AlignHCenter
                    verticalAlignment:Text.AlignVCenter
                    color:recipeListView.currentIndex===index?"#00E6B6":"#fff"
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
                        text: modelData.dishName
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
                        anchors.centerIn: parent
                        source: "/images/shanchu-icon.png"
                    }
                    Text{
                        anchors.centerIn: parent
                        visible: edit==false
                        text: modelData.collect===0?"收藏":"已收藏"
                        font.pixelSize: 40

                        horizontalAlignment:Text.AlignHCenter
                        verticalAlignment:Text.AlignHCenter
                        color:modelData.collect===0?"#fff":"orange"
                    }
                    onClicked: {
                        if(edit)
                        {
                            QmlDevState.deleteHistory(modelData.id)
                        }
                        else
                        {
                            QmlDevState.setCollect(index,!modelData.collect)
                        }
                    }
                }
            }
        }

    }
}

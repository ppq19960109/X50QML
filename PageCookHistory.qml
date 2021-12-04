import QtQuick 2.2
import QtQuick.Controls 2.2

Item {
    property bool edit: false
    id:root
    Component.onCompleted: {
        getHistory()
    }
    function getHistory()
    {
        listModel.clear();
        var recipe=QmlDevState.getHistory();
        for(var i = 0; i < recipe.length; ++i) {
            listModel.append(recipe[i])
        }
    }
//    function getCurHistory(index)
//    {
//        var param = {};
//        param.id=listModel.get(index).id
//        param.seqid=listModel.get(index).seqid
//        param.cookType=listModel.get(index).cookType
//        param.dishName=listModel.get(index).dishName
//        param.cookTime=listModel.get(index).cookTime
//        param.imgUrl=listModel.get(index).imgUrl
//        param.details=listModel.get(index).details
//        param.cookSteps=listModel.get(index).cookSteps
//        param.collect=listModel.get(index).collect
//        param.time=listModel.get(index).timestamp
//        return param
//    }
    Connections { // 将目标对象信号与槽函数进行连接
        target: QmlDevState
        onHistoryChanged: { // 处理目标对象信号的槽函数
            console.warn("PageCookHistory onHistoryChanged...")
            getHistory()
        }
    }
    ToolBar {
        id:topBar
        width:parent.width
        anchors.top:parent.top
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
                var param = {};
                param.dishName=listModel.get(recipe.currentIndex).dishName
                param.cookTime=listModel.get(recipe.currentIndex).cookTime
                param.imgUrl=listModel.get(recipe.currentIndex).imgUrl
                param.details=listModel.get(recipe.currentIndex).details
                param.cookSteps=listModel.get(recipe.currentIndex).cookSteps

                load_page("pageCookDetails",JSON.stringify(param))
            }
        }
    }
    ListModel {
        id:listModel
    }
    //内容
    Rectangle{
        width:parent.width
        anchors.top:topBar.bottom
        anchors.bottom: parent.bottom
        color:"#000"

        ListView{
            id: recipe
            model:listModel
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
                    color:"#fff"
                }
                Button {
                    height:parent.height
                    anchors.left:number.right
                    anchors.right:collection.left
                    background: Rectangle{
                        color:"transparent"
                    }
                    Text{
                        id:dname
                        width : parent.width;
                        anchors.centerIn: parent
                        text: dishName
                        font.pixelSize: 40

                        //                        horizontalAlignment:Text.AlignHCenter
                        verticalAlignment:Text.AlignHCenter
                        color:"#fff"
                    }
                    Rectangle{
                        width:parent.width
                        height: 5
                        anchors.top: dname.bottom
                        color:recipe.currentIndex===index?"cyan":"#000"
                    }
                    onClicked: {
                        recipe.currentIndex=index
                    }
                }
                Button {
                    id:collection
                    width:150
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
                        text: collect==false?"收藏":"已收藏"
                        font.pixelSize: 40

                        horizontalAlignment:Text.AlignHCenter
                        verticalAlignment:Text.AlignHCenter
                        color:collect==0?"#fff":"orange"
                    }
                    onClicked: {
                        if(edit)
                        {
                            QmlDevState.deleteHistory(id)
                        }
                        else
                        {
                            QmlDevState.setCollect(index,!collect)
                        }
                    }
                }
            }
        }

    }
}

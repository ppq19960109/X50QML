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
        for(let i = 0; i < recipe.length; ++i) {
            listModel.append(recipe[i])
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
                console.log("详情",listModel.get(recipe.currentIndex).run)
                var param = {};
                param.dishName=listModel.get(recipe.currentIndex).dishName
                param.dishCookTime=listModel.get(recipe.currentIndex).dishCookTime
                param.imgSource=listModel.get(recipe.currentIndex).imgSource
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
                    anchors.right:collect.left
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
                    id:collect
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
                        text: collection==0?"收藏":"已收藏"
                        font.pixelSize: 40

                        horizontalAlignment:Text.AlignHCenter
                        verticalAlignment:Text.AlignHCenter
                        color:collection==0?"#fff":"orange"
                    }
                    onClicked: {
                        if(edit)
                        {

                        }
                        else
                        {

                        }
                    }
                }
            }
        }

    }
}

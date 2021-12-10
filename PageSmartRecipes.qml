import QtQuick 2.2
import QtQuick.Controls 2.2

Item {
    //定义全局分类菜谱
    property var  menuId: ['蔬菜','肉类','水产','面点']
    property var  cookMode: ["蒸","烤","多段"]
    property var  cookModeColor: ["#19A582","#EC7A00","#EC7A00"]
    id:root
    Component.onCompleted: {
        getRecipe(menuList.currentIndex)
    }
    function getRecipe(index)
    {
        listModel.clear();
        var recipe=QmlDevState.getRecipe(index);
        for(var i = 0; i < recipe.length; ++i) {
            listModel.append(recipe[i])
        }
    }

    //内容
    Rectangle{
        width:parent.width
        anchors.top:parent.top
        anchors.bottom: topBar.top

        Rectangle{
            id:leftContent
            width:150
            height:parent.height
            color:"#000"
            ListView{
                id:menuList
                model:menuId
                width:parent.width
                height:parent.height

                orientation:ListView.Vertical
                currentIndex:0
                delegate: Rectangle{
                    height: 100
                    width:parent.width
                    color:menuList.currentIndex===index?"#333837":"#3A403F"
                    Button {
                        width:parent.width
                        height:parent.height
                        anchors.centerIn: parent
                        background: Rectangle{
                            color:"transparent"
                        }
                        Text{
                            text: modelData
                            font.pixelSize: 40
                            anchors.centerIn: parent
                            color:menuList.currentIndex===index?"#00E6B6":"#FFF"

                        }
                        onClicked: {
                            console.log("menuList",index)
                            if(menuList.currentIndex!=index)
                            {
                                menuList.currentIndex=index
                                getRecipe(menuList.currentIndex)
                            }
                        }
                    }
                }
            }
        }
        ListModel {
            id:listModel

//            ListElement {
//                cookType: 1
//                dishName: "清蒸鱼"
//                imgUrl:"/images/peitu01.png"
//                cookSteps:'[{"mode":1,temp:100,time:90}]'
//                details:""
//                collect:0
//                time:123444
//            }
        }

        Rectangle{

            height:parent.height
            anchors.left: leftContent.right
            anchors.right: parent.right
            color:"#404545"
            ListView{
                id: recipe
                model:listModel
                width:parent.width
                height:parent.height
                anchors.top:parent.top

                orientation:ListView.Horizontal
                highlightRangeMode: ListView.StrictlyEnforceRange
                boundsBehavior:Flickable.StopAtBounds
                clip: true
                currentIndex:0
                delegate: Rectangle{
                    width:250
                    height:parent.height
                    color:"transparent"
                    radius: 8
                    Button {
                        width:220
                        height:330
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        background: Rectangle{
                            color:"transparent"
                        }
                        Image{
                            anchors.top:parent.top
                            anchors.bottom: recipeNme.top
                            width:parent.width
                            source: imgUrl
                        }
                        Rectangle{
                            width:88
                            height: 48
                            anchors.top:parent.top
                            anchors.left: parent.left
                            color:cookModeColor[cookType]
                            radius: 16
                            Text{
                                width : parent.width;
                                anchors.centerIn: parent
                                text: cookMode[cookType]
                                font.pixelSize: 30

                                horizontalAlignment:Text.AlignHCenter
                                verticalAlignment:Text.AlignVCenter
                                wrapMode:Text.WordWrap
                                color:"#fff"
                            }
                        }
                        Rectangle{
                            id:recipeNme
                            width:parent.width
                            height: 60
                            anchors.bottom: parent.bottom
                            color:"lightslategray"
                            Text{
                                text: dishName
                                font.pixelSize: 40
                                anchors.centerIn: parent
                                color:"#fff"

                            }
                            Rectangle{
                                width:parent.width
                                height: 5
                                anchors.bottom: parent.bottom
                                color:recipe.currentIndex===index?"blue":"#000"
                            }
                        }
                        onClicked: {
                            recipe.currentIndex=index
                        }
                    }
                }
            }
        }

    }
    ToolBar {
        id:topBar
        width:parent.width
        anchors.bottom: parent.bottom
        height:80
        background:Rectangle{
            color:"#2B2E2E"
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
            color:"#FFF"
            font.pixelSize: 40
            anchors.left:goBack.right
            anchors.verticalCenter: parent.verticalCenter
            text:qsTr("智慧菜谱")
        }

        //详情
        TabButton{
            width:88
            height:44
            anchors.right:parent.right
            anchors.rightMargin: 40
            anchors.verticalCenter: parent.verticalCenter
            background:Rectangle{
                color:"transparent"
                border.color:"#00E6B6"
                radius: 8
            }
            Text{
                color:"#00E6B6"
                font.pixelSize: 40
                anchors.centerIn:parent
                text:qsTr("详情")
            }
            onClicked: {
                console.log("详情",listModel.get(recipe.currentIndex).run)
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
}

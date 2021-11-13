import QtQuick 2.2
import QtQuick.Controls 2.2

Item {
    //定义全局分类菜谱
    property var  menuId: ['蔬菜','肉类','水产','面点','烘焙','其他']
    property var  cookMode: ["蒸","烤","多段"]
    property var  cookModeColor: ["aqua","lightpink","lightsalmon"]
    id:root
    Component.onCompleted: {
        getRecipe(menuList.currentIndex)
    }
    function getRecipe(index)
    {
        listModel.clear();
        var recipe=QmlDevState.getRecipe(index);
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
            text:qsTr("智慧菜谱")
        }

        //详情
        TabButton{
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
    //内容
    Rectangle{
        width:parent.width
        anchors.top:topBar.bottom
        anchors.bottom: parent.bottom
        color:"#000"

        Rectangle{
            id:leftContent
            width:126
            height:parent.height
            color:"#000"
            ListView{
                id:menuList
                model:menuId
                width:parent.width
                height:parent.height
                anchors.top:parent.top
                //                anchors.topMargin:56
                orientation:ListView.Vertical
                currentIndex:0
                delegate: Rectangle{
                    height: 62
                    width:parent.width
                    color:"#000"
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
                            color:menuList.currentIndex===index?"#fff":"#7286A4"

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
//                dishCook: 1
//                dishName: "清蒸鱼"
//                imgSource:"/images/peitu01.png"
//                cookSteps:'[{"mode":1,temp:100,time:90}]'
//                details:""
//                collection:0
//                time:123444
//            }
        }

        Rectangle{

            height:parent.height
            anchors.left: leftContent.right
            anchors.right: parent.right
            color:"#000"
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
                    width:(root.width-126)/3
                    height:root.height-96
                    color:"#000"
                    Button {
                        width:200
                        height:300
                        anchors.centerIn: parent
                        background: Rectangle{
                            color:"transparent"
                        }
                        Image{
                            anchors.top:parent.top
                            anchors.bottom: recipeNme.top
                            width:parent.width
                            source: imgSource
                        }
                        Rectangle{
                            width:40
                            height: 80
                            anchors.top:parent.top
                            anchors.left: parent.left
                            color:cookModeColor[dishCook]
                            Text{
                                width : parent.width;
                                //                                               height : parent.height;
                                anchors.centerIn: parent
                                text: cookMode[dishCook]
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
}

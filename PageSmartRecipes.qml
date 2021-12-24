import QtQuick 2.7
import QtQuick.Controls 2.2

Item {
    //定义全局分类菜谱
    property var  menuId: ['蔬菜','肉类','水产','面点']
    property var  cookMode: ["蒸","烤","多段"]
    property var  cookModeColor: ["#19A582","#EC7A00","#EC7A00"]

    Component.onCompleted: {
        getRecipe(menuList.currentIndex)
    }
    function getRecipe(index)
    {
        recipeListView.model=QmlDevState.getRecipe(index);
    }
    Image {
        anchors.fill: parent
        source: "/x50/main/背景.png"
    }
    PageBackBar{
        id:topBar
        width:parent.width
        anchors.bottom:parent.bottom
        height:80
        name:qsTr("智慧菜谱")
        leftBtnText:qsTr("")
        rightBtnText:qsTr("详情")
        onLeftClick:{
        }
        onRightClick:{
            load_page("pageCookDetails",JSON.stringify(recipeListView.model[recipeListView.currentIndex]))
        }
        onClose:{
            backPrePage()
        }
    }
    //内容
    Rectangle{
        width:parent.width
        anchors.top:parent.top
        anchors.bottom: topBar.top
        color:"transparent"
        Rectangle{
            id:leftContent
            width:150
            height:parent.height
            color:"transparent"
            //            color:"#000"
            //            opacity: 0.15
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
                    color:"transparent"
                    Button {
                        width:parent.width
                        height:parent.height
                        anchors.centerIn: parent
                        background: Rectangle{
                            color:"#000"
                            opacity: menuList.currentIndex===index?0.3:0.15
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

        Rectangle{

            height:parent.height
            anchors.left: leftContent.right
            anchors.right: parent.right
            color:"transparent"
            ListView{
                id: recipeListView
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

                    Button {
                        width:220
                        height:330
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        background: Rectangle{
                            color:"transparent"
//                            radius: 16
                            border.width: 4
                            border.color: recipeListView.currentIndex===index?cookModeColor[modelData.cookType]:"transparent"
                        }
                        Image{
                            anchors.fill: parent
                            anchors.margins: 4
//                            fillMode:Image.PreserveAspectFit
                            source: "file:"+modelData.imgUrl
                        }
                        Rectangle{
                            width:88
                            height: 48
                            anchors.top:parent.top
                            anchors.left: parent.left
                            color:cookModeColor[modelData.cookType]
                            radius: 16
                            Text{
                                width : parent.width;
                                anchors.centerIn: parent
                                text: cookMode[modelData.cookType]
                                font.pixelSize: 30

                                horizontalAlignment:Text.AlignHCenter
                                verticalAlignment:Text.AlignVCenter
                                wrapMode:Text.WordWrap
                                color:"#fff"
                            }
                        }
                        Rectangle{
                            id:recipeName
                            width:parent.width
                            height: 60
                            anchors.bottom: parent.bottom
                            color:"transparent"
                            Text{
                                text: modelData.dishName
                                font.pixelSize: 40
                                anchors.centerIn: parent
                                color:"#fff"

                            }
                        }
                        onClicked: {
                            recipeListView.currentIndex=index
                        }
                    }
                }
            }
        }
    }

}

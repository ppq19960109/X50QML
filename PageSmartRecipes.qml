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
                backPrePage()
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
            width:100
            height:50
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
                font.pixelSize: 30
                anchors.centerIn:parent
                horizontalAlignment:Text.AlignHCenter
                verticalAlignment:Text.AlignVCenter
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

        Rectangle{

            height:parent.height
            anchors.left: leftContent.right
            anchors.right: parent.right
            color:"#404545"
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
                            radius: 16
                        }
                        Image{
                            anchors.top:parent.top
                            anchors.bottom: recipeName.top
                            width:parent.width
                            source: modelData.imgUrl
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
                            color:"lightslategray"
                            Text{
                                text: modelData.dishName
                                font.pixelSize: 40
                                anchors.centerIn: parent
                                color:"#fff"

                            }
                            Rectangle{
                                width:parent.width
                                height: 5
                                anchors.bottom: parent.bottom
                                color:recipeListView.currentIndex===index?"blue":"#000"
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

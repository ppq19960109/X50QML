import QtQuick 2.7
import QtQuick.Controls 2.2
//import QtGraphicalEffects 1.0

import "../"
Item {
    //定义全局分类菜谱
    property var  menuId: ['蔬菜','肉类','水产','面点','烘培','其他']
    property var  cookMode: ["蒸","烤","多段"]
    property var  cookModeColor: ["#19A582","#EC7A00","#298FD1"]

    Component.onCompleted: {
        getRecipe(menuList.currentIndex)
    }
    function getRecipe(index)
    {
        recipeListView.model=QmlDevState.getRecipe(index);
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
                clip: true
                orientation:ListView.Vertical
                currentIndex:0
                delegate: Item{
                    height: 100
                    width:parent.width

                    Button {
                        width:parent.width
                        height:parent.height-1
                        anchors.top: parent.top
                        background: Rectangle{
                            anchors.fill: parent
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
                    width:260
                    height:370
                    anchors.top: parent.top
                    anchors.topMargin: 25
                    color:"transparent"
                    Image{
                        id:recipeImg
                        clip:true
                        anchors.fill: parent
                        anchors.margins: 0
                        //                            fillMode:Image.PreserveAspectFit
                        source: "file:"+modelData.imgUrl
                        smooth: true
                        visible: true
                    }
                    Image{
                        width: recipeBtn.width+1
                        anchors.bottom: recipeBtn.bottom
                        anchors.horizontalCenter: recipeBtn.horizontalCenter
                        source: "qrc:/x50/main/bj_mb.png"
                        Rectangle{
                            id:recipeName
                            width:parent.width
                            //                            height: 60
                            //                            anchors.bottom: parent.bottom
                            anchors.verticalCenter: parent.verticalCenter
                            color:"transparent"
                            Text{
                                width:parent.width-20
                                text: modelData.dishName
                                font.pixelSize: 35
                                anchors.centerIn: parent
                                color:"#fff"
                                horizontalAlignment:Text.AlignHCenter
                                verticalAlignment:Text.AlignVCenter
                                elide:Text.ElideRight
                            }
                        }
                    }
                    Button {
                        id:recipeBtn
                        width:222
                        height:332
                        //                        anchors.verticalCenter: parent.verticalCenter
                        //                        anchors.right: parent.right
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: 8
                        clip:true
                        background: Rectangle{
                            //                            width:parent.width+2
                            //                            height:parent.height+2
                            color:"transparent"
                            radius: 16
                            border.width: 4
                            border.color: recipeListView.currentIndex===index?cookModeColor[modelData.cookType]:"transparent"
                        }


                        //                        Rectangle{
                        //                            id: mask
                        //                            anchors.fill: parent
                        //                            radius: 16
                        //                            visible: false
                        //                            smooth: true
                        //                        }

                        //                        OpacityMask {
                        //                            anchors.fill: recipeImg
                        //                            source: recipeImg
                        //                            maskSource: mask
                        //                            visible: true
                        //                        }

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
                            Rectangle{
                                width:16
                                height: 16
                                color:cookModeColor[modelData.cookType]
                                anchors.left: parent.left
                                anchors.bottom: parent.bottom

                            }
                            Rectangle{
                                width:16
                                height: 16
                                color:cookModeColor[modelData.cookType]
                                anchors.right: parent.right
                                anchors.top: parent.top
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

import QtQuick 2.7
import QtQuick.Controls 2.2
//import QtGraphicalEffects 1.0
import "qrc:/CookFunc.js" as CookFunc
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
        anchors.bottom:parent.bottom
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
    Item{
        width:parent.width
        anchors.top:parent.top
        anchors.bottom: topBar.top
        Item{
            id:leftContent
            width:150
            height:parent.height

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
                        height:parent.height-2
                        anchors.top: parent.top
                        background: Item{}

                        Text{
                            text: modelData
                            font.pixelSize: 40
                            anchors.centerIn: parent
                            color:menuList.currentIndex===index?themesTextColor:themesTextColor2

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
                    Rectangle{
                        anchors.bottom: parent.bottom
                        width:parent.width
                        height: 2
                        color:"#fff"
                        opacity: 0.1
                    }
                }
            }
        }

        Item{
            height:parent.height
            anchors.left: leftContent.right
            anchors.right: parent.right
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
                delegate: Item{
                    readonly property int cookType:CookFunc.getCookType(modelData.cookSteps)
                    width:260
                    height:370
                    anchors.top: parent.top
                    anchors.topMargin: 25

                    Image{
                        id:recipeImg
                        asynchronous:true
                        anchors.fill: parent
                        anchors.margins: 0
                        sourceSize.width: 260
                        sourceSize.height: 370
                        //                            fillMode:Image.PreserveAspectFit
                        source: "file:"+modelData.imgUrl
                    }
                    Image{
                        asynchronous:true
                        width: recipeBtn.width
                        anchors.bottom: recipeBtn.bottom
                        anchors.horizontalCenter: recipeBtn.horizontalCenter
                        source: themesImagesPath+"recipename-background.png"

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
                    Button {
                        id:recipeBtn
                        width:222
                        height:332
                        //                        anchors.verticalCenter: parent.verticalCenter
                        //                        anchors.right: parent.right
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: 8
                        //                        clip:true
                        background: Rectangle{
                            color:"transparent"
                            border.width: 3
                            border.color: recipeListView.currentIndex===index?cookModeColor[cookType]:"transparent"
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
                            Rectangle{
                                width:16
                                height: 16
                                color:cookModeColor[cookType]
                                anchors.left: parent.left
                                anchors.top: parent.top
                            }
                            Rectangle{
                                width:16
                                height: 16
                                color:cookModeColor[cookType]
                                anchors.left: parent.left
                                anchors.bottom: parent.bottom
                            }
                            Rectangle{
                                width:16
                                height: 16
                                color:cookModeColor[cookType]
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

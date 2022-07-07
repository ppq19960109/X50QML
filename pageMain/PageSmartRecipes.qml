import QtQuick 2.7
import QtQuick.Controls 2.2
//import QtGraphicalEffects 1.0
import "qrc:/CookFunc.js" as CookFunc
import "qrc:/SendFunc.js" as SendFunc
import "../"
Item {
    //定义全局分类菜谱
    readonly property var  menuId: ['蔬菜','肉类','水产','面点','烘培','其他']
//    readonly property var  cookModeColor: ["#19A582","#EC7A00","#298FD1"]

    Connections { // 将目标对象信号与槽函数进行连接
        id:connections
        enabled:false
        target: QmlDevState
        onStateChanged: { // 处理目标对象信号的槽函数
            if("SteamStart"==key)
            {
                var root=recipeListView.model[recipeListView.currentIndex]
                console.log("SteamStart:",JSON.stringify(root),recipeListView.currentIndex)
                var cookSteps=JSON.parse(root.cookSteps)
                if(systemSettings.cookDialog[5]>0)
                {
                    if(CookFunc.isSteam(cookSteps))
                        loaderSteamShow(360,"请将食物放入左腔\n将水箱加满水","开始烹饪",root,5)
                    else
                        loaderSteamShow(292,"请将食物放入左腔","开始烹饪",root,5)
                    return
                }
                startCooking(root,cookSteps)
            }
        }
    }
    StackView.onActivated:{
        connections.enabled=true
    }
    StackView.onDeactivated:{
        connections.enabled=false
    }

    Component.onCompleted: {
        getRecipe(menuList.currentIndex)
        SendFunc.permitSteamStartStatus(1)
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
                cacheBuffer:2
                orientation:ListView.Vertical
                currentIndex:0
                highlightMoveDuration:40
                highlightMoveVelocity:-1
                boundsBehavior:Flickable.StopAtBounds
                snapMode: ListView.SnapToItem
                delegate: Item{
                    height: 100
                    width:parent.width

                    Button {
                        width:parent.width
                        height:parent.height-2
                        anchors.top: parent.top
                        background: Rectangle{
                            color:menuList.currentIndex===index?"#131313":"transparent"
                        }

                        Text{
                            text: modelData
                            font.pixelSize: menuList.currentIndex===index?45:35
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
                cacheBuffer:2
                orientation:ListView.Horizontal
//                highlightRangeMode: ListView.ApplyRange//StrictlyEnforceRange
                boundsBehavior:Flickable.StopAtBounds
                //snapMode: ListView.SnapToItem //SnapToItem SnapOneItem
                clip: true
                currentIndex:0
                highlightMoveDuration:40
                highlightMoveVelocity:-1
                delegate: Item{
                    readonly property int cookType:CookFunc.getCookType(modelData.cookSteps)
                    readonly property var recipeDetail:QmlDevState.getRecipeDetails(modelData.recipeid)
                    width:240
                    height:330
                    anchors.verticalCenter: parent.verticalCenter

                    Image{
                        id:recipeImg
                        anchors.right: parent.right
                        asynchronous:true
                        smooth:false
                        //                        anchors.margins: 0
                        width: 220
                        height: 330
                        sourceSize.width: 220
                        sourceSize.height: 330
                        //                            fillMode:Image.PreserveAspectFit
                        source: recipeDetail.length!=0?("file:"+recipeDetail[0]):""
                    }
                    Image{
                        asynchronous:true
                        smooth:false
                        width: recipeBtn.width
                        anchors.bottom: recipeBtn.bottom
                        anchors.horizontalCenter: recipeBtn.horizontalCenter
                        source: themesImagesPath+"recipename-background.png"

                        Text{
                            width:parent.width-20
                            text: modelData.dishName
                            font.pixelSize: 34
                            anchors.centerIn: parent
                            color:"#fff"
                            horizontalAlignment:Text.AlignHCenter
                            verticalAlignment:Text.AlignVCenter
                            elide:Text.ElideRight
                        }
                    }
                    Image{
                        asynchronous:true
                        smooth:false
                        anchors.top: recipeBtn.top
                        anchors.left: recipeBtn.left
                        sourceSize.width: 88
                        sourceSize.height: 48
                        source: themesImagesPath+cookModeImg[cookType]
                    }
                    Button {
                        id:recipeBtn
                        width:220
                        height:330
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: recipeImg.horizontalCenter

                        //                        clip:true
                        background: Rectangle{
                            color:"transparent"
                            radius: 4
                            border.width: 4
                            border.color: recipeListView.currentIndex===index?themesTextColor:"transparent"
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


                        onClicked: {
                            recipeListView.currentIndex=index
                        }
                    }
                }
            }
        }
    }

}

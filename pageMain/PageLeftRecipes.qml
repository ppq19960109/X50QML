import QtQuick 2.12
import QtQuick.Controls 2.5
import "qrc:/CookFunc.js" as CookFunc
import "qrc:/SendFunc.js" as SendFunc
import "../"
Item {
    Component.onCompleted: {
        getRecipe(menuList.currentIndex)
    }

    function getRecipe(index)
    {
        recipeListView.model=QmlDevState.getRecipe(index);
    }
    function steamStart(reserve)
    {
        if(lStOvState!==workStateEnum.WORKSTATE_STOP && lStOvState!==workStateEnum.WORKSTATE_FINISH)
        {
            loaderWarnConfirmShow("左腔正在烹饪\n暂时无法启动智慧菜谱");
            return
        }
        var cookItem=recipeListView.model[recipeListView.currentIndex]
        var cookSteps=JSON.parse(cookItem.cookSteps)
        if(reserve)
        {
            loaderCookReserve(cookWorkPosEnum.LEFT,cookItem)
        }
        else
        {
            if(systemSettings.cookDialog[4] === true)
            {
                if(CookFunc.isSteam(cookSteps))
                    loaderSteamShow("请将食物放入左腔，水箱中加满水","开始",cookItem,4)
                else
                    loaderSteamShow("当前模式需要预热\n请您在左腔预热完成后再放入食材","开始",cookItem,4)
                return
            }
            startCooking(cookItem,cookSteps)
        }
    }

    Component {
        id: recipeDelegate
        Item{
            readonly property int cookType:CookFunc.getCookType(modelData.cookSteps)
            width:recipeListView.currentIndex===index?194:164
            height:recipeListView.currentIndex===index?252:210
            anchors.verticalCenter: parent.verticalCenter
            Image{
                id:recipeImg
                width: parent.width-10
                height: parent.height
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                asynchronous:true
                smooth:false
                source: "file:"+modelData.imgUrl+"/0.png"
            }
            Image{
                asynchronous:true
                smooth:false
                width: recipeImg.width
                anchors.bottom: recipeImg.bottom
                anchors.horizontalCenter: recipeImg.horizontalCenter
                source: themesPicturesPath+(recipeListView.currentIndex===index?"recipename_checked_background.png":"recipename_unchecked_background.png")

                Text{
                    width:parent.width - 10
                    text: modelData.dishName
                    font.pixelSize: recipeListView.currentIndex===index?24:17
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
                anchors.top: recipeImg.top
                anchors.left: recipeImg.left
                source: themesPicturesPath+cookModeUncheckedImg[cookType]
            }
            Button {
                width: parent.width-10
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: recipeImg.horizontalCenter
                background: Rectangle{
                    color:"transparent"
                    radius: 4
                    border.width: 3
                    border.color: recipeListView.currentIndex===index?themesTextColor:"transparent"
                }
                onClicked: {
                    console.log("recipeDelegate onClicked",recipeListView.currentIndex,index)
                    if(recipeListView.currentIndex!=index)
                        recipeListView.currentIndex=index
                    else
                    {
                        push_page(pageCookDetails,{cookItem:recipeListView.model[index]})
                    }
                }
            }
        }
    }
    //内容
    Item{
        anchors.fill: parent
        Item{
            id:leftContent
            width:156
            height:parent.height

            Image {
                asynchronous:true
                smooth:false
                source: themesPicturesPath+"menulist_background.png"
            }
            ListView{
                id:menuList
                model:['蔬菜杂粮','家禽肉类','河海鲜类','烘焙甜点','其他食材']
                width:parent.width
                anchors.top: parent.top
                anchors.topMargin: 15
                anchors.bottom: parent.bottom
                orientation:ListView.Vertical
                currentIndex:0
                interactive:false
                delegate:Button {
                    width:parent.width
                    height:62
                    background:Image {
                        asynchronous:true
                        smooth:false
                        anchors.fill: parent
                        source: menuList.currentIndex===index?(themesPicturesPath+"menulist_item_background.png"):""
                    }
                    Text{
                        text: modelData
                        font.pixelSize: menuList.currentIndex===index?30:24
                        font.bold: menuList.currentIndex===index
                        anchors.centerIn: parent
                        color:"#fff"
                    }
                    onClicked: {
                        console.log("menuList",index)
                        if(menuList.currentIndex!=index)
                        {
                            menuList.currentIndex=index
                            getRecipe(index)
                        }
                    }
                }
            }
        }

        Item{
            height:parent.height
            anchors.left: leftContent.right
            anchors.right: parent.right
            //            ListView{
            //                id: recipeListView
            //                model:listModel
            //                width:152*4+180+20
            //                height:258
            //                anchors.left:parent.left
            //                anchors.top:parent.top
            //                anchors.topMargin: 26
            //                cacheBuffer:2
            //                orientation:ListView.Horizontal
            //                //                highlightRangeMode: ListView.ApplyRange//StrictlyEnforceRange
            //                boundsBehavior:Flickable.StopAtBounds
            //                snapMode: ListView.SnapToItem //SnapToItem SnapOneItem
            //                clip: true
            //                currentIndex:0
            //                highlightMoveDuration:0
            //                highlightMoveVelocity:-1
            //                delegate:recipeDelegate
            //            }
            PathView {
                id:recipeListView
                width:152*4+180+30
                height:258
                anchors.left:parent.left
                anchors.top:parent.top
                anchors.topMargin: 26

                clip: true
                //cacheItemCount:5
                currentIndex:0
                pathItemCount:3
                interactive: true
                preferredHighlightBegin: 0.5;
                preferredHighlightEnd: 0.5;

                highlightRangeMode: PathView.StrictlyEnforceRange
                //maximumFlickVelocity:1280
                model:listModel
                delegate:recipeDelegate
                path : Path{
                    startX:0
                    startY: recipeListView.height/2
                    PathLine {
                        x :recipeListView.width
                        y:recipeListView.height/2
                    }
                }
            }
            PageLaunchBtn {
                anchors.verticalCenter: recipeListView.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 30
                onStartUp:{
                    steamStart(false)
                }
                onReserve:{
                    steamStart(true)
                }
            }

        }
    }
}

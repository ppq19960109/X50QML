import QtQuick 2.12
import QtQuick.Controls 2.5

import "qrc:/CookFunc.js" as CookFunc
import "qrc:/SendFunc.js" as SendFunc

Item {
    property alias model:recipeListView.model
    Connections { // 将目标对象信号与槽函数进行连接
        id:connections
        enabled:false
        target: QmlDevState
        onStateChanged: { // 处理目标对象信号的槽函数
            if("SteamStart"==key)
            {
                var root=recipeListView.model[recipeListView.currentIndex]
                startPanguCooking(root,root.cookSteps)
            }
        }
    }

    onVisibleChanged: {
        if(visible)
        {
            connections.enabled=true
            SendFunc.permitSteamStartStatus(1)
        }
        else
        {
            connections.enabled=false
        }
    }
    ListView{
        id: recipeListView
        //                model:listModel
        width:parent.width-20
        height:parent.height
        anchors.left: parent.left
        anchors.top:parent.top
        cacheBuffer:2
        orientation:ListView.Horizontal
        //                highlightRangeMode: ListView.ApplyRange//StrictlyEnforceRange
        boundsBehavior:Flickable.StopAtBounds
        //snapMode: ListView.SnapToItem //SnapToItem SnapOneItem
        clip: true
        currentIndex:0
        highlightMoveDuration:0
        highlightMoveVelocity:-1
        delegate: Item{
            width:240
            height:330
            anchors.verticalCenter: parent.verticalCenter

            Image{
                id:recipeImg
                anchors.right: parent.right
                asynchronous:true
                smooth:false
                sourceSize.width: 220
                sourceSize.height: 330
                source: "file:"+modelData.imgUrl
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
                source: themesImagesPath+cookModeImg[modelData.cookType]
            }
            Button {
                id:recipeBtn
                width:220
                height:330
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: recipeImg.horizontalCenter
                background: Rectangle{
                    color:"transparent"
                    radius: 4
                    border.width: 4
                    border.color: recipeListView.currentIndex===index?themesTextColor:"transparent"
                }

                onClicked: {
                    if(recipeListView.currentIndex!=index)
                        recipeListView.currentIndex=index
                    else
                        load_page("pageRecipeDetails",{"root":recipeListView.model[recipeListView.currentIndex]})
                }
            }
        }
    }
}

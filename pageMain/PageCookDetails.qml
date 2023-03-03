import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import "qrc:/pageCook"
import "../"
import "qrc:/CookFunc.js" as CookFunc
import "qrc:/SendFunc.js" as SendFunc
Item {
    property string name: "PageCookDetails"
    property var cookItem
    function steamStart(reserve)
    {
        if(cookItem.cookPos===cookWorkPosEnum.LEFT)
        {
            var cookSteps=JSON.parse(cookItem.cookSteps)
            if(reserve)
            {
                loaderCookReserve(cookWorkPosEnum.LEFT,cookItem)
            }
            else
            {
                if(systemSettings.cookDialog[5] === true)
                {
                    if(CookFunc.isSteam(cookSteps))
                        loaderSteamShow("请将食物放入左腔，水箱中加满水","开始",cookItem,5)
                    else
                        loaderSteamShow("当前模式需要预热\n请您在左腔预热完成后再放入食材","开始",cookItem,5)
                    return
                }
                startCooking(cookItem,cookSteps)
            }
        }
        else
        {
            SendFunc.tempControlRquest(cookItem.temp,cookItem.dishName)

        }
    }

    Component.onCompleted: {
        dishName.text=cookItem.dishName
        details.text=cookItem.ingredients
    }

    PageBackBar{
        id:topBar
        anchors.top:parent.top
        name:qsTr("菜谱详情")
    }

    //内容
    Item{
        width:parent.width
        anchors.top:topBar.bottom
        anchors.bottom: parent.bottom

        Item{
            id:leftContent
            width: 250
            height: parent.height

            Image{
                id:recipeImg
                width: tabBar.currentIndex==0?180:210
                height: tabBar.currentIndex==0?277:122
                anchors.centerIn: parent
                asynchronous:true
                smooth:false
                source: {
                    if(cookItem.cookPos==0)
                    {
                        if(tabBar.currentIndex==0)
                            return "file:"+cookItem.imgUrl+"/0.png"
                        else{
                            return "file:"+cookItem.imgUrl+"/"+(swipeview.currentIndex+1)+".png"
                        }
                    }
                    else
                    {
                        return "file:"+cookItem.imgUrl+".png"
                    }
                }
            }
            Image{
                visible: tabBar.currentIndex==0
                asynchronous:true
                smooth:false
                width: recipeImg.width
                anchors.bottom: recipeImg.bottom
                anchors.horizontalCenter: recipeImg.horizontalCenter
                source: themesPicturesPath+"recipename_checked_background.png"

                Text{
                    id:dishName
                    width:parent.width - 10
                    font.pixelSize: 26
                    anchors.centerIn: parent
                    color:"#fff"
                    horizontalAlignment:Text.AlignHCenter
                    verticalAlignment:Text.AlignVCenter
                    elide:Text.ElideRight
                }
            }
        }

        Item{
            width:730
            height:parent.height
            anchors.left: leftContent.right

            TabBar {
                id:tabBar
                contentWidth:180
                contentHeight:40
                anchors.top: parent.top
                anchors.topMargin: 12

                background:Rectangle {
                    color: "#2C2C2C"
                    radius: 20
                }

                Repeater {
                    model: ["食材", "步骤"]
                    TabButton {
                        width: 90
                        height: parent.height
                        background:Rectangle {
                            color: index==tabBar.currentIndex?themesTextColor2:"transparent"
                            radius: 20
                        }
                        Text{
                            anchors.fill: parent
                            text:modelData
                            color:index==tabBar.currentIndex?"#000":themesTextColor2
                            font.pixelSize: 26
                            horizontalAlignment:Text.AlignHCenter
                            verticalAlignment:Text.AlignVCenter
                        }
                    }
                }
            }
            Rectangle {
                width: parent.width
                height: 250
                anchors.top: parent.top
                anchors.topMargin: 64
                color:"#2C2C2C"
                StackLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    currentIndex: tabBar.currentIndex
                    Item{
                        PageScrollBarText{
                            id: details
                            anchors.fill: parent
                            anchors.rightMargin: 30
                            scrollBarLeftMargin:30
                        }
                    }
                    Item{
                        SwipeView {
                            id:swipeview
                            anchors.fill: parent
                            clip: true
                            Repeater {
                                model:cookItem.details
                                Flickable {
                                    id: flick
                                    flickableDirection:Flickable.VerticalFlick
                                    contentWidth: detail.width
                                    contentHeight: detail.height+30
                                    clip: true
                                    boundsBehavior:Flickable.StopAtBounds
                                    Text {
                                        font.pixelSize: 24
                                        color:"#fff"
                                        text:"步骤"+(index+1)+"/"+swipeview.count
                                    }
                                    Text {
                                        id:detail
                                        width: flick.width-30
                                        anchors.top: parent.top
                                        anchors.topMargin: 30
                                        font.pixelSize: 30
                                        lineHeight: 1.2
                                        color:"#fff"
                                        wrapMode: Text.WrapAnywhere
                                        text:modelData
                                    }
                                    ScrollBar.vertical:ScrollBar {
                                        anchors.right: parent.right
                                        visible: flick.height < contentHeight
                                        background:Rectangle{
                                            implicitWidth: 4
                                            color:"#000"
                                            radius: implicitWidth / 2
                                        }
                                        contentItem: Rectangle {
                                            implicitWidth: 4
                                            radius: implicitWidth / 2
                                            color: themesTextColor
                                        }
                                    }
                                }

                            }
                            Component.onCompleted:{
                                contentItem.highlightMoveDuration = 0
                                contentItem.highlightMoveVelocity = -1
                                contentItem.boundsBehavior=Flickable.StopAtBounds
                            }
                        }
                    }
                }
            }
            PageIndicator {
                visible: tabBar.currentIndex==1
                count: swipeview.count
                currentIndex: swipeview.currentIndex
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10
                anchors.horizontalCenter: parent.horizontalCenter
                interactive: false
                delegate: Rectangle {
                    color: index===swipeview.currentIndex?"#FFF":"#6F6F6F"
                    implicitWidth: 8
                    implicitHeight: 8
                    radius: 4
                }
            }

        }
        PageLaunchBtn {
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 30
            reserveVisible:cookItem.cookPos===cookWorkPosEnum.LEFT
            onStartUp:{
                steamStart(false)
            }
            onReserve:{
                steamStart(true)
            }
        }
    }
}

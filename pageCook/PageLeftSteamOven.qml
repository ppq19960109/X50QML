import QtQuick 2.7
import QtQuick.Controls 2.2
import "../"
import "qrc:/CookFunc.js" as CookFunc
import "qrc:/SendFunc.js" as SendFunc
Rectangle {
    color:themesWindowBackgroundColor

    readonly property var workModeImg: ["", "icon_1", "icon_1","icon_4", "icon_35", "icon_36", "icon_38", "icon_40", "icon_42", "icon_68", "icon_1", "icon_68"]
    property int cookWorkPos:0

    Component.onCompleted: {
        console.log("PageLeftSteamOven onCompleted")
        var i
        switch (cookWorkPos)
        {
        case cookWorkPosEnum.LEFT:
            for ( i=0; i< leftWorkModeModelEnum.length ; ++i) {
                modeListModel.append(leftWorkModeModelEnum[i])
            }
            break
        case cookWorkPosEnum.RIGHT:
            for ( i=0; i< rightWorkModeModelEnum.length ; ++i) {
                modeListModel.append(rightWorkModeModelEnum[i])
            }
            break
        case cookWorkPosEnum.ASSIST:
            for ( i=0; i< rightAssistWorkModeModelEnum.length ; ++i) {
                modeListModel.append(rightAssistWorkModeModelEnum[i])
            }
            break
        }

    }

    ListModel {
        id:modeListModel
    }

    function steamStart()
    {
        var list = steamOvenDelegate.getCurrentSteamOven()

        var cookItem =CookFunc.getDefCookItem()
        cookItem.cookPos=cookWorkPosEnum.LEFT
        cookItem.dishName=CookFunc.getDishName(list)
        cookItem.cookSteps=JSON.stringify(list)
        console.log("cookItem:",JSON.stringify(cookItem))

        if(systemSettings.cookDialog[0]>0)
        {
            if(CookFunc.isSteam(list))
                loaderSteamShow(360,"请将食物放入左腔\n将水箱加满水","开始烹饪",cookItem,0)
            else
                loaderSteamShow(292,"请将食物放入左腔","开始烹饪",cookItem,0)
            return
        }
        startCooking(cookItem,list)
    }

    PageBackBar{
        id:topBar
        anchors.top:parent.top
        name:qsTr("左腔蒸烤")
    }

    //内容
    Item{
        width:parent.width
        anchors.bottom:parent.bottom
        anchors.top: topBar.bottom
        PageLaunchBtn {
            anchors.verticalCenter: steamOvenDelegate.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 30
            onStartUp:{
                steamStart()
            }
            onReserve:{
                var list = steamOvenDelegate.getCurrentSteamOven()
                var cookItem =CookFunc.getDefCookItem()
                cookItem.cookPos=cookWorkPosEnum.LEFT
                cookItem.dishName=CookFunc.getDishName(list)
                cookItem.cookSteps=JSON.stringify(list)

                push_page("pageSteamBakeReserve",JSON.stringify(cookItem))
                cookItem=undefined
            }
        }

        PageSteamOvenDelegate {
            id:steamOvenDelegate
            width:291+180*2+180+20*3
            height: parent.height-50
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 30
            modeModel:modeListModel
            modeWidth:291
            tempWidth:180
            timeWidth:180
            steamGearVisible:cookWorkPos===cookWorkPosEnum.LEFT?true:false
            modeItemCount:cookWorkPos===cookWorkPosEnum.LEFT?5:3
        }
    }

}

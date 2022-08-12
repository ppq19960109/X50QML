import QtQuick 2.7
import QtQuick.Controls 2.2
import "../"
import "qrc:/CookFunc.js" as CookFunc

Rectangle {
    property string name: "PageSteamOvenConfig"
    color:themesWindowBackgroundColor
    property int cookWorkPos:0

    Component.onCompleted: {
        switch (cookWorkPos)
        {
        case cookWorkPosEnum.RIGHT:
            steamOvenDelegate.modeModel=rightWorkModeModelEnum
            topBar.name=qsTr("右腔速蒸")
            break
        case cookWorkPosEnum.ASSIST:
            steamOvenDelegate.modeModel=rightAssistWorkModeModelEnum
            topBar.name=qsTr("辅助烹饪（仅右腔可辅助烹饪）")
            break
        }
    }
    Component.onDestruction: {
        loaderMainHide()
    }
    function steamStart(reserve)
    {
        var cookSteps = []
        cookSteps.push(steamOvenDelegate.getCurrentSteamOven())

        var cookItem =CookFunc.getDefCookItem()
        cookItem.cookPos=cookWorkPosEnum.LEFT
        cookItem.dishName=CookFunc.getDishName(cookSteps)
        cookItem.cookSteps=JSON.stringify(cookSteps)
        if(reserve)
        {
            loaderCookReserve(cookWorkPos,cookItem)
        }
        else
        {
            switch (cookWorkPos)
            {
            case cookWorkPosEnum.LEFT:
                if(systemSettings.cookDialog[0] === true)
                {
                    if(CookFunc.isSteam(cookSteps))
                        loaderSteamShow("请将食物放入左腔，水箱中加满水","开始",cookItem,0)
                    else
                        loaderSteamShow("当前模式需要预热\n请您在左腔预热完成后再放入食材","开始",cookItem,0)
                    return
                }
                break
            case cookWorkPosEnum.RIGHT:
                if(systemSettings.cookDialog[1] === true)
                {
                    if(CookFunc.isSteam(cookSteps))
                        loaderSteamShow("请将食物放入右腔，水箱中加满水","开始",cookItem,1)
                    else
                        loaderSteamShow("当前模式需要预热\n请您在右腔预热完成后再放入食材","开始",cookItem,1)
                    return
                }
                break
            case cookWorkPosEnum.ASSIST:
                if(systemSettings.cookDialog[2] === true)
                {
                    if(CookFunc.isSteam(cookSteps))
                        loaderSteamShow("请将食物放入右腔，水箱中加满水","开始",cookItem,2)
                    else
                        loaderSteamShow("当前模式需要预热\n请您在右腔预热完成后再放入食材","开始",cookItem,2)
                    return
                }
                break

            }
            startCooking(cookItem,cookSteps)
        }
        cookSteps=undefined
        cookItem=undefined
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
                steamStart(false)
            }
            onReserve:{
                steamStart(true)
            }
        }

        PageSteamOvenDelegate {
            id:steamOvenDelegate
            width:cookWorkPos===cookWorkPosEnum.LEFT?(291+180*3+20*3):(291+226*2+20*2)
            height: parent.height-50
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: cookWorkPos===cookWorkPosEnum.LEFT?40:100
            modeModel:leftWorkModeModelEnum
            modeWidth:291
            tempWidth:cookWorkPos===cookWorkPosEnum.LEFT?180:226
            timeWidth:cookWorkPos===cookWorkPosEnum.LEFT?180:226
            steamGearVisible:cookWorkPos===cookWorkPosEnum.LEFT?true:false
            modeItemCount:cookWorkPos===cookWorkPosEnum.LEFT?5:3
        }
    }

}

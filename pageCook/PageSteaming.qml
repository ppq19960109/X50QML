import QtQuick 2.12
import QtQuick.Controls 2.5

import "qrc:/pageCook"
import "../"
import "qrc:/SendFunc.js" as SendFunc
import "qrc:/CookFunc.js" as CookFunc
Item {
    property string name: "PageSteaming"
    property var lStOvState: QmlDevState.state.LStOvState
    property var rStOvState: QmlDevState.state.RStOvState
    property var lStOvSetTimer: QmlDevState.state.LStOvSetTimer
    property var rStOvSetTimer: QmlDevState.state.RStOvSetTimer
    property var lStOvSetTimerLeft: QmlDevState.state.LStOvSetTimerLeft
    property var rStOvSetTimerLeft: QmlDevState.state.RStOvSetTimerLeft
    property var lStOvOrderTimer: QmlDevState.state.LStOvOrderTimer
    property var rStOvOrderTimer: QmlDevState.state.RStOvOrderTimer
    property var lStOvOrderTimerLeft: QmlDevState.state.LStOvOrderTimerLeft
    property var rStOvOrderTimerLeft: QmlDevState.state.RStOvOrderTimerLeft
    property var lStOvMode: QmlDevState.state.LStOvMode
    property var rStOvMode: QmlDevState.state.RStOvMode

    Component{
        id:component_cancelSteam
        PageDialogConfirm{
            hintCenterText:""
            cancelText:"否"
            confirmText:"是"
            onCancel:{
                loaderMainHide()
            }
            onConfirm:{
                SendFunc.setCookOperation(cookWorkPos,workOperationEnum.CANCEL)
                loaderMainHide()
            }
        }
    }
    function loaderCancelSteamShow(cookWorkPos,status){
        loaderManual.sourceComponent = component_cancelSteam

        loaderManual.item.hintCenterText="是否取消"+(cookWorkPos===0?"左腔":"右腔")+((status===workStateEnum.WORKSTATE_RESERVE||status===workStateEnum.WORKSTATE_PAUSE_RESERVE)?"预约？":"烹饪？")
        loaderManual.item.cookWorkPos=cookWorkPos
    }
    function loaderCancelSteamHide()
    {
        if(loaderManual.sourceComponent === component_cancelSteam)
        {
            loaderManual.sourceComponent = null
        }
    }

    PageBackBar{
        id:topBar
        anchors.top:parent.top
        name:"蒸烤箱"
        customClose:true
        onClose:{
            let page=isExistView("PageSteamOven")
            if(page==null)
                backTopPage()
            else
                backPage(page)
        }
    }
    Row {
        width: parent.width-100
        anchors.top: topBar.bottom
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: row.horizontalCenter
        spacing: 780
        Repeater {
            model: ["左腔","右腔"]
            Item
            {
                width: btnBar.width
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter

                PageButtonBar{
                    id:btnBar
                    visible: {
                        if(index==0)
                        {
                            return lStOvState!==workStateEnum.WORKSTATE_FINISH
                        }
                        else
                        {
                            return rStOvState!==workStateEnum.WORKSTATE_FINISH
                        }
                    }
                    anchors.verticalCenter: parent.verticalCenter
                    orientation:true
                    space:models.length==3?33:54
                    models: {
                        if(index==0)
                        {
                            if(lStOvState===workStateEnum.WORKSTATE_STOP)
                                return ["左腔蒸烤","多段烹饪","智慧菜谱"]
                            else if(lStOvState===workStateEnum.WORKSTATE_PAUSE)
                                return ["继续","取消"]
                            else if(lStOvState===workStateEnum.WORKSTATE_PAUSE_RESERVE)
                                return ["继续","取消","立即烹饪"]
                            else if(lStOvState===workStateEnum.WORKSTATE_RESERVE)
                                return ["暂停","取消","立即烹饪"]
                            else
                                return ["暂停","取消"]
                        }
                        else
                        {
                            if(rStOvState===workStateEnum.WORKSTATE_STOP)
                                return ["右腔速蒸","辅助烹饪"]
                            else if(rStOvState===workStateEnum.WORKSTATE_PAUSE)
                                return ["继续","取消"]
                            else if(rStOvState===workStateEnum.WORKSTATE_PAUSE_RESERVE)
                                return ["继续","取消","立即烹饪"]
                            else if(rStOvState===workStateEnum.WORKSTATE_RESERVE)
                                return ["暂停","取消","立即烹饪"]
                            else
                                return ["暂停","取消"]
                        }
                    }
                    onClick: {
                        let stOvState
                        if(index==0)
                            stOvState=lStOvState
                        else
                            stOvState=rStOvState
                        if(clickIndex==0)
                        {
                            if(stOvState===workStateEnum.WORKSTATE_STOP)
                                push_page(pageSteamOvenConfig,{cookWorkPos:index})
                            else if(stOvState===workStateEnum.WORKSTATE_PAUSE||stOvState===workStateEnum.WORKSTATE_PAUSE_RESERVE)
                                SendFunc.setCookOperation(index,workOperationEnum.START)
                            else
                                SendFunc.setCookOperation(index,workOperationEnum.PAUSE)

                        }
                        else if(clickIndex==1)
                        {
                            if(stOvState===workStateEnum.WORKSTATE_STOP)
                            {
                                if(index==0)
                                    push_page(pageMultistage)
                                else
                                    push_page(pageSteamOvenConfig,{cookWorkPos:cookWorkPosEnum.ASSIST})
                            }
                            else
                            {
                                loaderCancelSteamShow(index,stOvState)
                            }
                        }
                        else
                        {
                            if(stOvState===workStateEnum.WORKSTATE_STOP)
                                push_page(pageSmartRecipes)
                            else
                                SendFunc.setCookOperation(index,workOperationEnum.RUN_NOW)
                        }
                    }


                }
                Text{
                    id:stateText
                    color:themesTextColor2
                    font.pixelSize: 24
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 17
                    text:qsTr(modelData+"状态")
                }
                Image {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.horizontalCenterOffset: index==0?-60:60
                    anchors.verticalCenter: stateText.verticalCenter
                    asynchronous:true
                    smooth:false
                    source: themesPicturesPath+(index==0?"icon_leftcook_state.png":"icon_rightcook_state.png")
                }
            }
        }
    }
    Row {
        id:row
        width: 290*2+112
        height: 290
        anchors.top: topBar.bottom
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 112

        Repeater {
            model: ["左腔","右腔"]
            Button{
                width: 290
                height: width

                background:Image {
                    asynchronous:true
                    smooth:false
                    source: themesPicturesPath+"icon_steam_runing_background.png"
                }
                PageRotationImg{
                    width: 290
                    height: width
                    smooth:true
                    visible: {
                        if(index==0)
                        {
                            return lStOvState===workStateEnum.WORKSTATE_PREHEAT
                        }
                        else
                        {
                            return rStOvState===workStateEnum.WORKSTATE_PREHEAT
                        }
                    }
                    duration:8000
                    anchors.centerIn: parent
                    source:themesPicturesPath+"icon_steam_runing.png"
                }

                Item
                {
                    visible: {
                        if(index==0)
                        {
                            return lStOvState===workStateEnum.WORKSTATE_STOP
                        }
                        else
                        {
                            return rStOvState===workStateEnum.WORKSTATE_STOP
                        }
                    }
                    anchors.fill: parent
                    Image {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: 86
                        asynchronous:true
                        smooth:false
                        source: themesPicturesPath+"icon_cook_add.png"
                    }
                    Text{
                        text:modelData+"烹饪"
                        color:themesTextColor2
                        font.pixelSize: 30
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: 183
                    }
                }
                Item
                {
                    visible: {
                        if(index==0)
                        {
                            return lStOvState!==workStateEnum.WORKSTATE_STOP && lStOvState!==workStateEnum.WORKSTATE_FINISH
                        }
                        else
                        {
                            return rStOvState!==workStateEnum.WORKSTATE_STOP && rStOvState!==workStateEnum.WORKSTATE_FINISH
                        }
                    }
                    anchors.fill: parent
                    Text{
                        text:{
                            if(index==0)
                            {
                                return workStateChineseEnum[lStOvState]
                            }
                            else
                            {
                                return workStateChineseEnum[rStOvState]
                            }
                        }
                        color:themesTextColor
                        font.pixelSize: 30
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: 48
                    }
                    Text{
                        visible: flashAnimation.flash==0
                        PageFlashAnimation {
                            id:flashAnimation
                            running: {
                                if(index==0)
                                {
                                    return lStOvState===workStateEnum.WORKSTATE_PAUSE||lStOvState===workStateEnum.WORKSTATE_PAUSE_RESERVE
                                }
                                else
                                {
                                    return rStOvState===workStateEnum.WORKSTATE_PAUSE||rStOvState===workStateEnum.WORKSTATE_PAUSE_RESERVE
                                }
                            }
                        }
                        text:{
                            if(index==0)
                            {
                                if(lStOvState===workStateEnum.WORKSTATE_PREHEAT)
                                    return QmlDevState.state.LStOvRealTemp+"℃"
                                else if(lStOvState===workStateEnum.WORKSTATE_RESERVE||lStOvState===workStateEnum.WORKSTATE_PAUSE_RESERVE)
                                    return lStOvOrderTimerLeft+"分钟"
                                else
                                    return lStOvSetTimerLeft+"分钟"
                            }
                            else
                            {
                                if(rStOvState===workStateEnum.WORKSTATE_PREHEAT)
                                    return QmlDevState.state.RStOvRealTemp+"℃"
                                else if(rStOvState===workStateEnum.WORKSTATE_RESERVE||rStOvState===workStateEnum.WORKSTATE_PAUSE_RESERVE)
                                    return rStOvOrderTimerLeft+"分钟"
                                else
                                    return rStOvSetTimerLeft+"分钟"
                            }
                        }
                        color:themesTextColor
                        font.pixelSize: 50
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: 98
                    }
                    Item
                    {
                        width: 220
                        height: 40
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: 161
                        clip: true
                        Text{
                            id:modeName
                            width: parent.width
                            horizontalAlignment:modeName.contentWidth>parent.width?Text.AlignLeft:Text.AlignHCenter
                            text:{
                                if(index==0)
                                {
                                    if(QmlDevState.state.LMultiMode===1)
                                    {
                                        var LCookbookName=QmlDevState.state.LCookbookName
                                        if(LCookbookName==="")
                                        {
                                            if(QmlDevState.state.LCookbookID > 0)
                                            {
                                                var cookName=QmlDevState.getRecipeName(QmlDevState.state.LCookbookID)
                                                if(cookName!=="")
                                                    return cookName
                                            }
                                        }
                                        else
                                            return LCookbookName
                                    }
                                    if(lStOvMode===40)
                                        return CookFunc.workModeName(lStOvMode)+QmlDevState.state.LSteamGear+"档"
                                    else
                                        return CookFunc.workModeName(lStOvMode)
                                }
                                else
                                {
                                    if(QmlDevState.state.RMultiMode===1)
                                    {
                                        var RCookbookName=QmlDevState.state.RCookbookName
                                        if(RCookbookName==="")
                                        {
                                        }
                                        else
                                            return RCookbookName
                                    }
                                    return CookFunc.workModeName(rStOvMode)
                                }
                            }
                            color:themesTextColor2
                            font.pixelSize: 30
                        }
                        PropertyAnimation {
                            id:textAnimation
                            target: modeName
                            property: "x"
                            from: 0
                            to: -(modeName.contentWidth-modeName.width)
                            duration: 5000
                            loops: 1
                            running: false
                            easing.type: Easing.Linear
                            onFinished:{
                                modeName.x=0
                            }
                        }
                        Timer{
                            repeat: running
                            running: modeName.contentWidth>modeName.width
                            interval: 60000
                            triggeredOnStart: true
                            onTriggered: {
                                textAnimation.restart()
                            }
                        }
                    }
                    Text{
                        text:{
                            if(index==0)
                            {
                                return QmlDevState.state.LStOvSetTemp+"℃   "+lStOvSetTimer+"分钟"
                            }
                            else
                            {
                                return QmlDevState.state.RStOvSetTemp+"℃   "+rStOvSetTimer+"分钟"
                            }
                        }
                        color:themesTextColor2
                        font.pixelSize: 24
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: 200
                    }
                }
                Item
                {
                    visible: {
                        if(index==0)
                        {
                            return lStOvState===workStateEnum.WORKSTATE_FINISH
                        }
                        else
                        {
                            return rStOvState===workStateEnum.WORKSTATE_FINISH
                        }
                    }
                    anchors.fill: parent
                    Text{
                        text:{
                            if(index==0)
                            {
                                return QmlDevState.state.LMultiMode===1?QmlDevState.state.LCookbookName:CookFunc.workModeName(lStOvMode)
                            }
                            else
                            {
                                return QmlDevState.state.RMultiMode===1?QmlDevState.state.RCookbookName:CookFunc.workModeName(rStOvMode)
                            }
                        }
                        color:themesTextColor2
                        font.pixelSize: 30
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: 75
                    }
                    Text{
                        text:"烹饪已完成"
                        color:themesTextColor
                        font.pixelSize: 30
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: 123
                    }
                    Button {
                        width:140
                        height: 50
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: 186
                        background: Rectangle{
                            color:themesTextColor2
                            radius: 25
                        }
                        Text{
                            text:"返回"
                            color:"#000"
                            font.pixelSize: 30
                            anchors.centerIn: parent
                        }
                        onClicked: {
                            SendFunc.setCookOperation(index,workOperationEnum.CONFIRM)
                        }
                    }
                }
                PageIndicator {
                    id:indicator
                    visible:{
                        if(index==0)
                        {
                            return QmlDevState.state.LMultiMode > 0
                        }
                        else
                        {
                            return QmlDevState.state.RMultiMode > 0
                        }
                    }
                    count: {
                        if(index==0)
                        {
                            return QmlDevState.state.LMultiTotalStep
                        }
                        else
                        {
                            return QmlDevState.state.RMultiTotalStep
                        }
                    }
                    currentIndex: {
                        if(index==0)
                        {
                            return QmlDevState.state.LMultiCurrentStep-1
                        }
                        else
                        {
                            return QmlDevState.state.RMultiCurrentStep-1
                        }
                    }
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 35
                    anchors.horizontalCenter: parent.horizontalCenter
                    interactive: false
                    delegate: Rectangle {
                        implicitWidth: 24
                        implicitHeight: 4
                        radius: implicitHeight/2
                        color:index===indicator.currentIndex?themesTextColor:"#4f4f4f"
                    }
                }
                PageCirBar{
                    width: 290
                    height: width
                    anchors.centerIn: parent
                    runing: {
                        if(index==0)
                        {
                            return lStOvState!==workStateEnum.WORKSTATE_STOP && lStOvState!==workStateEnum.WORKSTATE_FINISH && lStOvState!==workStateEnum.WORKSTATE_PREHEAT
                        }
                        else
                        {
                            return rStOvState!==workStateEnum.WORKSTATE_STOP && rStOvState!==workStateEnum.WORKSTATE_FINISH && rStOvState!==workStateEnum.WORKSTATE_PREHEAT
                        }
                    }
                    canvasDiameter:width
                    outerRing:false
                    percent:{
                        if(index==0)
                        {
                            if(lStOvState===workStateEnum.WORKSTATE_RESERVE||lStOvState===workStateEnum.WORKSTATE_PAUSE_RESERVE)
                                return 100-Math.floor(100*lStOvOrderTimerLeft/lStOvOrderTimer)
                            else
                                return 100-Math.floor(100*lStOvSetTimerLeft/lStOvSetTimer)
                        }
                        else
                        {
                            if(rStOvState===workStateEnum.WORKSTATE_RESERVE||rStOvState===workStateEnum.WORKSTATE_PAUSE_RESERVE)
                                return 100-Math.floor(100*rStOvOrderTimerLeft/rStOvOrderTimer)
                            else
                                return 100-Math.floor(100*rStOvSetTimerLeft/rStOvSetTimer)
                        }
                    }
                }
                onClicked: {
                    var cookItem
                    if(index==0)
                    {
                        if(QmlDevState.state.LMultiMode===multiModeEnum.NONE)
                        {
                            if(lStOvState===workStateEnum.WORKSTATE_PAUSE)
                            {
                                loaderPauseSteamShow(cookWorkPosEnum.LEFT)
                            }
                            else if(lStOvState===workStateEnum.WORKSTATE_PAUSE_RESERVE)
                            {
                                cookItem =CookFunc.getDefCookItem()
                                cookItem.cookPos=cookWorkPosEnum.LEFT
                                loaderCookReserve(cookItem.cookPos,cookItem)
                            }
                        }
                        else if(QmlDevState.state.LMultiMode===multiModeEnum.MULTISTAGE && lStOvState!==workStateEnum.WORKSTATE_STOP && lStOvState!==workStateEnum.WORKSTATE_FINISH && lMultiStageContent!=null)
                        {
                            push_page(pageMultistageShow)
                        }
                    }
                    else
                    {
                        if(QmlDevState.state.RMultiMode===multiModeEnum.NONE)
                        {
                            if(rStOvState===workStateEnum.WORKSTATE_PAUSE)
                            {
                                loaderPauseSteamShow(cookWorkPosEnum.RIGHT)
                            }
                            else if(rStOvState===workStateEnum.WORKSTATE_PAUSE_RESERVE)
                            {
                                cookItem =CookFunc.getDefCookItem()
                                cookItem.cookPos=cookWorkPosEnum.RIGHT
                                loaderCookReserve(cookItem.cookPos,cookItem)
                            }
                        }
                    }
                }
            }
        }
    }
    Component{
        id:component_pauseSteam
        Item {
            property alias modeModel: steamOvenDelegate.modeModel
            property alias workPos: steamOvenDelegate.workPos
            function modeChange(modeIndex,tempIndex,timeIndex,steamGearIndex)
            {
                steamOvenDelegate.modeChange(modeIndex,tempIndex,timeIndex,steamGearIndex)
            }
            MouseArea{
                anchors.fill: parent
            }
            anchors.fill: parent
            Rectangle{
                anchors.fill: parent
                color: "#000"
                opacity: 0.6
            }
            Rectangle {
                width: 1066
                height: 351
                anchors.centerIn: parent
                color: "#333333"
                radius: 4

                Button {
                    width:closeImg.width+50
                    height:closeImg.height+50
                    anchors.top:parent.top
                    anchors.right:parent.right
                    Image {
                        id:closeImg
                        asynchronous:true
                        smooth:false
                        anchors.centerIn: parent
                        source: themesPicturesPath+"icon_window_close.png"
                    }
                    background: null
                    onClicked: {
                        loaderPauseSteamHide()
                    }
                }
                PageSteamOvenDelegate {
                    id:steamOvenDelegate
                    width:291+180*3+20*3
                    height: parent.height-70
                    anchors.top: parent.top
                    anchors.topMargin: 15
                    anchors.left: parent.left
                    anchors.leftMargin: 60
                    modeItemCount:3
                    tempItemCount:3
                    timeItemCount:3
                }
                Item {
                    width:80+140*2
                    height: 50
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 20
                    anchors.horizontalCenter: parent.horizontalCenter
                    Button {
                        width:140
                        height: 50
                        anchors.left: parent.left
                        background: Rectangle{
                            color:themesTextColor2
                            radius: 25
                        }
                        Text{
                            text:qsTr("取消")
                            color:"#000"
                            font.pixelSize: 34
                            anchors.centerIn: parent
                        }
                        onClicked: {
                            loaderPauseSteamHide()
                        }
                    }
                    Button {
                        width:140
                        height: 50
                        anchors.right: parent.right
                        background: Rectangle{
                            color:themesTextColor2
                            radius: 25
                        }
                        Text{
                            text:qsTr("确定")
                            color:"#000"
                            font.pixelSize: 34
                            anchors.centerIn: parent
                        }
                        onClicked: {
                            var cookSteps = []
                            cookSteps.push(steamOvenDelegate.getCurrentSteamOven())

                            var cookItem =CookFunc.getDefCookItem()
                            cookItem.cookPos=workPos
                            cookItem.dishName=CookFunc.getDishName(cookSteps)
                            cookItem.cookSteps=JSON.stringify(cookSteps)
                            startCooking(cookItem,cookSteps)
                            loaderPauseSteamHide()
                        }
                    }
                }
            }
        }
    }
    function loaderPauseSteamShow(dir){
        var modeIndex,tempIndex,timeIndex,steamGearIndex=0
        loaderManual.sourceComponent = component_pauseSteam
        loaderManual.item.workPos=dir
        if(dir===cookWorkPosEnum.LEFT)
        {
            modeIndex=CookFunc.leftWorkModeToIndex(lStOvMode)
            tempIndex=QmlDevState.state.LStOvSetTemp
            timeIndex=lStOvSetTimer
            steamGearIndex=QmlDevState.state.LSteamGear

            loaderManual.item.modeModel=leftWorkModeModelEnum
            loaderManual.item.modeChange(modeIndex,tempIndex,timeIndex,steamGearIndex)
        }
        else
        {
            modeIndex=CookFunc.rightWorkModeToIndex(rStOvMode)
            tempIndex=QmlDevState.state.RStOvSetTemp
            timeIndex=rStOvSetTimer

            loaderManual.item.modeModel=CookFunc.getrRightModeModel(rStOvMode)
        }
        loaderManual.item.modeChange(modeIndex,tempIndex,timeIndex,steamGearIndex)
    }
    function loaderPauseSteamHide(){
        if(loaderManual.sourceComponent===component_pauseSteam)
            loaderManual.sourceComponent = undefined
    }
}

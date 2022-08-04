import QtQuick 2.7
import QtQuick.Controls 2.2

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
        loader_main.sourceComponent = component_cancelSteam

        loader_main.item.hintCenterText="是否取消"+(cookWorkPos==0?"左腔":"右腔")+((status===workStateEnum.WORKSTATE_RESERVE||status===workStateEnum.WORKSTATE_PAUSE_RESERVE)?"预约？":"烹饪？")
        loader_main.item.cookWorkPos=cookWorkPos
    }
    function loaderCancelSteamHide()
    {
        if(loader_main.sourceComponent === component_cancelSteam)
        {
            loader_main.sourceComponent = null
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
                            else if(lStOvState===workStateEnum.WORKSTATE_PAUSE||lStOvState===workStateEnum.WORKSTATE_PAUSE)
                                return ["继续","取消"]
                            else
                                return ["暂停","取消"]
                        }
                        else
                        {
                            if(rStOvState===workStateEnum.WORKSTATE_STOP)
                                return ["右腔速蒸","辅助烹饪"]
                            else if(rStOvState===workStateEnum.WORKSTATE_PAUSE||rStOvState===workStateEnum.WORKSTATE_PAUSE)
                                return ["继续","取消"]
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
                            push_page(pageSmartRecipes)
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
                    //                    source: themesPicturesPath+"icon_close_heat.png"
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
                    duration:4000
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
                        text:{
                            if(index==0)
                            {
                                if(lStOvState===workStateEnum.WORKSTATE_PREHEAT)
                                    return QmlDevState.state.LStOvRealTemp+"℃"
                                else
                                    return lStOvSetTimerLeft+"分钟"
                            }
                            else
                            {
                                if(rStOvState===workStateEnum.WORKSTATE_PREHEAT)
                                    return QmlDevState.state.RStOvRealTemp+"℃"
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
                    Text{
                        text:{
                            if(index==0)
                            {
                                return QmlDevState.state.MultiMode===1?QmlDevState.state.CookbookName:CookFunc.workModeName(QmlDevState.state.LStOvMode)
                            }
                            else
                            {
                                return CookFunc.workModeName(QmlDevState.state.RStOvMode)
                            }
                        }
                        color:themesTextColor2
                        font.pixelSize: 30
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: 161
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
                                return QmlDevState.state.MultiMode===1?QmlDevState.state.CookbookName:CookFunc.workModeName(QmlDevState.state.LStOvMode)
                            }
                            else
                            {
                                return CookFunc.workModeName(QmlDevState.state.RStOvMode)
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
                    outerRing:true
                    percent:{
                        if(index==0)
                        {
                            return 100-Math.floor(100*lStOvSetTimerLeft/lStOvSetTimer)
                        }
                        else
                        {
                            return 100-Math.floor(100*rStOvSetTimerLeft/rStOvSetTimer)
                        }
                    }
                }
                onClicked: {
                    if(index==0)
                    {

                    }
                    else
                    {

                    }
                }
            }
        }
    }

}

import QtQuick 2.12
import QtQuick.Controls 2.5

import "pageMain"
import "WifiFunc.js" as WifiFunc
import "qrc:/SendFunc.js" as SendFunc
Item {

    property int lastLStOvState:-1
    property int lastRStOvState:-1
    property int lastErrorCodeShow:-1
    property int lastHoodSpeed:0
    property int lastHoodLight:0

    enabled: sysPower > 0

    Component{
        id:component_multistageConfirm
        PageDialogConfirm{
            hintTopText:""
            hintCenterText:""
            cancelText:""
            confirmText:"继续烹饪"
            onCancel: {
                loaderAuto.sourceComponent = null
            }
            onConfirm: {
                SendFunc.setCookOperation(cookWorkPosEnum.LEFT,workOperationEnum.START)
                loaderAuto.sourceComponent = null
            }
        }
    }
    function loaderMultistageShow(text){
        if(loaderAuto.sourceComponent !== component_multistageConfirm)
            loaderAuto.sourceComponent = component_multistageConfirm
        loaderAuto.item.hintCenterText=text
    }
    function loaderMultistageHide(){
        if(loaderAuto.sourceComponent === component_multistageConfirm)
        {
            loaderAuto.sourceComponent = null
        }
    }

    Component{
        id:component_updateConfirm
        PageDialogConfirm{
            hintTopText:"系统更新"
            hintCenterText:"检测到最新版本 "+get_current_version(QmlDevState.state.OTANewVersion,null)+"\n请问是否立即更新?"
            cancelText:"取消"
            confirmText:"升级"
            onCancel: {
                loaderAuto.sourceComponent = undefined
            }
            onConfirm: {
                SendFunc.otaRquest(1)
            }
        }
    }
    function loaderUpdateConfirmShow(){
        sysPowerWakeup()
        loaderAuto.sourceComponent = component_updateConfirm
    }

    Component{
        id:component_updatePowerConfirm
        PageDialogConfirm{
            hintTopText:"系统更新"
            hintCenterText:"检测到最新版本 "+get_current_version(null,QmlDevState.state.OTAPowerNewVersion)+"\n请问是否立即更新?"
            cancelText:"取消"
            confirmText:"升级"
            onCancel: {
                loaderAuto.sourceComponent = undefined
            }
            onConfirm: {
                SendFunc.otaPowerRquest(1)
            }
        }
    }
    function loaderUpdatePowerConfirmShow(){
        sysPowerWakeup()
        loaderAuto.sourceComponent = component_updatePowerConfirm
    }

    Component{
        id:component_update
        Rectangle {
            anchors.fill: parent
            color: themesWindowBackgroundColor
            property alias updateProgress: updateBar.value
            property alias titleText: title.text
            MouseArea{
                anchors.fill: parent
            }
            Text {
                id:title
                anchors.top: parent.top
                anchors.topMargin: 50
                anchors.horizontalCenter: parent.horizontalCenter
                color:themesTextColor
                font.pixelSize: 50
                text: qsTr("升级中,请勿断电!")
            }
            PageRotationImg {
                anchors.top: parent.top
                anchors.topMargin: 155
                anchors.horizontalCenter: parent.horizontalCenter
                source: themesPicturesPath+"icon_loading_big.png"
            }
            Text {
                anchors.top: parent.top
                anchors.topMargin: 300
                anchors.horizontalCenter: parent.horizontalCenter
                color:"#FFF"
                font.pixelSize: 40
                text: qsTr(updateBar.value+"%")
            }
            ProgressBar {
                id:updateBar
                width: 650
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 100
                anchors.horizontalCenter: parent.horizontalCenter
                from:0
                to:100
                value: 0

                background: Rectangle {
                    implicitWidth: parent.width
                    implicitHeight: 4
                    color: themesTextColor2
                    radius: 2
                }

                contentItem: Item {
                    implicitWidth: parent.width
                    implicitHeight: 4

                    Rectangle {
                        width: updateBar.visualPosition * parent.width
                        height: parent.height
                        radius: 2
                        color: themesTextColor
                    }
                }
            }
        }
    }
    function loaderUpdateShow(text){
        loaderAuto.sourceComponent = component_update
        loaderAuto.item.titleText=text+"升级中,请勿断电!"
    }
    function loaderUpdateProgress(value){
        if(value>0 && loaderAuto.sourceComponent !== component_update)
        {
            loaderAuto.sourceComponent = component_update
        }
        if(loaderAuto.sourceComponent === component_update)
            loaderAuto.item.updateProgress=value
    }

    function loaderUpdateResultShow(text){
        loaderAutoTextShow(text)
    }

    function steamInterfaceChange(state){
        if(state===false)
        {
            if(isExistView("PageSteaming")!=null)
            {
                let page=isExistView("PageSteamOven")
                if(page==null)
                    backTopPage()
                else
                    backPage(page)
            }
        }
        else
        {
            if(isExistView("PageSteaming")==null)
            {
                if(isCurrentView("PageSteamOvenConfig")===true||isCurrentView("PageMultistage")===true)
                    push_page(pageSteaming)
                else if(isCurrentView("PageSmartRecipes")===true||isCurrentView("PageCookDetails")===true)
                {
                    if(smartRecipesIndex==0)
                        push_page(pageSteaming)
                }
            }
        }
    }

    Connections { // 将目标对象信号与槽函数进行连接
        target: QmlDevState
        onRebootChanged:{
            console.log("onRebootChanged...")
            systemSettings.reboot=true
        }
        onLocalConnectedChanged:{
            console.log("page home onLocalConnectedChanged",value)
            if(value > 0)
            {
                if(boot.playing==false)
                    SendFunc.getAllToServer()
                loaderErrorHide()

                SendFunc.setBuzControl(buzControlEnum.STOP)
                SendFunc.setProductionTestStatus(0)
            }
            else
            {
                loaderErrorShow("通讯板故障！","请拨打售后电话<font color='"+themesTextColor+"'>400-888-8490</font><br/>咨询售后人员",false)
                standbyWakeup()
            }
        }
        onStateChanged: { // 处理目标对象信号的槽函数
            console.log("pageHome onStateChanged",key,value)
            if("SysPower"==key)
            {
                //                console.log("systemSettings.reboot",systemSettings.reboot)
                if(systemSettings.reboot==false)
                {
                    if(value==0)
                    {
                        if(sysPower<0)
                        {
                            SendFunc.setSysPower(1)
                            SendFunc.setBuzControl(buzControlEnum.SHORT)
                        }
                    }
                    else
                    {
                        if(sysPower<0)
                        {
                            SendFunc.setBuzControl(buzControlEnum.SHORT)
                        }

                    }
                }
                systemPower(value)
                if(systemSettings.reboot==false)
                {
                    if(errorCodeShow!=null && errorCodeShow!==0)
                    {
                        if(errorCodeShow===6)
                            errorBuzzer=true
                        loaderErrorCodeShow(errorCodeShow)
                    }
                }
                if(systemSettings.firstStartup===true)
                {
                    systemSettings.firstStartup=false
                    systemSync()
                    SendFunc.enableWifi(true)
                    loaderFirstStartupShow()
                }
            }
            else if("ComSWVersion"==key)
            {
                if(systemSettings.otaSuccess==true)
                {
                    systemSettings.otaSuccess=false
                    loaderUpdateResultShow("通讯板已更新至最新版本\n"+get_current_version(value,null))
                    systemSync()
                }
            }
            else if("PwrSWVersion"==key)
            {
                if(value===QmlDevState.state.OTAPowerNewVersion)
                {
                    SendFunc.setSysPower(1)
                    loaderUpdateResultShow("电源板已更新至最新版本\n"+get_current_version(null,value))
                }
            }
            else if("NtpTimestamp"==key)
            {
                if(value>1640966400)
                    getCurrentTime(value)
            }
            else if("OTASlientUpgrade"==key)
            {
                if(value>0)
                {
                    systemSettings.reboot=true
                    gSlientUpgradeMinutes=getRandom(0,30)
                    console.log("OTASlientUpgrade gSlientUpgradeMinutes:",gSlientUpgradeMinutes)
                }
            }
            else if("LStOvState"==key)
            {
                if(value===workStateEnum.WORKSTATE_STOP)
                {
                    if(rStOvState===workStateEnum.WORKSTATE_STOP)
                    {
                        steamInterfaceChange(false)
                    }
                }
                else
                {
                    steamInterfaceChange(true)
                }

                if(value===workStateEnum.WORKSTATE_RUN)
                    sleepWakeup()

                if(lastLStOvState!=value && lastLStOvState>=0)
                {
                    if(value===workStateEnum.WORKSTATE_PAUSE||value===workStateEnum.WORKSTATE_PAUSE_RESERVE||value===workStateEnum.WORKSTATE_PAUSE_PREHEAT)
                    {
                        if(QmlDevState.state.LStOvDoorState===1)
                            loaderDoorAutoShow("左腔门打开，暂停烹饪","","好的",cookWorkPosEnum.LEFT)
                    }
                    else
                    {
                        if(QmlDevState.state.LStOvDoorState===0)
                        {
                            if(value===workStateEnum.WORKSTATE_STOP)
                            {
                                loaderDoorAutoHide(cookWorkPosEnum.LEFT)
                            }
                        }
                    }

                    if(lastLStOvState===workStateEnum.WORKSTATE_STOP)
                    {
                        if(value===workStateEnum.WORKSTATE_PREHEAT || value===workStateEnum.WORKSTATE_RUN)
                        {
                            SendFunc.setBuzControl(buzControlEnum.SHORT)
                            sleepWakeup()
                        }
                    }
                    else if(lastLStOvState===workStateEnum.WORKSTATE_PREHEAT && value===workStateEnum.WORKSTATE_RUN)
                    {
                        var lMode=QmlDevState.state.LStOvMode
                        if(lMode===35||lMode===36||lMode===38||lMode===40||lMode===42)
                            loaderAutoCompleteShow("预热完成\n请将食物放入左腔！")
                        SendFunc.setBuzControl(buzControlEnum.SHORT)
                    }
                    else if(lastLStOvState===workStateEnum.WORKSTATE_RESERVE && (value===workStateEnum.WORKSTATE_PREHEAT||value===workStateEnum.WORKSTATE_RUN))
                        SendFunc.setBuzControl(buzControlEnum.SHORT)
                    else if(value===workStateEnum.WORKSTATE_FINISH)
                        SendFunc.setBuzControl(buzControlEnum.SHORTFIVE)

                    if(value===workStateEnum.WORKSTATE_STOP)
                        loaderMultistageHide()
                }
                lastLStOvState=value
            }
            else if("LStOvDoorState"==key)
            {
                if(value==0)
                {
                    if(lStOvState===workStateEnum.WORKSTATE_PAUSE||lStOvState===workStateEnum.WORKSTATE_PAUSE_RESERVE||lStOvState===workStateEnum.WORKSTATE_PAUSE_PREHEAT)
                        loaderDoorAutoRestoreShow("左腔门已关闭，是否继续烹饪？","继续烹饪",cookWorkPosEnum.LEFT)
                }
            }
            else if("RStOvState"==key)
            {
                if(value===workStateEnum.WORKSTATE_STOP)
                {
                    if(lStOvState===workStateEnum.WORKSTATE_STOP)
                    {
                        steamInterfaceChange(false)
                    }
                }
                else
                {
                    steamInterfaceChange(true)
                }
                if(value===workStateEnum.WORKSTATE_RUN)
                    sleepWakeup()

                if(lastRStOvState!=value && lastRStOvState>=0)
                {
                    if(value===workStateEnum.WORKSTATE_PAUSE||value===workStateEnum.WORKSTATE_PAUSE_RESERVE||value===workStateEnum.WORKSTATE_PAUSE_PREHEAT)
                    {
                        if(QmlDevState.state.RStOvDoorState===1)
                            loaderDoorAutoShow("右腔门打开，暂停烹饪","","好的",cookWorkPosEnum.RIGHT)
                    }
                    else
                    {
                        if(QmlDevState.state.RStOvDoorState===0)
                        {
                            if(value===workStateEnum.WORKSTATE_STOP)
                            {
                                loaderDoorAutoHide(cookWorkPosEnum.RIGHT)
                            }
                        }
                    }
                    if(lastRStOvState===workStateEnum.WORKSTATE_STOP)
                    {
                        if(value===workStateEnum.WORKSTATE_PREHEAT || value===workStateEnum.WORKSTATE_RUN)
                        {
                            SendFunc.setBuzControl(buzControlEnum.SHORT)
                            sleepWakeup()
                        }
                    }
                    else if(lastRStOvState===workStateEnum.WORKSTATE_PREHEAT && value===workStateEnum.WORKSTATE_RUN)
                        SendFunc.setBuzControl(buzControlEnum.SHORT)
                    else if(lastRStOvState===workStateEnum.WORKSTATE_RESERVE && (value===workStateEnum.WORKSTATE_PREHEAT||value===workStateEnum.WORKSTATE_RUN))
                        SendFunc.setBuzControl(buzControlEnum.SHORT)
                    else if(value===workStateEnum.WORKSTATE_FINISH)
                        SendFunc.setBuzControl(buzControlEnum.SHORTFIVE)
                }
                lastRStOvState=value
            }
            else if("RStOvDoorState"==key)
            {
                if(value==0)
                {
                    if(rStOvState===workStateEnum.WORKSTATE_PAUSE||rStOvState===workStateEnum.WORKSTATE_PAUSE_RESERVE||rStOvState===workStateEnum.WORKSTATE_PAUSE_PREHEAT)
                        loaderDoorAutoRestoreShow("右腔门已关闭，是否继续烹饪？","继续烹饪",cookWorkPosEnum.RIGHT)
                }
            }
            else if("LStOvPauseTimerLeft"==key)
            {
                if(value==0)
                    loaderDoorAutoRestoreHide(cookWorkPosEnum.LEFT)
            }
            else if("RStOvPauseTimerLeft"==key)
            {
                if(value==0)
                    loaderDoorAutoRestoreHide(cookWorkPosEnum.RIGHT)
            }
            else if("HoodOffLeftTime"==key)
            {
                if(value==0)
                    closeLoaderHoodOff()
            }
            else if("HoodOffRemind"==key)
            {
                if(value==1)
                {
                    if(QmlDevState.state.HoodOffLeftTime!==0)
                    {
                        showLoaderHoodOff()
                    }
                }
                else if(value==2)
                {
                    if(lStOvState === workStateEnum.WORKSTATE_PREHEAT || lStOvState === workStateEnum.WORKSTATE_RUN || lStOvState === workStateEnum.WORKSTATE_PAUSE || rStOvState === workStateEnum.WORKSTATE_PREHEAT || rStOvState === workStateEnum.WORKSTATE_RUN|| rStOvState === workStateEnum.WORKSTATE_PAUSE)
                        loaderAutoTextShow("蒸烤箱工作中，需散热，烟机无法关闭。")
                }
                else if(value==3)
                {
                    if(lStOvState === workStateEnum.WORKSTATE_PREHEAT || lStOvState === workStateEnum.WORKSTATE_RUN|| lStOvState === workStateEnum.WORKSTATE_PAUSE)
                        loaderAutoTextShow("烤箱工作中，需散热，烟机不得低于2档。")
                }
                else if(value==4)
                {
                    if(QmlDevState.state.LStoveStatus > 0 || QmlDevState.state.RStoveStatus > 0)
                        loaderAutoTextShow("灶具工作中，烟机无法关闭。")
                }
                else if(value==5)
                {
                    sleepStandby()
                }
            }
            else if("RStoveStatus"==key)
            {
                if(auxiliarySwitch>0)
                {
                    if(value==0)
                    {
                        if(timer_auxiliary.running==false)
                            timer_auxiliary.restart()
                    }
                    else
                    {
                        if(timer_auxiliary.running==true)
                            timer_auxiliary.stop()
                    }
                }
            }
            else if("ErrorCodeShow"==key)
            {
                if(lastErrorCodeShow!=value)
                {
                    if(value>0)
                    {
                        loaderErrorCodeShow(value)
                    }
                    else
                    {
                        loaderErrorHide()
                    }
                    if(systemSettings.reboot==true)
                    {
                        systemSettings.reboot=false
                    }
                }
                lastErrorCodeShow=value
            }
            else if("WifiEnable"==key)
            {
                systemSettings.wifiEnable=value
                if(value==0)
                {
                    wifiConnectInfo.ssid=""
                    wifiConnected=false
                    wifiModel.clear()
                }
                console.log("WifiEnable",value)
                if(productionTestFlag==2 && value > 0)
                {
                    getQuadScanWifi()
                }
                systemSync()
            }
            else if("WifiState"==key)
            {
                wifiConnected=false
                if(value==1)
                {
                    wifiConnecting=true
                }
                else
                {
                    wifiConnecting=false
                    if(value==2 || value==3||value==5)
                    {
                        QmlDevState.executeShell("(wpa_cli reconfigure) &")
                        WifiFunc.deleteWifiInfo(wifiConnectInfo)
                        if(wifiPageStatus==false)
                        {
                            wifiConnectInfo.ssid=""
                        }
                    }
                    else if(value==4)
                    {
                        wifiConnected=true
                    }
                    if(wifiPageStatus==false)
                    {
                        SendFunc.getCurWifi()
                    }
                }
                console.log("WifiState",value,wifiConnected,wifiConnecting)
            }
            else if("Wifissid"==key)
            {
                if(wifiConnected==true && wifiConnectInfo.ssid!="")
                {
                    //                    if(pattern.test(wifiConnectInfo.ssid))
                    //                    {
                    decode_ssid=decodeURI(value.replace(/\\x/g,'%'))
                    //                    }
                    //                    else
                    //                    {
                    //                        decode_ssid=value
                    //                    }
                    console.log("decode_ssid",decode_ssid,wifiConnectInfo.ssid)
                    if(decode_ssid==wifiConnectInfo.ssid)
                    {
                        WifiFunc.addWifiInfo(wifiConnectInfo)
                        var real_value=value.replace(/\\{1}x/g,"\\\\x")
                        QmlDevState.executeShell("(wpa_cli list_networks | tail -n +3 | grep \'"+real_value+"\' | grep -v 'CURRENT' | awk '{system(\"wpa_cli remove_network \" $1)}' && wpa_cli save_config) &")
                        real_value=null
                    }
                }
                if(wifiPageStatus==false)
                {
                    wifiConnectInfo.ssid=""
                }
            }
            else if("LStoveTimingState"==key)
            {
                if(value === timingStateEnum.CONFIRM)
                {
                    loaderAutoTextShow("左灶定时结束，请将灶具旋钮复位")
                    SendFunc.setBuzControl(buzControlEnum.SHORTTHREE)
                }
                else if(value === timingStateEnum.STOP)
                    loaderStoveAutoPopupHide("左灶定时")
            }
            else if("RStoveTimingState"==key)
            {
                if(value === timingStateEnum.CONFIRM)
                {
                    loaderAutoTextShow("右灶定时结束，请将灶具旋钮复位")
                    SendFunc.setBuzControl(buzControlEnum.SHORTTHREE)
                }
                else if(value === timingStateEnum.STOP)
                    loaderStoveAutoPopupHide("右灶定时")
            }
            else if("HoodSpeed"==key)
            {
                if(value!=0)
                {
                    if(lastHoodSpeed!=value)
                        sleepWakeup()
                }
                lastHoodSpeed=value
            }
            else if("HoodLight"==key)
            {
                if(value!=0)
                {
                    if(lastHoodLight!=value)
                        sleepWakeup()
                }
                lastHoodLight=value
            }
            else if("OTAState"==key)
            {
                if(value==otaStateEnum.OTA_NEW_FIRMWARE)
                {
                    loaderUpdateConfirmShow()
                }
                else if(value==otaStateEnum.OTA_DOWNLOAD_START)
                {
                    loaderUpdateShow("通讯板")
                }
                else if(value==otaStateEnum.OTA_DOWNLOAD_FAIL)
                {
                    loaderUpdateResultShow("通讯板升级失败")
                }
                else if(value==otaStateEnum.OTA_INSTALL_SUCCESS)
                {
                    systemSettings.reboot=true
                    systemSettings.otaSuccess=true
                }
            }
            else if("OTAPowerState"==key)
            {
                if(value==otaStateEnum.OTA_NEW_FIRMWARE)
                {
                    loaderUpdatePowerConfirmShow()
                }
                else if(value==otaStateEnum.OTA_DOWNLOAD_START)
                {
                    loaderUpdateShow("电源板")
                }
                else if(value==otaStateEnum.OTA_DOWNLOAD_FAIL)
                {
                    loaderUpdateResultShow("电源板升级失败")
                }
                else if(value==otaStateEnum.OTA_INSTALL_SUCCESS)
                {

                }
            }
            else if("OTAProgress"==key || "OTAPowerProgress"==key)
            {
                console.log("OTAProgress:",value)
                loaderUpdateProgress(value);
            }
            else if( "DeviceSecret"==key && productionTestFlag==1)
            {
                if(value==""||value==null)
                {
                    productionTestStatus=0xff
                    systemPower(1)
                    SendFunc.setSysPower(1)
                    productionTestFlag=2
                    if(systemSettings.wifiEnable==false)
                        SendFunc.enableWifi(true)
                    else
                    {
                        getQuadScanWifi()
                    }
                }
                else
                {
                    productionTestFlag=0x0f
                }
            }
            else if("WifiScanR"==key && systemSettings.wifiEnable>0)
            {
                setWifiList(value)
                if( productionTestFlag>=2 && productionTestFlag<=5 && QmlDevState.state.DeviceSecret==="")
                {
                    parseWifiList()
                }
            }
            else if("LMultiRemind"==key)
            {
                if(value>0 && QmlDevState.state.LMultiMode === 1)
                {
                    loaderMultistageShow(QmlDevState.state.LMultiRemindText)
                }
                else
                {
                    loaderMultistageHide()
                }
            }
            else if("CookAssistRemind"==key)
            {
                if(value==0)
                {
                    loaderAutoTextShow("右灶火力档位过小，无法达到"+QmlDevState.state.RAuxiliaryTemp+"℃\n请将火力调至最大！")
                }
                else if(value==1)
                {
                    loaderAutoTextShow("右灶长时间无锅具，已将燃气断开。\n请将旋钮复位！")
                }
                else if(value==2)
                {
                    loaderAutoTextShow("烟机档位发生变化，智能排烟已为您自动关闭")
                }
            }
            else if("RAuxiliarySwitch"==key)
            {
                if(value>0)
                {
                    if(smartRecipesIndex==1)
                        push_page(pageSmartCook)
                }
            }
        }
    }

    function setWifiList(sanR)
    {
        var root=JSON.parse(sanR)
        root.sort(function(a, b){return b.rssi - a.rssi})
        wifiModel.clear()
        var result={}
        var element
        var bssid=QmlDevState.state.Wifibssid
        for(var i = 0; i < root.length; ++i) {
            element=root[i]
            if(element.ssid==="")
                continue
            result.connected=0

            result.ssid=root[i].ssid
            result.level=WifiFunc.signalLevel(element.rssi)
            result.flags=WifiFunc.encrypType(element.flags)

            if(element.bssid===bssid && wifiConnected==true)
            {
                result.connected=1
                wifiModel.insert(0,result)
            }
            else
                wifiModel.append(result)
        }
    }

    Component{
        id:component_burn_wifi
        Item {
            Rectangle{
                width: 400
                height: 200
                color: "red"
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                Text {
                    anchors.centerIn: parent
                    font.pixelSize: 50
                    color: "#FFF"
                    text: qsTr("烧录WIFI不存在")
                }
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    loaderMainHide()
                }
            }
            Component.onCompleted: {
                SendFunc.setBuzControl(buzControlEnum.SHORT)
            }
            Component.onDestruction: {
                productionTestStatus=0
                systemPower(QmlDevState.state.SysPower)
                loaderErrorCodeShow(errorCodeShow)
            }
        }
    }
    function showBurnWifi(){
        loaderManual.sourceComponent = component_burn_wifi
    }
    function getQuadScanWifi()
    {
        SendFunc.scanWifi()
        timer_scanwifi.restart()
    }

    function parseWifiList()
    {
        var i
        for( i = 0; i < wifiModel.count; ++i) {
            if(wifiModel.get(i).ssid===productionTestWIFISSID)//productionTestWIFISSID
            {
                wifiModel.setProperty(0,"connected",0)
                wifiModel.setProperty(i,"connected",2)
                wifiModel.move(i,0,1)
                break
            }
        }

        if(i === wifiModel.count)
        {
            if(productionTestFlag<5)
            {
                ++productionTestFlag
                getQuadScanWifi()
                return
            }
            productionTestFlag=0x0f
            showBurnWifi()
            return
        }
        productionTestFlag=0x0f
        push_page(pageGetQuad)
    }
    Timer{
        id:timer_scanwifi
        repeat: false
        running: false
        interval: 3000
        triggeredOnStart: false
        onTriggered: {
            SendFunc.scanRWifi()
        }
    }
    Component.onCompleted: {
        console.log("page home onCompleted")

        QmlDevState.startLocalConnect()
        //        MNetwork.locationRequest();
        //        MNetwork.timeRequest();
        //        loaderAlarmShow()
        //        loaderErrorShow("左腔蒸箱加热异常！","请拨打售后电话 <font color='"+themesTextColor+"'>400-888-8490</font><br/>咨询售后人员");
        //        loaderErrorShow("右腔干烧检测电路故障！","请拨打售后电话<font color='"+themesTextColor+"'>400-888-8490</font><br/>咨询售后人员")
        //        loaderUpdateConfirmShow()
        //       loaderUpdateResultShow("系统已更新至最新版本\n"+"1.2.0")
        //loaderScreenSaverShow()
        //loaderDoorAutoRestoreShow("左腔门已关闭，是否继续烹饪？","继续烹饪",cookWorkPosEnum.LEFT)
    }

    Item{
        anchors.fill:parent
        Row {
            width: 292*3+100
            height: 360
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            spacing: 50

            Button{
                width: 292
                height:parent.height

                background:Image {
                    source: themesPicturesPath+"home_hood_background.png"
                }
                Text{
                    text:"烟机灶具"
                    color:"#fff"
                    font.pixelSize: 40
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 45
                    Text{
                        text:"HOOD"
                        color:"#C3C2C2"
                        font.pixelSize: 16
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.bottom
                        anchors.topMargin: 10
                        anchors.left: parent.left
                    }
                }
                Column{
                    width: 182
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: 40
                    spacing: 6
                    Item
                    {
                        visible: smartSmokeSwitch
                        width: parent.width
                        height: 50
                        Rectangle{
                            width: parent.width
                            height: parent.height
                            color: "#000"
                            opacity: 0.5
                            border.color: themesTextColor
                            radius: 4
                        }
                        Text{
                            text:"AUTO"
                            color:themesTextColor
                            font.pixelSize: 26
                            anchors.centerIn: parent
                        }
                    }
                    Item
                    {
                        visible: hoodSpeed > 0 && (testMode==true||smartSmokeSwitch===0)
                        width: parent.width
                        height: 50
                        Rectangle{
                            visible: true
                            width: parent.width
                            height: parent.height
                            color: "#000"
                            opacity: 0.5
                            border.color: themesTextColor
                            radius: 4
                        }
                        Image {
                            anchors.centerIn: parent
                            anchors.horizontalCenterOffset: -30
                            source:{
                                if(hoodSpeed>=3)
                                    return themesPicturesPath+"icon_speed_3.png"
                                else if(hoodSpeed > 0)
                                    return themesPicturesPath+"icon_speed_"+hoodSpeed+".png"
                                else
                                    return ""
                            }
                        }
                        Text{
                            text:{
                                if(hoodSpeed>3)
                                    return "爆炒"
                                else if(hoodSpeed===3)
                                    return "高速"
                                else if(hoodSpeed===2)
                                    return "中速"
                                else
                                    return "低速"
                            }
                            color:themesTextColor
                            font.pixelSize: 24
                            anchors.centerIn: parent
                            anchors.horizontalCenterOffset: 20
                        }
                    }
                    Item
                    {
                        visible: lTimingState===timingStateEnum.RUN||rTimingState===timingStateEnum.RUN
                        width: parent.width
                        height: 50
                        Rectangle{
                            visible: true
                            width: parent.width
                            height: parent.height
                            color: "#000"
                            opacity: 0.5
                            border.color: themesTextColor
                            radius: 4
                        }
                        Image {
                            anchors.centerIn: parent
                            anchors.horizontalCenterOffset: -30
                            source:themesPicturesPath+"icon_stove.png"
                        }
                        Text{
                            text:closeHeatShortTime()
                            color:themesTextColor
                            font.pixelSize: 24
                            anchors.centerIn: parent
                            anchors.horizontalCenterOffset: 20
                        }
                    }
                }

                onClicked: {
                    push_page(pageHood)
                }
            }
            Button{
                width: 292
                height:parent.height

                background:Image {
                    source: themesPicturesPath+"home_steamoven_background.png"
                }
                Text{
                    text:"蒸烤箱"
                    color:"#fff"
                    font.pixelSize: 40
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 45
                    Text{
                        text:"STEAM OVEN"
                        color:"#C3C2C2"
                        font.pixelSize: 16
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.bottom
                        anchors.topMargin: 10
                        anchors.left: parent.left
                    }
                }
                Rectangle
                {
                    id:workStatus
                    visible: rStOvState!==workStateEnum.WORKSTATE_STOP || lStOvState!==workStateEnum.WORKSTATE_STOP
                    width: 130
                    height: 130
                    anchors.top: parent.top
                    anchors.topMargin: 145
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#000"
                    opacity: 0.5
                    radius: 65
                }
                Image {
                    visible: workStatus.visible
                    anchors.centerIn: workStatus
                    source: themesPicturesPath+"icon_runing.png"
                    RotationAnimation on rotation {
                        from: 0
                        to: 360
                        duration: 8000 //旋转速度，默认250
                        loops: Animation.Infinite //一直旋转
                        running:workStatus.visible
                    }
                }
                Text{
                    visible: workStatus.visible
                    text:"工作中\n..."
                    color:themesTextColor
                    font.pixelSize: 26
                    anchors.centerIn: workStatus
                    horizontalAlignment:Text.AlignHCenter
                    verticalAlignment:Text.AlignVCenter
                    lineHeight:0.6
                }
                onClicked: {
                    push_page(pageSteamOven)
                }
            }
            Button{
                width: 292
                height:parent.height

                background:Image {
                    source: themesPicturesPath+"home_smartrecipes_background.png"
                }
                Text{
                    text:"智慧菜谱"
                    color:"#fff"
                    font.pixelSize: 40
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 45
                    Text{
                        text:"SMART RECIPES"
                        color:"#C3C2C2"
                        font.pixelSize: 16
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.bottom
                        anchors.topMargin: 10
                        anchors.left: parent.left
                    }
                }
                onClicked: {
                    push_page(pageSmartRecipes)
                }
            }

        }
    }

}

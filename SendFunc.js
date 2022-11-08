//.pragma library
var multiModeEnum={"NONE":0,"RECIPE":1,"MULTISTAGE":2}

function setToServer(Data)
{
    var root={}
    root.Type="SET"
    root.Data=Data
    var json=JSON.stringify(root)
    console.info("setToServer:",json)
    QmlDevState.sendToServer(json)
}

function getToServer(Data)
{
    var root={}
    root.Type="GET"
    root.Data=Data
    var json=JSON.stringify(root)
    console.info("getToServer:",json)
    QmlDevState.sendToServer(json)
}
function getAllToServer()
{
    var root={}
    root.Type="GETALL"
    root.Data=null
    var json=JSON.stringify(root)
    console.info("getAllToServer:",json)
    QmlDevState.sendToServer(json)
}

function otaRquest(request)
{
    var Data={}
    Data.OTARquest = request
    setToServer(Data)
}
function permitSteamStartStatus(status)
{
    permitStartStatus=status
    var Data={}
    Data.PermitSteamStartStatus = status
    setToServer(Data)
}
function enableWifi(enable)
{
    systemSettings.wifiEnable=enable
    var Data={}
    Data.WifiEnable = enable
    setToServer(Data)
}
function scanWifi()
{
    var Data={}
    Data.WifiScan = null
    setToServer(Data)
}
function scanRWifi()
{
    var Data={}
    Data.WifiScanR = null
    Data.WifiCurConnected = null
    getToServer(Data)
}

function connectWiFi(ssid,psk,encryp)
{
    var Data={}

    wifiConnectInfo.ssid = ssid
    wifiConnectInfo.psk = psk
    wifiConnectInfo.encryp = encryp

    Data.WifiConnect=wifiConnectInfo
    wifiConnecting=true
    setToServer(Data)
}
function getWifiState()
{
    var Data={}
    Data.WifiState = null
    getToServer(Data)
}

function setAlarm(operation)
{
    var Data={}
    Data.Alarm=operation
    setToServer(Data)
}

function setHoodSpeed(speed)
{
    var Data={}
    Data.HoodSpeed=speed
    setToServer(Data)
}
function setBuzControl(operation)
{
    var Data={}
    Data.BuzControl=operation
    setToServer(Data)
}
function setSysPower(operation)
{
    var Data={}
    Data.SysPower=operation
    setToServer(Data)
}

function setCookOperation(device,operation)
{
    var Data={}
    if(leftDevice===device)
    {
        Data.LStOvOperation=operation
    }
    else if(rightDevice===device)
    {
        Data.RStOvOperation=operation
    }
    else
    {
        Data.IceStOvOperation=operation
    }
    setToServer(Data)
}

function setCooking(list,orderTime,cookPos)
{
    var Data={}

    if(cookPos===leftDevice)
    {
        if(list!=null)
        {
            Data.MultiMode=multiModeEnum.NONE
            Data.LStOvMode=list.mode
            Data.LStOvSetTimer=list.time
            Data.LStOvSetTemp=list.temp
        }
        Data.LStOvOperation=workOperationEnum.START

        if(undefined !== orderTime && orderTime > 0)
        {
            Data.LStOvOrderTimer=orderTime
        }
    }
    else
    {
        if(list!=null)
        {
            Data.RStOvMode=list.mode
            Data.RStOvSetTimer=list.time
            Data.RStOvSetTemp=list.temp
//            Data.HoodSpeed=3
        }
        Data.RStOvOperation=workOperationEnum.START

        if(undefined !== orderTime && orderTime > 0)
        {
            Data.RStOvOrderTimer=orderTime
        }
    }
    setToServer(Data)
}
function setIceCooking(list,orderTime)
{
    var Data={}
    Data.IceStOvMode=list.mode

    Data.IceStOvSetTimer=list.time
    Data.IceStOvSetTemp=list.temp
    Data.IceStOvOperation=workOperationEnum.START
    setToServer(Data)
}

function setMultiIceCooking(list,orderTime)
{
    console.log("setIceCooking")
    if(list.length==1)
    {
        if(list[0].mode>=130)
            list[0].mode=iceWorkMode
        if(list[0].pos!=rightDevice || list[0].mode!=iceWorkMode)
            return
        iceWorkStep.state=iceWorkOperaEnum.ICE
        setIceCooking(list[0],orderTime)
    }
    else
    {
        if(list[0].mode>=131)
            list[0].mode=iceWorkMode
        else if(list[0].mode==130)
            list[0].mode=100

        if(list[1].mode>=131)
            list[1].mode=iceWorkMode
        else if(list[1].mode==130)
            list[1].mode=100

        if(list[0].pos==leftDevice && list[1].pos==rightDevice  && list[1].mode==iceWorkMode)
        {
            iceWorkStep.state=iceWorkOperaEnum.LEFT_ICE
            iceWorkStep.cookStep=JSON.parse(JSON.stringify(list[1]))
            if(list[0].time<=30)
                setCooking(list[0],10,list[0].pos)
            else
                setCooking(list[0],0,list[0].pos)
            list[1].time=960
            setIceCooking(list[1],orderTime)
        }
        else if(list[0].pos==rightDevice && list[0].mode!=iceWorkMode && list[1].pos==rightDevice  && list[1].mode==iceWorkMode)
        {
            iceWorkStep.state=iceWorkOperaEnum.RIGHT_ICE
            iceWorkStep.cookStep=JSON.parse(JSON.stringify(list[1]))
            setCooking(list[0],0,list[0].pos)

            list[1].mode=121
            list[1].time=960
            setIceCooking(list[1],orderTime)
        }
        else if(list[0].pos==rightDevice  && list[0].mode==iceWorkMode && list[1].pos==rightDevice && list[1].mode!=iceWorkMode)
        {
            iceWorkStep.state=iceWorkOperaEnum.ICE_RIGHT
            iceWorkStep.cookStep=list[1]
            setIceCooking(list[0],0)
        }
        else
        {

        }
        console.log("setIceCooking",JSON.stringify(iceWorkStep))
    }
}
function setMultiCooking(lists,orderTime,dishName,cookbookID)
{
    console.log("setMultiCooking")
    var Data={}
    var MultiStageContent=[]

    for(var i = 0; i < list.length; i++)
    {
        var buf={}
        buf.Mode=lists[i].mode
        buf.Temp=lists[i].temp
        buf.Timer=lists[i].time
        MultiStageContent.push(buf)
    }

    if(undefined === dishName || null === dishName)
    {
        Data.MultiMode=multiModeEnum.MULTISTAGE
        Data.MultiStageContent=MultiStageContent
        //        Data.CookbookID=0
    }
    else
    {
        Data.MultiMode=multiModeEnum.RECIPE
        Data.CookbookParam=MultiStageContent
        Data.CookbookName=dishName
        Data.CookbookID=cookbookID
    }
    Data.LStOvOperation=workOperationEnum.START
    if(undefined !== orderTime && orderTime > 0)
    {
        Data.LStOvOrderTimer=orderTime
    }

    setToServer(Data)
}


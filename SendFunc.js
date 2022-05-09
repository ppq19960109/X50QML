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
    else
    {
        Data.RStOvOperation=operation
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
            Data.LStOvMode=list[0].mode
            Data.LStOvSetTimer=list[0].time
            Data.LStOvSetTemp=list[0].temp
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
            Data.RStOvMode=list[0].mode
            Data.RStOvSetTimer=list[0].time
            Data.RStOvSetTemp=list[0].temp
        }
        Data.RStOvOperation=workOperationEnum.START

        if(undefined !== orderTime && orderTime > 0)
        {
            Data.RStOvOrderTimer=orderTime
        }
    }
    setToServer(Data)
}

function setMultiCooking(list,orderTime,dishName,cookbookID)
{
    console.log("setMultiCooking")
    var Data={}
    var MultiStageContent=[]

    for(var i = 0; i < list.length; i++)
    {
        var buf={}
        buf.Mode=list[i].mode
        buf.Temp=list[i].temp
        buf.Timer=list[i].time
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

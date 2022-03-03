//.pragma library

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
    Data.MultiMode=multiModeEnum.NONE
    if(cookPos===leftDevice)
    {
        Data.LStOvMode=list[0].mode
        Data.LStOvSetTimer=list[0].time
        Data.LStOvSetTemp=list[0].temp
        if(undefined !== orderTime && orderTime > 0)
        {
            Data.LStOvOrderTimer=orderTime
        }
        else
        {
            Data.LStOvOperation=workOperationEnum.START
        }
    }
    else
    {
        Data.RStOvMode=list[0].mode
        Data.RStOvSetTimer=list[0].time
        Data.RStOvSetTemp=list[0].temp
        if(undefined !== orderTime && orderTime > 0)
        {
            Data.RStOvOrderTimer=orderTime
        }
        else
        {
            Data.RStOvOperation=workOperationEnum.START
        }
    }
    setToServer(Data)
}

function setMultiCooking(list,orderTime,dishName)
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
    }
    else
    {
        Data.MultiMode=multiModeEnum.RECIPE
        Data.CookbookParam=MultiStageContent
        Data.CookbookName=dishName
    }

    if(undefined !== orderTime && orderTime > 0)
    {
        Data.LStOvOrderTimer=orderTime
    }
    else
    {
        Data.LStOvOperation=workOperationEnum.START
    }
    setToServer(Data)
}

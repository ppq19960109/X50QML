

function setToServer(Data)
{
    var root={}
    root.Type="SET"
    root.Data=Data
    var json=JSON.stringify(root)
    console.log("setToServer",json)
    QmlDevState.sendToServer(json)
    json=null
    root=null
}

function getToServer(Data)
{
    var root={}
    root.Type="GET"
    root.Data=Data
    var json=JSON.stringify(root)
    QmlDevState.sendToServer(json)
    json=null
    root=null
}
function getAllToServer()
{
    var root={}
    root.Type="GETALL"
    root.Data=null
    var json=JSON.stringify(root)
    QmlDevState.sendToServer(json)
    json=null
    root=null
}
function loadPowerSet(value)
{
    var Data={}
    Data.LoadPowerSet = value
    setToServer(Data)
}
function otaRquest(request)
{
    var Data={}
    Data.OTARquest = request
    setToServer(Data)
}

function enableWifi(enable)
{
    var Data={}
    Data.WifiEnable = enable
    setToServer(Data)
}
function getCurWifi()
{
    var Data={}
    Data.WifiCurConnected = null
    getToServer(Data)
}
function getWifiState()
{
    var Data={}
    Data.WifiState = null
    getToServer(Data)
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
//    Data.WifiCurConnected = null
    getToServer(Data)
}

function deleteWifissid(ssid)
{
    if(ssid==""||ssid==null)
        return
    console.log("deleteWifissid:",ssid)
    var wifiPasswdArray=systemSettings.wifiPasswdArray
    if(typeof wifiPasswdArray!="object")
    {
        console.log("wifiPasswdArray not Object")
        return
    }
    var array_len=wifiPasswdArray.length
    var i,element
    for( i = 0; i < array_len; ++i)
    {
        element=wifiPasswdArray[i]
        if(element.ssid===ssid)
        {
            console.log("remove ssid:",i,element.ssid)
            wifiPasswdArray.splice(i,1)
            break;
        }
    }

    if(i==array_len)
    {
        return
    }
    console.log("deleteWifissid:",JSON.stringify(wifiPasswdArray))
    systemSettings.wifiPasswdArray=wifiPasswdArray
}
function connectWiFi(ssid,psk,encryp)
{
    var Data={}

    wifiConnectInfo.ssid = ssid
    wifiConnectInfo.psk = psk
    wifiConnectInfo.encryp = encryp

    Data.WifiConnect=wifiConnectInfo
    wifiConnecting=true
    wifiConnected=false
    setToServer(Data)
    deleteWifissid(ssid)
}
function getWifiState()
{
    var Data={}
    Data.WifiState = null
    getToServer(Data)
}

function setSmartSmoke(state)
{
    var Data={}
    Data.SmartSmoke=state
    Data.DataReportReason=0
    setToServer(Data)
}
function setHoodSpeed(speed)
{
    var Data={}
    Data.HoodSpeed=speed
    Data.DataReportReason=0
    setToServer(Data)
}

function setBuzControl(operation)
{
    if(systemSettings.reboot==true)
        return
    var Data={}
    Data.BuzControl=operation
    Data.DataReportReason=0
    setToServer(Data)
}
function setSysPower(operation)
{
    var Data={}
    Data.SysPower=operation
    Data.DataReportReason=0
    setToServer(Data)
}

function setCookOperation(device,operation)
{
    var Data={}
    if(cookWorkPosEnum.LEFT===device)
    {
        Data.LStOvOperation=operation
    }
    else
    {
        Data.RStOvOperation=operation
    }
    Data.DataReportReason=0
    setToServer(Data)
}

function setCooking(list,orderTime,cookPos)
{
    var Data={}

    if(cookPos===cookWorkPosEnum.LEFT)
    {
        if(list!=null)
        {
            Data.MultiMode=multiModeEnum.NONE
            Data.LStOvMode=list[0].mode
            Data.LStOvSetTimer=list[0].time
            Data.LStOvSetTemp=list[0].temp
        }
        Data.LStOvOperation=workOperationEnum.START

        if(null != orderTime && orderTime > 0)
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

        if(null != orderTime && orderTime > 0)
        {
            Data.RStOvOrderTimer=orderTime
        }
    }
    Data.DataReportReason=0
    setToServer(Data)
}

function setMultiCooking(list,orderTime,dishName,cookbookID)
{
    console.log("setMultiCooking")
    var Data={}
    var MultiStageContent=[]
    var step
    for(var i = 0; i < list.length; ++i)
    {
        step=list[i]
        var buf={}
        buf.Mode=step.mode
        buf.Temp=step.temp
        buf.Timer=step.time
        MultiStageContent.push(buf)
    }

    if(null == cookbookID || null == dishName)
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
    if(null != orderTime && orderTime > 0)
    {
        Data.LStOvOrderTimer=orderTime
    }
    Data.DataReportReason=0
    setToServer(Data)
}

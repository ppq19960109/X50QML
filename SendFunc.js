//.pragma library
//var multiModeEnum={"NONE":0,"RECIPE":1,"MULTISTAGE":2}


//function makeRequest()
//{
//    var doc = new XMLHttpRequest();

//    doc.onreadystatechange = function() {
//        if (doc.readyState == XMLHttpRequest.HEADERS_RECEIVED) {
//            console.log("HEADERS_RECEIVED -->",doc.status,doc.statusText);
//            console.log("getAllResponseHeaders:",doc.getAllResponseHeaders ());
//            //            console.log("Last modified -->");
//            //            console.log(doc.getResponseHeader ("Last-Modified"));
//        } else if (doc.readyState == XMLHttpRequest.DONE) {
//            //            var a = doc.responseXML.documentElement;
//            //            for (var ii = 0; ii < a.childNodes.length; ++ii) {
//            //                console.log(a.childNodes[ii].nodeName);
//            //            }
//            console.log("DONE -->",doc.status,doc.statusText);
//            console.log("getAllResponseHeaders:",doc.getAllResponseHeaders ());
//            //            console.log("Last modified -->");
//            //            console.log(doc.getResponseHeader ("Last-Modified"));
//            console.log("responseText:",doc.responseText)
//            var dataJson=JSON.parse(doc.responseText.toString());
//            console.log("responseText cityName:",dataJson.data.cityName)
//            weatherRequest(dataJson.data.cityName)
//        }
//    }
//    doc.open("GET", "http://mcook.marssenger.com/application/weather/day");
//    doc.send();
//}

//function weatherRequest(city)
//{
//    var doc = new XMLHttpRequest();

//    doc.onreadystatechange = function() {
//        if (doc.readyState == XMLHttpRequest.HEADERS_RECEIVED) {
//            console.log("Headers -->",doc.statusText);
//            console.log(doc.getAllResponseHeaders ());

//        } else if (doc.readyState == XMLHttpRequest.DONE) {
//            //            var a = doc.responseXML.documentElement;
//            //            for (var ii = 0; ii < a.childNodes.length; ++ii) {
//            //                console.log(a.childNodes[ii].nodeName);
//            //            }
//            console.log("DONE  -->",doc.status,doc.statusText);
//            console.log(doc.getAllResponseHeaders ());

//            console.log(doc.responseText.toString())
//            //            var resp=JSON.parse(doc.responseText.toString());
//            //            var curTemp=resp.current_condition[0].temp_C
//            //            var curMinTemp=resp.weather[0].mintempC
//            //            var curMaxTemp=resp.weather[0].maxtempC
//            //            console.log("today",curTemp,curMinTemp,curMaxTemp)
//        }
//    }
//    console.log("weatherRequest","https://wttr.in/"+city+"?format=j2");
//    doc.open("GET", "https://wttr.in/"+city+"?format=j2");
//    doc.send();
//}

function setToServer(Data)
{
    var root={}
    root.Type="SET"
    root.Data=Data
    var json=JSON.stringify(root)
    //    console.info("setToServer:",json)
    QmlDevState.sendToServer(json)
    json=undefined
    root=undefined
}

function getToServer(Data)
{
    var root={}
    root.Type="GET"
    root.Data=Data
    var json=JSON.stringify(root)
    //    console.info("getToServer:",json)
    QmlDevState.sendToServer(json)
    json=undefined
    root=undefined
}
function getAllToServer()
{
    var root={}
    root.Type="GETALL"
    root.Data=null
    var json=JSON.stringify(root)
    QmlDevState.sendToServer(json)
    json=undefined
    root=undefined
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

function permitSteamStartStatus(status)
{
    permitStartStatus=status
    var Data={}
    Data.PermitSteamStartStatus = status
    setToServer(Data)
}
function enableWifi(enable)
{
    //    systemSettings.wifiEnable=enable
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
    //    console.log("deleteWifissid:",ssid)
    var wifiPasswdArray=systemSettings.wifiPasswdArray
    if(typeof wifiPasswdArray!="object")
    {
        //        console.log("wifiPasswdArray not Object")
        return
    }
    var array_len=wifiPasswdArray.length
    var i,element
    for( i = 0; i < array_len; ++i)
    {
        element=wifiPasswdArray[i]
        if(element.ssid===ssid)
        {
            //            console.log("remove ssid:",i,element.ssid)
            wifiPasswdArray.splice(i,1)
            break;
        }
    }

    if(i==array_len)
    {
        return
    }
    //    console.log("deleteWifissid:",JSON.stringify(wifiPasswdArray))
    systemSettings.wifiPasswdArray=wifiPasswdArray
    wifiPasswdArray=null
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
    //    permitSteamStartStatus(0)
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
    Data.DataReportReason=0
    setToServer(Data)
}

function setMultiCooking(list,orderTime,dishName,cookbookID)
{
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
    if(undefined !== orderTime && orderTime > 0)
    {
        Data.LStOvOrderTimer=orderTime
    }
    Data.DataReportReason=0
    setToServer(Data)
}


function signalLevel(rssi)
{
    if (rssi <= -100)
    {
        return 0
    }
    else if (rssi < -75)
    {
        return 1
    }
    else if (rssi < -55)
    {
        return 2
    }
    else
    {
        return 3
    }
}

function encrypType(flags)
{
    if (flags.indexOf("WPA") !== -1)
    {
        return 1
    }
    else if (flags.indexOf("WEP") !== -1)
    {
        return 2
    }
    else
    {
        return 0
    }
}

function deleteWifiInfo(wifiInfo)
{
    if(wifiInfo==null || wifiInfo.ssid=="" ||wifiInfo.psk=="" || wifiInfo.encryp===0)
        return
    console.log("deleteWifiInfo:",wifiInfo.ssid,wifiInfo.psk)
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
        if(element.ssid===wifiInfo.ssid)
        {
            console.log("remove ssid:",i,element.ssid,wifiInfo.ssid)
            wifiPasswdArray.splice(i,1)
            break;
        }
    }

    if(i==array_len)
    {
        return
    }
    console.log("deleteWifiInfo:",JSON.stringify(wifiPasswdArray))
    systemSettings.wifiPasswdArray=wifiPasswdArray
    wifiConnectInfo.psk=""
}

function addWifiInfo(wifiInfo)
{
    if(wifiInfo==null || wifiInfo.ssid=="" ||wifiInfo.psk=="" || wifiInfo.encryp===0)
        return
    console.log("addWifiInfo:",wifiInfo.ssid,wifiInfo.psk)
    var wifiPasswdArray=systemSettings.wifiPasswdArray

    if(typeof wifiPasswdArray!="object")
    {
        console.log("wifiPasswdArray not Object")
        wifiPasswdArray=new Array
    }
    var array_len=wifiPasswdArray.length
    var i,element
    for(i = 0; i < array_len; ++i)
    {
        element=wifiPasswdArray[i]
        if(element.ssid===wifiInfo.ssid)
        {
            if(element.psk===wifiInfo.psk && element.encryp===wifiInfo.encryp)
            {
                return
            }
            console.log("change ssid:",i,element.ssid,wifiInfo.ssid)
            element.psk=wifiInfo.psk
            element.encryp=wifiInfo.encryp
            break;
        }
    }
    if(i==array_len)
    {
        var newWifiInfo={}
        newWifiInfo.ssid=wifiInfo.ssid
        newWifiInfo.psk=wifiInfo.psk
        newWifiInfo.encryp=wifiInfo.encryp
        console.log("add ssid:",newWifiInfo.ssid)
        wifiPasswdArray.push(newWifiInfo)
    }
    console.log("addWifiInfo:",JSON.stringify(wifiPasswdArray))
    systemSettings.wifiPasswdArray=wifiPasswdArray
    wifiConnectInfo.psk=""
}

function getWifiInfo(ssid)
{
    if(ssid=="")
        return
    var wifiPasswdArray=systemSettings.wifiPasswdArray
    if(typeof wifiPasswdArray!="object")
    {
//        console.log("wifiPasswdArray not Object")
        return
    }
    var i,element
    for(i = 0; i < wifiPasswdArray.length; ++i)
    {
        element=wifiPasswdArray[i]
        if(element.ssid===ssid)
        {
            var wifiInfo={}
            wifiInfo.ssid=element.ssid
            wifiInfo.psk=element.psk
            wifiInfo.encryp=element.encryp
//            console.log("get ssid:",wifiInfo.ssid,wifiInfo.psk,wifiInfo.encryp)
            return wifiInfo
        }
    }
    if(i===wifiPasswdArray.length)
    {
        return
    }
}



function deleteWifiInfo(wifiInfo)
{
    if(wifiInfo.ssid=="" ||wifiInfo.psk=="" || wifiInfo.encryp===0)
        return
    var wifiPasswdArray=systemSettings.wifiPasswdArray
    if(typeof wifiPasswdArray!="object")
    {
        console.log("wifiPasswdArray not Object")
        return
    }
    var i;
    var len=wifiPasswdArray.length
    for( i = 0; i < len; i++)
    {
        if(wifiPasswdArray[i].ssid===wifiInfo.ssid)
        {
            console.log("remove ssid:",i,wifiPasswdArray[i].ssid,wifiInfo.ssid)
            wifiPasswdArray.splice(i,1)
            break;
        }
    }

    if(i===len)
    {
        return
    }
    systemSettings.wifiPasswdArray=wifiPasswdArray
}

function addWifiInfo(wifiInfo)
{
    if(wifiInfo.ssid=="" ||wifiInfo.psk=="" || wifiInfo.encryp===0)
        return
    var wifiPasswdArray=systemSettings.wifiPasswdArray

    if(typeof wifiPasswdArray!="object")
    {
        console.log("wifiPasswdArray not Object")
        wifiPasswdArray=new Array
    }

    var i;
    for(i = 0; i < wifiPasswdArray.length; i++)
    {
        if(wifiPasswdArray[i].ssid===wifiInfo.ssid)
        {
            if(wifiPasswdArray[i].psk===wifiInfo.psk && wifiPasswdArray[i].encryp===wifiInfo.encryp)
            {
                return
            }
            console.log("change ssid:",i,wifiPasswdArray[i].ssid,wifiInfo.ssid)
            wifiPasswdArray[i].psk=wifiInfo.psk
            wifiPasswdArray[i].encryp=wifiInfo.encryp
            break;
        }
    }
    if(i===wifiPasswdArray.length)
    {
        var newWifiInfo={}
        newWifiInfo.ssid=wifiInfo.ssid
        newWifiInfo.psk=wifiInfo.psk
        newWifiInfo.encryp=wifiInfo.encryp
        console.log("add ssid:",newWifiInfo.ssid)
        wifiPasswdArray.push(newWifiInfo)
    }
    systemSettings.wifiPasswdArray=wifiPasswdArray
}

function getWifiInfo(ssid)
{
    if(ssid=="")
        return
    var wifiPasswdArray=systemSettings.wifiPasswdArray
    if(typeof wifiPasswdArray!="object")
    {
        console.log("wifiPasswdArray not Object")
        return
    }
    var i;
    for(i = 0; i < wifiPasswdArray.length; i++)
    {
        if(wifiPasswdArray[i].ssid===ssid)
        {
            var wifiInfo={}
            wifiInfo.ssid=wifiPasswdArray[i].ssid
            wifiInfo.psk=wifiPasswdArray[i].psk
            wifiInfo.encryp=wifiPasswdArray[i].encryp
            console.log("get ssid:",wifiInfo.ssid,wifiInfo.psk,wifiInfo.encryp)
            return wifiInfo
        }
    }
    if(i===wifiPasswdArray.length)
    {
        return
    }
}


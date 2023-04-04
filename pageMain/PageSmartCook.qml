import QtQuick 2.12
import QtQuick.Controls 2.5
import "../"
import "qrc:/pageCook"
import "qrc:/SendFunc.js" as SendFunc
Item {
    Connections { // 将目标对象信号与槽函数进行连接
        target: QmlDevState
        onStateChanged: { // 处理目标对象信号的槽函数
            //            console.log("page PageSmartCook:",key,value)
            if("RAuxiliarySwitch"==key)
            {
                auxiliaryPageSwitch.checked=value
            }
            else if("CookingCurveSwitch"==key)
            {
                cookingCurvePageSwitch.checked=value
            }
            else if("OilTempSwitch"==key)
            {
                oilTempPageSwitch.checked=value
            }
            else if("RMovePotLowHeatSwitch"==key)
            {
                lowHeatPageSwitch.checked=value
            }
        }
    }
    Component.onCompleted: {
        auxiliaryPageSwitch.checked=auxiliarySwitch
        cookingCurvePageSwitch.checked=QmlDevState.state.CookingCurveSwitch
        oilTempPageSwitch.checked=oilTempSwitch
        lowHeatPageSwitch.checked=QmlDevState.state.RMovePotLowHeatSwitch
    }

    //    PageBackBar{
    //        id:topBar
    //        anchors.top:parent.top
    //        name:qsTr("智慧烹饪")
    //        centerText:oilTempSwitch?("左灶油温:"+(lOilTemp>=0?lOilTemp:"-")+"℃"+"    右灶油温:"+(rOilTemp>=0?rOilTemp:"-")+"℃"):""
    //        customClose:true
    //        onClose:{
    //            let page=isExistView("PageAICook")
    //            if(page==null)
    //                backTopPage()
    //            else
    //                backPage(page)
    //        }
    //    }
    Flickable{
        width: 341
        height:53
        contentWidth: width
        contentHeight: height
        flickableDirection:Flickable.VerticalFlick
        clip: true
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        Button{
            width: parent.width
            height:parent.height

            background:Image {
                asynchronous:true
                smooth:false
                anchors.centerIn: parent
                source: themesPicturesPath+"ai/cook_assist_open.png"
            }
            onClicked: {
                let page=isExistView("PageAICook")
                if(page==null)
                    replace_page(pageAICook)
                else
                    backPage(page)
            }
        }
        onVerticalOvershootChanged: {
            //            console.log("onVerticalOvershootChanged:",contentY,originY,verticalOvershoot)
            if(verticalOvershoot>13)
            {
                let page=isExistView("PageAICook")
                if(page==null)
                    replace_page(pageAICook)
                else
                    backPage(page)
            }
        }
    }
    Row {
        width: 314+204*3+40*2
        height: 282
        anchors.top: parent.top
        anchors.topMargin: 30
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 40
        Item{
            width: 314
            height:parent.height

            Image {
                asynchronous:true
                smooth:false
                source: themesPicturesPath+"auxiliary_temp_control.png"
            }
            Text{
                text:"右灶 | 辅助控温"
                color:"#fff"
                font.pixelSize: 34
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 30
                horizontalAlignment:Text.AlignHCenter
            }
            Text{
                height: 40
                visible: auxiliarySwitch > 0
                text:rAuxiliaryTemp+"℃"
                color:themesTextColor
                font.pixelSize: 30
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 84
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        console.log("Text onClicked")
                        loaderTempControl(null)
                    }
                }
            }
            PageSwitch {
                id:auxiliaryPageSwitch
                checked:false
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 30
                source: themesPicturesPath+(checked ?"icon_switch_open.png":"icon_switch_close.png")
                onClicked: {
                    if(checked==true)
                        loaderTempControl(null)
                    else
                    {
                        var Data={}
                        Data.RAuxiliarySwitch = checked
                        SendFunc.setToServer(Data)
                    }
                }
            }
        }
        Item{
            width: 204
            height:parent.height

            Image {
                asynchronous:true
                smooth:false
                source: themesPicturesPath+"cooking_curve.png"
            }
            Text{
                text:"烹饪曲线"
                color:"#fff"
                font.pixelSize: 34
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 30
                horizontalAlignment:Text.AlignHCenter
            }
            PageSwitch {
                id:cookingCurvePageSwitch
                checked: false
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 30
                source: themesPicturesPath+(checked ?"icon_switch_open.png":"icon_switch_close.png")
                onClicked: {
                    if(checked==true)
                    {
                        if(linkWifiConnected==false)
                        {
                            loaderManualConfirmShow("当前无网络，连网后可生成烹饪曲线","icon_wifi_warn.png","检查网络",openWifiPage)
                            cookingCurvePageSwitch.checked=false
                            return
                        }
                        loaderQrcodeShow("烹饪曲线已开启","下载火粉APP\n扫码查看您的烹饪曲线","file:CookingCurve.png")
                    }
                    var Data={}
                    Data.CookingCurveSwitch = checked
                    SendFunc.setToServer(Data)
                }
            }
        }
        Rectangle{
            width: 204
            height:parent.height
            color: "#000"
            Image {
                visible: oilTempPageSwitch.checked==false
                asynchronous:true
                smooth:false
                source: themesPicturesPath+"oil_temp.png"
            }
            Text{
                text:"油温显示"
                color:"#fff"
                font.pixelSize: 34
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 30
                horizontalAlignment:Text.AlignHCenter
            }
            Text{
                visible: oilTempPageSwitch.checked==true
                text:"当前油温参考\n左灶 "+(lOilTemp>=0?lOilTemp:"-")+"℃\n右灶 "+(rOilTemp>=0?rOilTemp:"-")+"℃"
                color:themesTextColor
                font.pixelSize: 24
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 84
            }
            PageSwitch {
                id:oilTempPageSwitch
                checked: false
                enabled: auxiliarySwitch === 0
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 30
                source: themesPicturesPath+(enabled==false?"icon_switch_disable.png":(checked ?"icon_switch_open.png":"icon_switch_close.png"))
                onClicked: {
                    if(checked==false && auxiliarySwitch > 0)
                    {
                        checked=true
                        return
                    }
                    var Data={}
                    Data.OilTempSwitch = checked
                    SendFunc.setToServer(Data)
                }
            }
        }
        Component{
            id:component_lowHeat
            PageDialog{
                cancelText:"取消"
                confirmText:"确定"
                hintCenterText:{
                    var time=QmlDevState.state.RMovePotLowHeatOffTime
                    var timeLeft=time%60
                    return "开启后锅具离开灶具，火力变小\n离开"+Math.floor(time/60)+"分"+(timeLeft===0?"钟":(+timeLeft+"秒"))+"以上，自动熄火"
                }
                checkboxVisible:true
                onCancel:{
                    lowHeatPageSwitch.checked=false
                    loaderMainHide()
                }
                onConfirm:{
                    if(checkboxChecked)
                    {
                        systemSettings.rMovePotLowHeatRemind=false
                    }
                    var Data={}
                    Data.RMovePotLowHeatSwitch = true
                    SendFunc.setToServer(Data)
                    loaderMainHide()
                }
            }
        }
        Item{
            width: 204
            height:parent.height

            Image {
                asynchronous:true
                smooth:false
                source: themesPicturesPath+"movePot_lowHeat.png"
            }
            Text{
                text:"右灶\n移锅小火"
                color:"#fff"
                font.pixelSize: 34
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 30
                horizontalAlignment:Text.AlignHCenter
            }
            PageSwitch {
                id:lowHeatPageSwitch
                checked: false
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 30
                source: themesPicturesPath+(checked ?"icon_switch_open.png":"icon_switch_close.png")
                onClicked: {
                    var Data={}
                    if(checked==true)
                    {
                        if(systemSettings.rMovePotLowHeatRemind)
                            loaderManual.sourceComponent = component_lowHeat
                        else
                        {
                            Data.RMovePotLowHeatSwitch = true
                            SendFunc.setToServer(Data)
                        }
                    }
                    else
                    {
                        Data.RMovePotLowHeatSwitch = false
                        SendFunc.setToServer(Data)
                    }
                }
            }
        }
    }

}

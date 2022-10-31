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
        oilTempPageSwitch.checked=QmlDevState.state.OilTempSwitch
        lowHeatPageSwitch.checked=QmlDevState.state.RMovePotLowHeatSwitch
    }

    Component{
        id:component_tempControl
        Item {
            property int cookWorkPos:0
            property var clickFunc:null
            Component.onCompleted: {
                var i
                var array = []
                for(i=80; i<= 300; ++i) {
                    array.push(i)
                }
                tempPathView.model=array
            }
            Component.onDestruction: {
                clickFunc=null
            }

            //内容
            Rectangle{
                width:730
                height: 350
                anchors.centerIn: parent

                color: "#333333"
                radius: 10

                PageCloseButton {
                    anchors.top:parent.top
                    anchors.right:parent.right
                    onClicked: {
                        loaderMainHide()
                    }
                }

                PageDivider{
                    width: parent.width-200
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter:tempPathView.verticalCenter
                    anchors.verticalCenterOffset:-30
                }
                PageDivider{
                    width: parent.width-200
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter:tempPathView.verticalCenter
                    anchors.verticalCenterOffset:30
                }
                Text{
                    width:130
                    color:"#fff"
                    font.pixelSize: 30
                    anchors.top: parent.top
                    anchors.topMargin: 20
                    anchors.horizontalCenter: parent.horizontalCenter
                    text:qsTr("控温范围")
                }

                PageCookPathView {
                    id:tempPathView
                    width: 449
                    height:222
                    anchors.top: parent.top
                    anchors.topMargin: 50
                    anchors.horizontalCenter: parent.horizontalCenter
                    pathItemCount:3
                    currentIndex:0
                    Image {
                        anchors.fill: parent
                        visible: parent.moving
                        asynchronous:true
                        smooth:false
                        anchors.centerIn: parent
                        source: themesPicturesPath+"steamoven/"+"roll_background.png"
                    }
                    Text{
                        text:qsTr("℃")
                        color:themesTextColor
                        font.pixelSize: 24
                        anchors.centerIn: parent
                        anchors.horizontalCenterOffset: 60
                    }
                }

                PageButtonBar{
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 20
                    space:80
                    models: ["取消","确定"]
                    onClick: {
                        if(clickIndex==1)
                        {
                            var Data={}
                            Data.RAuxiliarySwitch = true
                            Data.RAuxiliaryTemp = tempPathView.model[tempPathView.currentIndex]
                            if(oilTempPageSwitch.checked==false)
                                Data.OilTempSwitch=true
                            SendFunc.setToServer(Data)
                            timer_auxiliary.restart()
                        }
                        else
                        {
                            auxiliaryPageSwitch.checked=false
                        }
                        loaderMainHide()
                    }
                }
            }
        }
    }
    function loaderTempControl(clickFunc)
    {
        loaderManual.sourceComponent = component_tempControl
        loaderManual.item.clickFunc=clickFunc
    }

    PageBackBar{
        id:topBar
        anchors.top:parent.top
        name:qsTr("智慧烹饪")
        centerText:QmlDevState.state.OilTempSwitch?("左灶油温:"+QmlDevState.state.LOilTemp+"℃"+"    右灶油温:"+QmlDevState.state.ROilTemp+"℃"):""
        customClose:true
        onClose:{
            let page=isExistView("PageHood")
            if(page==null)
                backTopPage()
            else
                backPage(page)
        }
    }

    Row {
        width: 314+204*3+40*2
        height: 282
        anchors.top: topBar.bottom
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
                visible: auxiliarySwitch > 0
                text:QmlDevState.state.RAuxiliaryTemp+"℃"
                color:themesTextColor
                font.pixelSize: 30
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 84
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
                        if(wifiConnected==false)
                        {
                            loaderWifiConfirmShow("当前无网络，连网后可生成烹饪曲线")
                            cookingCurvePageSwitch.checked=false
                            return
                        }
                        loaderQrcodeShow("烹饪曲线已开启","下载火粉APP\n扫码查看您的烹饪曲线")
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
                text:"当前油温参考\n左灶 "+QmlDevState.state.LOilTemp+"℃\n右灶 "+QmlDevState.state.ROilTemp+"℃"
                color:themesTextColor
                font.pixelSize: 24
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 84
            }
            PageSwitch {
                id:oilTempPageSwitch
                checked: false
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 30
                source: themesPicturesPath+(checked ?"icon_switch_open.png":"icon_switch_close.png")
                onClicked: {
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
                hintCenterText:"开启后锅具离开灶具，火力变小\n离开3分钟以上，自动熄火"
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
                    if(checked==true)
                    {
                        if(systemSettings.rMovePotLowHeatRemind)
                            loaderManual.sourceComponent = component_lowHeat
                    }
                    else
                    {
                        var Data={}
                        Data.RMovePotLowHeatSwitch = false
                        SendFunc.setToServer(Data)
                    }
                }
            }
        }
    }

}

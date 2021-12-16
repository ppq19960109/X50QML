import QtQuick 2.2
import QtQuick.Controls 2.2
import "../"
Item {
    property var root
    property var para
    property var leftWorkBigImg: ["qrc:/x50/steam/icon_便捷蒸.png", "qrc:/x50/steam/icon_立体热风.png", "qrc:/x50/steam/icon_高温蒸.png", "qrc:/x50/steam/icon_热风烧烤.png", "qrc:/x50/steam/icon_上下加热.png", "qrc:/x50/steam/icon_立体热风.png", "qrc:/x50/steam/icon_蒸汽烤.png", "qrc:/x50/steam/icon_空气炸.png", "qrc:/x50/steam/icon_保暖烘干.png"]
    property var leftWorkSmallImg: ["", "qrc:/x50/steam/icon_立体热风缩小.png", "qrc:/x50/steam/icon_高温蒸缩小.png", "qrc:/x50/steam/icon_热风烧烤缩小.png", "qrc:/x50/steam/icon_上下加热缩小.png", "qrc:/x50/steam/icon_立体热风缩小.png", "qrc:/x50/steam/icon_蒸汽烤缩小.png", "qrc:/x50/steam/icon_空气炸缩小.png", "qrc:/x50/steam/icon_保暖烘干缩小.png"]
    Component.onCompleted: {
        var i;
        var tempArray = new Array
        for(i=40; i< 230; ++i) {
            tempArray.push(i+"℃")
        }
        tempPathView.model=tempArray
        var timeArray = new Array
        for(i=1; i< 300; ++i) {
            timeArray.push(i+"分钟")
        }
        timePathView.model=timeArray
        console.log("state",state,typeof state)
        root=JSON.parse(state)
        if(leftDevice===root.device)
        {
            name.text="左腔蒸烤"
            for (i=0; i< leftModel.length; ++i) {
                modeListModel.append(leftModel[i])
            }
        }
        else
        {
            name.text="右腔速蒸"
            modeListModel.append(rightModel)
        }
    }
    Component{
        id:component_steam1
        PageDialog{
            hintHeight: 358
            hintTopText:"请将食物放入"+(root.device===leftDevice?"左腔":"右腔")+"\n将水箱加满水"
            confirmText:"开始烹饪"
            checkboxVisible:true
            onCancel:{
                console.info("component_steam1 onCancel")
                closeLoaderMain()
            }
            onConfirm:{
                console.info("component_steam1 onConfirm")
                showLoaderSteam2()
            }
        }
    }
    Component{
        id:component_steam2
        PageDialog{
            hintHeight: 306
            hintTopText:"请将食物放入"+(root.device===leftDevice?"左腔":"右腔")
            confirmText:"开始烹饪"
            checkboxVisible:true
            onCancel:{
                console.info("component_steam2 onCancel")
                closeLoaderMain()
            }
            onConfirm:{
                console.info("component_steam2 onConfirm")
                closeLoaderMain()
                startCooking(para,JSON.parse(para.cookSteps),0)
            }
        }
    }
    function showLoaderSteam1(){
            loader_main.sourceComponent = component_steam1
    }
    function showLoaderSteam2(){
            loader_main.sourceComponent = component_steam2
    }
    Image {
        anchors.fill: parent
        source: "/x50/main/背景.png"
    }
    ToolBar {
        id:topBar
        width:parent.width
        anchors.bottom:parent.bottom
        height:80
        background:Rectangle{
            color:"#000"
            opacity: 0.15
        }
        //back图标
        TabButton {
            id:goBack
            width:80
            height:parent.height
            anchors.left:parent.left
            anchors.verticalCenter: parent.verticalCenter
            Image{
                anchors.centerIn: parent
                source: "qrc:/x50/icon/icon_wife_nor.png"
            }
            background: Rectangle {
                opacity: 0
            }
            onClicked: {
                backPrePage()
            }
        }

        Text{
            id:name
            width:80
            color:"#FFF"
            font.pixelSize: 40
            anchors.left:goBack.right
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
        }

        //启动
        TabButton{
            id:startBtn
            width:100
            height:50
            anchors.right:reserve.left
            anchors.rightMargin: 40
            anchors.verticalCenter: parent.verticalCenter
            background:Rectangle{
                color:"transparent"
                border.color:"#00E6B6"
                radius: 8
            }
            Text{
                color:"#00E6B6"
                font.pixelSize: 30
                anchors.centerIn:parent
                horizontalAlignment:Text.AlignHCenter
                verticalAlignment:Text.AlignVCenter
                text:qsTr("启动")
            }
            onClicked: {
                console.log("PageSteamBakeBase",modePathView.model.get(modePathView.currentIndex).modelData,tempPathView.model[tempPathView.currentIndex],timePathView.model[timePathView.currentIndex])
                var list = []
                var steps={}
                steps.device=root.device
                steps.mode=leftWorkModeNumber[modePathView.currentIndex+1]
                steps.temp=tempPathView.currentIndex+40
                steps.time=timePathView.currentIndex+1
                list.push(steps)

                para =getDefHistory()
                para.dishName=getDishName(list)
                para.cookSteps=JSON.stringify(list)
                para.cookTime=timePathView.currentIndex+1

                showLoaderSteam1()
//                startCooking(para,list,0)
            }
        }
        //预约
        TabButton{
            id:reserve
            width:100
            height:50
            anchors.right:parent.right
            anchors.rightMargin: 40
            anchors.verticalCenter: parent.verticalCenter
            background:Rectangle{
                color:"transparent"
                border.color:"#00E6B6"
                radius: 8
            }
            Text{
                color:"#00E6B6"
                font.pixelSize: 30
                anchors.centerIn:parent
                horizontalAlignment:Text.AlignHCenter
                verticalAlignment:Text.AlignVCenter
                text:qsTr("预约")
            }
            onClicked: {
                var list = []
                var steps={}
                steps.mode=leftWorkModeNumber[modePathView.currentIndex+1]
                steps.temp=tempPathView.currentIndex+40
                steps.time=timePathView.currentIndex+1
                list.push(steps)

                var para =getDefHistory()
                para.dishName=getDishName(list)
                para.cookSteps=JSON.stringify(list)
                para.cookTime=timePathView.currentIndex+1
                para.cookPos=root.device

                load_page("pageSteamBakeReserve",JSON.stringify(para))
            }
        }
    }
    Component {
        id: rectDelegate
        Item  {
            property int textFont:PathView.isCurrentItem ? 45 : 35
            property var textColor:PathView.isCurrentItem ?"#00E6B6":'white'
            width:parent.width
            height:parent.height/parent.pathItemCount
//            opacity: PathView.isCurrentItem ? 1 : 0.5

            Text {
                id:text
                anchors.centerIn: parent
                color:textColor
                font.pixelSize: textFont
                text: modelData
            }
        }
    }

    Component {
        id: modeDelegate
        Item  {
            property int textFont:PathView.isCurrentItem ? 45 : 35
            property var textColor:PathView.isCurrentItem ?"#00E6B6":'white'
            property var imgUrl:PathView.isCurrentItem ?leftWorkBigImg[modelData]:leftWorkSmallImg[modelData]
            width:parent.width
            height:parent.height/parent.pathItemCount
//            opacity: PathView.isCurrentItem ? 1 : 0.5

            Image {
                anchors.right: text.left
                anchors.rightMargin: 10
                anchors.verticalCenter: text.verticalCenter
                source: imgUrl
            }
            Text {
                id:text
                anchors.verticalCenter:  parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: 20
                color:textColor
                font.pixelSize: textFont
                text: modelData==0?rightWorkMode:leftWorkMode[modelData]
            }
        }
    }
    //内容
    Rectangle{
        width:parent.width
        anchors.bottom:topBar.top
        anchors.top: parent.top
        color:"transparent"

        PageDivider{
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top:parent.top
            anchors.topMargin:rowPathView.height/3+50
        }
        PageDivider{
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top:parent.top
            anchors.topMargin:rowPathView.height/3*2+50
        }

        ListModel {
            id:modeListModel
        }

        Row {
            id:rowPathView
            width: parent.width-80
            height:parent.height-100
            anchors.centerIn: parent
            spacing: 10

            DataPathView {
                id:modePathView
                width: parent.width/3
                height:parent.height
                model:modeListModel
                delegate:modeDelegate
                currentIndex:0
                onValueChanged: {
                    console.log(index,valueName)
                    console.log("model value:",model.get(index).modelData)
                    tempPathView.currentIndex=model.get(index).temp-40;
                    timePathView.currentIndex=model.get(index).time-1;
                }
            }
            DataPathView {
                id:tempPathView
                width: parent.width/3
                height:parent.height
                delegate:rectDelegate
                Component.onCompleted:{
                    //                            tempPathView.positionViewAtIndex(1, PathView.End)
                    tempPathView.currentIndex=modePathView.model.get(modePathView.currentIndex).temp-40;
                    console.log("tempPathView",tempPathView.currentIndex)
                }
            }
            DataPathView {
                id:timePathView
                width: parent.width/3
                height:parent.height
                delegate:rectDelegate
                Component.onCompleted:{
                    timePathView.currentIndex=modePathView.model.get(modePathView.currentIndex).time-1;
                    console.log("timePathView",tempPathView.currentIndex)
                }
            }
        }

    }
}

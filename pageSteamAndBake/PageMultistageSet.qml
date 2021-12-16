import QtQuick 2.0
import QtQuick.Controls 2.2

Item {

    property int listClickIndex:0
    ToolBar {
        id:topBar
        width:parent.width
        anchors.bottom:parent.bottom
        height:96
        Image {
            anchors.fill: parent
            source: "/images/main_menu/zhuangtai_bj.png"
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
                source: "/images/fanhui.png"
            }
            background: Rectangle {
                opacity: 0
            }
            onClicked: {
                backPrePage()
            }
        }

        Text{
            width:50
            color:"#9AABC2"
            font.pixelSize: 40
            anchors.left:goBack.right
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("多段烹饪")
        }

        TabButton{
            width:160
            height:parent.height
            anchors.right:reserve.left
            background:Rectangle{
                color:"transparent"
            }
            Text{
                color:"#ECF4FC"
                font.pixelSize: 40
                anchors.centerIn:parent
                text: qsTr("启动")
            }
            onClicked: {

                var list = []
                for(var i = 0; i < listModel.count; ++i)
                {
                    var steps={}
                    steps.mode=listModel.get(i).mode
                    steps.temp=listModel.get(i).temp
                    steps.time=listModel.get(i).time
                    steps.number=i+1
                    list.push(steps)
                }

                var para =getDefHistory()
                para.dishName=getDishName(list)
                para.cookSteps=JSON.stringify(list)

                startCooking(para,list,0)
            }
        }

        //预约
        TabButton{
            id:reserve
            width:160
            height:parent.height
            anchors.right:parent.right
            anchors.rightMargin: 10
            background:Rectangle{
                color:"transparent"
            }
            Text{
                color:"#ECF4FC"
                font.pixelSize: 40
                anchors.centerIn:parent
                text:qsTr("预约")
            }
            onClicked: {
                var list = []
                for(var i = 0; i < listModel.count; ++i)
                {
                    var steps={}
                    steps.device=0
                    steps.mode=listModel.get(i).mode
                    steps.temp=listModel.get(i).temp
                    steps.time=listModel.get(i).time
                    list.push(steps)
                }
                load_page("pageSteamBakeReserve",JSON.stringify(list))
            }
        }
    }
    Component {
        id: footerView
        Item{
            id: footerRootItem
            width: parent.width
            anchors.topMargin: 38

            // 新增按钮
            Button {
                width: 138
                height:114
                anchors.top:parent.top
                anchors.topMargin:8
                anchors.left: parent.left
                anchors.leftMargin:0
                visible:listView.count>=3?false:true
                background: Rectangle{
                    color:"transparent"
                    Image {
                        anchors.centerIn: parent
                        source: "/images/xinzeng.png"
                        opacity:1
                    }
                }
                onClicked:{
                    listClickIndex=listView.count
                    showTanchang()
                }
            }
        }
    }
    ListModel {
        id: listModel

//        ListElement {
//            mode: 1
//            temp: 75
//            time:30
//        }
    }
    // 定义delegate
    Component {
        id: listDelegate
        PageMultistageDelegate {
            modeIndex:mode
            tempIndex:temp+"℃"
            timeIndex:time+"分钟"
            closeVisible:true
            onClose:{
                listView.model.remove(index)
            }
            onConfirm:{
                listClickIndex=index
                showTanchang()
            }
        }
    }
    //内容
    Rectangle{
        width:parent.width
        height:parent.height-topBar.height
        anchors.bottom:topBar.top
        color:"#000"

        ListView {
            id: listView
            anchors.fill: parent
            interactive: true
            delegate: listDelegate
            model: listModel

            footer: footerView
            focus: true
            //            highlightRangeMode: ListView.StrictlyEnforceRange
            //            highlightFollowsCurrentItem: true
            //            snapMode: ListView.SnapToItem
        }
    }
    Component{
        id:component_tanchuang
        PageMultistagePopUp {

        }
    }
    function showTanchang(){
        loader_tanchuang.sourceComponent = component_tanchuang
        loader_tanchuang.item.title= '第'+ (listClickIndex+1) +'段'
    }
    function dismissTanchang(){
        loader_tanchuang.sourceComponent = null
    }
    Loader{
        //加载弹窗组件
        id:loader_tanchuang
        anchors.fill: parent
        Connections {
            target: loader_tanchuang.item
            onShowListData:{
                console.log("onShowListData",listData.mode,listData.temp,listData.time,listView.count)

                if(listClickIndex >= listView.count){
                    listView.model.append(listData)
                }else{
                    console.log("onShowListData listClickIndex",listClickIndex)

                    listView.model.get(listClickIndex).mode=listData.mode;
                    listView.model.get(listClickIndex).temp=listData.temp;
                    listView.model.get(listClickIndex).time=listData.time;
                }
            }
        }
    }
}

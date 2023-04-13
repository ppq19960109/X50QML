import QtQuick 2.12
import QtQuick.Controls 2.5

import "qrc:/CookFunc.js" as CookFunc

import "../"
Item {
    property int workPos:0
    property var currentStep:workPos===cookWorkPosEnum.LEFT?QmlDevState.state.LMultiCurrentStep:QmlDevState.state.RMultiCurrentStep
    property bool runing:{
        if(workPos===cookWorkPosEnum.LEFT)
            return lStOvState!==workStateEnum.WORKSTATE_RESERVE
        else
            return rStOvState!==workStateEnum.WORKSTATE_RESERVE
    }

    Connections { // 将目标对象信号与槽函数进行连接
        target: QmlDevState
        onStateChanged: { // 处理目标对象信号的槽函数
            console.log("PageMultistageShow:",key)
            if("LStOvState"==key)
            {
                if(value===workStateEnum.WORKSTATE_FINISH||value===workStateEnum.WORKSTATE_STOP)
                    backPrePage()
            }
        }
    }
    PageBackBar{
        id:topBar
        anchors.top:parent.top
        name:qsTr("多段烹饪（只有左腔可多段烹饪）")
    }
    // 定义delegate
    Component {
        id: listDelegate
        Item {
            width: 300
            height: 250
            anchors.verticalCenter: parent.verticalCenter
            Button {
                width: parent.height
                height: parent.height
                anchors.right: parent.right

                background:null
                Image{
                    asynchronous:true
                    smooth:false
                    anchors.centerIn: parent
                    source: {
                        if(currentStep===index+1 && runing)
                            return themesPicturesPath+"icon_round_checked.png"
                        else
                            return themesPicturesPath+"icon_round.png"
                    }
                }
                Text{
                    color:(currentStep<index+1 && runing) ?"#fff":"#FFA834"
                    font.pixelSize: 30
                    anchors.top: parent.top
                    anchors.topMargin: (currentStep===index+1 && runing) ?50:70
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: {
                        if(runing)
                        {
                            if(currentStep<index+1)
                                return "待运行"
                            if(currentStep===index+1)
                                return "烹饪中"
                            if(currentStep>index+1)
                                return "已完成"
                        }
                        else
                            return "待运行"
                    }
                }
                Text{
                    visible: (currentStep===index+1 && runing)
                    color:"#FFA834"
                    font.pixelSize: 30
                    anchors.top: parent.top
                    anchors.topMargin: 90
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: {
                        if(workPos==0)
                        {
                            return QmlDevState.state.LStOvSetTimerLeft+"分钟"
                        }
                        else
                        {
                            return QmlDevState.state.RStOvSetTimerLeft+"分钟"
                        }
                    }
                }
                Text{
                    color:themesTextColor2
                    font.pixelSize: 26
                    anchors.top: parent.top
                    anchors.topMargin: 130
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: CookFunc.workModeName(modelData.mode)+(modelData.steamGear!=null?modelData.steamGear+"档":"")
                }
                Text{
                    color:themesTextColor2
                    font.pixelSize: 24
                    anchors.top: parent.top
                    anchors.topMargin: 160
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr(modelData.temp+"℃   "+modelData.time+"分钟")
                }
                onClicked: {
                }
            }
        }
    }
    //内容
    Item{
        width:parent.width
        anchors.top:topBar.bottom
        anchors.bottom: parent.bottom

        ListView {
            id: listView
            width: 300*lMultiStageContent.length
            height: width
            anchors.centerIn: parent
            interactive: false
            orientation:ListView.Horizontal
            delegate: listDelegate
            model: lMultiStageContent
        }
    }
}

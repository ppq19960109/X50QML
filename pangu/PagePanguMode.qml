import QtQuick 2.12
import QtQuick.Controls 2.5
import "qrc:/SendFunc.js" as SendFunc
import ".."
Item{
    property var panguMode
    Component.onCompleted: {
        panguMode=QmlDevState.getPanguMode()
        //console.log("panguMode:",JSON.stringify(panguMode))
        SendFunc.permitSteamStartStatus(1)
    }
    PageBackBar{
        id:topBar
        anchors.bottom:parent.bottom
        name:"盘古模式"
        //leftBtnText:qsTr("启动")
        //        rightBtnText:qsTr("预约")
        onClose:{
            backPrePage()
        }
        onLeftClick:{
            steamStart(false)
        }
        onRightClick:{
            steamStart(true)
        }
    }
    GridView{
        width: parent.width
        anchors.bottom:topBar.top
        anchors.top: parent.top
        cellWidth: 200
        cellHeight: 120
        clip: true

        model:["测试","馒头面团-揉面","面包面团-揉面","奶油打发","蛋白打发","煲汤","研磨","酸奶发酵","面团发酵","绞肉","切碎","冰沙","豆浆"]
        delegate:Item{
            width: 200
            height: 120
            Button{
                anchors.margins: 10
                anchors.fill: parent
                background:Rectangle{
                    color: themesPopupWindowColor
                    radius: 10
                }
                Text{
                    text:modelData
                    color:themesTextColor2
                    font.pixelSize: 30

                    anchors.fill: parent
                    wrapMode: Text.WordWrap
                    horizontalAlignment:Text.AlignHCenter
                    verticalAlignment:Text.AlignVCenter
                }

                onClicked: {
                    console.log("index",index)
                    switch(index)
                    {
                    case 0:
                        load_page("pagePanguTest",{"cookSteps":panguMode[index].cookSteps})
                        break
                    case 1:
                        load_page("pagePanguMode1",{"cookSteps":panguMode[index].cookSteps})
                        break
                    case 2:
                        load_page("pagePanguMode2",{"cookSteps":panguMode[index].cookSteps})
                        break
                    case 3:
                        load_page("pagePanguMode3",{"cookSteps":panguMode[index].cookSteps})
                        break
                    case 4:
                        load_page("pagePanguMode4",{"cookSteps":panguMode[index].cookSteps})
                        break
                    case 5:
                        load_page("pagePanguMode5",{"cookSteps":panguMode[index].cookSteps})
                        break
                    case 6:
                        load_page("pagePanguMode6",{"cookSteps":panguMode[index].cookSteps})
                        break
                    case 7:
                        load_page("pagePanguMode7",{"cookSteps":panguMode[index].cookSteps})
                        break
                    case 8:
                        load_page("pagePanguMode8",{"cookSteps":panguMode[index].cookSteps})
                        break
                    case 9:
                        load_page("pagePanguMode9",{"cookSteps":panguMode[index].cookSteps})
                        break
                    case 10:
                        load_page("pagePanguMode10",{"cookSteps":panguMode[index].cookSteps})
                        break
                    case 11:
                        load_page("pagePanguMode11",{"cookSteps":panguMode[index].cookSteps})
                        break
                    case 12:
                        load_page("pageSoybeanMilk",{"cookSteps":panguMode[index].cookSteps})
                        break
                    }
                }
            }
        }
    }
}



import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import "qrc:/CookFunc.js" as CookFunc
import "qrc:/SendFunc.js" as SendFunc
import ".."
Item{
    property var cookSteps

    function steamStart(order)
    {
        cookSteps[cookSteps.length-1].cookTime=Math.ceil(timeSlider.value-timeSlider.from)
        var para =CookFunc.getDefHistory()
        para.cookPos=1
        para.cookSteps=cookSteps

        startPanguCooking(para,cookSteps)
    }
    PageBackBar{
        id:topBar
        anchors.bottom:parent.bottom
        name:"切碎"
        leftBtnText:qsTr("启动")
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
    Item{
        width: parent.width
        anchors.bottom:topBar.top
        anchors.top: parent.top
        ColumnLayout{
            width: 300
            height: parent.height
            anchors.right: parent.right
            anchors.rightMargin: 20
            spacing: 10

            PageSlider2 {
                id: timeSlider
                Layout.fillWidth: true
                Layout.preferredHeight: 100
                stepSize: 5
                from: 0
                to: 500
                value: cookSteps[0].cookTime
                title:"时间"
                unit:"S"
            }
        }
    }
}



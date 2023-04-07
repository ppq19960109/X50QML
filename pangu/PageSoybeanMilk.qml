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
        if(waterSlider.value==600)
        {
            cookSteps[1].repeat=2
            cookSteps[1].cookTime-=5
            cookSteps[4].repeat=4
        }
        else if(waterSlider.value==1000)
        {
            cookSteps[1].cookTime-=1
            cookSteps[7].repeat=5
            cookSteps[9].repeat+=1
            cookSteps[10].cookTime-=2
        }

        var para =CookFunc.getDefHistory()
        para.cookPos=1
        para.cookSteps=cookSteps

        startPanguCooking(para,cookSteps)
    }
    PageBackBar{
        id:topBar
        anchors.bottom:parent.bottom
        name:"豆浆"
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
                id: waterSlider
                Layout.fillWidth: true
                Layout.preferredHeight: 100
                stepSize: 200
                from:600
                to: 1000
                value: 800
                title:"进水量"
                unit:"ML"
            }
        }
    }
}



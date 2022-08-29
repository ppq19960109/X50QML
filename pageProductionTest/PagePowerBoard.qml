import QtQuick 2.12
import QtQuick.Controls 2.5
import "../"

Item {
    Component.onCompleted: {
        productionTestStatus=2
    }
    Component.onDestruction: {
        productionTestStatus=1
    }

    PageBackBar{
        id:topBar
        anchors.top:parent.top
        name:qsTr("电源板输入输出检测")
    }
    Item{
        width:parent.width
        anchors.top: topBar.bottom
        anchors.bottom: parent.bottom
        PageButtonBar{
            anchors.centerIn: parent
            buttonWidth:200
            buttonHeight:100
            space:150
            models: ["输入检测","输出检测"]
            onClick:{
                if(clickIndex==0)
                {
                    push_page(pagePowerInput)
                }
                else
                {
                    push_page(pagePowerOut)
                }
            }
        }
    }
}

import QtQuick 2.12
import QtQuick.Controls 2.5
import "qrc:/SendFunc.js" as SendFunc
Item{
    property var panguMode
    Component.onCompleted: {
        panguMode=QmlDevState.getPanguMode()
        //console.log("panguMode:",JSON.stringify(panguMode))
        SendFunc.permitSteamStartStatus(1)
    }
    GridView{
        width: parent.width
        height: 400
        anchors.verticalCenter: parent.verticalCenter
        cellWidth: 200
        cellHeight: 120
        clip: true

        model:["馒头面团-揉面","面包面团-揉面","奶油打发","蛋白打发","煲汤","研磨","酸奶发酵","面团发酵","绞肉","切碎","冰沙","豆浆"]
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

                        break
                    case 1:

                        break
                    case 2:

                        break
                    case 3:

                        break
                    case 4:

                        break
                    case 5:

                        break
                    case 11:
                        load_page("pageSoybeanMilk",{"cookSteps":panguMode[index].cookSteps})
                        break
                    }
                }
            }
        }
    }
}



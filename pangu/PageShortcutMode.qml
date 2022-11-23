import QtQuick 2.12
import QtQuick.Controls 2.5
import "qrc:/SendFunc.js" as SendFunc
Item{
    onVisibleChanged: {
        console.log("PageShortcutMode onVisibleChanged",visible)
        if(visible)
        {
            SendFunc.permitSteamStartStatus(0)
        }
    }

    GridView{
        width: parent.width
        height: 300
        anchors.verticalCenter: parent.verticalCenter
        cellWidth: 250
        cellHeight: height/2
        flow:GridView.FlowTopToBottom
        clip: true
        model:["+自定义","五谷豆浆","烧肉","揉面","慢炖","干磨","低温慢煮","榨汁","煮饭","清洗","称重"]
        delegate:Item{
            width: 250
            height: parent.height/2
            Button{
                width: 230
                height: 130
                anchors.centerIn: parent
                background:Rectangle{
                    color: themesPopupWindowColor
                    radius: 10
                }
                Text{
                    text:modelData
                    color:themesTextColor2
                    font.pixelSize: 30
                    anchors.centerIn: parent
                }

                onClicked: {
                    console.log("PageShortcutMode index",index)
                    switch(index)
                    {
                    case 0:
                        load_page("pageModeCustom")
                        break
                    }
                }
            }
        }
    }
}



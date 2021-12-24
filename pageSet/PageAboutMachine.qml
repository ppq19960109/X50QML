import QtQuick 2.0
import QtQuick.Controls 2.2
import "../"
Item {

    Component.onCompleted: {
        infoModel.get(0).value=QmlDevState.state.ProductCategory
        infoModel.get(1).value=QmlDevState.state.ProductModel
        infoModel.get(2).value=QmlDevState.state.DeviceName
        listView.model=infoModel
        console.log("infoModel",listView.model.count)
    }
    Image {
        anchors.fill: parent
        source: "/x50/main/背景.png"
    }
    PageBackBar{
        id:topBar
        width:parent.width
        anchors.bottom:parent.bottom
        height:80
        name:qsTr("关于本机")
        leftBtnText:qsTr("")
        rightBtnText:qsTr("")
        onClose:{
            backPrePage()
        }
    }
    ListModel {
        id: infoModel

        ListElement {
            key: "品类："
            value: ""
        }
        ListElement {
            key: "型号："
            value: ""
        }
        ListElement {
            key: "device ID："
            value: ""
        }
    }

    Component {
        id: infoDelegate
        Item{
            width: parent.width
            height: 70
            Text{
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                text:key
                color:"#fff"
                font.pixelSize: 35
            }
            Text{
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                text:value
                color:"#fff"
                font.pixelSize: 35
            }
            PageDivider{
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
            }
        }
    }
    //内容
    Rectangle{
        width:parent.width
        anchors.bottom:topBar.top
        anchors.top: parent.top
        color:"transparent"
        Item{
            width:parent.width-80
            height: parent.height-80
            anchors.centerIn: parent
            ListView {
                id: listView
                width: parent.width
                height: listView.model.count*70
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                interactive: false
                delegate: infoDelegate

                focus: true
            }
            Button{
                width: parent.width
                height: 70
                anchors.top: listView.bottom

                PageDivider{
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                }
                background:Rectangle{
                    color:"transparent"
                }
                Text{
                    text:"绑定官方APP"
                    color:"#fff"
                    font.pixelSize: 30
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    horizontalAlignment:Text.AlignHCenter
                    verticalAlignment:Text.AlignVCenter
                }
//                Text{
//                    text:" 已绑定火粉俱乐部"
//                    visible: QmlDevState.state.APPBind==1
//                    color:"#fff"
//                    font.pixelSize: 30
//                    anchors.verticalCenter: parent.verticalCenter
//                    anchors.right: qrcodeImg.left
//                    anchors.rightMargin: 20
//                    horizontalAlignment:Text.AlignHCenter
//                    verticalAlignment:Text.AlignVCenter
//                }
                Image {
                    id:qrcodeImg
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    source: "qrc:/x50/set/gengduo.png"
                }
                onClicked: {
//                    console.log("AppBind",QmlDevState.state.APPBind)
//                    if(QmlDevState.state.APPBind==0)
                        showQrcodeBind("此二维码可以")
                }
            }
        }
    }

}


import QtQuick 2.7
import QtQuick.Controls 2.2
import "../"
Item {

    Image {
        asynchronous:true
        cache:false
        source: themesImagesPath+"applicationwindow-background.png"
    }
    PageBackBar{
        id:topBar
        width:parent.width
        anchors.bottom:parent.bottom
        height:80
        name:qsTr("版本说明")
        leftBtnText:qsTr("")
        rightBtnText:qsTr("")
        onClose:{
            backPrePage()
        }
    }

    Rectangle{
        width:parent.width
        anchors.bottom:topBar.top
        anchors.bottomMargin: 60
        anchors.top: parent.top
        anchors.topMargin: 60
        anchors.left: parent.left
        anchors.leftMargin: 50
        anchors.right: parent.right
        anchors.rightMargin: 80

        color:"transparent"
        //        Text{
        //            id:version
        //            text:QmlDevState.state.ComSWVersion+"\n更新日志\n1、新增：产品详情页视频展示功能；\n2、新增：网站前台版权标识样式切换功能\n3、优化：会员中心社会化登陆功能，用户可通过扫码关注设定的公众号登录；\n4、优化：安装商城模块后，可在网站后台内容管理中直接添加和编辑商品；\n5、优化：用户购买版权标识修改许可后，后台版权"
        //            color:"#fff"
        //            font.pixelSize: 35
        //            lineHeight:1.2

        //            wrapMode:Text.Wrap
        //        }
        Flickable {
            id: flick
            width: parent.width
            height: parent.height

            contentWidth: details.width
            contentHeight: details.height
            clip: true
            Text {
                id: details
                width: flick.width
                //                    height: flick.height
                font.pixelSize: 30
                lineHeight: 1.3
                color:"#fff"
                //                                        clip :true
                wrapMode: Text.WordWrap
                //                    elide: Text.ElideRight
                text:QmlDevState.state.ComSWVersion+"\n更新日志\n"+QmlDevState.state.UpdateLog
            }

            ScrollBar.vertical: ScrollBar {
                parent: flick.parent
                anchors.top: flick.top
                anchors.left: flick.right
                anchors.leftMargin: 40
                anchors.bottom: flick.bottom
                background:Rectangle{
                    implicitWidth: 4
                    color:"#000"
                    radius: width / 2
                }
                contentItem: Rectangle {
                    implicitWidth: 4
                    implicitHeight: 100
                    radius: width / 2
                    color: "#00E6B6"
                }
            }
        }
    }
}

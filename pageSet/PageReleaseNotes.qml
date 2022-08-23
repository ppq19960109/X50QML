import QtQuick 2.12
import QtQuick.Controls 2.5
import "../"
Item {

    PageBackBar{
        id:topBar
        anchors.bottom:parent.bottom
        name:qsTr("版本说明")
        leftBtnText:qsTr("")
        rightBtnText:qsTr("")
        onClose:{
            backPrePage()
        }
    }

    Item{
        width:parent.width
        anchors.bottom:topBar.top
        anchors.bottomMargin: 60
        anchors.top: parent.top
        anchors.topMargin: 60
        anchors.left: parent.left
        anchors.leftMargin: 50
        anchors.right: parent.right
        anchors.rightMargin: 80

        //        Text{
        //            id:version
        //            text:QmlDevState.state.ComSWVersion+"\n更新日志\n1、新增：产品详情页视频展示功能；\n2、新增：网站前台版权标识样式切换功能\n3、优化：会员中心社会化登陆功能，用户可通过扫码关注设定的公众号登录；\n4、优化：安装商城模块后，可在网站后台内容管理中直接添加和编辑商品；\n5、优化：用户购买版权标识修改许可后，后台版权"
        //            color:"#fff"
        //            font.pixelSize: 35
        //            lineHeight:1.2

        //            wrapMode:Text.WrapAnywhere
        //        }

        PageScrollBarText{
            anchors.fill: parent
            text:"系统版本:"+QmlDevState.state.ComSWVersion+"\n更新日志\n"+QmlDevState.state.UpdateLog //+"\nUI版本:"+uiVersion
        }
    }
}

import QtQuick 2.7
import QtQuick.Controls 2.2

Button {
    width:closeImg.width+50
    height:closeImg.height+50
    Image {
        id:closeImg
        asynchronous:true
        smooth:false
        cache:false
        anchors.centerIn: parent
        source: themesPicturesPath+"icon_window_close.png"
    }
    background: null
}
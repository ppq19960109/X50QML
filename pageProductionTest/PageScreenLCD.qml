import QtQuick 2.7
import QtQuick.Controls 2.2

Button {
    property int step: 1
    background:Image{
        asynchronous: true
        cache:false
        source:"qrc:/x50/test/image"+step+".png"
    }
    onClicked: {

        if(++step>10)
        {
            backPrePage()
        }
    }
}

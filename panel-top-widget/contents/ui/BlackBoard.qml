import QtQuick 1.1
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as Plasma

Rectangle{


    property int minimumWidth: screenData.data["Local"]["width"]*16/100
    property int minimumHeight: screenData.data["Local"]["height"]
    color : "#34353a"
    Plasma.ToolButton {
        height: screenData.data["Local"]["width"]*14/400
        anchors
        {
            top:parent.top
            topMargin:screenData.data["Local"]["height"]*17/100 + 3
            left:parent.left

        }
        id:prebutton
        visible: pageStack.depth > 1
        iconSource: QIcon("geri")
        onClicked: pageStack.pop()
    }

    ListView {
        clip:true
        width:screenData.data["Local"]["width"]*14/100
        anchors {
            top: prebutton.bottom
            topMargin : 5
            left: parent.left
            leftMargin:minimumWidth*9/100
            bottom: parent.bottom
            right: parent.right

        }

        model: modelAlias
        delegate: appItem
    }
}


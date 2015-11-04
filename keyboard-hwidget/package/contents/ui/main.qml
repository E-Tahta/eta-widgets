import QtQuick 1.1
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.qtextracomponents 0.1 as QtExtraComponents
import org.kde.draganddrop 1.0
import org.kde.plasma.graphicswidgets 0.1 as PlasmaWidgets

Rectangle {
    id:root
    color:"#ffffff"
    Item {
        id:iconContainer
        height:parent.height
        PlasmaWidgets.IconWidget {
            id:keyboardIcon
            icon: QIcon("preferences-desktop-keyboard")
            preferredIconSize: "48x48"
            minimumIconSize: "32x32"
            drawBackground: false
            anchors {
                left:parent.left
                leftMargin: root.width*9/100
            }
            onClicked: { keyboardclient.toggle(); }
        }
    }
    Item {
        id:textContainer
        height:parent.height
        width: parent.width - iconContainer.width
        Text {
            id:keyboardText
            text:"KLAVYE"
            color: "#969699"
            font.bold : true
            font.pointSize: 8.5
            anchors {
                left:parent.left
                leftMargin: root.width*9/100 + keyboardIcon.width + root.width*7/100
                verticalCenter:parent.verticalCenter
            }
            MouseArea {
                anchors.fill:parent
                onClicked: { keyboardclient.toggle(); }
            }
        }
    }
}

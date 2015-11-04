import QtQuick 1.1
import org.kde.plasma.graphicswidgets 0.1 as PlasmaWidgets

Item {
    width: 35
    height: 35
    Item {
        PlasmaWidgets.IconWidget {
            icon: QIcon("search")
            preferredIconSize: "32x32"
            minimumIconSize: "32x32"
            drawBackground: false
            anchors.fill: parent
            onClicked:{ plasmoid.togglePopup(); }
        }
    }
    Component.onCompleted: {
        plasmoid.backgroundHints= "NoBackground";
    }
}

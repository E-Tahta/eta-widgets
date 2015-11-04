/*
 *   Copyright 2011 Viranch Mehta <viranch.mehta@gmail.com>
 *   Copyright 2012 Jacopo De Simoi <wilderkde@gmail.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2 or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

/*
 * Modified by Yunusemre Şentürk <yunusemre.senturk@pardus.org.tr> 2015
 */

import Qt 4.7
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.qtextracomponents 0.1

Item {
    id: deviceItem
    property string udi
    property string icon
    property alias deviceName: deviceLabel.text
    property string emblemIcon
    property int state
    property bool mounted
    property bool expanded: (notifierDialog.currentExpanded == index)
    property alias percentUsage: freeSpaceBar.value
    height: container.childrenRect.height
    width: parent.width
    MouseArea {
        id: container
        anchors {
            fill: parent

        }
        hoverEnabled: true
        onEntered: {
            notifierDialog.currentIndex = index;
            //notifierDialog.highlightItem.opacity = 1;
            service = sdSource.serviceForSource(udi);
            operation = service.operationDescription("mount");
            service.startOperationCall(operation);
        }
        onExited: {
            //notifierDialog.highlightItem.opacity = expanded ? 1 : 0;
        }
        onClicked: {
            notifierDialog.itemFocused();
            var actions = hpSource.data[udi]["actions"];
            if (actions.length == 1) {
                service = hpSource.serviceForSource(udi);
                operation = service.operationDescription("invokeAction");
                operation.predicate = actions[0]["predicate"];
                service.startOperationCall(operation);
            } else {
                notifierDialog.currentExpanded = expanded ? -1 : index;
            }
        }

        // FIXME: Device item loses focus on mounting/unmounting it,
        // or specifically, when some UI element changes.
        PlasmaCore.IconItem {
            id: deviceIcon
            width: theme.iconSizes.dialog
            height: width
            z: 900
            source: QIcon(deviceItem.icon)
            enabled: deviceItem.state == 0
            anchors {
                left: parent.left
                top: parent.top
            }

            PlasmaCore.IconItem {
                id: emblem
                width: theme.iconSizes.dialog * 0.5
                height: width
                source: deviceItem.state == 0 ? QIcon(emblemIcon) : QIcon();
                anchors {
                    left: parent.left
                    bottom: parent.bottom
                }
            }
        }
        Column {
            id: labelsColumn
            spacing:2
            z: 900
            anchors {
                top: parent.top
                left: deviceIcon.right
                right: parent.right

            }

            PlasmaComponents.Label {
                id: deviceLabel
                height: paintedHeight
                wrapMode: Text.WordWrap
                anchors {
                    left: parent.left
                    right: parent.right
                }
                enabled: deviceItem.state == 0
                color:"#ffffff"
            }

            Item {
                height:freeSpaceBar.height
                anchors {
                    left: parent.left
                    right: parent.right
                }
                opacity: (deviceItem.state == 0 && mounted) ? 1 : 0
                PlasmaComponents.ProgressBar {
                    id: freeSpaceBar
                    height: deviceStatus.height
                    anchors {
                        left: parent.left
                        right: parent.right
                    }
                    opacity: mounted ? deviceStatus.opacity : 0
                    minimumValue: 0
                    maximumValue: 100
                    orientation: Qt.Horizontal
                }
            }

            Item {
                width:deviceStatus.width
                height:deviceStatus.height
                PlasmaComponents.Label {
                    id: deviceStatus

                    height: paintedHeight
                    // FIXME: state changes do not reach the plasmoid if the
                    // device was already attached when the plasmoid was
                    // initialized
                    text: deviceItem.state == 0 ? container.idleStatus() : (deviceItem.state==1 ? i18nc("Accessing is a less technical word for Mounting; translation should be short and mean \'Currently mounting this device\'", "Accessing...") : i18nc("Removing is a less technical word for Unmounting; translation shoud be short and mean \'Currently unmounting this device\'", "Removing..."))
                    font.pointSize: theme.smallestFont.pointSize
                    color: "#ffffff"
                    opacity: deviceItem.state != 0 || container.containsMouse || expanded ? 1 : 0;

                    Behavior on opacity { NumberAnimation { duration: 150 } }
                }
            }
        }

        function idleStatus() {
            var actions = hpSource.data[udi]["actions"];
            if (actions.length > 1) {
                return i18np("1 action for this device", "%1 actions for this device", actions.length);
            } else {
                return actions[0]["text"];
            }
        }

        ListView {
            id: actionsList
            anchors {
                top: labelsColumn.bottom
                left: parent.left
                leftMargin: 10
                right: parent.right
            }
            interactive: false
            model: hpSource.data[udi]["actions"]
            property int actionVerticalMargins: 5
            property int actionIconHeight: theme.iconSizes.dialog
            height: ((actionIconHeight+(2*actionVerticalMargins))*model.length)+anchors.topMargin
            opacity:  1
            delegate: actionItem

            Component.onCompleted:
            {
                currentIndex = -1;


            }
        }

        Component {
            id: actionItem
            ActionItem {
                icon: modelData["icon"]
                label: modelData["text"].toUpperCase()
                predicate: modelData["predicate"]
            }
        }
    }
    function makeCurrent() {
        notifierDialog.currentIndex = index;
        //notifierDialog.highlightItem.opacity = 1;
    }
}

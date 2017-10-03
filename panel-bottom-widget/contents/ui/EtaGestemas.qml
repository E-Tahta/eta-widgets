/*****************************************************************************
 *   Copyright (C) 2015 by Yunusemre Senturk                                 *
 *   <yunusemre.senturk@pardus.org.tr>                                       *
 *                                                                           *
 *   This program is free software; you can redistribute it and/or modify    *
 *   it under the terms of the GNU General Public License as published by    *
 *   the Free Software Foundation; either version 2 of the License, or       *
 *   (at your option) any later version.                                     *
 *                                                                           *
 *   This program is distributed in the hope that it will be useful,         *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of          *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           *
 *   GNU General Public License for more details.                            *
 *                                                                           *
 *   You should have received a copy of the GNU General Public License       *
 *   along with this program; if not, write to the                           *
 *   Free Software Foundation, Inc.,                                         *
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA .          *
 *****************************************************************************/

import QtQuick 1.1
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.qtextracomponents 0.1 as QtExtraComponents
import org.kde.draganddrop 1.0
import org.kde.plasma.graphicswidgets 0.1 as PlasmaWidgets

/**
 * This qml component works as declerative plasma widget and basically triggers
 * the etak application through QDBUS bridge(Interactive White Board Virtual Keyboard).
 */
Rectangle {
    id:etagestemas
    color:"#ffffff"
    property bool isEtaGestemasOn : true
    property string command : "killall"
    property variant args : ["eta_gestemas","eta-gestemas"]

    Item {
        id:textContainer
        height:parent.height
        width: parent.width - iconContainer.width
        Text {
            id:etagestemasText
            text:"HAREKETLER"
            color: "#969699"
            font.bold : true
            horizontalAlignment: Text.AlignRight
            font.pointSize: 8.5
            anchors {
                right: parent.right
                rightMargin: lineAlign/3
                verticalCenter:parent.verticalCenter
            }
            MouseArea {
                anchors.fill:parent
                onPressAndHold: { etagestemasText.color= "#FF6C00"; }
                onPressed: {etagestemasText.color= "#FF6C00"; }
                onReleased: {
                    etagestemasText.color= "#969699";
                    if(!toggleIconAnimation.running) {
                        toggleText();
                        plasmoid.runCommand(command,args);
                    }
                }
            }
        }
    }

    Item {
        id:iconContainer
        height:parent.height
        width: etagestemasIcon.width
        anchors.left: textContainer.right
        PlasmaWidgets.IconWidget {
            id:etagestemasIcon
            icon: QIcon("gestures")
            preferredIconSize: "48x48"
            minimumIconSize: "32x32"
            drawBackground: false
            anchors {
                right: parent.right
                rightMargin: lineAlign/3

            }
            onClicked: {
                if(!toggleIconAnimation.running) {
                    toggleText();
                    plasmoid.runCommand(command,args);
                }
            }
        }
        Rectangle {
            id:gestureOff
            visible:true
            opacity: 0.0
            radius: gestureOff.width/2
            color: "red"
            width: lineAlign/3
            height: parent.height
            anchors.centerIn: etagestemasIcon
            transform: Rotation {
                origin.y: gestureOff.height /2
                origin.x: gestureOff.width /2
                angle: 45
            }
        }
    }

    function toggleText()
    {
        if(isEtaGestemasOn) {
            isEtaGestemasOn = false;
            toggleIconAnimation.start();
            command = "killall";
            args = ["eta_gestemas","eta-gestemas"];
        } else {
            isEtaGestemasOn = true;
            toggleIconAnimation.start();
            command = "eta-gestemas"
            args = [""];
        }
    }

    NumberAnimation {
        id: toggleIconAnimation
        target: gestureOff
        property: "opacity"
        from: isEtaGestemasOn ? 1.0 : 0.0
        to: isEtaGestemasOn ? 0.0 : 1.0
        duration: 1000
    }
}

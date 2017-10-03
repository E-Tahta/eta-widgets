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
 * the virtual keyboard application through QDBUS bridge(Interactive White Board
 * Virtual Keyboard).
 */
Rectangle {
    id:keyboardclient    
    Item {
        id:iconContainer
        height: parent.height * 3 / 4 + lineAlign / 2
        width: parent.height * 3 / 4 + lineAlign / 2
        anchors {
            centerIn: parent
        }
        PlasmaWidgets.IconWidget {
            id:keyboardIcon
            icon: QIcon("preferences-desktop-keyboard")            
            drawBackground: false
            anchors.fill: parent
            onClicked: {
                plasmoid.runCommand("qdbus",["org.eta.virtualkeyboard",
                                             "/VirtualKeyboard",
                                             "org.eta.virtualkeyboard.toggle"]);
            }
        }
    }    
}

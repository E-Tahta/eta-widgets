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
import org.kde.plasma.components 0.1 as Plasma

/**
 * This qml component works with pagestack infrastructure and acts like it.
 *
 * It basically pop-ups as application list as determined by sub-menu list.
 */
Rectangle {

    /**
     * Indicates that the minimum width of the widget regarding the screen
     * resolution. The static number 16 represents the actual persentage
     * of the screen width that specified after longterm researches about
     * Interactive White Board.
     */
    property int minimumWidth: screenData.data["Local"]["width"]*16/100

    /**
     * Indicates that the minimum height of the widget regarding the screen
     * resolution.
     */
    property int minimumHeight: screenData.data["Local"]["height"]

    color : "#34353a"

    Plasma.ToolButton {
        id:previousbutton

        // These button sizes supposed to be the same in every list.
        height: screenData.data["Local"]["width"]*14/400
        anchors {
            top:parent.top
            topMargin:screenData.data["Local"]["height"]*17/100 + 3
            left:parent.left
        }
        visible: pageStack.depth > 1
        iconSource: QIcon("geri")
        onClicked: pageStack.pop()
    }

    ListView {
        clip:true
        width:screenData.data["Local"]["width"]*14/100
        anchors {
            top: previousbutton.bottom
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


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

/**
 * This qml component works like simple transition animation multi components
 * and stands for two simple options that Helper Widget and User Manual
 * for Interactive White Board.
 */
Rectangle {
    id:pop
    color:"#34353a"
    Column {
        Item {
            height: pop.height/2
            width: minimumWidth
            Rectangle {
                id:circle1
                height: lineAlign/2
                width: lineAlign/2
                color: "#ffffff"
                radius: lineAlign/4
                anchors {
                    left:parent.left
                    leftMargin:lineAlign
                    verticalCenter:parent.verticalCenter
                }
            }
            Text {
                id: guideline
                text: "KULLANIM KLAVUZU"
                font.bold: true
                verticalAlignment: Text.AlignVCenter
                color: "#ffffff"
                anchors {
                    left: circle1.right
                    leftMargin: lineAlign/2
                    verticalCenter:parent.verticalCenter
                }
            }
            MouseArea{
                anchors.fill: parent
                onPressAndHold: { guideline.color= "#FF6C00"; }
                onPressed: {guideline.color= "#FF6C00"; }
                onReleased: {
                    //plasmoid.runCommand("konsole");
                    guideline.color= "#ffffff";
                    root.state = 'invisible';
                    helper.color= "#ffffff";
                }
            }
        }//user manual
        Item {
            height: pop.height/2
            width: minimumWidth
            Rectangle {
                id:circle2
                height: lineAlign/2
                width: lineAlign/2
                color: "#ffffff"
                radius: lineAlign/4
                anchors {
                    left:parent.left
                    leftMargin:lineAlign
                    verticalCenter:parent.verticalCenter
                }
            }
            Text {
                id: helpmsg
                text: "YARDIM MESAJI"
                font.bold: true
                verticalAlignment: Text.AlignVCenter
                color: "#ffffff"
                anchors {
                    left: circle2.right
                    leftMargin: lineAlign/2
                    verticalCenter:parent.verticalCenter
                }
            }
            MouseArea {
                anchors.fill: parent
                onPressAndHold: { helpmsg.color= "#FF6C00"; }
                onPressed: {helpmsg.color= "#FF6C00"; }
                onReleased: {
                    plasmoid.runCommand("/usr/bin/etahelp");
                    helpmsg.color= "#ffffff";
                    root.state = 'invisible';
                    helper.color= "#ffffff";
                }
            }
        }// helper
    }
    Rectangle {
        id:verticalLine
        color:"#ffffff"
        width:1
        x: circle1.x+circle1.radius-width
        y: circle1.y+circle1.radius
        height: pop.height -(pop.y-circle1.y) - closer.height
    }
}

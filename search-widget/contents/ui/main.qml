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
import org.kde.plasma.graphicswidgets 0.1 as PlasmaWidgets
import org.kde.plasma.core 0.1 as PlasmaCore

Item {
    id: searchplasmoid
    property int minimumWidth : 500
    property int minimumHeight : 800
    property Component compactRepresentation: SearchPlasmoid {}
    property string searchQuery : ''
    property int mininumStringLength : 3

    Image {
        id: pardusSvg
        source: "/usr/share/icons/EtaColorfulFlat/apps/scalable/pardus.svg"
        anchors.centerIn: parent
        width: searchplasmoid.minimumWidth - 20
        height: pardusSvg.width * 415 / 450
        opacity: 0.1
    }

    PlasmaWidgets.LineEdit {
        id: searchField
        text: ""
        width: 460
        z: 9
        anchors {
            top: parent.top
            topMargin: 20
            left: parent.left
            leftMargin: 20
            right: parent.right
            rightMargin: 20
        }
        onTextChanged: {
            if(text.length >= mininumStringLength) {
                // set search query
                searchQuery = text.toLowerCase();
                // search - activities
                views.visible = true;
                searchView.search();
            } else {
                views.visible = false;
            };
        }
    }
    Keys.onPressed: {
        if(event.key == Qt.Key_Backspace) {
            // delete last char
            searchField.text = searchField.text.substring(0, searchField.text.length - 1);
        } else if(event.key == Qt.Key_Down) {
            // focus app results
            searchView.appResultsGrid.focus = true;
        } else if(event.key == Qt.Key_Enter || event.key == Qt.Key_Return) {
            // if appresultgrid not focused, run first app
            if(!searchView.appResultsGrid.focus && searchField.text) {
                // run first app result
                searchView.runApp(0, 0);
            }
        } else {
            // add text to textfield
            searchField.text += event.text;
        }
    }
    Item {
        id: views
        visible : false
        anchors {
            top: searchField.bottom
            topMargin: 35
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        SearchEngine {
            id: searchView
            opacity: 1
            transitions: Transition {
                PropertyAnimation { property: "opacity"; duration: 100 }
            }
        }
    }
    Component.onCompleted: {

    }
}


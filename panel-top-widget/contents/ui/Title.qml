/**

    Copyright (C) 2011, 2012 Glad Deschrijver <glad.deschrijver@gmail.com>

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, see <http://www.gnu.org/licenses/>.

*/

import QtQuick 1.1
import org.kde.plasma.components 0.1 as PlasmaComponents

Item {
    id: title
	height: row.height

	signal itemSelected(int index)

	property int currentIndex
    property int fontPointSize
    property int leftSideMargin : 6

	function insert(index, value) {
		repeater.model.insert(index, {"text" : value});
	}
	function set(index, value) {
		repeater.model.set(index, {"text" : value});
	}
	function remove(index) {
		if (repeater.model.count > index)
			repeater.model.remove(index);
	}
	function text(index) {
		return repeater.model.get(index).text;
	}

	Row {
		id: row
		anchors.top: parent.top
		anchors.left: parent.left
		anchors.right: parent.right
        anchors.leftMargin: leftSideMargin
		spacing: 2

		Repeater {
			id: repeater
            model: ListModel {}
			delegate: PlasmaComponents.Label {
                id: text
                anchors.verticalCenter: parent
                width: title.width / repeater.model.count
                font.pointSize: title.fontPointSize *3/4
                font.weight: title.currentIndex == index ? Font.Bold : Font.Normal
                text: modelData.toUpperCase()
                elide: Text.ElideRight
                color: title.currentIndex == index ? "#FF6C00" : "white"
				MouseArea {
					anchors.fill: parent
                    onClicked: title.itemSelected(index);
				}
			}
		}
		add: Transition {
			NumberAnimation {
				properties: "x, width"
				duration: 300
				easing.type: Easing.Linear
			}
		}
		move: Transition {
			NumberAnimation {
				properties: "x, width"
				duration: 300
				easing.type: Easing.Linear
			}
		}
	}
}

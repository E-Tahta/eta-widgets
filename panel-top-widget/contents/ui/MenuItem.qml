import QtQuick 1.1
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.qtextracomponents 0.1


Item {
	id: menuItem
	height: childrenRect.height

	signal clicked()
	signal entered()
	signal addFavorite()
	signal removeFavorite()
	signal moveFavoriteDown()
	signal moveFavoriteUp()

	property string iconName
	property alias name: label.text
	property alias genericName: subLabel.text
	property string entryPath
	property bool isApp: true
    property int leftSideMargin: 6
    property bool isEditing: false
    property int iconSize: 22
    property int smallIconSize: 16
    property int fontPointSize: 18
	property bool showDescription: true	

	Item { // don't use Row so that we can add a left margin to icon
		id: row
		width: parent.width
        height: Math.max(icon.height, label.height + subLabel.height) + 2 * leftSideMargin // use fixed height because otherwise menuListView.contentHeight is not calculated correctly (and even varies during scroll)

		QIconItem {
			id: icon
			anchors.left: parent.left
			anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: leftSideMargin
			width: iconSize
			height: iconSize
			icon: QIcon(iconName);
		}

		Column {
			id: column
			anchors.left: icon.right
			anchors.verticalCenter: icon.verticalCenter;
            anchors.leftMargin: leftSideMargin

			PlasmaComponents.Label {
				id: label
                width: menuItem.width - 2 * leftSideMargin - icon.width - (arrowLoader.sourceComponent == arrow ? arrowLoader.width + leftSideMargin : 0)
				height: theme.defaultFont.mSize.height
                font.pointSize: fontPointSize
                elide: Text.ElideRight
                color: "white"
			}

			PlasmaComponents.Label {
				id: subLabel
                anchors {
                    top:label.bottom
                    topMargin:3
                }
				width: label.width
				height: showDescription ? label.height : 0
                font.pointSize: 8
				opacity: 0.6
				visible: showDescription && text != ""
				elide: Text.ElideRight

			}
		}

		Loader {
			id: arrowLoader
			sourceComponent: isApp ? undefined : arrow
			anchors.right: parent.right
			anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: leftSideMargin
		}
		Component {
			id: arrow
			RightArrow {
				size: smallIconSize
			}
		}
	}


	MouseArea {
		anchors.fill: parent
        hoverEnabled: true
        visible: true
		onClicked: menuItem.clicked();
        onEntered: menuItem.entered();
        onPressed: {label.color = "#FF6C00";}
        onPressAndHold: {label.color = "#FF6C00";}
        onReleased: {label.color = "white";}
	}


}

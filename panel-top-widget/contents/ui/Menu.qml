import QtQuick 1.1
import org.kde.plasma.components 0.1 as PlasmaComponents

Item {
	id: menu

    property alias model: menuListView.model
    property bool isEditing: false
    property int iconSize: 60 // iconSize is overwritten in main.qml , do not set iconSize
    property int smallIconSize: 60
    property int fontPointSize : 18
    property int leftSideMargin : 6
	property bool showDescription: true
    property bool isSearchMenu: false

	signal itemSelected(string source)
	signal moveItem(int oldIndex, int newIndex)
	signal addFavorite(string source)
	signal removeFavorite(string source)
	signal moveFavoriteDown(int index)
	signal moveFavoriteUp(int index)
	signal goLeft()
	signal goRight(string source)

	function incrementCurrentIndex() {
		menuListView.incrementCurrentIndex();
	}
	function decrementCurrentIndex() {
		menuListView.decrementCurrentIndex();
	}
	function selectCurrentItem() {
		menu.itemSelected(menuListView.count == 0 ? "" : menuListView.currentItem.source);
	}
	function selectLeft() {
		menu.goLeft();
	}
	function selectRight() {
		menu.goRight(menuListView.count == 0 ? "" : menuListView.currentItem.source);
	}

	PlasmaComponents.Label {
		id: noEntriesText
		anchors.top: parent.top
		anchors.topMargin: 20
		anchors.horizontalCenter: parent.horizontalCenter
		text: i18n("No entries")
		visible: menuListView.count == 0
	}

	ListView {
		id: menuListView
		anchors.top: menu.top
		anchors.left: menu.left
		anchors.bottom: menu.bottom
		anchors.right: scrollBar.visible ? scrollBar.left : menu.right
		anchors.margins: 5
		spacing: 2
        highlightMoveDuration: 250

		// dirty hack to get rid of the binding loop in PlasmaComponents.ScrollBar when using the Up/Down keys to navigate the list
		Timer {
			id: indexChangeTimer
			running: false
			repeat: false
			interval: 200
			onTriggered: menuListView.currentIndexChanging = false;
		}
		property bool currentIndexChanging: false
		property bool moving: Flickable.moving || currentIndexChanging // this property is not set to true when the list moves because of keypresses, so we set it ourselves
		onContentYChanged: {
			currentIndexChanging = true;
			indexChangeTimer.running = true; // after some delay currentIndexChanging must be set to false again
		}
		// end dirty hack to get rid of the binding loop

        delegate: MenuItem {
			id: menuItemDelegate
			width: menuListView.width

			property variant menuItemModel: isSearchMenu ? model : modelData // dirty hack to allow the search menu to be displayed properly
			property string source: menuItemModel["DataEngineSource"]

            name: menuItemModel["name"]//.toUpperCase()
			genericName: menuItemModel["genericName"] == undefined ? "" : menuItemModel["genericName"]
			entryPath: menuItemModel["entryPath"] == undefined ? "" : menuItemModel["entryPath"]
			iconName: menuItemModel["iconName"]
			isApp: menuItemModel["isApp"]			
			isEditing: menu.isEditing			
			iconSize: menu.iconSize
			smallIconSize: menu.smallIconSize
            fontPointSize: menu.fontPointSize
            leftSideMargin: menu.leftSideMargin
			showDescription: menu.showDescription
			onClicked: menu.itemSelected(source);
			onEntered: menuListView.currentIndex = index;			
		}
	}

	PlasmaComponents.ScrollBar {
		id: scrollBar
		orientation: Qt.Vertical
		flickableItem: menuListView
		anchors.top: parent.top
		anchors.right: parent.right
		anchors.bottom: parent.bottom
	}	
}

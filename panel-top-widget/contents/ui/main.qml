import QtQuick 1.1
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents


Rectangle {
    id: main
    color : "#34353a"

    /**
     * Indicates that the minimum width of the widget.
     */
    property int minimumWidth

    /**
     * Indicates that the minimum height of the widget.
     */
    property int minimumHeight

    /**
     * Indicates that the background color of the widget.
     */
    property string containerBackgroundColor

    /**
     * Indicates that the font of the texts in the widget.
     */
    property string textFont

    property int numOfSubMenus: 2 // the maximum number of nested submenus
    property int numOfVisibleSubMenus: 0
    property int startIndex: 0
    property int numOfColumns: 1

    property int iconSize: 45
    property int smallIconSize: 20
    property int fontPointSize: 15
    property int leftSideMargin : 10

    property bool showDescription: true

    property variant appsMenu0List
    property variant appsMenu1List
    property variant appsMenu2List
    property variant appsMenu3List
    property variant appsMenu4List

     property Component compactRepresentation: WidgetCompactRepresenter {}

    function doMenuAction(action) {
        var menu = searchField.text.length == 0 ? appsMenuList.currentItem : searchMenu;
        menu.forceActiveFocus();
        if (action == "down")
            menu.incrementCurrentIndex();
        else if (action == "up")
            menu.decrementCurrentIndex();
        else if (action == "select")
            menu.selectCurrentItem();
    }

    function openItem(source, currentMenu) {
        if (source == "")
            return;
        var entry = appsSource.data[source];
        if (!entry["isApp"] && entry["entries"].length > 0) { // create and show submenu

            // if currentMenu == 0 (i.e. in the favorites list), then there are no submenus
            if (currentMenu < startIndex + numOfSubMenus) {
                appsMenuList.currentIndex = currentMenu + 1;
                var currentSubMenu = currentMenu - startIndex + 1;
                eval("appsMenu" + currentSubMenu + "List = getMenuItems(source)");
                appsTitle.set(currentSubMenu + startIndex, entry["name"]);
                ++numOfVisibleSubMenus;
                if (currentMenu < startIndex + numOfSubMenus - 1) {
                    eval("appsMenu" + (currentSubMenu + 1) + "List = new Array()"); // clean up old second level submenu
                    appsTitle.remove(currentSubMenu + startIndex + 1);
                    numOfVisibleSubMenus = currentSubMenu;
                }

            } else {
                console.log("Known crash with unknown solution :-(");
            }
        } else { // launch app
            var service = appsSource.serviceForSource(source);
            var operation = service.operationDescription("launch");
            service.startOperationCall(operation);
            plasmoid.hidePopup();
        }
    }

    function goLeft() {
        appsMenuList.decrementCurrentIndex();
    }

    function goRight(source, currentMenu) {
        var entry = appsSource.data[source];
        if (source != "" && !entry["isApp"] && entry["entries"].length > 0) // create and show submenu
            openItem(source, currentMenu);
        else
            appsMenuList.incrementCurrentIndex();
    }

    function isNonHiddenAppOrNonEmptyDirectory(source, entry) {
        if (source == "---" // the entry is a separator
            || entry["name"] == ".hidden"
            || !entry["display"]) // respect NoDisplay=true in .desktop file
            return false;

        if (entry["isApp"])
            return true;

        // at this point we have a non-hidden directory, let us check whether it is empty
        var sources = entry["entries"];
        if (sources.length <= 0) // the directory is empty
            return false;

        if (main.checkEmptySubmenusThoroughly) { // the following is slower
            for (var i = 0; i < sources.length; i++) {
                var entry = appsSource.data[sources[i]];
                if (isNonHiddenAppOrNonEmptyDirectory(sources[i], entry))
                    return true;
            }
            return false;
        }
        return true;
    }

    function getMenuItems(source) {
        var model = new Array();
        var sources = appsSource.data[source]["entries"];
        var names = new Array();
        for (var i = 0; i < sources.length; i++) {
            var entry = appsSource.data[sources[i]];
            if (isNonHiddenAppOrNonEmptyDirectory(sources[i], entry) && names.indexOf(entry["name"]) < 0) { // the entry has not already been found
                names.push(entry["name"]);
                model.push({"DataEngineSource" : sources[i], "name" : entry["name"], "genericName" : entry["genericName"], "iconName" : entry["iconName"], "isApp" : entry["isApp"], "entryPath" : entry["entryPath"]});
            }
        }
        return model;
    }

    function refresh() {
        appsMenu0List = getMenuItems("/");
    }

    function reset() {
        searchField.text = "";
        appsMenuList.currentIndex = 0;
    }
    function popupEventSlot(shown) {
        if (shown) {
            if (resetOnShow)
                reset();
            searchField.forceActiveFocus();
        }
    }

    function activateSlot() {
        searchField.forceActiveFocus();
    }

    PlasmaCore.DataSource {
        id: appsSource
        engine: "apps"

        onSourceAdded: {
            connectSource(source);
        }

        Component.onCompleted: {
            connectedSources = sources;
            refresh();
        }
    }

    SearchField {
        id: searchField
        anchors.top: main.top
        anchors.left: main.left
        anchors.right: main.right
        anchors.topMargin: screenData.data["Local"]["height"]*17/100 + 3
        anchors.leftMargin: leftSideMargin
        anchors.rightMargin: leftSideMargin
        dataSource: appsSource
        searchMenu: searchMenu

    }

    Item {
        id: centralWidget
        anchors.top: searchField.bottom
        anchors.left: main.left
        anchors.right: main.right
        anchors.bottom: parent.bottom
        anchors.topMargin: leftSideMargin
        clip: true

        Menu {
            id: searchMenu
            width: centralWidget.width
            height: centralWidget.height
            x: 0
            y: searchField.text.length > 0 ? 0 : -centralWidget.height
            clip: true
            model: searchField.model
            iconSize: main.iconSize
            smallIconSize: main.smallIconSize
            fontPointSize: main.fontPointSize
            showDescription: main.showDescription
            isSearchMenu: true
            onItemSelected: openItem(source, 0);


            Behavior on y {
                NumberAnimation { duration: 300; easing.type: Easing.Linear }
            }
        }

        Item {
            id: appsMenuListContainer
            width: centralWidget.width
            height: centralWidget.height
            x: 0
            y: searchField.text.length > 0 ? centralWidget.height : 0

            Title {
                id: appsTitle
                anchors {
                    top: searchMenu.bottom
                    left: parent.left
                    right: parent.right
                    leftMargin: leftSideMargin
                    topMargin: leftSideMargin
                }
                fontPointSize : main.fontPointSize
                leftSideMargin: main.leftSideMargin
                currentIndex: appsMenuList.currentIndex
                Component.onCompleted: {                    
                    insert(0, i18n("Applications"));
                }
                onItemSelected: appsMenuList.currentIndex = index;
            }

            ListView {
                id: appsMenuList
                anchors.top: appsTitle.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                spacing: 5
                snapMode: ListView.SnapOneItem
                orientation: ListView.Horizontal                
                highlightMoveSpeed: 400
                highlightMoveDuration: 150
                clip: true
                focus: true;
                model: main.numOfSubMenus + 1 + main.startIndex// this dramatically slows down opening a submenu
                delegate: Menu {
                    id: appsMenu
                    width: (appsMenuList.width - appsMenuList.spacing) / numOfColumns
                    height: appsMenuList.height
                    model: eval("appsMenu" + (index - startIndex) + "List")
                    isEditing:false
                    iconSize: main.iconSize
                    smallIconSize: main.smallIconSize
                    fontPointSize: main.fontPointSize
                    showDescription: main.showDescription
                    onItemSelected: openItem(source, index);
                    onGoLeft: main.goLeft();
                    onGoRight: main.goRight(source, index);
                    leftSideMargin: main.leftSideMargin
                }

                onMovementEnded: { // make sure currentIndex has the correct value when flicking appsMenuList
                    currentIndex = contentX / contentWidth * count;
                }
            }
        }
    }
    /**
     * This is the plasma data-engine that provides current user information.
     */
    PlasmaCore.DataSource {
        id: screenData
        engine: "userinfo"
        connectedSources: ["Local"]
        interval : 900
    }

    function configChanged()
    {
        containerBackgroundColor = plasmoid.readConfig( "panelColor" )
        textFont = plasmoid.readConfig( "textFont" )
    }

    Component.onCompleted: {
        main.minimumHeight = screenData.data["Local"]["height"];
        main.minimumWidth = screenData.data["Local"]["width"]*16/100;
        plasmoid.addEventListener( 'ConfigChanged', configChanged );
        containerBackgroundColor = plasmoid.readConfig( "panelColor" );
        textFont = plasmoid.readConfig( "textFont" );
    }
}

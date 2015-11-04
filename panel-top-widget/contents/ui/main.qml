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
import Qt 4.7
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as Plasma
import org.kde.plasma.graphicswidgets 0.1 as PlasmaWidgets

import "../code/apps.js" as Apps

/**
 * This qml component works with pagestack infrastructure and acts like it.
 *
 * This component generates application list and application cathegory list
 * and also pop-ups the application cathegory list (sub-menu list).
 */
Rectangle {
    id: root
    clip: true
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

    /**
     * Indicates that the intial query string going to be calculated in
     * getMenuItems function.
     */
    property string appSearchQuery : '/'

    property int i : 0

    /**
     * Indicates that the counter veriable for the cathegories of
     * applications.
     */
    property int categoryIndex : 0

    /**
     * Indicates that the alias property for appItem Object.
     */
    property alias appItem:appItem

    /**
     * Indicates that the variant property for model for pagestack ListView
     * model in ApplicaitonListView.qml .
     */
    property variant modelAlias

    /**
     * Indicates that the variant property for the source of an application.
     */
    property variant sources

    /**
     * Indicates that the variant property for the entry among applications.
     */
    property variant entry

    /**
     * Indicates that the actual drawable component compactRepresenter for
     * this main.qml .
     */
    property Component compactRepresentation: WidgetCompactRepresenter {}

    /**
     * This functions generates the application list in the system and cathegories
     * of the applicaitons.
     *
     * @param type:variant source see variant property
     * @return type:bool
     */
    function getMenuItems(source) {
        if(!sources) sources = appsSource.data[appSearchQuery]["entries"];
        entry = appsSource.data[sources[i]];
        if (sources[i] != "---" && entry && entry["name"]) {
            if (Apps.appNames.indexOf(entry["name"]) < 0 && entry["name"] != ".hidden") {
                Apps.appNames.push(entry["name"]);
                if (entry["isApp"] && entry["display"]) {
                    var app = {
                        source: sources[i],
                        name: entry["name"],
                        genericName: entry["genericName"],
                        menuId: entry["menuId"],
                        iconName: entry["iconName"],
                        entryPath: entry["entryPath"]
                    };
                    Apps.allApps.push(app);
                    Apps.categories[Apps.categoryName].apps.push(app);
                } else if(entry["entries"] && entry["entries"].length > 0) {
                    // check if major category
                    // subcategories don't have name
                    // check number of / in name
                    if(entry["name"] && sources[i].split('/').length == 2) {
                        Apps.categoryNames.push({
                            source: sources[i],
                            name: entry["name"],
                            genericName: entry["genericName"],
                            iconName: entry["iconName"]
                        });
                        Apps.categories[entry["name"]] = {
                            source: sources[i],
                            genericName: entry["genericName"],
                            iconName: entry["iconName"],
                            entryPath: entry["entryPath"],
                            menuId: entry["menuId"],
                            apps: []
                        };
                    }
                    appCategories.append({
                        source: sources[i],
                        name: entry["name"]
                    });
                }
            }
        }
        if(i < sources.length - 1) {
            i++;
            return true;
        } else {
            i = 0;
            if(categoryIndex == appCategories.count) {
                Apps.allApps.sort(sortByName);
                categoriesList.model = Apps.categoryNames;
                return false;
            }
            appSearchQuery = appCategories.get(categoryIndex).source;
            if( appCategories.get(categoryIndex).name && appSearchQuery.split('/').length == 2 ) {
                Apps.categoryName = appCategories.get(categoryIndex).name;
            }
            sources = appsSource.data[appSearchQuery]["entries"];
            categoryIndex++;
            return true;
        }
    }

    function sortByName(a, b) {
        var nameA = a.name.toLowerCase(),
            nameB = b.name.toLowerCase();

        if (nameA < nameB) //sort string ascending
            return -1
        if (nameA > nameB)
            return 1

        return 0 //default return value (no sorting)
    }

    /**
     * This function corrects the sub-menu names that determined
     * as it is.
     *
     * @param type:string modelname
     * @return type:string modelname
     */
    function checkName(modelname) {
     if(modelname=="All")
         return "Tüm Uygulamalar"
     else if(modelname=="Bulunanlar")
         return "Eğitim"
     else
         return modelname
    }

    /**
     * This function corrects the icon names according to its name.
     *
     * @param type:string modelname
     * @return type:string iconname
     */
    //FIXME: This function works arbitrary make it dynamic please!
    function checkIcon(modelname) {
        if(modelname == "All")
            return "tum_uygulamalar"
        else if(modelname == "Ayarlar")
            return "preferences-system"
        else if(modelname == "Çoklu Ortam")
            return "applications-multimedia"
        else if(modelname == "Eğitim")
            return "applications-education"
        else if(modelname == "Geliştirme")
            return "applications-development"
        else if(modelname == "Grafik")
            return "applications-graphics"
        else if(modelname == "İnternet")
            return "applications-internet"
        else if(modelname == "Ofis")
            return "applications-office"
        else if(modelname == "Sistem")
            return "applications-system"
        else if(modelname == "Oyunlar")
            return "applications-games"
        else if(modelname == "Yardımcı Programlar")
            return "applications-utilities"
        else
            return "applications-education" //"tum_uygulamalar"
    }

    /**
     * This function determines the correct application name is set or not.
     *
     * @param type:string appname
     * @return type:bool
     */
    function checkApplication(appname) {
        if(appname == screenData.data["Local"]["name"].toUpperCase())
            return false;
        else
            return true;
    }

    ListModel {
        id: appCategories
    }

    /**
     * This is the plasma data-engine that provides information about
     * applications installed on the system.
     */
    PlasmaCore.DataSource {
        id: appsSource
        dataEngine: "apps"
        onSourceAdded: {
            connectSource(source);
            appSearchQuery = source;
            categorizeAppsTimer.start();
        }
        Component.onCompleted: {
            connectedSources = sources;
            categorizeAppsTimer.start();
        }
    }

    // App Categorization and Search "Thread"
    Timer {
        id: categorizeAppsTimer
        repeat: true
        interval: 1
        triggeredOnStart: false
        onTriggered: {
            if(!getMenuItems(appSearchQuery)) {
                stop();
            }
        }
    }

    Component {
        id: appItem
        Item {
            width: screenData.data["Local"]["width"]*13/100
            height: minimumWidth*20/100 * checkApplication(modelData.name.toUpperCase())
            visible: checkApplication(modelData.name.toUpperCase())
            Plasma.ToolButton {
                id:tb
                iconSource: QIcon(modelData.iconName)
                anchors.fill: parent
                onClicked: {
                    var operation = appsSource.serviceForSource(modelData.menuId).operationDescription("launch");
                    appsSource.serviceForSource(modelData.menuId).startOperationCall(operation);
                    pageStack.pop();
                }
            }

            Text {
                id:appname
                font.family:textFont
                text:modelData.name.toUpperCase()
                font.bold: true
                verticalAlignment: Text.AlignVCenter
                font.pointSize: 10
                color: "#ffffff"
                anchors{
                    left:tb.left
                    leftMargin: minimumWidth*20/100 + 5
                    verticalCenter:tb.verticalCenter
                }
            }
        }
    }
    Component {
        id: categoryItem
        Item {
            id:categoryItemMain
            visible:checkCathegory(modelData.name)
            enabled:checkCathegory(modelData.name)
            width: screenData.data["Local"]["width"]*13/100
            height: (minimumWidth*20/100) * checkCathegory(modelData.name)
            Plasma.ToolButton {
                id:tbMenu
                iconSource: QIcon(checkIcon(modelData.name))
                anchors.fill:parent
                onClicked: {
                    categoriesList.currentIndex = index;
                    modelAlias = Apps.categories[modelData.name].apps;
                    pageStack.push(Qt.createComponent(plasmoid.file("ui", "ApplicationListView.qml")));
                }
                Text {
                    color: "#ffffff"
                    font.family:textFont
                    text: checkName(modelData.name).toUpperCase()
                    font.bold: true
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: 9
                    anchors {
                        left:tbMenu.left
                        leftMargin: minimumWidth*20/100 + 5
                        verticalCenter:tbMenu.verticalCenter
                    }
                }// Text
            }// Plasma Toolbutton
        }// Item
    }// categoryItem

    /**
     * This function hides the unwanted sub-menu list items.
     *
     * @param type:string cname
     * @return type:bool
     */
    function checkCathegory(cname) {
        if(cname == "Ayarlar")
            return false
        else if(cname == "Geliştirme")
            return false
        else if(cname == "Oyunlar")
            return false
        else if(cname == "Sistem")
            return false
        else if(cname == "Yardımcı Programlar")
            return false
        else if(cname == "Eğitim")
            return false
        else
            return true
    }

    Plasma.PageStack {
        id: pageStack
        toolBar: toolBar
        clip: true
        anchors {
            top: toolBar.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        initialPage: categoriesList
    }

    ListView {
        id: categoriesList
        width: minimumWidth
        height: minimumWidth * 20/100 * count
        anchors {
            top: parent.top
            topMargin : minimumWidth * 80 / 100
            left: parent.left
            leftMargin:minimumWidth*9/100
        }
        delegate: categoryItem
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
        root.minimumHeight = screenData.data["Local"]["height"];
        root.minimumWidth = screenData.data["Local"]["width"]*16/100;
        plasmoid.addEventListener( 'ConfigChanged', configChanged );
        containerBackgroundColor = plasmoid.readConfig( "panelColor" );
        textFont = plasmoid.readConfig( "textFont" );
    }
}


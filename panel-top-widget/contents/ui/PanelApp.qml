import QtQuick 1.1
import Qt 4.7
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as Plasma
import org.kde.plasma.graphicswidgets 0.1 as PlasmaWidgets

import "../code/specificapps.js" as Apps


Rectangle {


    anchors.fill: parent

    property string specificapp1 : ""
    property string applicationName1 : ""
    property string specificapp2 : ""
    property string applicationName2 : ""
    property string specificapp3 : ""
    property string applicationName3 : ""

    property string appSearchQuery : '/'
    property int i : 0
    property int categoryIndex : 0

    property variant sources
    property variant entry

    function getMenuItems(source) {
        if(!sources) sources = appsSource.data[appSearchQuery]["entries"];

        entry = appsSource.data[sources[i]];

        if (sources[i] != "---" && entry && entry["name"] )
        {

            if (Apps.appNames.indexOf(entry["name"]) < 0 && entry["name"] != ".hidden")
            {

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



                        if(app.name.toLowerCase() == specificapp1 || app.name.toLowerCase() == specificapp2 || app.name.toLowerCase() == specificapp3)
                        {
                                 Apps.allApps.push(app);
                                 Apps.categories[Apps.categoryName].apps.push(app);
                        }


                }
                else if(entry["entries"] && entry["entries"].length > 0)
                {

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

                        appCategories.append({source: sources[i],name: entry["name"]});


                }

            }

        }

        if(i < sources.length - 1)
        {

                i++;
                return true;

        }
        else //filling allApps finished
        {

            i = 0;

            if(categoryIndex == appCategories.count) {
                Apps.allApps.sort(sortByName);
                appGrid.model = Apps.allApps;
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

    function checkName(modelname)
    {
     if(specificapp1==modelname)
         return applicationName1
     else if(specificapp2==modelname)
         return applicationName2
     else if(specificapp3==modelname)
         return applicationName3
     else
         return modelname.toUpperCase()
    }

    ListModel {
        id: appCategories
    }

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
            width: minimumWidth-lineAlign-1
            height: minimumWidth*23/100



            Plasma.ToolButton {
                id:tb
                iconSource: QIcon(modelData.iconName)

                anchors.fill: parent

                onClicked: {
                    var operation = appsSource.serviceForSource(modelData.menuId).operationDescription("launch");
                    appsSource.serviceForSource(modelData.menuId).startOperationCall(operation);


                }
            }

            Text
            {   id:appname
                text: checkName(modelData.name.toLowerCase())
                font.family:textFont
                font.bold: true
                verticalAlignment: Text.AlignVCenter
                font.pointSize: 10
                color: "#969699"

                anchors{
                    left:tb.left
                    leftMargin: minimumWidth*23/100 +5
                    verticalCenter:tb.verticalCenter
                }
            }



        }
    }

    ListView {
        id: appGrid
        width:minimumWidth
        anchors {
            top: parent.top
            left: parent.left
            leftMargin:lineAlign
            bottom: parent.bottom
            right: categoriesList.left
            rightMargin: 0
        }

        delegate: appItem
        interactive: false
    }


    Plasma.ScrollBar {
        id: appGridScroll
        anchors {
            top: appGrid.top
            right: appGrid.right
            bottom: appGrid.bottom
        }
        flickableItem: appGrid
    }


}


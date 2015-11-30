/*****************************************************************************
 *   Copyright (C) 2013 by Ionut Colceriu <contact@ghinda.net>               *
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

/*
 * Modified by Yunusemre Şentürk <yunusemre.senturk@pardus.org.tr> 2015
 */
import QtQuick 1.1
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as Plasma
import org.kde.plasma.graphicswidgets 0.1 as PlasmaWidgets
import org.kde.runnermodel 0.1 as RunnerModels

Item {
	anchors.fill: parent
    clip: true
	property int activitySearchIndex : 0	
	property alias appResultsGrid : appResultsGrid
	property alias appsRunnerModel : appsRunnerModel
    property int cSize : 50
    Component {
        id: appItem
        Column {
            Item {
                id:iconContainer
                width: parent.width
                height: cSize
                anchors.top:parent.top
                PlasmaWidgets.IconWidget {
                    id: resultIcon
                    preferredIconSize: "32x32"
                    minimumIconSize: "32x32"
                    drawBackground: false
                    anchors {
                        left:parent.left
                        leftMargin:10
                    }
                    onClicked: {
                        runApp(runnerid, index);
                    }
                }
                Text {
                    id: iconText
                    text: label
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    anchors {
                        left:resultIcon.right
                        leftMargin: 10
                    }
                }
                Component.onCompleted: {

				// there's an issue with the icon returned from runnermodel
				// so we can't assign it directly to the iconwidget
                resultIcon.icon = icon;
                }
            }
        }
    }
    Item {
        id: searchContainer
        width: parent.width
        height: appSearchContainer.height + placesSearchContainer.height + recentSearchContainer.height
        Item {
            id: appSearchContainer
            anchors {
                top: parent.top
                right: parent.right
                left: parent.left
            }
            height: appsRunnerModel.count ? cSize*appsRunnerModel.count : 0
            visible: appsRunnerModel.count
            Plasma.Label {
                id: applicationsLabel
                text: 'Uygulamalar'
                anchors {
                    top: parent.top
                }
            }
            ListView {
                id: appResultsGrid
                focus: true
                height: cSize*count
				anchors {
					top: applicationsLabel.bottom
					left: parent.left
					right: parent.right
				}
                model: appsRunnerModel
				delegate: appItem				
				KeyNavigation.up: searchField
				KeyNavigation.down: (placesResultsGrid.visible) ? placesResultsGrid : placesResultsGrid.KeyNavigation.down
			}			
        }
        Item {
            id: placesSearchContainer
            anchors {
                top: appSearchContainer.bottom
                topMargin: 10
				right: parent.right
				left: parent.left
            }
            height: placesRunnerModel.count ?cSize*placesRunnerModel.count : 0
			visible: placesRunnerModel.count			
			Plasma.Label {
				id: placesLabel
                text: 'Dizinler'
				anchors {
					top: parent.top
				}
            }
            ListView {
                id: placesResultsGrid
				focus: true
                height: cSize*count
				anchors {
					top: placesLabel.bottom
					left: parent.left
					right: parent.right
				}				
                model: placesRunnerModel
                delegate: appItem
				KeyNavigation.up: (appResultsGrid.visible) ? appResultsGrid : appResultsGrid.KeyNavigation.up
				KeyNavigation.down: (recentResultsGrid.visible) ? recentResultsGrid : recentResultsGrid.KeyNavigation.down
			}
        }
        Item {
            id: recentSearchContainer
            anchors {
				top: placesSearchContainer.bottom
                topMargin: 10
				right: parent.right
				left: parent.left
			}
            height: recentRunnerModel.count ? cSize*recentRunnerModel : 0
			visible: recentRunnerModel.count			
			Plasma.Label {
				id: recentLabel
                text: 'Son Kullanılanlar'
				anchors {
					top: parent.top
				}
            }
            ListView {
				id: recentResultsGrid
				focus: true
                height: cSize*count
				anchors {
					top: recentLabel.bottom
					left: parent.left
					right: parent.right
                }
                model: recentRunnerModel
                delegate: appItem
				KeyNavigation.up: (placesResultsGrid.visible) ? placesResultsGrid : placesResultsGrid.KeyNavigation.up
                KeyNavigation.down: searchField
            }
        }
    }
    Plasma.ScrollBar {
        anchors {
            top: searchContainer.top
            right: searchContainer.right
			bottom: searchContainer.bottom
		}
		flickableItem: searchContainer
    }
    Plasma.Label {
        id: noResultsLabel
        text: 'Üzgünüz, aradığınız kelime ile eşleşen bulunamadı'
        anchors.fill: parent
        visible: !activityResultsModel.count && !recentRunnerModel.count && !placesRunnerModel.count && !appsRunnerModel.count
    }
    /* Search Functionality and Models */
	RunnerModels.RunnerModel {
		id: appsRunnerModel
		runners: [ "services", "kill", "kget", "calculator" ]
		query: searchQuery
	}	
	RunnerModels.RunnerModel {
		id: placesRunnerModel
        runners: [ "sessions", "places", "solid" ]
		query: searchQuery
	}	
	RunnerModels.RunnerModel {
		id: recentRunnerModel
		runners: [ "recentdocuments" ]
		query: searchQuery
	}	
	/* Activities Search */
	ListModel {
		id: activityResultsModel
	}	
	// Search "Thread"
	Timer {
		id: searchActivityTimer
		repeat: true
		interval: 1
		triggeredOnStart: false
        onTriggered: {
            if(!searchActivities(searchQuery)) {
                stop();
            }
            searchplasmoid.minimumHeight = searchContainer.height;//FIX ME: make height dynamic through the search
        }
    }
    function searchActivities(activityName) {
        if(activitiesModel.get(activitySearchIndex).Name && activitiesModel.get(activitySearchIndex).Name.toLowerCase().indexOf(activityName) != -1) {
            activityResultsModel.append(activitiesModel.get(activitySearchIndex));
            activitySearchContainer.opacity = 1;
        };
        activitySearchIndex++;
		if (activitySearchIndex == activitiesModel.count) return false;		
        return true;
    }

    /* Global search method
	 * - currently searches only activities
	 */
	function search(string) {
		// clear activities results
		searchActivityTimer.stop();
		activitySearchIndex = 0;
		activityResultsModel.clear();
		activitySearchContainer.opacity = 0;
		
		// search activities
		searchActivityTimer.start();
	}	
	/* Run app */
	// TODO Find better fix for this, to know which runner to use for launching
	function runApp(runnerid, index) {		
		// default to app runner
		var runner = appsRunnerModel;		
		// places
		if([ "sessions", "places", "solid", "nepomuksearch" ].indexOf(runnerid) != -1) {
			runner = placesRunnerModel;
		}		
		// recent
		if([ "recentdocuments" ].indexOf(runnerid) != -1) {
			runner = recentRunnerModel;
		}		
		runner.run(index);
    }
    Component.onCompleted: {
		// attach key events to the seachfield
		searchField.KeyNavigation.up = appResultsGrid
        searchField.KeyNavigation.down = appResultsGrid
    }
}

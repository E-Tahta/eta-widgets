import QtQuick 1.1
import org.kde.plasma.graphicswidgets 0.1 as PlasmaWidgets
import org.kde.plasma.core 0.1 as PlasmaCore

Item{
    id: searchplasmoid
    property int minimumWidth : 500
    property int minimumHeight : 800

    property Component compactRepresentation: SearchPlasmoid {}
    property string searchQuery : ''
    property int mininumStringLength : 3



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

                    // activate search view
                    //dashboardCategories.currentIndex = 0;

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

        // dashboard categories


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


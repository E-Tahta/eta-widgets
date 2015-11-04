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
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.runnermodel 0.1 as RunnerModels
import org.kde.plasma.graphicswidgets 0.1 as PlasmaWidgets


/**
 * This qml component specifically prepared for Interactive White Board.
 *
 * It shows the current date and time, teacher's name surname and nickname
 * and holds the representer of the all applications menu list.
 */
Item {
    id: widgetrepresenter

    /**
     * Indicates that the minimum width of the widget regarding the screen
     * resolution.
     */
    property int minimumWidth: screenData.data["Local"]["width"] * 14 / 100

    /**
     * Indicates that the minimum height of the widget regarding the sub
     * modules that are clock, seperator-line, teacherinfo and all applications
     * rectangle.
     */
    property int minimumHeight: clock.height + topseperatorcontainer.height
            + teacherinfo.height + allapps.height

    /**
     * Indicates that the global veriable for general left & right alignment
     * regarding the screen resolution.
     */
    property int leftrightAlign: minimumWidth * 9 / 100

    /**
     * Indicates that the global veriable for general line alignment
     * regarding the screen resolution.
     */
    property int lineAlign: minimumWidth * 7 / 100

    /**
     * Indicates that the global veriable for general text left & right
     * alignment regarding the screen resolution.
     */
    property int textAlign: minimumWidth * 4 / 100

    /**
     * Indicates that the height of widget except all applications rectangle
     * regarding the screen resolution.
     */
    property int topPartHeight: screenData.data["Local"]["height"] * 17 / 100

    Column {
        anchors.fill: parent

        Rectangle {
            id: clock
            width: minimumWidth
            height: topPartHeight / 2
            color: containerBackgroundColor
            Row {
                anchors {
                    top: parent.top
                    topMargin: 0
                    fill: parent
                }
                Item {
                    id: textclockcontainer
                    anchors {
                        left: parent.left
                        leftMargin: leftrightAlign
                        top: parent.top
                        topMargin: lineAlign
                        verticalCenter: parent.verticalCenter
                    }
                    Column {
                        Text {
                            id: date
                            font.family: textFont
                            font.pointSize: minimumWidth * 3 / 100
                            text: Qt.formatDate(
                                      dataSource.data["Local"]["Date"],
                                      "dddd, d MMMM yyyy")
                            color: "#ffffff"
                            horizontalAlignment: Text.AlignLeft
                            anchors {
                                left: parent.left
                                leftMargin: 0
                            }
                        } //textdate
                        Text {
                            id: time
                            font.bold: true
                            font.family: textFont
                            font.pointSize: minimumWidth * 11 / 100
                            text: (Qt.formatTime(
                                       dataSource.data["Local"]["Time"],
                                       "h:mmap")).toString().slice(0, -2)
                            color: "#ffffff"
                            horizontalAlignment: Text.AlignLeft
                            anchors {
                                top: date.bottom
                                topMargin: 1
                                left: parent.left
                                leftMargin: 0
                            }
                        } //texttime
                    } // Column
                } // Item textclockcontainer
            } //Row
        } // Date and Time

        Rectangle {
            id: topseperatorcontainer
            color: containerBackgroundColor
            height: 3
            width: minimumWidth
            Rectangle {
                id: topseperator
                color: "#cccccc"
                height: 1
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: lineAlign
                    right: parent.right
                    rightMargin: lineAlign
                }
            } //Rectangle line
        } // Rectangle middleline container

        Rectangle {
            id: teacherinfo
            width: minimumWidth
            height: topPartHeight / 2
            color: containerBackgroundColor
            Row {
                anchors {
                    top: parent.top
                    topMargin: 0
                    fill: parent
                }
                Item {
                    id: labelcontainer
                    anchors {
                        left: parent.left
                        leftMargin: leftrightAlign
                        verticalCenter: parent.verticalCenter
                    }
                    Column {
                        anchors {
                            left: parent.left
                            leftMargin: 0
                            verticalCenter: parent.verticalCenter
                        }
                        Text {
                            id: nameSurname
                            font.family: textFont
                            text: userDataSource.data["Local"]["fullname"].toUpperCase()
                            color: "#ffffff"
                            font.pointSize: minimumWidth * 5 / 100
                            font.bold: true
                            elide: Text.ElideLeft
                            horizontalAlignment: Text.AlignLeft
                            anchors {
                                left: parent.left
                                leftMargin: 0
                            }
                        } //label
                        Text {
                            id: branch
                            font.family: textFont
                            text: userDataSource.data["Local"]["loginname"] // hocabranş
                            color: "#ffffff"
                            font.pointSize: minimumWidth * 3 / 100
                            font.bold: false
                            elide: Text.ElideLeft
                            horizontalAlignment: Text.AlignLeft
                            anchors {
                                left: parent.left
                                leftMargin: 0
                            }
                        } //label
                    } //Column
                } //item labelcontainer
            } //Row
        } // Rectangle teacherinfo

        Rectangle {
            id: allapps
            width: minimumWidth
            height: minimumWidth * 25 / 100
            color: "#6d6f76"
            Row {
                anchors {
                    top: parent.top
                    topMargin: 0
                    fill: parent
                }
                Item {
                    id: toolbuttonappcontainer
                    width: minimumWidth * 18 / 100
                    height: minimumWidth * 18 / 100
                    anchors {
                        left: parent.left
                        leftMargin: leftrightAlign
                        verticalCenter: parent.verticalCenter
                    }
                    PlasmaWidgets.IconWidget {
                        id: appIcon
                        icon: QIcon("tum_uygulamalar")
                        anchors.fill: parent
                        onClicked: {
                            plasmoid.togglePopup()
                        }
                    }
                } //item toolbuttonappcontainer
                Item {
                    anchors {
                        left: toolbuttonappcontainer.right
                        leftMargin: textAlign
                        verticalCenter: parent.verticalCenter
                    }
                    Text {
                        id: allappstext
                        font.family: textFont
                        text: "TÜM\nUYGULAMALAR"
                        verticalAlignment: Text.AlignVCenter
                        color: "#ffffff"
                        font.bold: true
                        elide: Text.ElideLeft
                        horizontalAlignment: Text.AlignLeft
                        anchors {
                            left: parent.left
                            leftMargin: 0
                            verticalCenter: parent.verticalCenter
                            verticalCenterOffset: 0
                        }
                    } //label
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            plasmoid.togglePopup()
                            //toggleAllAppsVision(); //TODO figure out popup is opened or not and then toggle with global function
                        }
                    }
                } //item labelcontainer
            } //Row
        } // All apps
    } //main column

    /**
     * This is the plasma data-engine that provides current time.
     */
    PlasmaCore.DataSource {
        id: dataSource
        engine: "time"
        connectedSources: ["Local"]
        interval: 500
    }

    /**
     * This is the plasma data-engine that provides current user information.
     */
    PlasmaCore.DataSource {
        id: userDataSource
        engine: "userinfo"
        connectedSources: ["Local"]
        interval: 500
    }
} //Item widgetrepresenter

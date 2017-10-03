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
import org.kde.runnermodel 0.1 as RunnerModels
import org.kde.plasma.graphicswidgets 0.1 as PlasmaWidgets

Item {
    id: root

    /**
     * Indicates that the font of the texts in the widget.
     */
    property string textFont

    /**
     * Indicates that the minimum width of the widget regarding the screen
     * resolution. The static number 16 represents the actual persentage
     * of the screen width that specified after longterm researches about
     * Interactive White Board.
     */
    property int minimumWidth : screenData.data["Local"]["width"]*14/100 -1;

    /**
     * Indicates that the minimum height of the widget regarding the screen
     * resolution.
     */
    property int minimumHeight : volumeChanger.height +
                                 //keyboardclient.height +
                                 //printscreen.height +
                                 bottomseperator.height +
                                 closer.height

    /**
     * Indicates that the global veriable for general left & right alignment
     * regarding the screen resolution.
     */
    property int leftrightAlign: minimumWidth*9/100

    /**
     * Indicates that the global veriable for general line alignment
     * regarding the screen resolution.
     */
    property int lineAlign: minimumWidth*7/100

    /**
     * Indicates that the global veriable for general text left & right
     * alignment regarding the screen resolution.
     */
    property int textAlign: minimumWidth*4/100

    Column {
        anchors.fill:parent

        Row {
            VolumeChanger {
                id:volumeChanger
                width:  minimumWidth / 4
                height: minimumWidth * 57 /100
                volumeline: minimumWidth * 38 /100
                color:"#ffffff"
                visible: true
            }

            Column {
                id: toolsContainer
                Row {
                    KeyboardClient {
                        id:keyboardclient
                        height: volumeChanger.height / 2
                        color:"#ffffff"
                        width: minimumWidth * 3 / 8
                        visible: true
                    }

                    Rectangle {
                        id:penclient
                        height: volumeChanger.height / 2
                        width: minimumWidth * 3 / 8
                        color:"#ffffff"

                        Item {
                            id:toolbuttonpenclientcontainer
                            height: penclient.height * 3 / 4
                            width: penclient.height * 3 / 4
                            anchors {
                                centerIn: parent
                            }
                            PlasmaWidgets.IconWidget {
                                id: printscreenIcon
                                icon: QIcon("zim")
                                anchors.fill:parent
                                onClicked: {
                                    plasmoid.runCommand("/usr/bin/eta-pen");
                                }
                            }
                        }//item toolbuttoncontainer
                    }
                }


                Row {


                    Rectangle {
                        id:printscreen
                        height: volumeChanger.height / 2
                        width: minimumWidth * 3 / 8
                        color: "#ffffff"

                        Item {
                            id:toolbuttonprintscreencontainer
                            height: printscreen.height * 3 / 4
                            width: printscreen.height * 3 / 4
                            anchors {
                                centerIn: parent
                            }
                            PlasmaWidgets.IconWidget {
                                id: penClientIcon
                                icon: QIcon("ekran_goruntusu")
                                anchors.fill:parent
                                onClicked: {
                                    plasmoid.runCommand("ksnapshot");
                                }
                            }
                        }
                    } //printscreen rectangle

                    Rectangle {
                        id:screenblackout
                        height: volumeChanger.height / 2
                        width: minimumWidth * 3 / 8
                        color: "#ffffff"

                        Item {
                            id:toolbuttonscreenblackoutcontainer
                            height: screenblackout.height * 3 / 4 - lineAlign/3
                            width: screenblackout.height * 3 / 4
                            anchors {
                                centerIn: parent
                            }
                            PlasmaWidgets.IconWidget {
                                id: ekrankarartIcon
                                icon: QIcon("perde")
                                anchors.fill:parent
                                onClicked: {
                                    plasmoid.runCommand("/usr/bin/eta-black",
                                                        ["&"]);
                                }
                            }
                        }//item toolbuttonappcontainer
                    }//ekran karart rectangle
                }
            }
        }

        Rectangle {
            id:bottomseperator
            color: "#ffffff"
            height: 2
            width: minimumWidth
            Rectangle {
                color: "#cccccc"
                height: 1
                anchors {
                    bottom:parent.bottom
                    bottomMargin:0
                    left:parent.left
                    leftMargin:0
                    right:parent.right
                    rightMargin:0
                }
            }//Rectangle line
        }// Rectangle middleline container

        Row {
            Rectangle {
                id:helper
                width: minimumWidth/2 -2
                height: minimumWidth *15/100
                color: "#ffffff"
                Text {
                    id:yardimtext
                    text: "YARDIM"
                    color: "#969699"
                    font.family:textFont
                    font.bold : true
                    elide: Text.ElideLeft
                    horizontalAlignment: Text.AlignLeft
                    anchors {
                        left: parent.left
                        leftMargin: lineAlign -8
                        centerIn:parent
                    }
                }//label
                MouseArea {
                    anchors.fill: parent

                    onPressAndHold: {helper.color= "#000000"; }
                    onPressed: {helper.color= "#000000"; }
                    onReleased: {
                        if(root.state == 'visible') {
                            root.state = 'invisible';
                            helper.color= "#ffffff";
                        } else {
                            root.state = 'visible';
                            helper.color= "#000000";
                        }
                    }
                }
            } //helper rectangle
            Rectangle {
                height: minimumWidth *15/100
                width: 3
                color:"#ffffff"
                Rectangle {
                    color: "#cccccc"
                    anchors.horizontalCenterOffset: 0
                    width:1
                    height: minimumWidth *15/100
                    anchors {
                        horizontalCenter:parent.horizontalCenter
                    }
                }//Rectangle line
            }// Rectangle middleline container
            Rectangle {
                id:closer
                width: minimumWidth/2 -1
                height: minimumWidth *15/100
                color: "#ffffff"
                Row {
                    anchors {
                        top:parent.top
                        topMargin:0
                        fill:parent
                    }
                    Item {
                        id:toolbuttonkapatcontainer
                        width: minimumWidth *13/100
                        height: minimumWidth *13/100
                        anchors {
                            left : parent.left
                            leftMargin: lineAlign -10
                            verticalCenter: parent.verticalCenter
                        }
                        PlasmaWidgets.IconWidget {
                            id: kapatIcon
                            icon: QIcon("power_off")
                            anchors.fill:parent
                        }
                    }//item toolbuttonappcontainer
                    Item {
                        anchors {
                            left:toolbuttonkapatcontainer.right
                            leftMargin :lineAlign -8
                            verticalCenter: parent.verticalCenter
                        }
                        Text {
                            id:kapattext
                            text: "KAPAT"
                            color: "#969699"
                            font.family:textFont
                            font.bold : true
                            elide: Text.ElideLeft
                            horizontalAlignment: Text.AlignLeft
                            anchors {
                                left: parent.left
                                leftMargin: 0
                                verticalCenter: parent.verticalCenter
                                verticalCenterOffset: 0
                            }
                        }//label
                    }//item labelcontainer
                }//Row
                MouseArea {
                    anchors.fill: parent

                    onPressAndHold: {kapattext.color= "#FF6C00"; }
                    onPressed: {kapattext.color= "#FF6C00"; }
                    onReleased: {
                        plasmoid.runCommand("qdbus", ["org.kde.ksmserver",
                            "/KSMServer", "org.kde.KSMServerInterface.logout",
                            "1", "-1", "-1"]);
                        kapattext.color= "#969699";
                    }
                }
            }// closer rectangle
        }//Row of helper + closer

    }//main column

    Help {
        id:helpRect
        width: minimumWidth
        height: volumeChanger.height
        x:root.x
        y:root.y+height
        z:-1
        opacity: 0
    }

    states: [
        State {
            name: 'visible'
            PropertyChanges {
                target: helpRect;
                x: root.x;
                y: root.y;
                z:100;
                opacity:1;
            }
        },
        State {
            name: 'invisible'
            PropertyChanges { target: helpRect;
                x: root.x ;
                y: root.y+ helpRect.height;
                z:-1;
                opacity:0;
            }
        }
    ]
    transitions: [
        Transition {
            NumberAnimation { properties: "x,y,opacity"; duration: 200 }
        }
    ]

    /**
     * This is the plasma data-engine that provides current user information.
     */
    PlasmaCore.DataSource {
        id: screenData
        engine: "userinfo"
        connectedSources: ["Local"]
    }

    function configChanged()
    {

        textFont = plasmoid.readConfig( "textFont" )
    }

    Component.onCompleted: {
        plasmoid.addEventListener( 'ConfigChanged', configChanged );

        textFont = plasmoid.readConfig( "textFont" )
    }
}//Item root


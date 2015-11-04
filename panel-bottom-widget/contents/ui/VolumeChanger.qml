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
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as Plasma
import org.kde.plasma.graphicswidgets 0.1 as PlasmaWidgets

/**
 * This qml component works like simple plasma widget slider and mixer volume
 * changer on background.
 */
Rectangle {
    id:main

    /**
     * Indicates that a flag holds global volume changed by Plasma engine or not
     * default is false.
     */
    property bool volumeChangedByEngine : false

    /**
     * Indicates that a flag holds global volume changed by this widget or not
     * default is false.
     */
    property bool volumeChangedBySlider : false

    /**
     * Indicates that string property stores kmix volume changer source
     * name.
     */
    property string controller

    /**
     * Indicates that integer property holds volume level default is 0.
     */
    property int level : 0

    /**
     * Indicates that integer property holds previous volume level default is 50.
     * This property strongly needed because when volume is unmuted from mute
     * position by system or by this  widget, kmix audio engine does not provide
     * previous volume level, default is 50.
     */
    property int previousVol : 50

    /**
     * Indicates that integer property holds the width of slider used by parent
     * qml components.
     */
    property int volumeline
    Row {
        anchors {
            left:parent.left
            leftMargin:leftrightAlign
        }
        Item {
            id:iconcontainer
            width: volumeChanger.height
            height: volumeChanger.height
            PlasmaWidgets.IconWidget {
                id:soundicon
                icon:QIcon("audio-volume-medium")
                anchors.fill:parent
                onClicked: {
                    if(level == 0)
                        level= previousVol ;
                    else
                        level = 0;
                    changeVolume.restart();
                }
            }
        }
        Column {
            anchors {
                left:iconcontainer.right
                leftMargin: 20
            }
            Item {
                id:textcontainer
                width: volumeline
                height: volumeChanger.height/2
                Text {
                    text:"SES AYARI"
                    font.family:textFont
                    color:"#969699"
                    font.bold: true
                    font.pointSize: 8
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
            Item {
                id:volumeslidercontainer
                width: volumeline
                height: volumeChanger.height/2
                Rectangle {
                    anchors.fill:parent
                    color:"transparent"
                    Rectangle {
                        height: 1
                        color:"#969699"
                        anchors {
                            left:parent.left
                            right:parent.right
                            verticalCenter: parent.verticalCenter
                        }
                    }
                }
                PlasmaWidgets.Slider {
                    id: volumeSlider
                    anchors {
                        left: parent.left
                        right: parent.right
                        verticalCenter:parent.verticalCenter
                    }
                    orientation: Qt.Horizontal
                    maximum: 100
                    minimum: 0
                    value: level
                    height: 10
                    onValueChanged: {
                        if(controller) {
                            if(volumeChangedByEngine) {
                                volumeChangedByEngine = false;
                            } else {
                                volumeChangedBySlider = true;
                                level = volumeSlider.value;
                                previousVol = level;
                                changeVolume.restart();
                            }
                        }
                        if(level == 0)
                            soundicon.icon= QIcon("audio-volume-muted");
                        else if(level <35)
                            soundicon.icon= QIcon("audio-volume-low");
                        else if(level<69)
                            soundicon.icon= QIcon("audio-volume-medium");
                        else if (level<=100)
                            soundicon.icon= QIcon("audio-volume-high");
                    }
                }
            }
        }
    }
    /**
     * Timer to change volume, to only trigger a single request on the datasource
     */
    Timer {
        id: changeVolume
        interval: 50
        running: false
        repeat: false
        onTriggered: {
            var operation = mixerSource.serviceForSource(controller).operationDescription("setVolume");
            operation.level = level;
            mixerSource.serviceForSource(controller).startOperationCall(operation);
        }
    }
    /**
     * This function created in order to connect dataengine to controller.
     * @param type:void
     */
    function connectToDevice() {
        controller = mixerSource.data["Mixers"]["Current Master Mixer"] + "/" + mixerSource.data["Mixers"]["Current Master Control"];
        mixerSource.connectSource(controller);        
        level = (controller) ? mixerSource.data[controller].Volume : 0;
        volumeSlider.value = level;
    }

    /**
     * This is the plasma data-engine that provides current kmix audio information.
     */
    // mixer DataEngine for global Volume control
    PlasmaCore.DataSource {
        id: mixerSource
        dataEngine: "mixer"
        connectedSources: [ "Mixers" ]
        onDataChanged: {
            // connect after kmix was started
            if(mixerSource.data["Mixers"].Running) {
                if(controller) {
                    if(volumeChangedBySlider) {
                        volumeChangedBySlider = false;
                    } else {
                        volumeChangedByEngine = true;
                        level = (controller) ? mixerSource.data[controller].Volume : 0;
                        volumeSlider.value = level;
                    }
                } else {
                    connectToDevice();
                }
            } else {
                // disconnect if kmix closed
                controller = "";
                volumeSlider.value = level = 0;
            }
        }
        Component.onCompleted: {
            if(mixerSource.data["Mixers"].Running) connectToDevice()
        }
    }
}


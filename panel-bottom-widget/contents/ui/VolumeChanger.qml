import QtQuick 1.1
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as Plasma
import org.kde.plasma.graphicswidgets 0.1 as PlasmaWidgets



Rectangle
{
    id:main
    property bool volumeChangedByEngine : false
    property bool volumeChangedBySlider : false
    property string controller
    property int level : 0
    property int previousVol : 50
    property int volumeline



Row{
    anchors{

        left:parent.left
        leftMargin:leftrightAlign
    }
    Item{
        id:iconcontainer
        width: volumeChanger.height
        height: volumeChanger.height
        PlasmaWidgets.IconWidget{
            id:soundicon
            icon:QIcon("audio-volume-medium")
            anchors.fill:parent
            onClicked:{
                    if(level == 0)
                        level= previousVol ;
                    else
                        level = 0;
                    changeVolume.restart();
            }
        }
    }



Column{

    anchors{
        left:iconcontainer.right
        leftMargin: 20
    }
    Item{
        id:textcontainer
        width: volumeline
        height: volumeChanger.height/2
        Text{
            text:"SES AYARI"
            font.family:textFont
            color:"#969699"
            font.bold: true
            font.pointSize: 8
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    Item{
    id:volumeslidercontainer
    width: volumeline
    height: volumeChanger.height/2


    Rectangle
    {
     anchors.fill:parent
     color:"transparent"
     Rectangle
     {
      height: 1
      color:"#969699"
      anchors{
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

        onValueChanged:
        {

            if(controller)
            {
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




    // timer to change volume, to only trigger a single request on the datasource
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

    // connect dataengine to controller
    function connectToDevice() {
        controller = mixerSource.data["Mixers"]["Current Master Mixer"] + "/" + mixerSource.data["Mixers"]["Current Master Control"];
        mixerSource.connectSource(controller);

        level = (controller) ? mixerSource.data[controller].Volume : 0;
        volumeSlider.value = level;
    }

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


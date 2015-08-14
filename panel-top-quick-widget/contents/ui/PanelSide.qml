import QtQuick 1.1
import Qt 4.7
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.runnermodel 0.1 as RunnerModels
import org.kde.plasma.graphicswidgets 0.1 as PlasmaWidgets
Item
{
  id: panelside
  property int minimumWidth: screenData.data["Local"]["width"]*14/100;
  property int minimumHeight: checkUser(userDataSource.data["Local"]["loginname"])
  property int leftrightAlign: minimumWidth*9/100
  property int lineAlign: minimumWidth*7/100
  property int textAlign: minimumWidth*4/100
  Column{
    anchors.fill:parent

    Rectangle // DOLPHIN
    {
        id:dolphin
        width: minimumWidth
        height: minimumWidth * 22 /100

        color: "#ffffff"

        Row
        {
          anchors
          {
        top:parent.top
        topMargin:0
        fill:parent
          }

          Item
          {
        id:toolbuttondolphincontainer
        width: minimumWidth * 18 /100
        height: minimumWidth * 18 /100
        anchors
           {
                    left:  parent.left
                    leftMargin: leftrightAlign
                    verticalCenter: parent.verticalCenter
           }


          PlasmaWidgets.IconWidget
          {
            id: dolphinIcon
            icon:QIcon("system-file-manager")
            anchors.fill:parent
          }
        }//ToolButton


          Item
          {


         anchors
           {
                    left:toolbuttondolphincontainer.right
                    leftMargin :textAlign
                    verticalCenter: parent.verticalCenter
               }
         Text
         {

                id:dolphintext
                 text: "DOSYALARIM"

            color: "#969699"
            font.family:textFont
            font.bold : true
                elide: Text.ElideLeft
            horizontalAlignment: Text.AlignLeft
            anchors
            {

             left: parent.left
             leftMargin: 0
             verticalCenter: parent.verticalCenter
             verticalCenterOffset: 0
            }
     }//label
          }//item labelcontainer


         }//Row

        MouseArea{
            anchors.fill: parent

            onPressAndHold: { dolphintext.color= "#FF6C00"; }
            onPressed: {dolphintext.color= "#FF6C00"; }
            onReleased: {plasmoid.runCommand("dolphin"); dolphintext.color= "#969699";}
        }

    }


    Rectangle // USB
    {
      id:usb
      width: minimumWidth
      height: minimumWidth * 22 /100

      color: "#ffffff"

      Row
      {
        anchors
        {
      top:parent.top
      topMargin:0
      fill:parent
        }

        Item
        {
      id:toolbuttonusbcontainer
      width: minimumWidth * 18 /100
      height: minimumWidth * 18 /100
      anchors
         {
                  left:  parent.left
                  leftMargin: leftrightAlign
                  verticalCenter: parent.verticalCenter
         }


        PlasmaWidgets.IconWidget
        {
          id: usbIcon
          icon:QIcon("usb")
          anchors.fill:parent
        }
        }//ToolButton


        Item
        {


       anchors
         {
                  left:toolbuttonusbcontainer.right
                  leftMargin :textAlign
                  verticalCenter: parent.verticalCenter
             }
       Text
       {

              id:usbtext
               text: "USB BELLEK " + mountPoint

          color: "#969699"
          font.family:textFont
          font.bold : true
              elide: Text.ElideLeft
          horizontalAlignment: Text.AlignLeft
          anchors
          {

           left: parent.left
           leftMargin: 0
           verticalCenter: parent.verticalCenter
           verticalCenterOffset: 0
          }
            }//label
        }//item labelcontainer

        Item
        {
            id:usbarrowContainer
            width:minimumWidth * 13 /100
            height: minimumWidth * 18 /100
            anchors{
                right: parent.right
            }

            /*
            PlasmaWidgets.IconWidget
            {
              id: usbarrowIcon
              icon:QIcon("gtk-goto-last-ltr")
              anchors.fill:parent
              onClicked:{
                    plasmoid.togglePopup();
              }
            }
            */

            Image {
                id: usbarrowIcon
                source: "../images/usb_arrow.png"
                height: 32
                width: 32
                anchors{
                    bottom:parent.bottom
                    right: parent.right
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked:{
                          plasmoid.togglePopup();
                    }
                }
            }
        }

       }//Row

      MouseArea{
          height: minimumWidth * 18 /100
          width: usb.width-usbarrowContainer.width
          anchors{
            left:parent.left
            top:parent.top
            bottom:parent.bottom
            right: usbarrowContainer.left
          }

          onPressAndHold: { usbtext.color= "#FF6C00"; }
          onPressed: {usbtext.color= "#FF6C00"; }
          onReleased: {

              usbtext.color= "#969699";
              //plasmoid.runCommand("dolphin",[mountPoint]);
          }
      }

  }


    Rectangle // LIBRE
    {
        id:libre
        width: minimumWidth
        height: minimumWidth * 22 /100

        color: "#ffffff"

        Row
        {
          anchors
          {
        top:parent.top
        topMargin:0
        fill:parent
          }

          Item
          {
        id:toolbuttonlibrecontainer
        width: minimumWidth * 18 /100
        height: minimumWidth * 18 /100
        anchors
           {
                    left:  parent.left
                    leftMargin: leftrightAlign
                    verticalCenter: parent.verticalCenter
           }


          PlasmaWidgets.IconWidget
          {
            id: libreIcon
            icon:QIcon("libreoffice-main")
            anchors.fill:parent
          }
        }//ToolButton


          Item
          {


         anchors
           {
                    left:toolbuttonlibrecontainer.right
                    leftMargin :textAlign
                    verticalCenter: parent.verticalCenter
               }
         Text
         {

                id:libretext
                 text: "LIBRE OFFICE"

            color: "#969699"
            font.family:textFont
            font.bold : true
                elide: Text.ElideLeft
            horizontalAlignment: Text.AlignLeft
            anchors
            {

             left: parent.left
             leftMargin: 0
             verticalCenter: parent.verticalCenter
             verticalCenterOffset: 0
            }
     }//label
          }//item labelcontainer


         }//Row

        MouseArea{
            anchors.fill: parent

            onPressAndHold: { libretext.color= "#FF6C00"; }
            onPressed: {libretext.color= "#FF6C00"; }
            onReleased: {plasmoid.runCommand("libreoffice"); libretext.color= "#969699";}
        }

    }


    Rectangle // FIREFOX
    {
        id:firefox
        width: minimumWidth
        height: minimumWidth * 22 /100

        color: "#ffffff"

        Row
        {
          anchors
          {
        top:parent.top
        topMargin:0
        fill:parent
          }

          Item
          {
        id:toolbuttonfirefoxcontainer
        width: minimumWidth * 18 /100
        height: minimumWidth * 18 /100
        anchors
           {
                    left:  parent.left
                    leftMargin: leftrightAlign
                    verticalCenter: parent.verticalCenter
           }


          PlasmaWidgets.IconWidget
          {
            id: firefoxIcon
            icon:QIcon("firefox")
            anchors.fill:parent
          }
        }//ToolButton


          Item
          {


         anchors
           {
                    left:toolbuttonfirefoxcontainer.right
                    leftMargin :textAlign
                    verticalCenter: parent.verticalCenter
               }
         Text
         {

                id:firefoxtext
                 text: "INTERNET TARAYICISI"

            color: "#969699"
            font.family:textFont
            font.bold : true
                elide: Text.ElideLeft
            horizontalAlignment: Text.AlignLeft
            anchors
            {

             left: parent.left
             leftMargin: 0
             verticalCenter: parent.verticalCenter
             verticalCenterOffset: 0
            }
     }//label
          }//item labelcontainer


         }//Row

        MouseArea{
            anchors.fill: parent

            onPressAndHold: { firefoxtext.color= "#FF6C00"; }
            onPressed: {firefoxtext.color= "#FF6C00"; }
            onReleased: {plasmoid.runCommand("firefox"); firefoxtext.color= "#969699";}
        }

    }


    Rectangle // EBA
    {
        id:eba
        width: minimumWidth
        height: minimumWidth * 22 /100

        color: "#ffffff"

        Row
        {
          anchors
          {
        top:parent.top
        topMargin:0
        fill:parent
          }

          Item
          {
        id:toolbuttonebacontainer
        width: minimumWidth * 18 /100
        height: minimumWidth * 18 /100
        anchors
           {
                    left:  parent.left
                    leftMargin: leftrightAlign
                    verticalCenter: parent.verticalCenter
           }


          PlasmaWidgets.IconWidget
          {
            id: ebaIcon
            icon:QIcon("eba_dosya")
            anchors.fill:parent
          }
        }//ToolButton


          Item
          {


         anchors
           {
                    left:toolbuttonebacontainer.right
                    leftMargin :textAlign
                    verticalCenter: parent.verticalCenter
               }
         Text
         {

            id:ebatext
             text: "EBA"

        color: "#969699"
        font.family:textFont
        font.bold : true
            elide: Text.ElideLeft
        horizontalAlignment: Text.AlignLeft
        anchors
        {

         left: parent.left
         leftMargin: 0
         verticalCenter: parent.verticalCenter
         verticalCenterOffset: 0
        }
     }//label
          }//item labelcontainer


         }//Row

        MouseArea{
            anchors.fill: parent

            onPressAndHold: { ebatext.color= "#FF6C00"; }
            onPressed: {ebatext.color= "#FF6C00"; }
            onReleased: {plasmoid.runCommand("firefox",["-new-window", "http://eba.gov.tr"]); ebatext.color= "#969699";}
        }


    }

  }//main column

  function checkUser(username)
  {
      if(username=="ogrenci")
      {
          usb.visible=false;


          return dolphin.height+libre.height+firefox.height+eba.height;
      }
      return dolphin.height+usb.height+libre.height+firefox.height+eba.height;
  }

  PlasmaCore.DataSource {
          id: userDataSource
          engine: "userinfo"
          connectedSources: ["Local"]
          interval: 500
  }

}

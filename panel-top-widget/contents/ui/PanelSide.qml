/***************************************************************************
 *   Copyright (C) %{CURRENT_YEAR} by %{AUTHOR} <%{EMAIL}>                            *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, write to the                         *
 *   Free Software Foundation, Inc.,                                       *
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA .        *
 ***************************************************************************/

import QtQuick 1.1
import Qt 4.7
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.runnermodel 0.1 as RunnerModels
import org.kde.plasma.graphicswidgets 0.1 as PlasmaWidgets
Item
{ 
  id: panelside
  
   property string pColor
   property string tFont
   property int minimumWidth : screenData.data["Local"]["width"]*14/100;
   property int leftrightAlign: minimumWidth*9/100
   property int lineAlign: minimumWidth*7/100
   property int textAlign: minimumWidth*4/100
   property int topPartHeight : screenData.data["Local"]["height"]*17/100

   property int minimumHeight : clock.height+topseperatorcontainer.height+hocainfo.height+allapps.height


    Column
    {
      anchors.fill:parent

    Rectangle
    {
      id:clock
          width: minimumWidth
          height: topPartHeight/2

          color: panelSideColor

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
        id:textclockcontainer

         anchors
           {

                    left:  parent.left
                    leftMargin: leftrightAlign
                    top:parent.top
                    topMargin:lineAlign
                    verticalCenter: parent.verticalCenter
               }
            Column{
            Text
            {
           id: tarih
           font.family:textFont
           font.pointSize: minimumWidth*3/100
           text : Qt.formatDate( dataSource.data["Local"]["Date"],"dddd, d MMMM yyyy" )
           color: "#ffffff"
           horizontalAlignment: Text.AlignLeft
           anchors
           {

            left: parent.left
            leftMargin: 0
           }
        }//texttarih
        Text
            {
           id: time
           font.bold: true
           font.family:textFont
           font.pointSize: minimumWidth*11/100
           text : (Qt.formatTime( dataSource.data["Local"]["Time"],"h:mmap" )).toString().slice(0,-2)
           color: "#ffffff"
           horizontalAlignment: Text.AlignLeft
           anchors
           {
            top:tarih.bottom
            topMargin:1
            left: parent.left
            leftMargin: 0
           }
        }//texttime

          }//item textclockcontainer
            }//Column


        }//Row
        MouseArea{

        }

    }// Tarih Saat

    Rectangle
    {

        id:topseperatorcontainer
        color: panelSideColor
        height: 3
        width: minimumWidth


        Rectangle
        {
           id:topseperator
           color: "#cccccc"
           height: 1
           anchors
           {
               verticalCenter:parent.verticalCenter
               left:parent.left
               leftMargin:lineAlign
               right:parent.right
               rightMargin:lineAlign

           }
        }//Rectangle line
        MouseArea{

        }
    }// Rectangle middleline container


    Rectangle //Hoca Info
    {
      id: hocainfo
          width: minimumWidth
          height: topPartHeight/2

          color: panelSideColor

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
        id:labelcontainer

         anchors
           {
                    left:  parent.left
                    leftMargin: leftrightAlign
                    verticalCenter: parent.verticalCenter
               }
            Column
            {
           anchors
           {
                    left:  parent.left
                    leftMargin: 0
                    verticalCenter: parent.verticalCenter
               }
            Text
            {
           id : adsoyad
           font.family:textFont
           text: userDataSource.data["Local"]["fullname"].toUpperCase()

           color: "#ffffff"
           font.pointSize: minimumWidth*5/100
           font.bold : true
           elide: Text.ElideLeft
           horizontalAlignment: Text.AlignLeft
           anchors
           {

            left: parent.left
            leftMargin: 0
           }
        }//label
        Text
            {
           id: brans
           font.family:textFont
           text: userDataSource.data["Local"]["loginname"] // hocabranş
           color: "#ffffff"
           font.pointSize: minimumWidth*3/100
           font.bold : false
           elide: Text.ElideLeft
           horizontalAlignment: Text.AlignLeft
           anchors
           {

            left: parent.left
            leftMargin: 0
           }
        }//label
        }//Column
          }//item labelcontainer

         }//Row
        MouseArea{

        }
    }//Rectangle hocainfo



    Rectangle // All apps
    {
        id:allapps
        width: minimumWidth
        height: minimumWidth * 25 /100

        color: "#6d6f76"

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
        id:toolbuttonappcontainer
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
            id: appIcon
            icon:QIcon("tum_uygulamalar")
            anchors.fill:parent
            onClicked:{
                    plasmoid.togglePopup();


                }

          }


          }//item toolbuttonappcontainer
          Item
          {


         anchors
           {
                    left:toolbuttonappcontainer.right
                    leftMargin :textAlign
                    verticalCenter: parent.verticalCenter
               }
         Text
         {

             id:allappstext
             font.family:textFont
             text: "TÜM\nUYGULAMALAR"
             verticalAlignment: Text.AlignVCenter

        color: "#ffffff"
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
         MouseArea{
             anchors.fill: parent


             onClicked:{
                 plasmoid.togglePopup();
                 //toggleAllAppsVision(); //TODO figure out popup is opened or not and then toggle with global function

             }
         }
          }//item labelcontainer


         }//Row


    }





    }//main column


    PlasmaCore.DataSource {
            id: dataSource
            engine: "time"
            connectedSources: ["Local"]
            interval: 500
    }
    PlasmaCore.DataSource {
            id: userDataSource
            engine: "userinfo"
            connectedSources: ["Local"]
            interval: 500
    }





}//Item panelside
  

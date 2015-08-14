import QtQuick 1.1

Rectangle {
    id:pop
    color:"#34353a"
    Column
    {
       Item
       {
         height: pop.height/2
         width: minimumWidth
         Rectangle{
            id:circle1
            height: lineAlign/2
            width: lineAlign/2
            color: "#ffffff"
            radius: lineAlign/4

            anchors
            {
              left:parent.left
              leftMargin:lineAlign
              verticalCenter:parent.verticalCenter
            }
         }

         Text {
             id: guideline
             text: "KULLANIM KLAVUZU"
             font.bold: true
             verticalAlignment: Text.AlignVCenter
             color: "#ffffff"
             anchors
             {
                left: circle1.right
                leftMargin: lineAlign/2
                verticalCenter:parent.verticalCenter
             }
         }
         MouseArea{
              anchors.fill: parent
              onPressAndHold: { guideline.color= "#FF6C00"; }
              onPressed: {guideline.color= "#FF6C00"; }
              onReleased:
                {
                  //plasmoid.runCommand("konsole");
                  guideline.color= "#ffffff";
                  root.state = 'invisible';
                  yardim.color= "#ffffff";
                }
         }
       }//kullanım klavuzu

       Item
       {
           height: pop.height/2
           width: minimumWidth
           Rectangle{
              id:circle2
              height: lineAlign/2
              width: lineAlign/2
              color: "#ffffff"
              radius: lineAlign/4

              anchors
              {
                left:parent.left
                leftMargin:lineAlign
                verticalCenter:parent.verticalCenter
              }
           }
           Text {
               id: helpmsg
               text: "YARDIM MESAJI"
               font.bold: true
               verticalAlignment: Text.AlignVCenter
               color: "#ffffff"
               anchors
               {
                  left: circle2.right
                  leftMargin: lineAlign/2
                  verticalCenter:parent.verticalCenter
               }
           }
           MouseArea{
                anchors.fill: parent
                onPressAndHold: { helpmsg.color= "#FF6C00"; }
                onPressed: {helpmsg.color= "#FF6C00"; }
                onReleased:
                    {
                        plasmoid.runCommand("/usr/bin/etahelp");
                        helpmsg.color= "#ffffff";
                        root.state = 'invisible';
                        yardim.color= "#ffffff";
                    }
           }
       }// yardım mesajı
    }
    Rectangle
    {
        id:verticalLine
        color:"#ffffff"
        width:1
        x: circle1.x+circle1.radius-width
        y: circle1.y+circle1.radius
        height: pop.height -(pop.y-circle1.y) - kapat.height
    }
}


import QtQuick 1.1
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.qtextracomponents 0.1 as QtExtraComponents
import org.kde.draganddrop 1.0
import org.kde.plasma.graphicswidgets 0.1 as PlasmaWidgets

Rectangle
{
    id:root        
    color:"#ffffff"
    
      
      Item{
	      id:iconContainer
	      height:parent.height
	      
	      
	      PlasmaWidgets.IconWidget
	      {
		  id:peachIcon
		  icon: QIcon("peach")
		  preferredIconSize: "48x48"
		  minimumIconSize: "32x32"
		  drawBackground: false
		  anchors
		  {
		    left:parent.left
		    leftMargin: root.width*9/100
		  }
		  onClicked:
		  {
		    peachhybrid.fakekey();
		    
		  }
	      }
	    } 
	  
	    Item
	    {
	      height:parent.height
	      width: parent.width - iconContainer.width
	      Text
	      {
		  text:"AÇIK PENCERELER"
		  color: "#FF6C00"
		  font.bold : true
		  font.pointSize: 8.5
		  anchors
		  {
		    left:parent.left
		    leftMargin: root.width*9/100 + peachIcon.width + root.width*7/100
		    verticalCenter:parent.verticalCenter
		  }
	      
	      }
	    }
	          
       
}
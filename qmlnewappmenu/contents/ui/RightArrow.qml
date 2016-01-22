import QtQuick 1.1
import org.kde.plasma.core 0.1 as PlasmaCore

Item {
	id: arrow

	property int size: 16 // theme.smallIconSize

	width: arrow.size
	height: arrow.size

	PlasmaCore.SvgItem {
		svg: arrowSvg
		elementId: "right-arrow"
		anchors.fill: parent
	}
	PlasmaCore.Svg {
		id: arrowSvg
		imagePath: "widgets/arrows"

	}    
}

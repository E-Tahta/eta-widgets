import QtQuick 1.1
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents

FocusScope {
	id: search
	height: searchTextField.height
    focus : true
	property alias text: searchTextField.text
	property variant searchMenu
	property variant dataSource
//	property variant model: searchModel

	signal textChanged()
	signal textEmptied()

	Component.onCompleted: searchMenu.model = searchModel;

	PlasmaCore.SortFilterModel {
		id: searchModel
		filterRole: "name"
		filterRegExp: searchTextField.text.length > 1 ? ".*" + searchTextField.text + ".*" : "zzz" // assume nobody has an app named like this
		sortRole: "name" // this should be here and not in the SortFilterModel below because otherwise empty items appear in the search menu
		sortOrder: Qt.AscendingOrder
		sourceModel: PlasmaCore.SortFilterModel {
			filterRole: "display"
			filterRegExp: "true"
			sourceModel: PlasmaCore.DataModel {
				id: searchDataModel
				// hack to make the plasmoid load faster: we set dataSource when the user searches for the first time instead of at startup
                //dataSource: appsSource // assume appsSource.connectedSources == appsSource.sources
			}
		}
	}

	PlasmaComponents.TextField {
		id: searchTextField
		anchors.top: parent.top
		anchors.left: parent.left
		anchors.right: parent.right
        height: 35
		focus: true
		clearButtonShown: true
        placeholderText: "Uygulamalarda ara..."
		onTextChanged: {
			// hack to make the plasmoid load faster: we set SearchMenuDataModel.dataSource when the user searches for the first time instead of at startup
			if (searchDataModel.dataSource == undefined)
				searchDataModel.dataSource = dataSource; // assume appsSource.connectedSources == appsSource.sources
			if (searchMenu.currentIndex < 0 || searchMenu.currentIndex >= searchMenu.count)
				searchMenu.currentIndex = 0;			
			search.textChanged();
		}
	}
}

project(eta-widgets)
 
find_package(KDE4 REQUIRED)
 
include(KDE4Defaults)

add_subdirectory(peach-hwidget)
 
install(DIRECTORY icons/
        DESTINATION ${CMAKE_INSTALL_PREFIX}/share/eta/eta-widgets/icons)

install(DIRECTORY panel-bottom-widget/ 
        DESTINATION ${CMAKE_INSTALL_PREFIX}/share/kde4/apps/plasma/plasmoids/panelbottomwidget)
 
install(FILES panel-bottom-widget/metadata.desktop
        DESTINATION ${CMAKE_INSTALL_PREFIX}/share/kde4/services/ RENAME plasma-applet-panelbottomwidget.desktop)
        
install(DIRECTORY panel-top-quick-widget/
        DESTINATION ${CMAKE_INSTALL_PREFIX}/share/kde4/apps/plasma/plasmoids/paneltopquickwidget)
 
install(FILES panel-top-quick-widget/metadata.desktop
        DESTINATION ${CMAKE_INSTALL_PREFIX}/share/kde4/services/ RENAME plasma-applet-paneltopquickwidget.desktop)
        
install(DIRECTORY panel-top-widget/
        DESTINATION ${CMAKE_INSTALL_PREFIX}/share/kde4/apps/plasma/plasmoids/paneltopwidget)
 
install(FILES panel-top-widget/metadata.desktop
        DESTINATION ${CMAKE_INSTALL_PREFIX}/share/kde4/services/ RENAME plasma-applet-paneltopwidget.desktop)
        
install(DIRECTORY search-widget/
        DESTINATION ${CMAKE_INSTALL_PREFIX}/share/kde4/apps/plasma/plasmoids/searchplasmoid)
 
install(FILES search-widget/metadata.desktop
        DESTINATION ${CMAKE_INSTALL_PREFIX}/share/kde4/services/ RENAME plasma-applet-searchplasmoid.desktop)

        

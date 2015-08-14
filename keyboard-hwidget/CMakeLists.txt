project(plasma-keyboardclient)

find_package(KDE4 REQUIRED)
include(KDE4Defaults)
 
add_definitions (${QT_DEFINITIONS} ${KDE4_DEFINITIONS})
include_directories(
   ${CMAKE_SOURCE_DIR}
   ${CMAKE_BINARY_DIR}
   ${KDE4_INCLUDES}
   )
 
set(keyboardclient_SRCS
    
    keyboardclient.cpp)


kde4_add_plugin(plasma_applet_keyboardclient ${keyboardclient_SRCS})
target_link_libraries(plasma_applet_keyboardclient
                      ${KDE4_KIO_LIBS}
                      ${KDE4_PLASMA_LIBS}
                      ${KDE4_KCMUTILS_LIBRARY}
                      ${KACTIVITIES_LIBRARY}
                      ${QT_QTDECLARATIVE_LIBRARY}
                      ${X11_XTest_LIB} 
                      ${X11_X11_LIB} 
                      ${X11_LIBS} )
                      
MACRO(installPackage dir component)
   SET(root ${ARGN})
   IF(NOT root)
      SET(root plasma/plasmoids)
   ENDIF(NOT root)
   install(DIRECTORY ${dir}/ DESTINATION ${DATA_INSTALL_DIR}/${root}/${component} PATTERN Messages.sh EXCLUDE PATTERN CMakeLists.txt EXCLUDE)
   install(FILES ${dir}/metadata.desktop DESTINATION ${SERVICES_INSTALL_DIR} RENAME plasma-applet-${component}.desktop)
ENDMACRO(installPackage)

install(TARGETS plasma_applet_keyboardclient DESTINATION ${PLUGIN_INSTALL_DIR})
install(FILES plasma-keyboardclient-default.desktop DESTINATION ${SERVICES_INSTALL_DIR})
install(DIRECTORY package/ DESTINATION ${DATA_INSTALL_DIR}/plasma/packages/org.kde.keyboardclient)

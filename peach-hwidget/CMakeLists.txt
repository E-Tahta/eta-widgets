project(plasma-peachhybrid)

find_package(KDE4 REQUIRED)
include(KDE4Defaults)

add_definitions (${QT_DEFINITIONS} ${KDE4_DEFINITIONS})
include_directories(
   ${CMAKE_SOURCE_DIR}
   ${CMAKE_BINARY_DIR}
   ${KDE4_INCLUDES}
   )
 
set(peachhybrid_SRCS
    
    peachhybrid.cpp)


kde4_add_plugin(plasma_applet_peachhybrid ${peachhybrid_SRCS})
target_link_libraries(plasma_applet_peachhybrid
                      ${KDE4_KIO_LIBS}
                      ${KDE4_PLASMA_LIBS}
                      ${KDE4_KCMUTILS_LIBRARY}
                      ${KACTIVITIES_LIBRARY}
                      ${QT_QTDECLARATIVE_LIBRARY}
                      ${X11_XTest_LIB} 
                      ${X11_X11_LIB} 
                      ${X11_LIBS} )

                      

install(TARGETS plasma_applet_peachhybrid DESTINATION ${CMAKE_INSTALL_PREFIX}/lib/kde4/)
install(FILES plasma-peachhybrid-default.desktop DESTINATION ${CMAKE_INSTALL_PREFIX}/share/kde4/services/)
install(DIRECTORY package/ DESTINATION ${CMAKE_INSTALL_PREFIX}/share/kde4/apps/plasma/packages/org.kde.peachhybrid)

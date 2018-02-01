QT -= gui

CONFIG += console
CONFIG -= app_bundle

#CONFIG -= qt
#设置console就会从shell启动
#CONFIG += console c++11
CONFIG += c++14


#使Release版本可调试
QMAKE_CXXFLAGS_RELEASE = $$QMAKE_CFLAGS_RELEASE_WITH_DEBUGINFO
QMAKE_LFLAGS_RELEASE = $$QMAKE_LFLAGS_RELEASE_WITH_DEBUGINFO

#define platform variable for folder name
win32 {contains(QMAKE_TARGET.arch, x86_64) {PLATFORM = x64} else {PLATFORM = Win32}}
macx {PLATFORM = macx}
unix:!macx:!android {PLATFORM = linux}

#define configuration variable for folder name
CONFIG(debug, debug|release) {CONFIGURATION = Debug} else {CONFIGURATION = Release}


DESTDIR = ../_bin/$$TARGET/$$CONFIGURATION/$$PLATFORM
OBJECTS_DIR = ../_intermediate/$$TARGET/$$CONFIGURATION/$$PLATFORM
MOC_DIR = ../_intermediate/$$TARGET/$$CONFIGURATION/$$PLATFORM
RCC_DIR = ../_intermediate/$$TARGET/$$CONFIGURATION/$$PLATFORM
UI_DIR = ../_intermediate/$$TARGET/$$CONFIGURATION/$$PLATFORM

HEADERS     += $$files(*.h,true)
SOURCES     += $$files(*.cpp,true)
SOURCES     += $$files(*.cc,true)
FORMS       += $$files(*.ui,true)
RESOURCES   += $$files(*.qrc,true)
OTHER_FILES += $$files(*,true)

# exclude plugin templates
#HEADERS     -= media/plugin_development/_template/NAME.h
#SOURCES     -= media/plugin_development/_template/NAME.cpp
#SOURCES     -= media/plugin_development/_template/plugin.cpp


#RC_FILE = res/icon.rc

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked as deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

win32: {
    #CONFIG(release, debug|release): LIBS += -L$$PWD/../_bin/$$CONFIGURATION/$$PLATFORM -lIPL
    #else:CONFIG(debug, debug|release): LIBS += -L$$PWD/../_bin/$$CONFIGURATION/$$PLATFORM -lIPL
    DESTDIR = ..\\_bin\\$$TARGET\\$$CONFIGURATION\\$$PLATFORM


    LIBS += Kernel32.lib

    #清理目标目录
    QMAKE_POST_LINK +=  rmdir /s/q  .\\$$DESTDIR\\config & \

    #在release时才会执行windeployqt
    #CONFIG(release, debug|release): QMAKE_POST_LINK +=  windeployqt.exe --no-angle --no-svg --no-system-d3d-compiler --no-quick-import --no-translations $$DESTDIR\\$$TARGET.exe & \
    #else:CONFIG(debug, debug|release):{
    #LIBS += -L$$PWD/../_bin/$$CONFIGURATION/$$PLATFORM -lIPL
    QMAKE_POST_LINK +=  windeployqt.exe --no-angle --no-svg --no-system-d3d-compiler --no-quick-import --no-translations $$DESTDIR\\$$TARGET.exe & \

    QMAKE_POST_LINK +=  $${QMAKE_COPY_DIR} ..\\_lib\\windows\\$$TARGET\\$$CONFIGURATION $$DESTDIR & \
                        #$${QMAKE_COPY_DIR} ..\\_lib\\windows\\wxwidget\\$$CONFIGURATION $$DESTDIR & \
                        $${QMAKE_COPY_DIR} media\\lua $$DESTDIR\\lua & \
                        $${QMAKE_COPY_DIR} media\\config $$DESTDIR\\config\\ & \
#                        $${QMAKE_COPY_DIR} media\\process_icons ..\\_bin\\$$CONFIGURATION\\$$PLATFORM\\process_icons\\ & \
#                        $${QMAKE_COPY_DIR} media\\examples ..\\_bin\\$$CONFIGURATION\\$$PLATFORM\\examples\\ & \
#                        $${QMAKE_COPY_DIR} media\\examples\images ..\\_bin\\$$CONFIGURATION\\$$PLATFORM\\examples\\images\\ & \
#                        $${QMAKE_COPY_DIR} media\\plugin_development ..\\_bin\\$$CONFIGURATION\\$$PLATFORM\\plugin_development & \
#                        $${QMAKE_COPY_DIR} ..\\IPL\\include ..\\_bin\\$$CONFIGURATION\\$$PLATFORM\\plugin_development\\_lib\\include & \
#                        del ..\\_bin\\$$CONFIGURATION\\$$PLATFORM\\IPL.exp & \
#                        del ..\\_bin\\$$CONFIGURATION\\$$PLATFORM\\IPL.lib & \

}

linux: {

}


msvc {
    #QMAKE_CXXFLAGS_RELEASE -= -O1
    #QMAKE_CXXFLAGS_RELEASE -= -O2
    #QMAKE_CXXFLAGS_RELEASE *= -O3
}

clang {
    #CONFIG +=c++14
}

gcc:!clang {
    #CONFIG +=c++14
    #LIBS += -lgomp
}

#加入通用lib支持


INCLUDEPATH += $$PWD/include/


message("Defines:")
message($$DEFINES)


# Visual Leak Detector
#win32: LIBS += -L"C:/Program Files (x86)/Visual Leak Detector/lib/Win32/" -lvld

#INCLUDEPATH += "C:/Program Files (x86)/Visual Leak Detector/include/"
#DEPENDPATH += "C:/Program Files (x86)/Visual Leak Detector/include/"


#INCLUDEPATH += $$PWD/../_bin/Release/macx
#DEPENDPATH += $$PWD/../_bin/Release/macx


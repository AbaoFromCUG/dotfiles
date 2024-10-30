pragma ComponentBehavior: Bound
import QtQuick.Controls.impl
import QtQml
import QtQuick
import QtQuick.Layouts
import Quickshell
import QtQuick.Controls
import Quickshell.Wayland

import ".."
import "../model"

Window {
    id: powerMenu
    width: 800
    height: 500
    color: "transparent"
    // visible: false
    flags: Qt.Popup

    Rectangle {
        anchors.fill: parent
        radius: 26
        border {
            width: 1
            // color: Style.secondaryBg
        }

        // color: Style.bg

        property var modelData
        Connections {
            target: EventCenter
            function onPowerMenuShow(screen) {
                powerMenu.x = screen.x + screen.width / 2 - powerMenu.width / 2;
                powerMenu.y = screen.y + screen.height / 2 - powerMenu.height / 2;
                console.log(screen.x, screen.width);
                if (powerMenu.visible) {
                    powerMenu.close();
                } else {
                    powerMenu.show();
                }
            }
        }

        GridLayout {
            anchors.centerIn: parent

            width: parent.width * 0.75
            height: parent.height * 0.75

            columns: 3
            columnSpacing: 0
            rowSpacing: 0

            Repeater {
                model: Option.systemActions
                delegate: Rectangle {
                    required property ActionModel modelData

                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    // color: ma.containsMouse ? Style.secondaryBg : Style.bg
                    border.color: "black"
                    border.width: ma.containsMouse ? 0 : 1

                    MouseArea {
                        id: ma
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: modelData.exec()
                    }

                    IconImage {
                        id: icon
                        anchors.centerIn: parent
                        source: Quickshell.iconPath(modelData.icon)
                        // color: Style.fg
                        width: parent.width * 0.25
                        height: parent.width * 0.25
                    }

                    Text {
                        anchors {
                            top: icon.bottom
                            topMargin: 20
                            horizontalCenter: parent.horizontalCenter
                        }

                        text: modelData.text
                        font.pointSize: 20
                        color: "white"
                    }
                }
            }
        }
    }
}

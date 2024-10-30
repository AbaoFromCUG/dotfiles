pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import Quickshell.Services.UPower
import Quickshell

import "../"

Scope {
    id: bar

    property string time: ""

    Variants {
        model: Quickshell.screens

        delegate: Component {
            PanelWindow {
                property var modelData
                height: Config.bar.height

                screen: modelData
                color: Config.bar.bg

                anchors {
                    left: true
                    top: true
                    right: true
                }

                BarItem {
                    anchors.centerIn: parent
                    height: parent.height
                    contentItem: DateTimeLabel {}

                    onClicked: function () {
                        EventCenter.dateMenuShow(mapToGlobal(width / 2, y + height));
                    }
                }

                Row {
                    height: parent.height
                    anchors.right: parent.right

                    Loader {
                        active: UPower.displayDevice
                        height: parent.height
                        sourceComponent: Component {
                            BatteryButton {}
                        }
                    }
                    BarItem {
                        height: parent.height
                        icon.source: Quickshell.iconPath("system-shutdown-symbolic")
                        icon.color: Qt.rgba(229 / 256, 95 / 256, 134 / 256, 0.7)
                        onClicked: function () {
                            EventCenter.powerMenuShow(modelData);
                        }
                    }
                }
            }
        }
    }
}

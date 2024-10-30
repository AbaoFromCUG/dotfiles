pragma Singleton
import "./model"
import QtQuick

QtObject {
    readonly property QtObject bar: QtObject {
        property bool transparent: false
    }

    readonly property list<ActionModel> systemActions: [
        // sleep: 'weather-clear-night-symbolic',
        // reboot: 'system-reboot-symbolic',
        // logout: 'system-log-out-symbolic',
        // shutdown: 'system-shutdown-symbolic'
        ActionModel {
            command: "loginctl lock-session"
            keybind: Qt.Key_K
            text: "Lock"
            icon: "lock-symbolic"
        },
        ActionModel {
            command: "loginctl terminate-user $USER"
            keybind: Qt.Key_E
            text: "Logout"
            icon: "logout-symbolic"
        },
        ActionModel {
            command: "systemctl suspend"
            keybind: Qt.Key_U
            text: "Suspend"
            icon: "system-suspend-symbolic"
        },
        ActionModel {
            command: "systemctl hibernate"
            keybind: Qt.Key_H
            text: "Hibernate"
            icon: "weather-clear-night-symbolic"
        },
        ActionModel {
            command: "systemctl poweroff"
            keybind: Qt.Key_K
            text: "Shutdown"
            icon: "system-shutdown-symbolic"
        },
        ActionModel {
            command: "systemctl reboot"
            keybind: Qt.Key_R
            text: "Reboot"
            icon: "system-reboot-symbolic"
        }
    ]
    readonly property QtObject theme: QtObject {
        property QtObject dark
        property bool shadows: true
        property int padding: 7
        property int spacing: 12
        property int blur: 0
        property string scheme: 'dark'
        property QtObject widget
        property QtObject light
        property QtObject border
        property int radius: 11
        readonly property font font: ({
                "family": "FiraCode Nerd Font",
                "pointSize": 13
            })

        border: QtObject {
            property int width: 1
            property int opacity: 96
        }

        dark: QtObject {
            readonly property QtObject text: QtObject {
                property color normal: "#eeeeee"
                property color primary: "#141414"
                property color secondary: "#eeeeee"
                property color error: "#e55f86"
            }

            readonly property QtObject battery: QtObject {
                property color bg: "#e6e6e6"
                property color charging: '#00D787'
                property color discharging: '#51a4e7'
            }

            readonly property QtObject background: QtObject {
                property color normal: '#171717'
                property color primary: '#51a4e7'
                property color secondary: Qt.rgba(238, 238, 238, 0.154)
            }

            property QtObject primary
            property QtObject error
            property color bg: '#171717'
            property color fg: '#eeeeee'
            property color widget: '#eeeeee'
            property color border: '#eeeeee'

            primary: QtObject {
                property color bg: '#51a4e7'
                property color fg: '#141414'
            }

            error: QtObject {
                property color bg: '#e55f86'
                property color fg: '#141414'
            }
        }

        widget: QtObject {
            property int opacity: 94
        }
    }
}

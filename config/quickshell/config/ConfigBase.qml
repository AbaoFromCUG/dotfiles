import "../library"
import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import Quickshell
import Quickshell.Services.Mpris
import Quickshell.Services.Pipewire

Singleton {
    id: root

    required property ColorConfig colors
    property QtObject battery
    property QtObject network
    property QtObject button
    property ControlConfig widget
    property QtObject bar
    property QtObject greeter
    property ControlConfig input
    property ProgressConfig progress
    property ControlConfig barItem

    progress: ProgressConfig {}

    component ProgressConfig: QtObject {
        property color bg: Qt.alpha(root.colors.primaryBg, 0.8)
        property color fg: root.colors.primaryFg
    }

    component ControlConfig: QtObject {
        property color bg
        property color activeBg
        property int radius
        property int borderWidth
        property color borderColor
        property int activeBorderWidth
        property color activeBorderColor
    }

    barItem: ControlConfig {
        bg: "transparent"
        activeBg: root.colors.primaryHoverBg
        radius: root.widget.radius
    }

    input: ControlConfig {
        borderWidth: 1
        borderColor: root.colors.primaryHoverBg
        activeBorderWidth: 1
        activeBorderColor: root.colors.primaryHoverBg
    }

    component ColorConfig: QtObject {
        property color primaryBg
        property color secondaryBg
        property color primaryHoverBg
        property color primaryFg
        property color secondaryFg
        property color happy
        property color error
        property color warn
    }

    component BorderConfig: QtObject {
        property int width
        property color color
    }

    component BatteryConfig: QtObject {
        property int percent
        required property url chargingIcon
        required property url dischargingIcon
        property color chargingColor
        property color dischargingColor
    }

    greeter: QtObject {
        property color time: "white"
        property url background: Qt.url("../../../../Pictures/wallpapers/nature-3058859.jpg")
    }

    network: QtObject {
        property string device: "wlp0s20f3"
    }

    bar: QtObject {
        property int height: 30
        property color bg: Qt.alpha(root.colors.primaryBg, 0.3)
    }

    widget: ControlConfig {
        property int borderWidth: 2
        property color borderColor: root.colors.primaryFg
        property int activeBorderWidth: 2
        property color activeBorderColor: root.colors.happy
        property color textColor: root.colors.primaryFg

        bg: root.colors.primaryBg
        activeBg: root.colors.primaryHoverBg
        radius: 8
    }

    button: QtObject {
        property color bg: Qt.alpha(root.colors.secondaryBg, 0.2)
        property color hoverBg: Qt.alpha(root.colors.primaryHoverBg, 0.4)
        property int radius: root.widget.radius
        property int borderWidth: root.widget.borderWidth
    }

    battery: QtObject {
        property list<BatteryConfig> intervals
        property BatteryConfig full

        intervals: [
            BatteryConfig {
                percent: 20
                chargingIcon: Quickshell.iconPath("battery-020-charging")
                dischargingIcon: Quickshell.iconPath("battery-020")
                chargingColor: root.colors.happy
                dischargingColor: root.colors.error
            },
            BatteryConfig {
                percent: 50
                chargingIcon: Quickshell.iconPath("battery-050-charging")
                dischargingIcon: Quickshell.iconPath("battery-050")
                chargingColor: root.colors.happy
                dischargingColor: root.colors.error
            },
            BatteryConfig {
                percent: 80
                chargingIcon: Quickshell.iconPath("battery-080-charging")
                dischargingIcon: Quickshell.iconPath("battery-080")
                chargingColor: root.colors.happy
                dischargingColor: root.colors.error
            },
            BatteryConfig {
                percent: 100
                chargingIcon: Quickshell.iconPath("battery-100-charging")
                dischargingIcon: Quickshell.iconPath("battery-100")
                chargingColor: root.colors.happy
                dischargingColor: root.colors.error
            }
        ]

        full: BatteryConfig {
            chargingIcon: Quickshell.iconPath("battery-full-charging")
            dischargingIcon: Quickshell.iconPath("battery-full")
            chargingColor: root.colors.happy
            dischargingColor: root.colors.error
        }
    }
}

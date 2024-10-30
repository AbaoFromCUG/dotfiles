pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import Quickshell.Services.UPower
import QtQuick.Controls.impl
import Quickshell

import ".."
import "../config"

BarItem {
    id: button
    text: "Hello"
    property bool showPercentage: false
    property UPowerDevice device: UPower.displayDevice
    onClicked: function () {
        showPercentage = !showPercentage;
    }
    contentItem: Row {
        spacing: 4
        IconImage {
            anchors.verticalCenter: parent.verticalCenter
            source: {
                const percent = device.percentage * 100;
                const state = device.state;
                // const percent = 5;
                // const state = UPowerDeviceState.Discharging;
                let config;
                if (state === UPowerDeviceState.FullyCharged) {
                    config = Config.battery.full;
                }
                const items = [...Config.battery.intervals].sort(function (a, b) {
                    return b.percent - a.percent;
                });
                for (let i = 0; i < items.length; i++) {
                    console.log(items[i].percent, percent);
                    if (items[i].percent < percent) {
                        config = items[i] ?? percent[i - 1];
                        break;
                    }
                }
                config = config ?? items[items.length - 1];
                return state === UPowerDeviceState.Discharging ? config.dischargingIcon : config.chargingIcon;
            }
            width: 30
        }
        Text {
            visible: button.showPercentage
            text: `${Math.floor(button.device.percentage * 100)}%`
            anchors.verticalCenter: parent.verticalCenter
            color: Config.colors.primaryFg
            font {
                pointSize: 14
                bold: true
            }
        }
    }
}

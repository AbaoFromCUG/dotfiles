pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Services.SystemTray

Row {
    anchors.verticalCenter: parent.verticalCenter

    Repeater {
        model: SystemTray.items
        PushButton {
            required property string modelData
            // text: modelData.title
            text: JSON.stringify(modelData)
            Component.onCompleted: {
                // console.log(SystemTray.items)
                // console.log(SystemTray.items[0])
                // console.log(typeof modelData)
                // console.log(JSON.stringify(modelData))
            }
            // icon.source: modelData.icon
            // icon.color: Qt.rgba(229 / 256, 95 / 256, 134 / 256, 0.7)
        }
    }
}

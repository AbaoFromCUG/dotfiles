import ".."
import QtQuick
import QtQuick.Controls.Fusion
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

Label {
    id: control

    property string format: "hh:mm AP"
    property int interval: 1000

    color: Config.colors.primaryFg
    // color: "#a0e0ffff"
    // The native font renderer tends to look nicer at large sizes.
    renderType: Text.NativeRendering

    // updates the clock every second
    Timer {
        running: true
        repeat: true
        interval: control.interval
        triggeredOnStart: true
        onTriggered: {
            let date = new Date();
            control.text = date.toLocaleTimeString(Qt.locale(), control.format);
        }
    }
}

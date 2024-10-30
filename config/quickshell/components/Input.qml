import ".."
import QtQuick
import QtQuick.Controls.Fusion
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

TextField {
    // width: control.activeFocus?: 0: co

    id: control

    background: Rectangle {
        // color: control.activeFocus ? "white" : "black"
        radius: Config.widget.radius

        border {
            width: control.activeFocus ? Config.input.activeBorderWidth : Config.input.borderWidth
            color: control.activeFocus ? Config.input.activeBorderColor : Config.input.borderColor
        }
    }
}

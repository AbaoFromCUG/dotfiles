pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Controls.impl
import Quickshell
import ".."

Button {
    id: control

    highlighted: true
    hoverEnabled: true

    font {
        pointSize: 14
        bold: true
    }

    contentItem: IconLabel {
        spacing: control.spacing
        mirrored: control.mirrored
        display: control.display

        icon: control.icon
        text: control.text
        font: control.font
        color: Config.colors.primaryFg
    }

    background: Rectangle {
        color: control.hovered ? Config.button.hoverBg : Config.button.bg
        radius: Config.button.radius
        border {
            width: Config.button.borderWidth
        }
    }
}

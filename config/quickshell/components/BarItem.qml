import ".."
import QtQuick
import QtQuick.Controls
import QtQuick.Controls.impl

Button {
    // color: mouseArea.containsMouse ? Config.barItem.hoverBg : Config.barItem.bg

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
        color: control.hovered ? Config.barItem.activeBg : Config.barItem.bg
        radius: Config.barItem.radius
    }
}

import ".."
import QtQuick
import QtQuick.Controls

ProgressBar {
    // color:

    id: control

    height: 12
    from: 0
    to: 1

    background: Rectangle {
        implicitWidth: 200
        implicitHeight: 6
        color: Config.progress.bg
        radius: parent.height / 2
    }

    contentItem: Item {
        height: parent.height

        Rectangle {
            color: Config.progress.fg
            radius: parent.height / 2
            width: control.visualPosition * parent.width
            height: parent.height
        }
    }
}

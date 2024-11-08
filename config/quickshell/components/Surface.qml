import ".."
import "../components/"
import QtQuick
import QtQuick.Controls.Fusion
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Greetd
import Quickshell.Wayland

Rectangle {
    id: root

    Image {
        source: Config.greeter.background
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
    }

    DateTimeLabel {
        font.bold: true
        font.pointSize: 80
        format: "hh:mm"
        color: Config.greeter.time

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: 100
        }
    }
}

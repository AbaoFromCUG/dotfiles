import "./greeter/"
import "./lock/"
import QtQuick
import Quickshell

ShellRoot {
    LockContext {
        id: context

        onUnlocked: {
            Qt.quit();
        }
    }

    FloatingWindow {
        LockSurface {
            anchors.fill: parent
            context: context
        }

    }

    // exit the example if the window closes
    Connections {
        function onLastWindowClosed() {
            Qt.quit();
        }

        target: Quickshell
    }

}

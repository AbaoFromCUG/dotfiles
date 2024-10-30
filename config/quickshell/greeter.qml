import "./greeter/"
import Quickshell
import Quickshell.Wayland

ShellRoot {
    GreeterContext {
        id: greeterContext
    }

    WlSessionLock {
        id: lock

        // Lock the session immediately when quickshell starts.
        locked: true

        WlSessionLockSurface {
            GreeterSurface {
                anchors.fill: parent
                context: greeterContext
            }
        }
    }
}

import "./lock"
import Quickshell
import Quickshell.Wayland

ShellRoot {
    LockContext {
        id: lockContext

        onUnlocked: {
            lock.locked = false;
            Qt.quit();
        }
    }

    WlSessionLock {
        id: lock

        // Lock the session immediately when quickshell starts.
        locked: true

        WlSessionLockSurface {
            LockSurface {
                anchors.fill: parent
                context: lockContext
            }

        }

    }

}

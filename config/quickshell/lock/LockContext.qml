import QtQuick
import Quickshell
import Quickshell.Services.Pam

Scope {
    id: root

    property string password
    property bool showFailure: false
    property alias pamActive: pam.active
    property alias pamConfig: pam.config
    property alias pamMessage: pam.message
    property alias pamUser: pam.user
    property bool unlockInProgress: false

    signal unlocked

    function tryUnlock() {
        console.log("tryUnlock: ", root.password);
        if (root.password === "")
            return;

        root.unlockInProgress = true;
        pam.start();
    }

    PamContext {
        id: pam

        // configDirectory: "../pam"
        // config: "unlock.conf"
        onCompleted: result => {
            console.log("completed: ", result);
            if (result === PamResult.Success) {
                root.unlocked();
            } else {
                root.password = "";
                root.showFailure = true;
            }
            root.unlockInProgress = false;
        }
        onPamMessage: () => {
            console.log("onPamMessage: ", this.responseRequired, root.password)
            if (this.responseRequired) {
                console.log(root.password);
                this.respond(root.password);
            }
        }
    }
}

import QtQuick
import Quickshell
import Quickshell.Services.Greetd
import Quickshell.Services.Pam

Scope {
    id: root

    property int state: Greetd.state
    property string password

    function tryToLock(user) {
        Greetd.createSession(user);
    }

    function tryToAuth(password) {
        Greetd.respond(password);
    }

    Connections {
        function onAuthMessage(message: string, error: bool, responseRequired: bool, echoResponse: bool) {
            console.log(message, error, responseRequired, echoResponse);
        }

        function onReadyToLaunch() {
            Greetd.launch(["Hyprland"]);
        }

        function onLaunched() {
            Qt.exit(0);
        }

        target: Greetd
    }
}

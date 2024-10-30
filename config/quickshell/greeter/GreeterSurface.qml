import ".."
import "../components/"
import QtQuick
import QtQuick.Controls.Fusion
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Greetd
import Quickshell.Wayland

Surface {
    id: root

    required property GreeterContext context

    ColumnLayout {
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.verticalCenter
        }

        RowLayout {
            visible: root.context.state === GreetdState.Inactive

            Input {
                id: userBox

                implicitWidth: 400
                padding: 10
                focus: true
                inputMethodHints: Qt.ImhSensitiveData
            }

            PushButton {
                text: "->"
                padding: 10
                onClicked: root.context.tryToLock(userBox.text)
            }
        }

        RowLayout {
            visible: root.context.state === GreetdState.Authenticating

            Input {
                id: passwordBox

                implicitWidth: 400
                echoMode: TextInput.Password
                padding: 10
                focus: true
                inputMethodHints: Qt.ImhSensitiveData
            }

            PushButton {
                text: "Login"
                padding: 10
                onClicked: root.context.tryToAuth(passwordBox.text)
            }
        }
    }
}

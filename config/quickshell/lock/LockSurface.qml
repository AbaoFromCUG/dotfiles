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

    required property LockContext context

    ColumnLayout {
        anchors.centerIn: parent

        RowLayout {
            Input {
                // onTextChange

                id: passwordBox

                implicitWidth: 400
                echoMode: TextInput.Password
                padding: 10
                focus: true
                inputMethodHints: Qt.ImhSensitiveData
                // Update the text in the context when the text in the box changes.
                onTextChanged: root.context.password = this.text
                // Try to unlock when enter is pressed.
                onAccepted: root.context.tryUnlock()

                Connections {
                    function onPasswordChanged() {
                        passwordBox.text = root.context.password;
                    }

                    target: root.context
                }
            }

            PushButton {
                text: "Unlock"
                padding: 10
                onClicked: root.context.tryUnlock()
            }
        }

        Label {
            color: Config.colors.error
            visible: root.context.showFailure
            text: "Incorrect password"
        }
    }
}

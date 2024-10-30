pragma ComponentBehavior: Bound
import QtQml
import QtQuick
import QtQuick.Layouts
import Quickshell
import QtQuick.Controls
import "../"

Window {
    id: dateMenu
    flags: Qt.Popup
    width: 800
    height: 500
    color: "transparent"
    Rectangle {
        anchors.fill: parent
        radius: 26
        border {
            width: 1
            // color: Style.secondaryBg
        }

        // color: Style.bg

        property var modelData
        Connections {
            target: EventCenter
            function onDateMenuShow(p) {
                console.log(p);
                dateMenu.x = p.x - dateMenu.width / 2;
                dateMenu.y = p.y;
                dateMenu.show();
            }
        }
        Item {

            height: parent.height
            width: parent.width / 2
        }

        Item {
            anchors.right: parent.right
            height: parent.height
            width: parent.width / 2
            GridLayout {
                id: dateGrid
                columns: 2
                anchors.centerIn: parent

                DayOfWeekRow {
                    locale: monthGrid.locale

                    Layout.column: 1
                    Layout.fillWidth: true

                    delegate: Text {
                        text: shortName
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter

                        // color: Style.secondaryFg
                        required property string shortName
                    }
                }

                WeekNumberColumn {
                    month: monthGrid.month
                    year: monthGrid.year
                    locale: monthGrid.locale

                    Layout.fillHeight: true

                    delegate: Text {
                        text: weekNumber
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter

                        // color: Style.secondaryFg
                        required property int weekNumber
                    }
                }

                MonthGrid {
                    id: monthGrid

                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    delegate: Rectangle {
                        required property var model
                        // color: model.today ? Style.secondaryBg : Style.bg
                        // radius: Style.radius
                        Text {
                            anchors.centerIn: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            opacity: model.month === monthGrid.month ? 1 : 0
                            text: monthGrid.locale.toString(model.date, "d")
                            // color: model.today ? Style.primaryFg : Style.secondaryFg
                            font.bold: model.today
                        }
                    }
                }
            }
        }
    }
}

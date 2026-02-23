import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects   // <--- legacy shadow support

ApplicationWindow {
    id: root
    visible: true
    width: 600
    height: 400
    title: "Cool Dashboard"

    signal buttonClicked

    Rectangle {
        anchors.fill: parent
        color: "#0f172a"

        // --- Navbar ---
        Rectangle {
            id: navbar
            width: 400
            height: 50
            radius: 25                  // rounded edges
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 10
            color: "#1e293b"           // dark gray/navy
            border.color: "#334155"    // subtle border
            border.width: 1

            // DropShadow using Qt5Compat
            layer.enabled: true
            layer.effect: DropShadow {
                horizontalOffset: 0
                verticalOffset: 4
                radius: 8
                samples: 16
                color: "#80000000"
            }

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 20

                Repeater {
                    model: ["Dashboard", "Analytics", "Settings", "Profile"]

                    delegate: Rectangle {
                        width: 80
                        height: 30
                        radius: 15
                        color: mouseArea.containsMouse ? "#334155" : "transparent"

                        Text {
                            anchors.centerIn: parent
                            text: modelData
                            color: "white"
                            font.pixelSize: 14
                        }

                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                console.log("Clicked: " + modelData);
                            }
                        }

                        Behavior on color {
                            ColorAnimation {
                                duration: 150
                            }
                        }
                    }
                }
            }
        }
    }
}

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects   // for DropShadow
import "../components"

Item {
    id: root
    property StackView stackView

    Rectangle {
        anchors.fill: parent

        // Gradient background
        gradient: Gradient {
            GradientStop {
                position: 0.0
                color: "#ff7a18"
            }
            GradientStop {
                position: 1.0
                color: "#7c3aed"
            }
        }

        ColumnLayout {
            anchors.fill: parent
            spacing: 20
            anchors.margins: 20

            // --- Navbar ---
            Rectangle {
                id: navbar
                Layout.preferredHeight: 50
                Layout.preferredWidth: root.width * 0.4
                radius: 25
                color: "#000000"
                border.color: "#888888"
                border.width: 0

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

                    Item {
                        Layout.fillWidth: true
                    }

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
                            }

                            Behavior on color {
                                ColorAnimation {
                                    duration: 150
                                }
                            }
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                    }
                }
            }

            // --- Sensor Gauges ---
            Card {
                color: "#000000"
                Layout.preferredWidth: root.width * 0.95
                Layout.preferredHeight: root.height * 0.8
                Layout.alignment: Qt.AlignHCenter

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 50

                    // --- Sensor Info Panel ---
                    Rectangle {
                        Layout.preferredWidth: parent.width * 0.23
                        Layout.fillHeight: true
                        radius: 12
                        color: Qt.rgba(1, 1, 1, 0.2)
                        border.color: "#334155"
                        border.width: 1

                        Column {
                            anchors.fill: parent
                            anchors.margins: 20
                            spacing: 12

                            Text {
                                text: "Sensor Info"
                                color: "white"
                                font.bold: true
                                font.pixelSize: 20
                            }

                            Text {
                                text: "pH: 1-14"
                                color: "white"
                                font.pixelSize: 14
                            }
                            Text {
                                text: "Turbidity: NTU"
                                color: "white"
                                font.pixelSize: 14
                            }
                            Text {
                                text: "Temp: °C"
                                color: "white"
                                font.pixelSize: 14
                            }

                            // Legend items
                            Row {
                                spacing: 10
                                anchors.verticalCenterOffset: 0
                                Rectangle {
                                    width: 12
                                    height: 12
                                    radius: 6
                                    color: "#facc15"
                                }
                                Text {
                                    text: "pH Value"
                                    color: "white"
                                    font.pixelSize: 14
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }
                            Row {
                                spacing: 10
                                anchors.verticalCenterOffset: 0
                                Rectangle {
                                    width: 12
                                    height: 12
                                    radius: 6
                                    color: "#ef4444"
                                }
                                Text {
                                    text: "Turbidity"
                                    color: "white"
                                    font.pixelSize: 14
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }
                            Row {
                                spacing: 10
                                anchors.verticalCenterOffset: 0
                                Rectangle {
                                    width: 12
                                    height: 12
                                    radius: 6
                                    color: "#22c55e"
                                }
                                Text {
                                    text: "Temperature"
                                    color: "white"
                                    font.pixelSize: 14
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }
                        }

                        layer.enabled: true
                        layer.effect: DropShadow {
                            horizontalOffset: 0
                            verticalOffset: 4
                            radius: 8
                            samples: 16
                            color: "#80000000"
                        }
                    }

                    // --- Gauges Panel ---
                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        spacing: 20

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            color: "#CC000000"
                            radius: 12

                            Row {
                                spacing: 40
                                anchors.centerIn: parent

                                CircularGauge {
                                    id: phGauge
                                    Layout.preferredWidth: parent.width * 0.3
                                    Layout.preferredHeight: parent.width * 0.3
                                    label: "pH"
                                    value: 0
                                }

                                CircularGauge {
                                    id: turbidityGauge
                                    Layout.preferredWidth: parent.width * 0.3
                                    Layout.preferredHeight: parent.width * 0.3
                                    label: "Turbidity"
                                    value: 0
                                }

                                CircularGauge {
                                    id: tempGauge
                                    Layout.preferredWidth: parent.width * 0.3
                                    Layout.preferredHeight: parent.width * 0.3
                                    label: "Temperature"
                                    value: 0
                                }

                                // --- Live Connections ---
                                Connections {
                                    target: controller

                                    function onPhChanged(ph) {
                                        phGauge.value = ph;
                                    }

                                    function onTurbidityChanged(turbidity) {
                                        turbidityGauge.value = turbidity;
                                    }

                                    function onTempChanged(temp) {
                                        tempGauge.value = temp;
                                    }
                                }
                            }
                        }

                        // --- Optional Button ---
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 80
                            radius: 8
                            color: "transparent"

                            Button {
                                anchors.right: parent.right
                                anchors.bottom: parent.bottom
                                Layout.preferredHeight: 60
                                Layout.preferredWidth: 200
                                text: "Calculate"
                                font.pixelSize: 15

                                onClicked: {
                                    aiController.calculate_ai();
                                    stackView.push("reading.qml");
                                }

                                background: Rectangle {
                                    radius: 8
                                    color: Qt.rgba(1, 1, 1, 0.05)
                                    border.color: "#334155"
                                    border.width: 1
                                }

                                contentItem: Text {
                                    text: qsTr("Calculate")
                                    color: "white"
                                    font.pixelSize: 15
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

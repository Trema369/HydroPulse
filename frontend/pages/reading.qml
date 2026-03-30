import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "../components"

Item {
    id: root
    property StackView stackView

    // ── shared ambient animation ─────────────────────────────────────
    property real globalAngle: 0
    NumberAnimation on globalAngle {
        from: 0
        to: Math.PI * 2
        duration: 12000
        loops: Animation.Infinite
        running: true
    }

    // ── base background ──────────────────────────────────────────────
    Rectangle {
        anchors.fill: parent
        color: "#0a0a0f"
    }

    // ── drifting ambient blobs ───────────────────────────────────────
    Rectangle {
        width: 600
        height: 600
        radius: 300
        x: (parent.width / 2 - 300) + Math.cos(globalAngle) * 200
        y: (parent.height / 2 - 300) + Math.sin(globalAngle) * 150
        opacity: 0.06
        color: "#5e4bdb"
    }
    Rectangle {
        width: 440
        height: 440
        radius: 220
        x: (parent.width / 2 - 220) + Math.cos(globalAngle + Math.PI) * 180
        y: (parent.height / 2 - 220) + Math.sin(globalAngle + Math.PI) * 120
        opacity: 0.04
        color: "#3d2fb0"
    }
    Rectangle {
        width: 320
        height: 320
        radius: 160
        x: (parent.width / 2 - 160) + Math.cos(globalAngle + Math.PI * 0.7) * 260
        y: (parent.height / 2 - 160) + Math.sin(globalAngle + Math.PI * 0.7) * 140
        opacity: 0.035
        color: "#1e90ff"
    }

    // ── root layout ──────────────────────────────────────────────────
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 16

        // ── NAVBAR ───────────────────────────────────────────────────
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 52

            // pill container — centred
            Rectangle {
                id: navbar
                width: Math.min(parent.width * 0.55, 520)
                height: 48
                radius: 24
                anchors.centerIn: parent
                color: "#0f0f17"
                border.color: "#1e2235"
                border.width: 1

                layer.enabled: true
                layer.effect: DropShadow {
                    horizontalOffset: 0
                    verticalOffset: 6
                    radius: 20
                    samples: 32
                    color: "#60000000"
                }

                Row {
                    anchors.centerIn: parent
                    spacing: 4

                    Repeater {
                        model: ["Dashboard", "Analytics", "Settings", "Profile"]
                        delegate: Rectangle {
                            width: 100
                            height: 36
                            radius: 18
                            // highlight the first tab as "active"
                            color: index === 0 ? Qt.rgba(0.23, 0.51, 0.96, 0.18) : (navMouse.containsMouse ? Qt.rgba(1, 1, 1, 0.05) : "transparent")

                            Text {
                                anchors.centerIn: parent
                                text: modelData
                                color: index === 0 ? "#93c5fd" : "#9ca3af"
                                font.pixelSize: 13
                                font.weight: index === 0 ? Font.Medium : Font.Normal
                                font.letterSpacing: 0.3
                            }

                            // active underline dot
                            Rectangle {
                                visible: index === 0
                                width: 4
                                height: 4
                                radius: 2
                                color: "#3b82f6"
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: 5
                            }

                            MouseArea {
                                id: navMouse
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
                }
            }

            // ── wordmark — top-left ───────────────────────────────────
            Row {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                spacing: 0
                Text {
                    text: "Hydro"
                    color: "#93c5fd"
                    font.pixelSize: 17
                    font.weight: Font.Black
                }
                Text {
                    text: "Pulse"
                    color: "#fb923c"
                    font.pixelSize: 17
                    font.weight: Font.Black
                }
            }

            // ── live badge — top-right ────────────────────────────────
            Row {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                spacing: 6

                Rectangle {
                    width: 7
                    height: 7
                    radius: 3.5
                    color: "#22c55e"
                    anchors.verticalCenter: parent.verticalCenter
                    SequentialAnimation on opacity {
                        loops: Animation.Infinite
                        running: true
                        NumberAnimation {
                            to: 0.3
                            duration: 800
                            easing.type: Easing.InOutSine
                        }
                        NumberAnimation {
                            to: 1.0
                            duration: 800
                            easing.type: Easing.InOutSine
                        }
                    }
                }
                Text {
                    text: "Live"
                    color: "#4ade80"
                    font.pixelSize: 12
                    font.weight: Font.Medium
                    font.letterSpacing: 1
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

        // ── MAIN CONTENT CARD ────────────────────────────────────────
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: 16
            color: "#0d0d16"
            border.color: "#1a1a2e"
            border.width: 1

            layer.enabled: true
            layer.effect: DropShadow {
                horizontalOffset: 0
                verticalOffset: 8
                radius: 32
                samples: 48
                color: "#50000000"
            }

            RowLayout {
                anchors.fill: parent
                anchors.margins: 24
                spacing: 20

                // ── LEFT PANEL — sensor info ──────────────────────────
                Rectangle {
                    Layout.preferredWidth: 200
                    Layout.fillHeight: true
                    radius: 12
                    color: "#0a0a14"
                    border.color: "#1e2235"
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 20
                        spacing: 0

                        // header
                        Text {
                            text: "Sensor Info"
                            color: "#f1f5f9"
                            font.pixelSize: 15
                            font.weight: Font.Bold
                            font.letterSpacing: 0.4
                        }
                        Text {
                            text: "WHO safe ranges"
                            color: "#4b5563"
                            font.pixelSize: 11
                            font.letterSpacing: 0.3
                            Layout.bottomMargin: 20
                        }

                        // divider
                        Rectangle {
                            Layout.fillWidth: true
                            height: 1
                            color: "#1e2235"
                            Layout.bottomMargin: 16
                        }

                        // sensor rows
                        Repeater {
                            model: [
                                {
                                    label: "pH",
                                    range: "6.5 – 8.5",
                                    dot: "#facc15"
                                },
                                {
                                    label: "Turbidity",
                                    range: "< 4 NTU",
                                    dot: "#ef4444"
                                },
                                {
                                    label: "Temperature",
                                    range: "10 – 25 °C",
                                    dot: "#22c55e"
                                },
                                {
                                    label: "TDS",
                                    range: "< 300 ppm",
                                    dot: "#818cf8"
                                },
                            ]
                            delegate: ColumnLayout {
                                required property var modelData
                                Layout.fillWidth: true
                                spacing: 2
                                Layout.bottomMargin: 14

                                Row {
                                    spacing: 8
                                    Rectangle {
                                        width: 8
                                        height: 8
                                        radius: 4
                                        color: modelData.dot
                                        anchors.verticalCenter: parent.verticalCenter
                                    }
                                    Text {
                                        text: modelData.label
                                        color: "#e2e8f0"
                                        font.pixelSize: 13
                                        font.weight: Font.Medium
                                    }
                                }
                                Text {
                                    text: modelData.range
                                    color: "#4b5563"
                                    font.pixelSize: 11
                                    leftPadding: 16
                                }
                            }
                        }

                        // spacer
                        Item {
                            Layout.fillHeight: true
                        }

                        // divider
                        Rectangle {
                            Layout.fillWidth: true
                            height: 1
                            color: "#1e2235"
                            Layout.bottomMargin: 14
                        }

                        // legend
                        Repeater {
                            model: [
                                {
                                    label: "Safe / Normal",
                                    dot: "#22c55e"
                                },
                                {
                                    label: "Caution / Moderate",
                                    dot: "#facc15"
                                },
                                {
                                    label: "Danger / Critical",
                                    dot: "#ef4444"
                                },
                            ]
                            delegate: Row {
                                required property var modelData
                                spacing: 8
                                Layout.bottomMargin: 8
                                Rectangle {
                                    width: 8
                                    height: 8
                                    radius: 4
                                    color: modelData.dot
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                Text {
                                    text: modelData.label
                                    color: "#6b7280"
                                    font.pixelSize: 11
                                }
                            }
                        }
                    }
                }

                // ── RIGHT PANEL — gauges + button ─────────────────────
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 16

                    // section label
                    Row {
                        spacing: 10
                        Text {
                            text: "Live Sensor Readings"
                            color: "#f1f5f9"
                            font.pixelSize: 16
                            font.weight: Font.Bold
                            font.letterSpacing: 0.3
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Text {
                            text: "· Updated every 5 s"
                            color: "#374151"
                            font.pixelSize: 12
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    // gauge grid
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        radius: 12
                        color: "#08080f"
                        border.color: "#12121f"
                        border.width: 1

                        Grid {
                            columns: 2
                            rowSpacing: 20
                            columnSpacing: 20
                            anchors.centerIn: parent

                            CircularGauge {
                                id: phGauge
                                width: 180
                                height: 180
                                label: "pH"
                                value: 0
                            }
                            CircularGauge {
                                id: turbidityGauge
                                width: 180
                                height: 180
                                label: "Turbidity"
                                value: 0
                            }
                            CircularGauge {
                                id: tempGauge
                                width: 180
                                height: 180
                                label: "Temperature"
                                value: 0
                            }
                            CircularGauge {
                                id: tdsGauge
                                width: 180
                                height: 180
                                label: "TDS"
                                value: 0
                            }
                        }

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
                            function onTdsChanged(tds) {
                                tdsGauge.value = tds;
                            }
                        }
                    }

                    // ── bottom action bar ─────────────────────────────
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 12

                        // status chip
                        Rectangle {
                            height: 44
                            width: statusRow.implicitWidth + 28
                            radius: 8
                            color: "#0f1520"
                            border.color: "#1e2235"
                            border.width: 1

                            Row {
                                id: statusRow
                                anchors.centerIn: parent
                                spacing: 8

                                Rectangle {
                                    width: 7
                                    height: 7
                                    radius: 3.5
                                    color: "#22c55e"
                                    anchors.verticalCenter: parent.verticalCenter
                                    SequentialAnimation on opacity {
                                        loops: Animation.Infinite
                                        running: true
                                        NumberAnimation {
                                            to: 0.3
                                            duration: 900
                                            easing.type: Easing.InOutSine
                                        }
                                        NumberAnimation {
                                            to: 1.0
                                            duration: 900
                                            easing.type: Easing.InOutSine
                                        }
                                    }
                                }
                                Text {
                                    text: "Sensors connected"
                                    color: "#9ca3af"
                                    font.pixelSize: 12
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        // Calculate button
                        Rectangle {
                            height: 44
                            width: 160
                            radius: 10
                            color: calcMouse.containsMouse ? Qt.rgba(0.23, 0.51, 0.96, 0.22) : Qt.rgba(0.23, 0.51, 0.96, 0.14)
                            border.color: calcMouse.containsMouse ? "#3b82f6" : "#1e3a6e"
                            border.width: 1

                            Behavior on color {
                                ColorAnimation {
                                    duration: 150
                                }
                            }
                            Behavior on border.color {
                                ColorAnimation {
                                    duration: 150
                                }
                            }

                            layer.enabled: true
                            layer.effect: DropShadow {
                                horizontalOffset: 0
                                verticalOffset: calcMouse.containsMouse ? 6 : 3
                                radius: calcMouse.containsMouse ? 18 : 8
                                samples: 24
                                color: "#403b82f6"
                                Behavior on verticalOffset {
                                    NumberAnimation {
                                        duration: 150
                                    }
                                }
                                Behavior on radius {
                                    NumberAnimation {
                                        duration: 150
                                    }
                                }
                            }

                            Row {
                                anchors.centerIn: parent
                                spacing: 8
                                Text {
                                    text: "Run Analysis"
                                    color: "#93c5fd"
                                    font.pixelSize: 13
                                    font.weight: Font.Medium
                                    font.letterSpacing: 0.4
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                Text {
                                    text: "→"
                                    color: "#3b82f6"
                                    font.pixelSize: 14
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }

                            MouseArea {
                                id: calcMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    aiController.calculate_ai();
                                    stackView.push("results.qml", {
                                        snapPh: phGauge.value,
                                        snapTemp: tempGauge.value,
                                        snapTurbidity: turbidityGauge.value,
                                        snapTds: tdsGauge.value
                                    });
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

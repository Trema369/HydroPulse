import QtQuick
import QtQuick.Controls

Item {
    property StackView stackView
    property Loader pageLoader

    // ── animated angle drives all the orbs ──────────────────────────
    property real globalAngle: 0
    NumberAnimation on globalAngle {
        from: 0
        to: Math.PI * 2
        duration: 8000
        loops: Animation.Infinite
        running: true
    }

    // ── dark background ─────────────────────────────────────────────
    Rectangle {
        anchors.fill: parent
        color: "#0a0a0f"
    }

    // ── drifting background blobs (same trick as your main window) ──
    Rectangle {
        width: 520
        height: 520
        radius: 260
        x: (parent.width / 2 - 260) + Math.cos(globalAngle) * 180
        y: (parent.height / 2 - 260) + Math.sin(globalAngle) * 130
        opacity: 0.07
        color: "#5e4bdb"
    }
    Rectangle {
        width: 400
        height: 400
        radius: 200
        x: (parent.width / 2 - 200) + Math.cos(globalAngle + Math.PI) * 160
        y: (parent.height / 2 - 200) + Math.sin(globalAngle + Math.PI) * 110
        opacity: 0.05
        color: "#3d2fb0"
    }
    Rectangle {
        width: 300
        height: 300
        radius: 150
        x: (parent.width / 2 - 150) + Math.cos(globalAngle + Math.PI * 0.5) * 220
        y: (parent.height / 2 - 150) + Math.sin(globalAngle + Math.PI * 0.5) * 100
        opacity: 0.04
        color: "#1e90ff"
    }

    // ── central glow layers (outermost → innermost) ─────────────────
    Rectangle {
        width: 340
        height: 340
        radius: 170
        anchors.centerIn: parent
        color: "transparent"
        border.color: "#3b82f6"
        border.width: 1
        opacity: 0.15 + 0.08 * Math.sin(globalAngle * 2)
    }
    Rectangle {
        width: 280
        height: 280
        radius: 140
        anchors.centerIn: parent
        color: "#0d1a3a"
        opacity: 0.6
    }
    // soft halo
    Rectangle {
        width: 260
        height: 260
        radius: 130
        anchors.centerIn: parent
        color: "transparent"
        border.color: "#60a5fa"
        border.width: 2
        opacity: 0.25 + 0.12 * Math.sin(globalAngle * 3)
    }
    // inner sphere
    Rectangle {
        id: sphere
        width: 200
        height: 200
        radius: 100
        anchors.centerIn: parent
        gradient: Gradient {
            orientation: Gradient.Diagonal
            GradientStop {
                position: 0.0
                color: "#1e3a6e"
            }
            GradientStop {
                position: 0.5
                color: "#1a56db"
            }
            GradientStop {
                position: 1.0
                color: "#0a0a0f"
            }
        }
        // pulsing scale
        property real pulse: 1.0
        SequentialAnimation on pulse {
            loops: Animation.Infinite
            running: true
            NumberAnimation {
                to: 1.04
                duration: 1200
                easing.type: Easing.InOutSine
            }
            NumberAnimation {
                to: 1.00
                duration: 1200
                easing.type: Easing.InOutSine
            }
        }
        transform: Scale {
            origin.x: sphere.width / 2
            origin.y: sphere.height / 2
            xScale: sphere.pulse
            yScale: sphere.pulse
        }
    }

    // ── sphere highlight ────────────────────────────────────────────
    Rectangle {
        width: 80
        height: 50
        radius: 40
        anchors {
            horizontalCenter: parent.horizontalCenter
            horizontalCenterOffset: -28
            verticalCenter: parent.verticalCenter
            verticalCenterOffset: -44
        }
        color: "white"
        opacity: 0.08
        rotation: -30
    }

    // ── "HydroPulse" wordmark inside sphere ─────────────────────────
    Row {
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -10
        spacing: 0
        Text {
            text: "Hydro"
            color: "#93c5fd"
            font.pixelSize: 20
            font.weight: Font.Black
            font.letterSpacing: 0.5
        }
        Text {
            text: "Pulse"
            color: "#fb923c"
            font.pixelSize: 20
            font.weight: Font.Black
            font.letterSpacing: 0.5
        }
    }

    // ── animated loading dots beneath wordmark ──────────────────────
    Row {
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 18
        spacing: 6

        Repeater {
            model: 3
            delegate: Rectangle {
                required property int index
                width: 6
                height: 6
                radius: 3
                color: "#60a5fa"
                opacity: 0.3

                SequentialAnimation on opacity {
                    loops: Animation.Infinite
                    running: true
                    PauseAnimation {
                        duration: index * 220
                    }
                    NumberAnimation {
                        to: 1.0
                        duration: 400
                        easing.type: Easing.InOutSine
                    }
                    NumberAnimation {
                        to: 0.3
                        duration: 400
                        easing.type: Easing.InOutSine
                    }
                    PauseAnimation {
                        duration: (2 - index) * 220
                    }
                }
            }
        }
    }

    // ── tagline below sphere ─────────────────────────────────────────
    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.verticalCenter
        anchors.topMargin: 130
        text: "Water Quality Monitor"
        color: "#6b7280"
        font.pixelSize: 13
        font.letterSpacing: 3
        font.capitalization: Font.AllUppercase
    }

    // ── auto-navigate after 4 s ──────────────────────────────────────
    Timer {
        interval: 4000
        running: true
        repeat: false
        onTriggered: stackView.push("reading.qml", {
            stackView: stackView
        })
    }
}

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

Item {
    id: root
    property StackView stackView

    // ── data properties — filled by Connections below ───────────────
    property real score: 0
    property string status: ""
    property string overview: ""
    property var issues: []
    property var actions: []

    // snapshot readings passed in when pushing this page
    property real snapPh: 0
    property real snapTemp: 0
    property real snapTurbidity: 0
    property real snapTds: 0

    // ── ambient animation ────────────────────────────────────────────
    property real globalAngle: 0
    NumberAnimation on globalAngle {
        from: 0
        to: Math.PI * 2
        duration: 12000
        loops: Animation.Infinite
        running: true
    }

    // ── dark base ────────────────────────────────────────────────────
    Rectangle {
        anchors.fill: parent
        color: "#0a0a0f"
    }

    // ── drifting blobs ───────────────────────────────────────────────
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

    // ── receive analysis from backend ────────────────────────────────
    Connections {
        target: aiController
        function onResultReady(data) {
            root.score = data["score"] ?? 0;
            root.status = data["status"] ?? "";
            root.overview = data["overview"] ?? "";
            root.issues = data["issues"] ?? [];
            root.actions = data["recommended_actions"] ?? [];
        }
    }

    // ── score colour helper ──────────────────────────────────────────
    function scoreColor(s) {
        if (s >= 7.5)
            return "#22c55e";
        if (s >= 5.0)
            return "#facc15";
        if (s >= 2.5)
            return "#f97316";
        return "#ef4444";
    }
    function statusBg(st) {
        if (st === "Good")
            return "#14532d";
        if (st === "Moderate")
            return "#713f12";
        if (st === "Warning")
            return "#7c2d12";
        return "#450a0a";
    }
    function statusFg(st) {
        if (st === "Good")
            return "#4ade80";
        if (st === "Moderate")
            return "#fde047";
        if (st === "Warning")
            return "#fb923c";
        return "#f87171";
    }

    // ── page scaffold ────────────────────────────────────────────────
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 16

        // ── top bar ──────────────────────────────────────────────────
        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            // back button
            Rectangle {
                width: 36
                height: 36
                radius: 8
                color: backMouse.containsMouse ? "#1a1a2e" : "#0d0d16"
                border.color: "#1e2235"
                border.width: 1
                Behavior on color {
                    ColorAnimation {
                        duration: 120
                    }
                }
                Text {
                    anchors.centerIn: parent
                    text: "←"
                    color: "#9ca3af"
                    font.pixelSize: 16
                }
                MouseArea {
                    id: backMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: stackView.pop()
                }
            }

            ColumnLayout {
                spacing: 2
                Text {
                    text: "Analysis Results"
                    color: "#f1f5f9"
                    font.pixelSize: 18
                    font.weight: Font.Bold
                    font.letterSpacing: 0.3
                }
                Text {
                    text: "AI-evaluated water quality report"
                    color: "#4b5563"
                    font.pixelSize: 12
                }
            }

            Item {
                Layout.fillWidth: true
            }

            // wordmark
            Row {
                spacing: 0
                anchors.verticalCenter: parent.verticalCenter
                Text {
                    text: "Hydro"
                    color: "#93c5fd"
                    font.pixelSize: 15
                    font.weight: Font.Black
                }
                Text {
                    text: "Pulse"
                    color: "#fb923c"
                    font.pixelSize: 15
                    font.weight: Font.Black
                }
            }

            // print / new analysis buttons
            Rectangle {
                width: 110
                height: 34
                radius: 8
                color: newMouse.containsMouse ? "#1a1a2e" : "#0d0d16"
                border.color: "#1e2235"
                border.width: 1
                Behavior on color {
                    ColorAnimation {
                        duration: 120
                    }
                }
                Row {
                    anchors.centerIn: parent
                    spacing: 6
                    Text {
                        text: "↺"
                        color: "#9ca3af"
                        font.pixelSize: 14
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Text {
                        text: "New Analysis"
                        color: "#9ca3af"
                        font.pixelSize: 12
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                MouseArea {
                    id: newMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: stackView.pop()
                }
            }
        }

        // ── main row ─────────────────────────────────────────────────
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 16

            // ── LEFT — score card ─────────────────────────────────────
            Rectangle {
                Layout.preferredWidth: 220
                Layout.fillHeight: true
                radius: 14
                color: "#0d0d16"
                border.color: "#1a1a2e"
                border.width: 1

                layer.enabled: true
                layer.effect: DropShadow {
                    horizontalOffset: 0
                    verticalOffset: 6
                    radius: 24
                    samples: 40
                    color: "#50000000"
                }

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 0

                    Text {
                        text: "Safety Score"
                        color: "#6b7280"
                        font.pixelSize: 11
                        font.letterSpacing: 2
                        font.capitalization: Font.AllUppercase
                        Layout.bottomMargin: 20
                    }

                    // score ring
                    Item {
                        Layout.preferredWidth: 160
                        Layout.preferredHeight: 160
                        Layout.alignment: Qt.AlignHCenter

                        // track ring
                        Canvas {
                            id: trackRing
                            anchors.fill: parent
                            onPaint: {
                                var ctx = getContext("2d");
                                ctx.clearRect(0, 0, width, height);
                                ctx.beginPath();
                                ctx.arc(width / 2, height / 2, 64, -Math.PI * 0.75, Math.PI * 0.75);
                                ctx.strokeStyle = "#1e2235";
                                ctx.lineWidth = 10;
                                ctx.lineCap = "round";
                                ctx.stroke();
                            }
                        }

                        // value arc
                        Canvas {
                            id: scoreRing
                            anchors.fill: parent
                            property real animValue: 0
                            Behavior on animValue {
                                NumberAnimation {
                                    duration: 1000
                                    easing.type: Easing.OutCubic
                                }
                            }
                            onAnimValueChanged: requestPaint()
                            Component.onCompleted: animValue = root.score
                            Connections {
                                target: root
                                function onScoreChanged() {
                                    scoreRing.animValue = root.score;
                                }
                            }
                            onPaint: {
                                var ctx = getContext("2d");
                                ctx.clearRect(0, 0, width, height);
                                var frac = Math.max(0, Math.min(animValue, 10)) / 10;
                                var startA = -Math.PI * 0.75;
                                var endA = startA + frac * Math.PI * 1.5;
                                ctx.beginPath();
                                ctx.arc(width / 2, height / 2, 64, startA, endA);
                                ctx.strokeStyle = root.scoreColor(animValue);
                                ctx.lineWidth = 10;
                                ctx.lineCap = "round";
                                ctx.stroke();
                            }
                        }

                        // score number
                        Column {
                            anchors.centerIn: parent
                            spacing: 2
                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: root.score.toFixed(1)
                                color: root.scoreColor(root.score)
                                font.pixelSize: 36
                                font.weight: Font.Black
                            }
                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: "out of 10"
                                color: "#4b5563"
                                font.pixelSize: 11
                            }
                        }
                    }

                    // status badge
                    Rectangle {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.topMargin: 16
                        height: 28
                        width: statusLabel.implicitWidth + 24
                        radius: 14
                        color: root.statusBg(root.status)
                        border.color: Qt.lighter(root.statusBg(root.status), 1.5)
                        border.width: 1
                        Text {
                            id: statusLabel
                            anchors.centerIn: parent
                            text: root.status
                            color: root.statusFg(root.status)
                            font.pixelSize: 12
                            font.weight: Font.SemiBold
                            font.letterSpacing: 0.4
                        }
                    }

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

                    // snapshot readings grid
                    Text {
                        text: "Readings at analysis"
                        color: "#4b5563"
                        font.pixelSize: 10
                        font.letterSpacing: 1.5
                        font.capitalization: Font.AllUppercase
                        Layout.bottomMargin: 10
                    }
                    Grid {
                        columns: 2
                        rowSpacing: 10
                        columnSpacing: 16
                        Layout.fillWidth: true

                        Repeater {
                            model: [
                                {
                                    lbl: "pH",
                                    val: root.snapPh.toFixed(2),
                                    unit: ""
                                },
                                {
                                    lbl: "Temp",
                                    val: root.snapTemp.toFixed(1),
                                    unit: "°C"
                                },
                                {
                                    lbl: "Turbidity",
                                    val: root.snapTurbidity.toFixed(1),
                                    unit: "NTU"
                                },
                                {
                                    lbl: "TDS",
                                    val: root.snapTds.toFixed(0),
                                    unit: "ppm"
                                },
                            ]
                            delegate: Column {
                                required property var modelData
                                spacing: 1
                                Text {
                                    text: modelData.lbl
                                    color: "#4b5563"
                                    font.pixelSize: 10
                                }
                                Row {
                                    spacing: 2
                                    Text {
                                        text: modelData.val
                                        color: "#e2e8f0"
                                        font.pixelSize: 14
                                        font.weight: Font.Bold
                                    }
                                    Text {
                                        text: modelData.unit
                                        color: "#6b7280"
                                        font.pixelSize: 10
                                        anchors.bottom: parent.bottom
                                        anchors.bottomMargin: 2
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // ── RIGHT — detail cards ──────────────────────────────────
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 12

                // AI Overview
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: overviewCol.implicitHeight + 36
                    radius: 12
                    color: "#0d0d16"
                    border.color: "#1a1a2e"
                    border.width: 1

                    ColumnLayout {
                        id: overviewCol
                        anchors {
                            left: parent.left
                            right: parent.right
                            top: parent.top
                            margins: 18
                        }
                        spacing: 8

                        Text {
                            text: "AI Overview"
                            color: "#f1f5f9"
                            font.pixelSize: 13
                            font.weight: Font.SemiBold
                        }
                        Text {
                            Layout.fillWidth: true
                            text: root.overview !== "" ? root.overview : "Waiting for analysis..."
                            color: "#6b7280"
                            font.pixelSize: 12
                            wrapMode: Text.WordWrap
                            lineHeight: 1.5
                        }
                    }
                }

                // Issues + Actions — side by side
                RowLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 12

                    // Detected Issues
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        radius: 12
                        color: "#120a00"
                        border.color: "#7c2d12"
                        border.width: 1

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 16
                            spacing: 10

                            // header
                            Row {
                                spacing: 8
                                Rectangle {
                                    width: 20
                                    height: 20
                                    radius: 4
                                    color: "#7c2d12"
                                    anchors.verticalCenter: parent.verticalCenter
                                    Text {
                                        anchors.centerIn: parent
                                        text: "⚠"
                                        color: "#fb923c"
                                        font.pixelSize: 10
                                    }
                                }
                                Text {
                                    text: "Detected Issues"
                                    color: "#fb923c"
                                    font.pixelSize: 13
                                    font.weight: Font.SemiBold
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                height: 1
                                color: "#7c2d1250"
                            }

                            // scrollable list
                            Flickable {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                contentHeight: issueCol.implicitHeight
                                clip: true

                                Column {
                                    id: issueCol
                                    width: parent.width
                                    spacing: 8

                                    Repeater {
                                        model: root.issues
                                        delegate: Row {
                                            required property string modelData
                                            width: parent.width
                                            spacing: 10
                                            Rectangle {
                                                width: 6
                                                height: 6
                                                radius: 3
                                                color: "#f97316"
                                                anchors.top: issueText.top
                                                anchors.topMargin: 4
                                            }
                                            Text {
                                                id: issueText
                                                width: parent.width - 16
                                                text: modelData
                                                color: "#9ca3af"
                                                font.pixelSize: 12
                                                wrapMode: Text.WordWrap
                                                lineHeight: 1.4
                                            }
                                        }
                                    }

                                    Text {
                                        visible: root.issues.length === 0
                                        text: "No issues detected."
                                        color: "#374151"
                                        font.pixelSize: 12
                                    }
                                }
                            }
                        }
                    }

                    // Recommended Actions
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        radius: 12
                        color: "#001208"
                        border.color: "#14532d"
                        border.width: 1

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 16
                            spacing: 10

                            Row {
                                spacing: 8
                                Rectangle {
                                    width: 20
                                    height: 20
                                    radius: 4
                                    color: "#14532d"
                                    anchors.verticalCenter: parent.verticalCenter
                                    Text {
                                        anchors.centerIn: parent
                                        text: "✓"
                                        color: "#4ade80"
                                        font.pixelSize: 10
                                        font.weight: Font.Bold
                                    }
                                }
                                Text {
                                    text: "Recommended Actions"
                                    color: "#4ade80"
                                    font.pixelSize: 13
                                    font.weight: Font.SemiBold
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                height: 1
                                color: "#14532d50"
                            }

                            Flickable {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                contentHeight: actionCol.implicitHeight
                                clip: true

                                Column {
                                    id: actionCol
                                    width: parent.width
                                    spacing: 8

                                    Repeater {
                                        model: root.actions
                                        delegate: Row {
                                            required property string modelData
                                            width: parent.width
                                            spacing: 10
                                            Rectangle {
                                                width: 6
                                                height: 6
                                                radius: 3
                                                color: "#22c55e"
                                                anchors.top: actionText.top
                                                anchors.topMargin: 4
                                            }
                                            Text {
                                                id: actionText
                                                width: parent.width - 16
                                                text: modelData
                                                color: "#9ca3af"
                                                font.pixelSize: 12
                                                wrapMode: Text.WordWrap
                                                lineHeight: 1.4
                                            }
                                        }
                                    }

                                    Text {
                                        visible: root.actions.length === 0
                                        text: "No actions needed."
                                        color: "#374151"
                                        font.pixelSize: 12
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

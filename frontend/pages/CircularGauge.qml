import QtQuick
import Qt5Compat.GraphicalEffects

Item {
    id: gauge
    implicitWidth: 200
    implicitHeight: 200
    width: implicitWidth
    height: implicitHeight

    property real value: 50
    property real minValue: 0
    property real maxValue: 100
    property string label: "Sensor"

    property real percentage: (value - minValue) / (maxValue - minValue)

    property color gaugeColor: {
        if (percentage < 0.6)
            return "#22c55e";
        else if (percentage < 0.85)
            return "#facc15";
        else
            return "#ef4444";
    }

    Canvas {
        id: canvas
        anchors.fill: parent
        anchors.margins: -width * 0.09

        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);

            var centerX = width / 2;
            var centerY = height / 2;
            var radius = width / 2 - width * 0.12;

            // Background ring
            ctx.beginPath();
            ctx.arc(centerX, centerY, radius, 0, 2 * Math.PI);
            ctx.lineWidth = width * 0.14;
            ctx.shadowBlur = width * 0.08;       // <-- shadow blur
            ctx.shadowColor = "#00000080";
            ctx.strokeStyle = "rgba(255, 255, 255, 0.2)";
            ctx.stroke();
            ctx.shadowBlur = 0;

            // Value arc
            ctx.beginPath();
            ctx.arc(centerX, centerY, radius, -Math.PI / 2, -Math.PI / 2 + (2 * Math.PI * percentage));
            ctx.lineWidth = width * 0.07;
            ctx.lineCap = "round";
            ctx.strokeStyle = gaugeColor;
            ctx.shadowBlur = width * 0.06;
            ctx.shadowColor = gaugeColor;
            ctx.stroke();
            ctx.shadowBlur = 0;
        }

        Connections {
            target: gauge
            function onValueChanged() {
                canvas.requestPaint();
            }
        }
    }

    Rectangle {
        id: innerCircle
        width: parent.width * 0.60
        height: width
        anchors.centerIn: parent
        radius: width / 2
        color: Qt.rgba(1, 1, 1, 0.2)
        opacity: 0.95
        z: -1

        Behavior on color {
            ColorAnimation {
                duration: 400
            }
        }

        layer.enabled: true
        layer.effect: DropShadow {
            horizontalOffset: 0
            verticalOffset: 4
            radius: 8
            samples: 16
            color: "#40ffffff"
        }
    }

    Column {
        anchors.centerIn: innerCircle
        spacing: 4

        Text {
            text: label
            font.pixelSize: innerCircle.width * 0.10
            font.bold: true
            color: "#969997"
        }

        Text {
            text: Math.round(value)
            font.pixelSize: innerCircle.width * 0.2
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            color: "white"
            width: parent.width
        }
    }

    Behavior on value {
        NumberAnimation {
            duration: 600
            easing.type: Easing.InOutQuad
        }
    }
}

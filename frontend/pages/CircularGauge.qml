import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Canvas 1.15

Item {
    id: gauge
    width: 200
    height: 200

    property real value: 50           // current gauge value
    property real minValue: 0
    property real maxValue: 100
    property string label: "Sensor"

    // Animated property for smooth arc movement
    property real animatedValue: value
    property real percentage: (animatedValue - minValue) / (maxValue - minValue)

    Canvas {
        id: canvas
        anchors.fill: parent

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
            ctx.strokeStyle = "rgba(255, 255, 255, 0.2)";
            ctx.stroke();

            // Value arc (animated)
            ctx.beginPath();
            ctx.arc(centerX, centerY, radius, -Math.PI / 2, -Math.PI / 2 + (2 * Math.PI * percentage));
            ctx.lineWidth = width * 0.07;
            ctx.lineCap = "round";
            ctx.strokeStyle = percentage < 0.6 ? "#22c55e" : percentage < 0.85 ? "#facc15" : "#ef4444";
            ctx.stroke();
        }

        Connections {
            target: gauge
            function onAnimatedValueChanged() {
                canvas.requestPaint();
            }
        }
    }

    // Inner circle
    Rectangle {
        id: innerCircle
        width: parent.width * 0.6
        height: width
        anchors.centerIn: parent
        radius: width / 2
        color: "rgba(255,255,255,0.05)"
    }

    // Centered text
    Column {
        anchors.centerIn: innerCircle
        spacing: 4

        Text {
            text: label
            font.pixelSize: innerCircle.width * 0.1
            font.bold: true
            color: "#969997"
            horizontalAlignment: Text.AlignHCenter
        }

        Text {
            text: Math.round(animatedValue)
            font.pixelSize: innerCircle.width * 0.2
            font.bold: true
            color: "white"
            horizontalAlignment: Text.AlignHCenter
        }
    }

    // Animation
    Behavior on animatedValue {
        NumberAnimation {
            duration: 600
            easing.type: Easing.InOutQuad
        }
    }

    // Update animatedValue whenever value changes
    onValueChanged: animatedValue = value
}

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects   // <--- legacy shadow support
import QtCharts

Item {
    property StackView stackView
    Rectangle {
        anchors.fill: parent

        gradient: Gradient {
            GradientStop {
                id: stop1
                position: 0.0
                color: "#ff7a18"
            }
            GradientStop {
                id: stop2
                position: 1.0
                color: "#7c3aed"
            }
        }
        AnimatedImage {
            id: lottieId
            width: 400
            height: 400
            anchors.centerIn: parent
            fillMode: Image.PreserveAspectFit
            source: "assets/loading.gif"
            smooth: true
        }
    }
    Timer {
        interval: 2000   // 5 seconds
        running: true
        repeat: false
        onTriggered: {
            myStackView.push("reading.qml");
        }
    }
}

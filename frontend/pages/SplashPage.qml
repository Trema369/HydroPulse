import QtQuick
import QtQuick.Controls

Item {
    property StackView stackView
    property Loader pageLoader
    anchors.fill: parent

    Rectangle {
        anchors.fill: parent
        color: "black"

        Text {
            anchors.centerIn: parent
            text: "Welcome"
            color: "white"
            font.pixelSize: 32
        }
    }

    Timer {
        interval: 5000   // 5 seconds
        running: true
        repeat: false
        onTriggered: {
            myStackView.push("loading.qml");
        }
    }
}

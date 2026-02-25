import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects   // legacy shadow support
import "../components"
import QtCharts

Item {
    id: root
    width: 800
    height: 600
    property StackView stackView

    Rectangle {
        anchors.fill: parent
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
            anchors.centerIn: parent
            spacing: 30
            width: parent.width * 0.9
            height: parent.height * 0.8  // definite height

            // Header text
            Text {
                text: "Select a card to continue"
                color: "white"
                font.pixelSize: 22
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                Layout.alignment: Qt.AlignHCenter
            }

            // Cards row
            RowLayout {
                spacing: 40
                Layout.alignment: Qt.AlignHCenter
                Layout.fillWidth: true
                Layout.preferredHeight: parent.height * 0.5  // definite height

                // Card 1
                Card {
                    id: card1
                    color: Qt.rgba(1, 1, 1, 0.2)
                    radius: 16
                    Layout.preferredWidth: 250
                    Layout.preferredHeight: 300

                    ColumnLayout {
                        anchors.fill: parent  // optional, can remove
                        spacing: 10
                        Layout.alignment: Qt.AlignHCenter

                        Image {
                            source: "assets/PlantAnalysis.png"
                            fillMode: Image.PreserveAspectFit
                            Layout.preferredWidth: parent.width * 0.8
                            Layout.preferredHeight: 180
                        }

                        Text {
                            text: "AI Plant Analysis"
                            color: "white"
                            font.pixelSize: 16
                            horizontalAlignment: Text.AlignHCenter
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (stackView)
                                stackView.push("plantAnalysis.qml");
                        }
                    }
                }

                // Card 2
                Card {
                    id: card2
                    color: Qt.rgba(1, 1, 1, 0.2)
                    radius: 16
                    Layout.preferredWidth: 250
                    Layout.preferredHeight: 300

                    ColumnLayout {
                        spacing: 10
                        Layout.alignment: Qt.AlignHCenter

                        Image {
                            source: "assets/WaterAnalysis.png"
                            fillMode: Image.PreserveAspectFit
                            Layout.preferredWidth: parent.width * 0.8
                            Layout.preferredHeight: 180
                        }

                        Text {
                            text: "Water Analysis"
                            color: "white"
                            font.pixelSize: 16
                            horizontalAlignment: Text.AlignHCenter
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (stackView)
                                stackView.push("reading.qml");
                        }
                    }
                }
            }
        }
    }
}

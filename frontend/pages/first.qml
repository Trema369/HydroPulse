import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "../components"
import QtCharts

Item {
    id: root
    width: parent ? parent.width : 800
    height: parent ? parent.height : 600
    property StackView stackView

    Rectangle {
        width: root.width
        height: root.height
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
            spacing: 30
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            // Header
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
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                // Card 1
                Card {
                    color: Qt.rgba(1, 1, 1, 0.2)
                    radius: 16
                    Layout.preferredWidth: root.width * 0.3
                    Layout.preferredHeight: root.height * 0.5

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (stackView)
                                stackView.push("plantAnalysis.qml");
                        }
                    }

                    ColumnLayout {
                        spacing: 10
                        Layout.alignment: Qt.AlignHCenter
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Image {
                            source: "assets/PlantAnalysis.png"
                            fillMode: Image.PreserveAspectFit
                            Layout.preferredWidth: parent.width * 0.8
                            Layout.preferredHeight: parent.height * 0.7
                        }

                        Text {
                            text: "AI Plant Analysis"
                            color: "white"
                            font.pixelSize: 16
                            horizontalAlignment: Text.AlignHCenter
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                }

                // Card 2
                Card {
                    color: Qt.rgba(1, 1, 1, 0.2)
                    radius: 16
                    Layout.preferredWidth: root.width * 0.3
                    Layout.preferredHeight: root.height * 0.5

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (stackView)
                                stackView.push("reading.qml");
                        }
                    }

                    ColumnLayout {
                        spacing: 10
                        Layout.alignment: Qt.AlignHCenter
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Image {
                            source: "assets/WaterAnalysis.png"
                            fillMode: Image.PreserveAspectFit
                            Layout.preferredWidth: parent.width * 0.8
                            Layout.preferredHeight: parent.height * 0.7
                        }

                        Text {
                            text: "Water Analysis"
                            color: "white"
                            font.pixelSize: 16
                            horizontalAlignment: Text.AlignHCenter
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                }
            }
        }
    }
}

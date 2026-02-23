import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects   // <--- legacy shadow support
import "../components"
import QtCharts

Item {
    id: root
    anchors.fill: parent
    property Loader loaderRef

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

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 30
            anchors.horizontalCenter: parent.horizontalCenter

            // --- Header text ---
            Text {
                text: "Select a card to continue"
                color: "white"
                font.pixelSize: 22
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                Layout.alignment: Qt.AlignHCenter
            }

            // --- Cards row ---
            RowLayout {
                spacing: 40
                Layout.alignment: Qt.AlignHCenter

                // --- Card 1 ---
                Card {
                    id: card1
                    color: Qt.rgba(1, 1, 1, 0.2)

                    Layout.preferredWidth: root.width * 0.3
                    Layout.preferredHeight: root.height * 0.5
                    radius: 16

                    Column {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 10
                        anchors.horizontalCenter: parent.horizontalCenter

                        Image {
                            source: "assets/PlantAnalysis.png"
                            fillMode: Image.PreserveAspectFit
                            width: parent.width * 0.8
                            height: parent.height * 0.7
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        Text {
                            text: "AI Plant Analysis"
                            color: "white"
                            font.pixelSize: 16
                            horizontalAlignment: Text.AlignHCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                    }
                }

                // --- Card 2 ---
                Card {
                    id: card2
                    color: Qt.rgba(1, 1, 1, 0.2)

                    Layout.preferredWidth: root.width * 0.3
                    Layout.preferredHeight: root.height * 0.5
                    radius: 16

                    Column {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 10
                        anchors.horizontalCenter: parent.horizontalCenter

                        Image {
                            source: "assets/WaterAnalysis.png"
                            fillMode: Image.PreserveAspectFit
                            width: parent.width * 0.8
                            height: parent.height * 0.7
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        Text {
                            text: "Water Analysis"
                            color: "white"
                            font.pixelSize: 16
                            horizontalAlignment: Text.AlignHCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            myStackView.push("reading.qml");
                        }
                        cursorShape: Qt.PointingHandCursor
                    }
                }
            }
        }
    }
}

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects   // for DropShadow
import "../components"

Item {
    id: root

    Rectangle {
        anchors.fill: parent
        Text {
            id: aiOverview
            objectName: "aiOverview"  // important for Python to find it
            anchors.left: parent.left
            width: parent.width
            wrapMode: Text.WordWrap
            color: "white"
            text: ""
        }
    }
}

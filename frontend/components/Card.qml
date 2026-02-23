import QtQuick
import Qt5Compat.GraphicalEffects

Rectangle {
    id: mainCard
    radius: 16
    //color: "#000000"
    border.color: "#888888"    // subtle border
    border.width: 0

    layer.enabled: true
    layer.effect: DropShadow {
        horizontalOffset: 0
        verticalOffset: 4
        radius: 8
        samples: 16
        color: "#80000000"
    }
    default property alias content: contentItem.data

    Item {
        id: contentItem
        anchors.fill: parent
        anchors.margins: 20
    }
}

import QtQuick
import QtQuick.Controls
import "pages"

ApplicationWindow {
    visible: true
    width: 800
    height: 500
    title: "Water Dashboard"

    StackView {
        id: myStackView
        anchors.fill: parent
        initialItem: "pages/SplashPage.qml"
    }
}

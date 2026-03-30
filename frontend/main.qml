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

        Component.onCompleted: {
            myStackView.push("pages/SplashPage.qml", {
                stackView: myStackView
            });
        }
    }
}

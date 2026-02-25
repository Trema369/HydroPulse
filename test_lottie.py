import sys
from PySide6.QtWidgets import QApplication
from PySide6.QtQml import QQmlEngine, QQmlComponent

app = QApplication(sys.argv)

engine = QQmlEngine()
engine.addImportPath('/usr/lib/qt6/qml')  # system QML path

component = QQmlComponent(engine, 'file:///usr/lib/qt6/qml/Qt/labs/lottieqt/LottieAnimation.qml')

if component.isReady():
    print("Loaded!")
else:
    for error in component.errors():
        print(error)

# lottie_renderer.py
import os
import tempfile
from PySide6.QtCore import QTimer, QObject
from PIL import ImageQt
from rlottie_python import LottieAnimation

class LottiePlayer(QObject):
    """
    Plays a Lottie animation into a QML Image object.
    """
    def __init__(self, image_item, json_file, fps=60, parent=None):
        super().__init__(parent)
        self.image_item = image_item
        self.anim = LottieAnimation.from_file(json_file)
        self.frame_count = self.anim.lottie_animation_get_totalframe()
        self.frame_index = 0
        self.tmp_dir = tempfile.TemporaryDirectory()
        self.timer = QTimer(self)
        self.timer.timeout.connect(self.update_frame)
        self.timer.start(int(1000 / fps))  # ms per frame

    def update_frame(self):
        # Use rlottie to render frame to pillow image
        pil_img = self.anim.render_pillow_frame(frame_num=self.frame_index)
        self.frame_index = (self.frame_index + 1) % self.frame_count

        # Convert PIL image to temporary file
        frame_path = os.path.join(self.tmp_dir.name, f"frame_{self.frame_index}.png")
        pil_img.save(frame_path)

        # Update QML Image source
        self.image_item.setProperty("source", frame_path)

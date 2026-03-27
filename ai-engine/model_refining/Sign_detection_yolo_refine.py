import os
import shutil
import random

# Paths
GTSRB_PATH = "../datasets/GTSRB/Train"
OUTPUT_IMG = "../datasets/traffic_dataset/images/train"
OUTPUT_LABEL = "../datasets/traffic_dataset/labels/train"

os.makedirs(OUTPUT_IMG, exist_ok=True)
os.makedirs(OUTPUT_LABEL, exist_ok=True)

# Map dataset class → your class
CLASS_MAP = {
    14: 0,  # stop
    2: 1,   # speed limit
}

for class_id in os.listdir(GTSRB_PATH):

    if int(class_id) not in CLASS_MAP:
        continue

    class_path = os.path.join(GTSRB_PATH, class_id)

    for img_name in os.listdir(class_path):

        img_path = os.path.join(class_path, img_name)

        new_name = f"{class_id}_{img_name}"

        # Copy image
        shutil.copy(img_path, os.path.join(OUTPUT_IMG, new_name))

        # Create label (FULL IMAGE BOX)
        label_path = os.path.join(OUTPUT_LABEL, new_name.replace(".png", ".txt"))

        with open(label_path, "w") as f:
            f.write(f"{CLASS_MAP[int(class_id)]} 0.5 0.5 1.0 1.0\n")
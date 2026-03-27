import os
import random
import shutil

img_dir = "../datasets/traffic_dataset/images/train"
label_dir = "../datasets/traffic_dataset/labels/train"

val_img_dir = "../datasets/traffic_dataset/images/val"
val_label_dir = "../datasets/traffic_dataset/labels/val"

os.makedirs(val_img_dir, exist_ok=True)
os.makedirs(val_label_dir, exist_ok=True)

files = os.listdir(img_dir)
random.shuffle(files)

split = int(0.8 * len(files))

val_files = files[split:]

for f in val_files:
    shutil.move(os.path.join(img_dir, f), val_img_dir)
    shutil.move(os.path.join(label_dir, f.replace(".png", ".txt")), val_label_dir)
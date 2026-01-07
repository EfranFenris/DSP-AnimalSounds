import csv
import os
import shutil

# TODO: change these two paths to your actual ones
ESC50_DIR = r"/Users/Efran/Downloads/ESC-50-master"            # folder that contains 'audio' and 'meta'
PROJECT_DATA_DIR = r"/Users/Efran/Documents/DSP-AnimalSounds/data"

AUDIO_DIR = os.path.join(ESC50_DIR, "audio")
META_CSV  = os.path.join(ESC50_DIR, "meta", "esc50.csv")

# Choose the animals you want
TARGET_CATEGORIES = ["dog", "cat", "crow"]  

# Create output folders if they don't exist
for cat in TARGET_CATEGORIES:
    out_dir = os.path.join(PROJECT_DATA_DIR, cat)
    os.makedirs(out_dir, exist_ok=True)

# Read CSV and copy files
with open(META_CSV, newline="") as f:
    reader = csv.DictReader(f)
    for row in reader:
        category = row["category"]
        if category in TARGET_CATEGORIES:
            filename = row["filename"]  # e.g. "1-100032-A-0.wav"
            src_path = os.path.join(AUDIO_DIR, filename)
            dst_dir  = os.path.join(PROJECT_DATA_DIR, category)
            dst_path = os.path.join(dst_dir, filename)
            print(f"Copying {src_path} -> {dst_path}")
            shutil.copy2(src_path, dst_path)

print("Done. Check your data/ folder.")
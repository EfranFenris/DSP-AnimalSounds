
## Folder structure

- `data/`  
  WAV files from the ESC-50 dataset (only cat, dog, crow).

- `matlab/`  
  MATLAB scripts to:
  - load and normalise the audio,
  - plot time and frequency figures,
  - extract DSP features for each clip,
  - save all features to `features.csv`.

- `figures/`  
  PDF plots created in MATLAB (time and frequency plots).

- `python/`  
  Python script `classify.py` that reads `features.csv` and runs k-NN.

- `DSP_project Final.pdf`  
  Project report written in LaTeX (PDF file).

- `README.md`  
  This file.

## Requirements


### Python (Just in case you want to run the python part)
- Python 3
- Packages:
  - `pandas`
  - `scikit-learn`
  - `numpy` (installed automatically by the others)

You can install the Python packages with:

`pip install pandas scikit-learn`

## How to generate features in MATLAB

1. Open MATLAB.
2. Set the current folder to the project root (`DSP-AnimalSounds`).
3. Go to the `matlab/` folder.
4. Run the main MATLAB script that builds the dataset  
   (the script that loops over the files and calls `extract_features`).
5. This script will:
   - read all WAV files in `data/`,
   - normalise and resample them,
   - compute the six features,
   - save everything into `matlab/features.csv`,
   - save plots into `figures/`.

The project already includes `features.csv`, so this step is only needed if you want to regenerate it.

## How to run the Python classifier

These steps are for a terminal (macOS / Linux) or PowerShell (Windows).

1. Go to the project folder  

   `cd DSP-AnimalSounds`

2. (Optional) activate the virtual environment  

   - macOS / Linux: `source .venv/bin/activate`  
   - Windows: `.venv\Scripts\activate`

3. Run the classifier  

   `python python/classify.py`

4. Look at the terminal output  

   You should see the test accuracy and the confusion matrix, for example:

   `Test accuracy (k=5): 63.89%`  
   and a 3×3 matrix for cat, crow and dog.


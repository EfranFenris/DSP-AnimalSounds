import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split, cross_val_score
from sklearn.preprocessing import StandardScaler
from sklearn.neighbors import KNeighborsClassifier
from sklearn.metrics import accuracy_score, confusion_matrix
import matplotlib.pyplot as plt

# 1) Load CSV exported from MATLAB
df = pd.read_csv("features.csv")

# 2) Separate features and labels
# label column is text: "dog", "cat", "crow"
y = df["label"].values
X = df[["RMS", "ZCR", "Centroid", "E_low", "E_mid", "E_high"]].values

# 3) Standardize features (zero mean, unit variance)
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)

# 4) Simple train/test split (e.g. 70% train, 30% test)
X_train, X_test, y_train, y_test = train_test_split(
    X_scaled, y, test_size=0.3, random_state=0, stratify=y
)

# 5) k-NN classifier
k = 5
knn = KNeighborsClassifier(n_neighbors=k)
knn.fit(X_train, y_train)

# 6) Evaluate on test set
y_pred = knn.predict(X_test)
acc = accuracy_score(y_test, y_pred)
print(f"Test accuracy (k={k}): {acc*100:.2f}%")

cm = confusion_matrix(y_test, y_pred, labels=["dog", "cat", "crow"])
print("Confusion matrix (rows=true, cols=pred):")
print(cm)

# 7) Optional: quick 2D scatter plot of two features
plt.figure()
# choose indices of features you like, e.g. 2=Centroid, 5=E_high
feat1_idx = 2  # Centroid
feat2_idx = 5  # E_high

for label, marker, color in zip(["dog", "cat", "crow"],
                                ["o", "x", "^"],
                                ["r", "g", "b"]):
    idx = (y == label)
    plt.scatter(X_scaled[idx, feat1_idx], X_scaled[idx, feat2_idx],
                marker=marker, label=label, alpha=0.7)

plt.xlabel("Centroid (standardized)")
plt.ylabel("High-band energy (standardized)")
plt.legend()
plt.grid(True)
plt.title("Feature scatter: centroid vs high-band energy")
plt.show()
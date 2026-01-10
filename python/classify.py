import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.neighbors import KNeighborsClassifier
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import accuracy_score, confusion_matrix

# 1) Load data
df = pd.read_csv("matlab/features.csv")

X = df[["RMS", "ZCR", "Centroid", "E_low", "E_mid", "E_high"]].values
y = df["label"].values

# 2) Train/test split (stratified)
X_train, X_test, y_train, y_test = train_test_split(
    X, y,
    test_size=0.3,
    stratify=y,
    random_state=0
)

# 3) Standardize features using only train stats
scaler = StandardScaler()
X_train_std = scaler.fit_transform(X_train)
X_test_std  = scaler.transform(X_test)

# 4) k-NN classifier
k = 5
clf = KNeighborsClassifier(n_neighbors=k)
clf.fit(X_train_std, y_train)

y_pred = clf.predict(X_test_std)

# 5) Metrics
acc = accuracy_score(y_test, y_pred) * 100
cm  = confusion_matrix(y_test, y_pred)

print(f"Test accuracy (k={k}): {acc:.2f}%")
print("Confusion matrix (rows=true, cols=pred):")
print(cm)
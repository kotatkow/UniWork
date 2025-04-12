import pandas as pd

# Load the CSV file
file_path = "C:/Users/ghkjs/Downloads/연습문제자료/favoritesujects.csv"
df = pd.read_csv(file_path)

print(df.head())

from sklearn.decomposition import FactorAnalysis
from sklearn.preprocessing import StandardScaler
import numpy as np

# Select only the subject preference scores for analysis
X = df[['BIO', 'GEO', 'CHEM', 'ALG', 'CALC', 'STAT']]

# Standardize the data
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)

# Estimate number of factors via Kaiser's criterion (eigenvalues > 1)
from sklearn.decomposition import PCA

pca = PCA()
pca.fit(X_scaled)

# Extract eigenvalues
eigenvalues = pca.explained_variance_

# Count number of factors with eigenvalue > 1
num_factors = np.sum(eigenvalues > 1)
num_factors, eigenvalues

print(num_factors)
print(eigenvalues)
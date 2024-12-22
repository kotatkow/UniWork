import pandas as pd
import numpy as np
from collections import Counter
import matplotlib.pyplot as plt

try:
    # Load and display data structure
    data = pd.read_csv('C:/Users/ghkjs/OneDrive/Documents/ML/knn_assignment_data.csv')
    print("Data loaded successfully:")
    print(data.head())
except Exception as e:
    print(f"Error loading data: {e}")

# Split the dataset function
def train_test_split(data, test_size=0.2):
    np.random.seed(0)
    indices = np.random.permutation(len(data))
    test_set_size = int(len(data) * test_size)
    test_indices = indices[:test_set_size]
    train_indices = indices[test_set_size:]
    return data.iloc[train_indices], data.iloc[test_indices]

# Euclidean distance
def euclidean_distance(point1, point2):
    return np.sqrt(np.sum((point1 - point2) ** 2))

# KNN Classifier
def knn_predict(train_data, test_instance, k):
    distances = []
    for _, row in train_data.iterrows():
        dist = euclidean_distance(test_instance[:-1], row[:-1])
        distances.append((dist, row['Label']))

    distances.sort(key=lambda x: x[0])
    k_nearest_neighbors = [label for _, label in distances[:k]]
    most_common = Counter(k_nearest_neighbors).most_common(1)
    return most_common[0][0]

def knn(test_data, train_data, k=10):
    predictions = test_data.apply(lambda row: knn_predict(train_data, row, k), axis=1)
    accuracy = np.mean(predictions == test_data['Label'])
    print(f"Predictions: {predictions.head()}")
    print(f"Accuracy: {accuracy}")
    return predictions, accuracy

# Plot function with error handling
def plot_knn_classification(train_data, test_data, predictions, k):
    plt.figure(figsize=(10, 6))
    plt.title(f'KNN Classification (K={k})')
    plt.scatter(train_data['Feature1'], train_data['Feature2'], c=train_data['Label'], cmap='viridis', marker='x', alpha=0.5, label='Training data')
    plt.scatter(test_data['Feature1'], test_data['Feature2'], c=predictions, cmap='viridis', edgecolor='k', s=100, label='Predicted')
    plt.xlabel('Feature 1')
    plt.ylabel('Feature 2')
    plt.legend()
    plt.show(block=True)  # Ensure the plot shows up

# Split data
try:
    train_data, test_data = train_test_split(data, test_size=0.2)
    print("Data split successful")
except Exception as e:
    print(f"Error in data splitting: {e}")

# Predict and calculate accuracy
k = 10
try:
    predictions, accuracy = knn(test_data, train_data, k)
    print(f"Final Accuracy: {accuracy}")
    plot_knn_classification(train_data, test_data, predictions, k)
except Exception as e:
    print(f"Error during prediction or plotting: {e}")

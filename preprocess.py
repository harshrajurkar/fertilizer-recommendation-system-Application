import pandas as pd
from sklearn.preprocessing import StandardScaler

# Load the dataset
df = pd.read_csv("Fertilizer Prediction.csv")  # Replace "your_dataset.csv" with the actual file path

# 1. Handling Missing Values
# Check for missing values
print(df.isnull().sum())

# There are no missing values in this dataset, so no further action is needed for handling missing values.

# 2. Encoding Categorical Variables
# Perform one-hot encoding on 'Fertilizer Name' column
df_encoded = pd.get_dummies(df, columns=['Fertilizer Name'])

# 3. Scaling Numerical Features
# Define columns to scale
numerical_cols = ['Nitrogen', 'Phosphorous', 'Potassium']

# Instantiate a StandardScaler
scaler = StandardScaler()

# Scale the numerical columns
df_encoded[numerical_cols] = scaler.fit_transform(df_encoded[numerical_cols])

# Export the preprocessed dataset as a CSV file
df_encoded.to_csv("preprocessed_dataset.csv", index=False)

print("Preprocessed dataset exported successfully.")

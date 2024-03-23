import pandas as pd

# Load the original dataset
df = pd.read_csv("preprocessed_dataset.csv")

# Create separate dataframes for each fertilizer type
urea_data = df[df['Fertilizer Name_Urea'] == True]
dap_data = df[df['Fertilizer Name_DAP'] == True]
fertilizer_10_26_26_data = df[df['Fertilizer Name_10-26-26'] == True]
fertilizer_14_35_14_data = df[df['Fertilizer Name_14-35-14'] == True]
fertilizer_17_17_17_data = df[df['Fertilizer Name_17-17-17'] == True]
fertilizer_20_20_data = df[df['Fertilizer Name_20-20'] == True]
fertilizer_28_28_data = df[df['Fertilizer Name_28-28'] == True]

# Determine the length of the largest dataset
max_len = max(len(urea_data), len(dap_data), len(fertilizer_10_26_26_data), len(fertilizer_14_35_14_data), len(fertilizer_17_17_17_data), len(fertilizer_20_20_data), len(fertilizer_28_28_data))

# Augment each dataset to match the length of the largest dataset
urea_augmented = urea_data.sample(n=max_len, replace=True)
dap_augmented = dap_data.sample(n=max_len, replace=True)
fertilizer_10_26_26_augmented = fertilizer_10_26_26_data.sample(n=max_len, replace=True)
fertilizer_14_35_14_augmented = fertilizer_14_35_14_data.sample(n=max_len, replace=True)
fertilizer_17_17_17_augmented = fertilizer_17_17_17_data.sample(n=max_len, replace=True)
fertilizer_20_20_augmented = fertilizer_20_20_data.sample(n=max_len, replace=True)
fertilizer_28_28_augmented = fertilizer_28_28_data.sample(n=max_len, replace=True)

# Concatenate all augmented datasets
balanced_df = pd.concat([urea_augmented, dap_augmented, fertilizer_10_26_26_augmented, 
                         fertilizer_14_35_14_augmented, fertilizer_17_17_17_augmented, 
                         fertilizer_20_20_augmented, fertilizer_28_28_augmented])

# Shuffle the balanced dataset
balanced_df = balanced_df.sample(frac=1, random_state=42).reset_index(drop=True)

# Save the balanced dataset to a new CSV file
balanced_df.to_csv("balanced_dataset.csv", index=False)

import numpy as np
import pandas as pd
import sklearn
from sklearn.tree import DecisionTreeClassifier
import pickle
import time
import tensorflow as tf

# Load the dataset (assuming you have a dataset with NPK values and corresponding fertilizer recommendations)
# Replace "your_dataset.csv" with the actual file name
df = pd.read_csv("assets/Fertilizer Prediction.csv")

# Feature columns (NPK values)
X = df[['Nitrogen', 'Phosphorous','Potassium' ]]

# Target column (Fertilizer recommendation)
y = df['Fertilizer Name']

# Initialize and train the Decision Tree Classifier
classifier = DecisionTreeClassifier(random_state=42)    
classifier.fit(X, y)

# Save the trained model using pickle
with open('fertilizer_recommendation_model.pkl', 'wb') as pickle_out:
    pickle.dump(classifier, pickle_out)
print('The scikit-learn version is {}.'.format(sklearn.__version__))

# Save class labels
class_labels = classifier.classes_

# Example of how to use the model for prediction with user input NPK values
user_nitrogen = float(input("Enter Nitrogen value: "))
user_phosphorous = float(input("Enter Phosphorous value: "))
user_potassium = float(input("Enter Potassium value: "))

print("Waiting for prediction...")  # Display the "waiting" message
time.sleep(3)  # Simulate a 5-second delay

user_input_values = np.array([[user_nitrogen, user_potassium, user_phosphorous]])

user_recommendation = classifier.predict(user_input_values)
print("Recommended Fertilizer is:", user_recommendation[0])

# Convert the scikit-learn model to a TensorFlow model
input_shape = (3,)  # Adjust according to your input features
inputs = tf.keras.Input(shape=input_shape)
num_classes = len(np.unique(y))  # Number of unique classes in the target column
outputs = tf.keras.layers.Dense(num_classes, activation='softmax')(inputs)  # Softmax for multi-class classification
model = tf.keras.Model(inputs=inputs, outputs=outputs)

# Save the TensorFlow model
model.save('tf_model')

# Convert the TensorFlow model to TensorFlow Lite format
converter = tf.lite.TFLiteConverter.from_saved_model('tf_model')
tflite_model = converter.convert()

# Save the TensorFlow Lite model to a file
with open('fertilizer_recommendation_model.tflite', 'wb') as tflite_out:
    tflite_out.write(tflite_model)

# Save class labels to a file
with open('class_labels.txt', 'w') as f:
    for label in class_labels:
        f.write("%s\n" % label)

print('TensorFlow Lite model saved successfully.')

# import numpy as np
# import pandas as pd
# from sklearn.tree import DecisionTreeClassifier
# import pickle
# import time
# import tensorflow as tf

# # Load the dataset (assuming you have a dataset with NPK values and corresponding fertilizer recommendations)
# # Replace "your_dataset.csv" with the actual file name
# df = pd.read_csv("Fertilizer Prediction.csv")

# # Feature columns (NPK values)
# X = df[['Nitrogen', 'Potassium', 'Phosphorous']]

# # Target column (Fertilizer recommendation)
# y = df['Fertilizer Name']

# # Initialize and train the Decision Tree Classifier
# classifier = DecisionTreeClassifier(random_state=42)
# classifier.fit(X, y)

# # Save the trained model using pickle
# with open('fertilizer_recommendation_model.pkl', 'wb') as pickle_out:
#     pickle.dump(classifier, pickle_out)

# # Save class labels
# class_labels = classifier.classes_

# # Convert the scikit-learn model to a TensorFlow model
# input_shape = (3,)  # Adjust according to your input features
# inputs = tf.keras.Input(shape=input_shape)
# num_classes = len(np.unique(y))  # Number of unique classes in the target column
# outputs = tf.keras.layers.Dense(num_classes, activation='softmax')(inputs)  # Softmax for multi-class classification
# model = tf.keras.Model(inputs=inputs, outputs=outputs)

# # Save the TensorFlow model
# model.save('tf_model')

# # Convert the TensorFlow model to TensorFlow Lite format
# converter = tf.lite.TFLiteConverter.from_saved_model('tf_model')
# converter.allow_custom_ops = True  # Allow custom ops if needed
# tflite_model = converter.convert()

# # Save the TensorFlow Lite model to a file
# with open('fertilizer_recommendation_model.tflite', 'wb') as tflite_out:
#     tflite_out.write(tflite_model)

# # Save class labels to a file
# with open('class_labels.txt', 'w') as f:
#     for label in class_labels:
#         f.write("%s\n" % label)

# print('TensorFlow Lite model saved successfully.')

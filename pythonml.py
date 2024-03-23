import numpy as np
import pandas as pd
import tensorflow as tf
from sklearn.tree import DecisionTreeClassifier  
import pickle
import time

# Load the dataset
df = pd.read_csv("preprocessed_dataset.csv")

# Feature columns (NPK values)
X = df[['Nitrogen', 'Phosphorous', 'Potassium']]

# Target columns (Fertilizer recommendations)
y = df[['Fertilizer Name_14-35-14', 'Fertilizer Name_17-17-17', 'Fertilizer Name_20-20', 'Fertilizer Name_28-28', 'Fertilizer Name_DAP', 'Fertilizer Name_Urea']]

# Initialize and train the Decision Tree Classifier
classifier = DecisionTreeClassifier(random_state=42)    
classifier.fit(X, y)

# Save the trained model using pickle
with open('fertilizer_recommendation_model.pkl', 'wb') as pickle_out:
    pickle.dump(classifier, pickle_out)

# Save class labels
class_labels = y.columns.tolist()

# Example of how to use the model for prediction with user input NPK values
user_nitrogen = float(input("Enter Nitrogen value: "))
user_phosphorous = float(input("Enter Phosphorous value: "))
user_potassium = float(input("Enter Potassium value: "))

print("Waiting for prediction...")  
time.sleep(3)  

user_input_values = np.array([[user_nitrogen, user_phosphorous, user_potassium]])
user_recommendation = classifier.predict(user_input_values)

# Get the class label for the predicted class
predicted_class_label = class_labels[np.argmax(user_recommendation)]

print("Predicted class:", predicted_class_label)

# Convert the scikit-learn model to a TensorFlow model
input_shape = (3,)  
inputs = tf.keras.Input(shape=input_shape)
num_classes = len(class_labels)  
outputs = tf.keras.layers.Dense(num_classes, activation='softmax')(inputs)  
model = tf.keras.Model(inputs=inputs, outputs=outputs)

# Compile the model
model.compile(optimizer='adam',
              loss='categorical_crossentropy',
              metrics=['accuracy'])

# Convert the pandas DataFrame to TensorFlow Dataset
dataset = tf.data.Dataset.from_tensor_slices((X.values, y.values))
dataset = dataset.shuffle(len(df)).batch(1)

# Train the TensorFlow model
model.fit(dataset, epochs=10)

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

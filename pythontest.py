import numpy as np
import tensorflow as tf

# Load TFLite model and allocate tensors.
interpreter = tf.lite.Interpreter(model_path="fertilizer_recommendation_model.tflite")
interpreter.allocate_tensors()

# Get input and output tensors.
input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()

# Load the label file
with open('class_labels.txt', 'r') as f:
    labels = f.read().splitlines()

# Take user input for NPK values
user_nitrogen = float(input("Enter Nitrogen value: "))
user_phosphorous = float(input("Enter Phosphorous value: "))
user_potassium = float(input("Enter Potassium value: "))

# Prepare input data
input_data = np.array([[user_nitrogen, user_phosphorous, user_potassium]], dtype=np.float32)

print("Input data shape:", input_data.shape)

# Run inference
interpreter.set_tensor(input_details[0]['index'], input_data)
interpreter.invoke()

# Get the output tensor
output_data = interpreter.get_tensor(output_details[0]['index'])

print("Output data shape:", output_data.shape)
print("Output probabilities:", output_data)

# Get the index of the highest probability class
predicted_index = np.argmax(output_data)

# Get the corresponding class name from the labels list
predicted_class = labels[predicted_index]

print("Predicted class:", predicted_class)

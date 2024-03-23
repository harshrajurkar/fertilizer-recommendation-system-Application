import numpy as np
import tensorflow as tf

# Load TFLite model and allocate tensors.
interpreter = tf.lite.Interpreter(model_path="assets/fertilizer_recommendation_model.tflite")
interpreter.allocate_tensors()

# Get input and output tensors.
input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()

# Load the label file
with open('assets/class_labels.txt', 'r') as f:
    labels = f.read().splitlines()

# Take user input for NPK values
user_nitrogen = float(input("Enter Nitrogen value: "))
user_potassium = float(input("Enter Potassium value: "))
user_phosphorous = float(input("Enter Phosphorous value: "))

# Prepare input data
input_data = np.array([[user_nitrogen, user_potassium, user_phosphorous]], dtype=np.float32)
interpreter.set_tensor(input_details[0]['index'], input_data)

# Run inference
interpreter.invoke()

# Get the output tensor and convert it to class indices
output_data = interpreter.get_tensor(output_details[0]['index'])
predicted_index = np.argmax(output_data)

# Get the corresponding class name from the labels list
predicted_class = labels[predicted_index]

print("Predicted class:", predicted_class)

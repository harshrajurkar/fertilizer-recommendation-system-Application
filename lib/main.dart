import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tflite;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fertilizer Recommendation',
      home: FertilizerPage(),
    );
  }
}

class FertilizerPage extends StatefulWidget {
  @override
  _FertilizerPageState createState() => _FertilizerPageState();
}

class _FertilizerPageState extends State<FertilizerPage> {
  // Text editing controllers for NPK values input fields
  final TextEditingController nitrogenController = TextEditingController();
  final TextEditingController phosphorusController = TextEditingController();
  final TextEditingController potassiumController = TextEditingController();

  // Variable to store recommended fertilizer
  String recommendation = '';

  // TFLite interpreter instance
  late tflite.Interpreter interpreter;
  late List<String> labels;

  @override
  void initState() {
    super.initState();
    loadModel();
    loadLabels();
  }

  loadModel() async {
    // Load the TensorFlow Lite model
    interpreter = await tflite.Interpreter.fromAsset(
      'assets/fertilizer_recommendation_model.tflite',
    );
    interpreter.allocateTensors(); // Allocate tensors after loading the model
  }

  loadLabels() async {
    // Load the labels from the label file
    String labelsContent = await DefaultAssetBundle.of(context)
        .loadString('assets/class_labels.txt');
    labels = labelsContent.split('\n').map((label) => label.trim()).toList();
  }

  // Method to perform inference using TFLite model
  Future<void> performInference() async {
    // Get input values from text editing controllers
    double nitrogen = double.tryParse(nitrogenController.text) ?? 0.0;
    double phosphorus = double.tryParse(phosphorusController.text) ?? 0.0;
    double potassium = double.tryParse(potassiumController.text) ?? 0.0;

    // Prepare input data
    var input = [nitrogen, phosphorus, potassium];
    var inputBuffer = Float32List.fromList(input);

    // Prepare output buffer
    var outputBuffer = Float32List(6); // Assuming output tensor has size 6

    // Run inference
    interpreter.run(inputBuffer.buffer, outputBuffer.buffer);

    // Get the predicted class index
    var predictedIndex = outputBuffer.indexOf(outputBuffer
        .reduce((value, element) => value > element ? value : element));

    // Get the corresponding class name from the labels list
    var predictedClass = labels[predictedIndex];

    // Update the recommendation state with the predicted class
    setState(() {
      recommendation = predictedClass;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fertilizer Recommendation'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: nitrogenController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Nitrogen'),
            ),
            TextFormField(
              controller: phosphorusController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Phosphorus'),
            ),
            TextFormField(
              controller: potassiumController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Potassium'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: performInference,
              child: Text('Recommend Fertilizer'),
            ),
            SizedBox(height: 20),
            Text(
              'Recommended Fertilizer: $recommendation',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose text editing controllers
    nitrogenController.dispose();
    phosphorusController.dispose();
    potassiumController.dispose();
    super.dispose();
  }
}

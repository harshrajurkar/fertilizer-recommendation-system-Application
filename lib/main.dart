import 'dart:typed_data';
import 'dart:ui';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tflite;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:animated_widgets/animated_widgets.dart';
import 'package:page_transition/page_transition.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
return MaterialApp(
  debugShowCheckedModeBanner: false,
  title: 'Fertilizer Recommendation',
  theme: ThemeData(
    primaryColor: Colors.green,
    fontFamily: 'Lato',
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: Colors.greenAccent, // Change font to Lato
    ),
    appBarTheme: AppBarTheme(
      toolbarTextStyle: TextTheme(
        headline6: TextStyle(
          fontSize: 24, // Increase the font size for the AppBar title
          fontWeight: FontWeight.bold,
        ),
      ).bodyText2, titleTextStyle: TextTheme(
        headline6: TextStyle(
          fontSize: 24, // Increase the font size for the AppBar title
          fontWeight: FontWeight.bold,
        ),
      ).headline6,
    ),
  ),
  home: FertilizerPage(),
);

  }
}

class FertilizerPage extends StatefulWidget {
  @override
  _FertilizerPageState createState() => _FertilizerPageState();
}

class _FertilizerPageState extends State<FertilizerPage> {
  // Variable to store recommended fertilizer
  String recommendation = '';

  // TFLite interpreter instance
  late tflite.Interpreter interpreter;
  late List<String> labels;

  // Variable to store fetched NPK values
  late int fetchedNitrogenValue;
  late int fetchedPhosphorusValue;
  late int fetchedPotassiumValue;

  Query dbRef = FirebaseDatabase.instance.ref().child("npk_data");

  Widget ListItem({required Map<String, dynamic> npk}) {
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(20), // Increase padding for larger box size
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nitrogen value: ${npk['nitrogen']}',
              style: TextStyle(
                fontSize: 20, // Increase text size
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Phosphorus value: ${npk['phosphorus']}',
              style: TextStyle(
                fontSize: 20, // Increase text size
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Potassium value: ${npk['potassium']}',
              style: TextStyle(
                fontSize: 20, // Increase text size
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

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
  Future<void> performInference(Map<String, dynamic> npkValues) async {
    // Get input values from the fetched data
    // Convert fetched values to double
    double nitrogen = (npkValues['nitrogen'] as int).toDouble();
    double phosphorus = (npkValues['phosphorus'] as int).toDouble();
    double potassium = (npkValues['potassium'] as int).toDouble();

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
        backgroundColor: Color.fromARGB(255, 21, 133, 24),
        title: Text(
          'Fertilizer Recommendation',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          // Background image with blur effect
          // Background container for the blur effect
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/plant.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Blur effect overlay
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 3,
                sigmaY: 3,
              ), // Adjust sigma values for blur intensity
              child: Container(
                color: Colors.black.withOpacity(0), // Adjust opacity as needed
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: FirebaseAnimatedList(
                    query: dbRef,
                    itemBuilder: (BuildContext context, DataSnapshot snapshot,
                        Animation<double> animation, int index) {
                      final dynamic value = snapshot.value;
                      print('Received data: $value');

                      // Handle the case where only a single integer is received
                      if (value is int) {
                        final String nutrient;
                        if (index == 0) {
                          nutrient = 'Nitrogen';
                          fetchedNitrogenValue =
                              value; // Store fetched nitrogen value
                        } else if (index == 1) {
                          nutrient = 'Phosphorus';
                          fetchedPhosphorusValue =
                              value; // Store fetched phosphorus value
                        } else if (index == 2) {
                          nutrient = 'Potassium';
                          fetchedPotassiumValue =
                              value; // Store fetched potassium value
                        } else {
                          nutrient = 'Unknown';
                        }
                        return Card(
                          margin: const EdgeInsets.all(10),
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(20), // Increase padding for larger box size
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$nutrient value: $value',
                                  style
: TextStyle(
                                    fontSize: 20, // Increase text size
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          child: Text('Unexpected data format'),
                        );
                      }
                    },
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    // Perform inference with the fetched values
                    // You need to pass the fetched values to the performInference method
                    performInference({
                      'nitrogen':
                          fetchedNitrogenValue, // Replace with fetched nitrogen value
                      'phosphorus':
                          fetchedPhosphorusValue, // Replace with fetched phosphorus value
                      'potassium':
                          fetchedPotassiumValue, // Replace with fetched potassium value
                    });
                  },
                  child: Text(
                    'Recommend Fertilizer',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25), // Change text color to black
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Change button color
                    textStyle: TextStyle(
                      color: Colors.black, // Change text color to black
                      fontSize: 16,
                    ),
                    minimumSize:
                        Size(double.infinity, 70), // Adjust button size here
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Clear the recommended fertilizer field
                    setState(() {
                      recommendation = '';
                    });
                  },
                  child: Text(
                    'Clear Recommendation',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25), // Change text color to black
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Change button color
                    textStyle: TextStyle(
                      color: Colors.black, // Change text color to black
                      fontSize: 16,
                    ),
                    minimumSize:
                        Size(double.infinity, 70), // Adjust button size here
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 100,
                  padding: EdgeInsets.all(10), // Adjust the padding as needed
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(10), // Add rounded corners
                    border: Border.all(
                      color: Colors.black,
                      width: 2, // Adjust the width of the border
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // Add shadow
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recommended Fertilizer:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '$recommendation',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 170,)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

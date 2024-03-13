import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class NpkForm extends StatelessWidget {
  NpkForm({Key? key}) : super(key: key);

  Query dbRef = FirebaseDatabase.instance.ref().child("npk_data");

  Widget ListItem({required Map<String, dynamic> npk}) {
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Nitrogen: ${npk['nitrogen']}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Phosphorus: ${npk['phosphorus']}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Potassium: ${npk['potassium']}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  toolbarHeight: 120, // Set this height
  flexibleSpace: Container(
    color: Color.fromARGB(255, 187, 208, 226),
    child: Column(
      children: [
        SizedBox(height: 10,),
         Text('NPK Monitoring'),
         SizedBox(height: 20,),
         Text('Fertilizer to used =UREA'),
        // Text('3'),
        // Text('4'),
      ],
    ),
  ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        height: double.infinity,
        
        child: FirebaseAnimatedList(
          
          query: dbRef,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            print("Received data: ${snapshot.value}");

            if (snapshot.value is int) {
              // Handle the case where only a single integer is received
              int value = snapshot.value as int;
              print("Received single value: $value");

              // Determine which nutrient the value corresponds to
              String nutrient;
              if (index == 0) {
                nutrient = "Nitrogen";
              } else if (index == 1) {
                nutrient = "Phosphorus";
              } else if (index == 2) {
                nutrient = "Potassium";
              } else {
                nutrient = "Unknown";
              }

              return Card(
                margin: const EdgeInsets.all(10),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        "$nutrient Value",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "$value",
                        style: TextStyle(fontSize: 18),
                      ),
                      
                    ],
                  ),
                ),
              );
            } else if (snapshot.value is Map<dynamic, dynamic>) {
              // Check if the snapshot value is a Map
              Map<String, dynamic> npk = snapshot.value as Map<String, dynamic>;

              // Verify the structure of the data
              if (npk.containsKey('nitrogen') &&
                  npk.containsKey('phosphorous') &&
                  npk.containsKey('potassium')) {
                return ListItem(npk: npk);
              } else {
                print("Invalid data structure: ${snapshot.value}");
                return Container(
                  child: Text("Invalid data structure"),
                );
              }
            } else {
              // Handle other cases
              print("Unexpected data structure: ${snapshot.value}");
              return Container(
                child: Text("Unexpected data structure"),
              );
            }
          },
        ),
      ),
    );
  }
}

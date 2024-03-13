import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frs_app/frs_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: "AIzaSyA3KWYai7N4oWEbAOa9GGsbGMEVJqgodfQ",
          authDomain: "fertilizer-recommendatio-f9b82.firebaseapp.com",
          databaseURL: "https://fertilizer-recommendatio-f9b82-default-rtdb.firebaseio.com",
          projectId: "fertilizer-recommendatio-f9b82",
          storageBucket: "fertilizer-recommendatio-f9b82.appspot.com",
          messagingSenderId: "219091452172",
          appId: "1:219091452172:web:3a36b7a06c77a195530929",
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
  } catch (e) {
    print("Error initializing Firebase: $e");
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NpkForm()
    );
  }
}

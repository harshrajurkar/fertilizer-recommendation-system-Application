import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frs_app/constants.dart';
import 'package:frs_app/frs_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

 
 await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
          // apiKey: apikey,
          // authDomain: databaseURL,
          // projectId: projectId,
          // storageBucket: storageBucket,
          // messagingSenderId: messagingSenderId,
          // appId: appId,
);
  

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

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyDQ1STjZxOtk7qarCTYpCt-VAiw6MLLGqs",
        authDomain: "fchome-472b6.firebaseapp.com",
        projectId: "fchome-472b6",
        storageBucket: "fchome-472b6.firebasestorage.app",
        messagingSenderId: "788634060832",
        appId: "1:788634060832:web:2f378b223706ce53855445",
        measurementId: "G-ZN7K0GZPCC",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:personal_financial_management/app/application.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyCIGVsY2hn2MICXSbcPUsKmVUPa4VfC4Ns",
        appId: "1:515065352774:android:311546f23979fd77f97047",
        messagingSenderId: "515065352774",
        projectId: "personal-financel-app",
        authDomain: 'personal-financel-app.firebaseapp.com'),
  );

  runApp(const MyApp());
}

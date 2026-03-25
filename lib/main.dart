import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:src/views/app.dart';
import 'package:src/shared/mock_data_seeder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCm_f07eLr0u_2n_Syh-XpR-ofz6IeTTWI",
      authDomain: "hospital-management-syst-a534b.firebaseapp.com",
      projectId: "hospital-management-syst-a534b",
      storageBucket: "hospital-management-syst-a534b.firebasestorage.app",
      messagingSenderId: "1025907082191",
      appId: "1:1025907082191:web:1c32365f8b5ed5ba9908ba",
      measurementId: "G-M6Q97S5ZQ8",
    ),
  );
  await MockDataSeeder.seed();
  runApp(App());
}

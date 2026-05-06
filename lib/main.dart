import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lowgos_app/firebase_options.dart';
import 'package:lowgos_app/lawgos_app.dart';

void main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const LawgosApp());
}


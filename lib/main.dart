import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notepad/database/screena/NotesScreen.dart';

void main(){

  runApp(NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes App',

      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF1E1E1E)
      ),
      home: const NotesScreen(),
     
    );
  }
}

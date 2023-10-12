import 'dart:math';

import 'package:chat_grv/login.dart';
import 'package:chat_grv/routegenerator.dart';
import 'package:chat_grv/start/tela01.dart';
import 'package:chat_grv/telas/contatos.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main()async {

  //Inicializar o Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: telaum(),
      theme: ThemeData(
        primarySwatch: Colors.purple
      ),
      initialRoute: "/",
      onGenerateRoute: RouteGenerator.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}

//SE APARECER DEU BOM
//SE APARECER DEU BOM
//SE APARECER DEU BOM
//SE APARECER DEU BOM
//SE APARECER DEU BOM
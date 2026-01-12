import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'python_bridge.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDatabase();       // 1. Copy Seed DB
  await PythonBridge.initialize(); // 2. Start Python
  runApp(const UniversalApp());
}

Future<void> setupDatabase() async {
  final docsDir = await getApplicationDocumentsDirectory();
  final dbPath = "${docsDir.path}/app_database.db";
  
  if (!File(dbPath).existsSync()) {
    print("Copying Seed Database...");
    ByteData data = await rootBundle.load("assets/app_database.db");
    List<int> bytes = data.buffer.asUint8List();
    await File(dbPath).writeAsBytes(bytes, flush: true);
  }
}

class UniversalApp extends StatelessWidget {
  const UniversalApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: HomeScreen(),
    );
  }
}
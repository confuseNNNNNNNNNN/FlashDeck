import 'dart:io';
import 'dart:convert';
import 'package:serious_python/serious_python.dart';

class PythonBridge {
  static Future<void> initialize() async {
    // Start backend/main.py in a background thread
    await SeriousPython.run("backend/main.py");
  }

  static Future<Map<String, dynamic>> sendCommand(String action, Map<String, dynamic> payload) async {
    try {
      Socket socket = await Socket.connect('127.0.0.1', 65432);
      Map<String, dynamic> request = {'action': action, ...payload};
      socket.write(jsonEncode(request));

      // Wait for response
      var response = await socket.first;
      socket.close();
      return jsonDecode(String.fromCharCodes(response));
    } catch (e) {
      print("Bridge Error: $e");
      return {"status": "error"};
    }
  }
}
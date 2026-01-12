import 'package:flutter/material.dart';
import '../python_bridge.dart';

class AddCardScreen extends StatefulWidget {
  final List<dynamic> decks;
  AddCardScreen({required this.decks});
  @override
  _AddCardScreenState createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  int? _selectedDeckId;
  String _front = "";
  String _back = "";
  String _gender = "M"; // For Polish

  void _save() async {
    if (_selectedDeckId == null) return;
    
    // Simple logic: if Polish deck is selected (assuming ID 1 for seeded deck), add gender
    Map<String, dynamic> extras = {};
    if (_selectedDeckId == 1) extras["gender"] = _gender;

    await PythonBridge.sendCommand("ADD_CARD", {
      "payload": {
        "deck_id": _selectedDeckId,
        "front": _front,
        "back": _back,
        "extra_data": extras
      }
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Card")),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          DropdownButtonFormField<int>(
            value: _selectedDeckId,
            items: widget.decks.map<DropdownMenuItem<int>>((d) {
              return DropdownMenuItem(value: d['id'], child: Text(d['name']));
            }).toList(),
            onChanged: (v) => setState(() => _selectedDeckId = v),
            decoration: InputDecoration(labelText: "Deck"),
          ),
          TextField(
            decoration: InputDecoration(labelText: "Front / Question"),
            onChanged: (v) => _front = v,
          ),
          TextField(
            decoration: InputDecoration(labelText: "Back / Answer (LaTeX for Math)"),
            onChanged: (v) => _back = v,
          ),
          // Only show gender selector if Polish (ID=1) is picked
          if (_selectedDeckId == 1) 
            Row(children: [
              Text("Gender: "),
              Radio(value: "M", groupValue: _gender, onChanged: (v)=>setState(()=>_gender=v.toString())), Text("M"),
              Radio(value: "F", groupValue: _gender, onChanged: (v)=>setState(()=>_gender=v.toString())), Text("F"),
            ]),
          SizedBox(height: 20),
          ElevatedButton(onPressed: _save, child: Text("Save Card"))
        ],
      ),
    );
  }
}
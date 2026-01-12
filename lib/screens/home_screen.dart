import 'package:flutter/material.dart';
import '../python_bridge.dart';
import 'study_screen.dart';
import 'add_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> decks = [];

  @override
  void initState() {
    super.initState();
    _loadDecks();
  }

  void _loadDecks() async {
    // Give Python a second to wake up on first launch
    await Future.delayed(Duration(seconds: 1));
    var res = await PythonBridge.sendCommand("GET_DECKS", {});
    setState(() {
      if (res['status'] == 'success') decks = res['data'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Libraries")),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(
            builder: (_) => AddCardScreen(decks: decks)
          ));
          _loadDecks(); // Refresh after adding
        },
      ),
      body: decks.isEmpty 
        ? Center(child: CircularProgressIndicator()) 
        : ListView.builder(
            itemCount: decks.length,
            itemBuilder: (ctx, i) {
              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  leading: Icon(_getIcon(decks[i]['icon']), size: 32),
                  title: Text(decks[i]['name'], style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("Tap to study"),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (_) => StudyScreen(
                        deckId: decks[i]['id'], 
                        deckName: decks[i]['name']
                      )
                    ));
                  },
                ),
              );
            },
          ),
    );
  }

  IconData _getIcon(String? icon) {
    if (icon == "engineering") return Icons.settings;
    if (icon == "calculate") return Icons.functions;
    return Icons.translate;
  }
}
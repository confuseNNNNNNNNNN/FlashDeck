import 'package:flutter/material.dart';
import '../models/card_model.dart';
import '../python_bridge.dart';
import '../widgets/universal_card.dart';
import '../widgets/review_buttons.dart';

class StudyScreen extends StatefulWidget {
  final int deckId;
  final String deckName;
  const StudyScreen({required this.deckId, required this.deckName});
  @override
  _StudyScreenState createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  List<CardModel> cards = [];
  int index = 0;
  bool isFlipped = false;
  bool isCorrect = false;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  void _loadCards() async {
    var res = await PythonBridge.sendCommand("GET_CARDS", {"deck_id": widget.deckId});
    setState(() {
      cards = (res['data'] as List).map((x) => CardModel.fromJson(x)).toList();
    });
  }

  void _checkAnswer() {
    String input = _controller.text.trim().toLowerCase();
    String answer = cards[index].back.trim().toLowerCase();

    // Auto-pass math because LaTeX is hard to type
    bool autoPass = (widget.deckName == "Engineering" || widget.deckName == "Math");
    
    setState(() {
      isCorrect = autoPass || (input == answer);
      isFlipped = true;
    });
  }

  void _rateCard(int quality) async {
    await PythonBridge.sendCommand("REVIEW_CARD", {
      "card_id": cards[index].id,
      "quality": quality
    });

    setState(() {
      index = (index + 1) % cards.length;
      isFlipped = false;
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) return Scaffold(body: Center(child: Text("All caught up!")));
    CardModel card = cards[index];

    return Scaffold(
      appBar: AppBar(title: Text("Study: ${widget.deckName}")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(child: Card(
              elevation: 4,
              child: UniversalCardView(
                deckName: widget.deckName,
                content: isFlipped ? card.back : card.front,
                metadata: isFlipped ? card.extraData : {},
              ),
            )),
            
            if (!isFlipped) ...[
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: "Type Answer...", 
                  border: OutlineInputBorder()
                ),
                onSubmitted: (_) => _checkAnswer(),
              ),
              SizedBox(height: 10),
              ElevatedButton(onPressed: _checkAnswer, child: Text("Check")),
            ],

            if (isFlipped) 
              ReviewButtons(onRated: _rateCard, allowEasy: isCorrect)
          ],
        ),
      ),
    );
  }
}
import 'dart:convert';

class CardModel {
  final int id;
  final int deckId;
  final String front;
  final String back;
  final Map<String, dynamic> extraData;

  CardModel({
    required this.id, 
    required this.deckId, 
    required this.front, 
    required this.back, 
    required this.extraData
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['id'],
      deckId: json['deck_id'],
      front: json['front'],
      back: json['back'],
      // Python sends JSON string, we parse it to Dart Map
      extraData: json['extra_data'] != null ? 
                 jsonDecode(json['extra_data']) : {},
    );
  }
}
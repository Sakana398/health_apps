import 'package:flutter/material.dart';
import 'package:tabler_icons/tabler_icons.dart';

class CardModel {
  String doctor;
  int cardBackground;
  var cardIcon;
  
  // change the "this.doctor" to features
  CardModel(this.doctor, this.cardBackground, this.cardIcon);
}

List<CardModel> cards = [
  CardModel("Status", 0xFF5c6bc0, Icons.auto_graph),
  CardModel("Mental Training", 0xFFec407a, Icons.psychology),
  CardModel("Journal", 0xFFfbc02d, Icons.book),
  CardModel("ChatBot",0xFF00008B,TablerIcons.robot),
  CardModel("Clinic", 0xFF2E7D32, Icons.medical_services),
];

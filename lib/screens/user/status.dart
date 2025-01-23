import 'package:flutter/material.dart';
import 'package:health_apps/screens/user/dailyQuestions.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Status extends StatefulWidget {
  const Status({super.key});

  @override
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<Status> {
  int selectedDayIndex = 0;
  Map<String, int> weeklyScores = {
    "Mon": 0,
    "Tue": 0,
    "Wed": 0,
    "Thu": 0,
    "Fri": 0,
    "Sat": 0,
    "Sun": 0,
  };

  Map<String, Map<String, double>> keyIndicators = {
    "Mon": {
      "Mood": 0.0,
      "Stress Level": 0.0,
      "Sleep Quality": 0.0,
      "Energy Level": 0.0,
      "Social Engagement": 0.0,
      "Focus": 0.0,
      "Coping Ability": 0.0,
      "Sense of Purpose": 0.0,
      "Physical Activity": 0.0,
    },
    "Tue": {
      "Mood": 0.0,
      "Stress Level": 0.0,
      "Sleep Quality": 0.0,
      "Energy Level": 0.0,
      "Social Engagement": 0.0,
      "Focus": 0.0,
      "Coping Ability": 0.0,
      "Sense of Purpose": 0.0,
      "Physical Activity": 0.0,
    },
    "Wed": {
      "Mood": 0.0,
      "Stress Level": 0.0,
      "Sleep Quality": 0.0,
      "Energy Level": 0.0,
      "Social Engagement": 0.0,
      "Focus": 0.0,
      "Coping Ability": 0.0,
      "Sense of Purpose": 0.0,
      "Physical Activity": 0.0,
    },
    "Thu": {
      "Mood": 0.0,
      "Stress Level": 0.0,
      "Sleep Quality": 0.0,
      "Energy Level": 0.0,
      "Social Engagement": 0.0,
      "Focus": 0.0,
      "Coping Ability": 0.0,
      "Sense of Purpose": 0.0,
      "Physical Activity": 0.0,
    },
    "Fri": {
      "Mood": 0.0,
      "Stress Level": 0.0,
      "Sleep Quality": 0.0,
      "Energy Level": 0.0,
      "Social Engagement": 0.0,
      "Focus": 0.0,
      "Coping Ability": 0.0,
      "Sense of Purpose": 0.0,
      "Physical Activity": 0.0,
    },
    "Sat": {
      "Mood": 0.0,
      "Stress Level": 0.0,
      "Sleep Quality": 0.0,
      "Energy Level": 0.0,
      "Social Engagement": 0.0,
      "Focus": 0.0,
      "Coping Ability": 0.0,
      "Sense of Purpose": 0.0,
      "Physical Activity": 0.0,
    },
    "Sun": {
      "Mood": 0.0,
      "Stress Level": 0.0,
      "Sleep Quality": 0.0,
      "Energy Level": 0.0,
      "Social Engagement": 0.0,
      "Focus": 0.0,
      "Coping Ability": 0.0,
      "Sense of Purpose": 0.0,
      "Physical Activity": 0.0,
    },
  };

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    try {
      User? user = auth.currentUser;
      if (user == null) return;

      String userId = user.uid;
      CollectionReference userCollection =
          firestore.collection('users').doc(userId).collection('status');

      DocumentSnapshot snapshot = await userCollection.doc("data").get();

      if (snapshot.exists) {
        setState(() {
          weeklyScores = Map<String, int>.from(snapshot['weeklyScores']);
          keyIndicators = (snapshot['keyIndicators'] as Map<String, dynamic>)
              .map((day, indicators) {
            return MapEntry(day, Map<String, double>.from(indicators));
          });
        });
      } else {
        await userCollection.doc("data").set({
          'weeklyScores': weeklyScores,
          'keyIndicators': keyIndicators,
        });
      }
    } catch (e) {
      print("Error initializing data: $e");
    }
  }

  void saveDataToFirestore() {
    User? user = auth.currentUser;
    if (user == null) return;

    String userId = user.uid;
    firestore
        .collection('users')
        .doc(userId)
        .collection('status')
        .doc("data")
        .set({
      'weeklyScores': weeklyScores,
      'keyIndicators': keyIndicators,
    }).catchError((error) {
      print("Error updating data: $error");
    });
  }

  void updateKeyIndicators(
      String day, int severityScore, Map<String, double> indicators) {
    setState(() {
      weeklyScores[day] = severityScore;
      keyIndicators[day] = indicators;
    });
    saveDataToFirestore();
  }

  double getPercentageScore(int score) {
    const int maxScore = 27;
    return (score / maxScore) * 100;
  }

  String getCategory(int score) {
    if (score <= 12) return "Severe";
    if (score <= 20) return "Mild";
    return "Normal";
  }

  Color getCategoryColor(int score) {
    if (score <= 12) return Colors.red;
    if (score <= 20) return Colors.yellow[700]!;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    List<String> daysOfWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    int? currentScore = weeklyScores[daysOfWeek[selectedDayIndex]];
    Map<String, double> currentIndicators =
        keyIndicators[daysOfWeek[selectedDayIndex]]!;
    String category = getCategory(currentScore!);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Mental Health Progress',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Daily Check-in Button
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Daily Check-in',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () async {
                      String today = DateFormat.E().format(DateTime.now());
                      var result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DailyQuestionsPage(),
                        ),
                      );
                      if (result != null) {
                        updateKeyIndicators(today, result['severityScore'],
                            result['indicators']);
                      }
                    },
                    child: const Text(
                      'Start Questions',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            // Today's Severity Score
            Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8), // Match margins of other cards
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Severity Score",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "${getPercentageScore(currentScore).toStringAsFixed(1)}%",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: getCategoryColor(currentScore),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        category,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: getCategoryColor(currentScore),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        category == "Normal"
                            ? "Your symptoms are within normal levels. Keep maintaining your healthy habits!"
                            : category == "Mild"
                                ? "Your symptoms are mild. Consider some relaxation techniques or reaching out to a friend."
                                : "Your symptoms are severe. It might help to speak with a counselor or use additional coping strategies.",
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Weekly Progress Chart
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Weekly Progress',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: daysOfWeek.map((day) {
                        int index = daysOfWeek.indexOf(day);
                        int? score = weeklyScores[day];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedDayIndex = index;
                            });
                          },
                          child: Column(
                            children: [
                              Container(
                                height: getPercentageScore(score!).toDouble(),
                                width: 20,
                                decoration: BoxDecoration(
                                  color: index == selectedDayIndex
                                      ? Colors.blueAccent
                                      : Colors.grey,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(day),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            // Key Indicators Card
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Key Indicators',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    ...currentIndicators.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              entry.key,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              entry.value.toStringAsFixed(1),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

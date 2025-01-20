import 'package:flutter/material.dart';
import 'package:health_apps/screens/patient/dailyQuestions.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    "Mon": {"Stress Level": 0.0, "Anxiety": 0.0, "Sleep Quality": 0.0},
    "Tue": {"Stress Level": 0.0, "Anxiety": 0.0, "Sleep Quality": 0.0},
    "Wed": {"Stress Level": 0.0, "Anxiety": 0.0, "Sleep Quality": 0.0},
    "Thu": {"Stress Level": 0.0, "Anxiety": 0.0, "Sleep Quality": 0.0},
    "Fri": {"Stress Level": 0.0, "Anxiety": 0.0, "Sleep Quality": 0.0},
    "Sat": {"Stress Level": 0.0, "Anxiety": 0.0, "Sleep Quality": 0.0},
    "Sun": {"Stress Level": 0.0, "Anxiety": 0.0, "Sleep Quality": 0.0},
  };

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  // Method to initialize data in Firestore
  void initializeData() async {
    try {
      DocumentReference docRef = firestore.collection('user_data').doc('weekly_data');
      DocumentSnapshot snapshot = await docRef.get();

      if (snapshot.exists) {
        setState(() {
          weeklyScores = Map<String, int>.from(snapshot['weeklyScores']);
          keyIndicators = (snapshot['keyIndicators'] as Map<String, dynamic>).map((day, indicators) {
            return MapEntry(day, Map<String, double>.from(indicators));
          });
        });
      } else {
        // Create the document with default values if it doesn't exist
        await docRef.set({
          'weeklyScores': weeklyScores,
          'keyIndicators': keyIndicators,
        });
      }
    } catch (e) {
      print("Error initializing data: $e");
    }
  }

  // Method to save data to Firestore
  void saveDataToFirestore() {
    firestore.collection('user_data').doc('weekly_data').set({
      'weeklyScores': weeklyScores,
      'keyIndicators': keyIndicators,
    }).catchError((error) {
      print("Error updating data: $error");
    });
  }

  // Method to update key indicators and severity score
  void updateKeyIndicators(String day, int severityScore, Map<String, double> indicators) {
    setState(() {
      weeklyScores[day] = severityScore;
      keyIndicators[day] = indicators;
    });
    saveDataToFirestore();
  }

  // Method to determine the category based on the score
  String getCategory(int score) {
    if (score <= 9) return "Normal";
    if (score <= 18) return "Mild";
    return "Severe";
  }

  // Method to determine the category color
  Color getCategoryColor(int score) {
    if (score <= 9) return Colors.green;
    if (score <= 18) return Colors.yellow[700]!;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    List<String> daysOfWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    int? currentScore = weeklyScores[daysOfWeek[selectedDayIndex]];
    String category = getCategory(currentScore!);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mental Health Progress'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Daily Check-in Button
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
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
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                        updateKeyIndicators(today, result['severityScore'], result['indicators']);
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
            Card(
              margin: const EdgeInsets.all(16),
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
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      currentScore.toString(),
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
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                                height: score! * 10.0,
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
            // Key Indicators
            Card(
              margin: const EdgeInsets.all(16),
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
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    ...keyIndicators[daysOfWeek[selectedDayIndex]]!.entries.map((entry) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.key,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Slider(
                            value: entry.value,
                            min: 0,
                            max: 3,
                            onChanged: null, // Read-only slider
                          ),
                          const SizedBox(height: 8),
                        ],
                      );
                    }),
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

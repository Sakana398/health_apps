import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DailyQuestionsPage extends StatefulWidget {
  const DailyQuestionsPage({super.key});

  @override
  _DailyQuestionsPageState createState() => _DailyQuestionsPageState();
}

class _DailyQuestionsPageState extends State<DailyQuestionsPage> {
  int currentQuestionIndex = 0;
  List<String> questions = [
    'On a scale of 1-3, how are you feeling today?',
    'On a scale of 1-3, how is your stress level?',
    'On a scale of 1-3, how is your sleep quality?',
    'On a scale of 1-3, how is your energy level?',
    'On a scale of 1-3, how is your social engagement?',
    'On a scale of 1-3, how is your focus?',
    'On a scale of 1-3, how is your coping ability?',
    'On a scale of 1-3, how is your sense of purpose?',
    'On a scale of 1-3, how is your physical activity?',
  ];

  int currentTopicIndex = 0;
  List<String> topics = [
    'MOOD',
    'STRESS LEVEL',
    'SLEEP QUALITY',
    'ENERGY LEVEL',
    'SOCIAL CONNECTION',
    'FOCUS',
    'COPING ABILITY',
    'SENSE OF PURPOSE',
    'PHYSICAL ACTIVITY',
  ];

  Map<int, int> responses = {};

  void nextQuestion(int response) {
    setState(() {
      responses[currentQuestionIndex] = response;
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      } else {
        // Calculate severity score and indicators
        int severityScore = responses.values.reduce((a, b) => a + b);
        Map<String, double> indicators = {
          "Mood": responses[0]?.toDouble() ?? 0.0,
          "Stress Level": responses[1]?.toDouble() ?? 0.0,
          "Sleep Quality": responses[2]?.toDouble() ?? 0.0,
          "Energy Level": responses[3]?.toDouble() ?? 0.0,
          "Social Engagement": responses[4]?.toDouble() ?? 0.0,
          "Focus": responses[5]?.toDouble() ?? 0.0,
          "Coping Ability": responses[6]?.toDouble() ?? 0.0,
          "Sense of Purpose": responses[7]?.toDouble() ?? 0.0,
          "Physical Activity": responses[8]?.toDouble() ?? 0.0,
        };
        Navigator.pop(context,
            {"severityScore": severityScore, "indicators": indicators});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Questions'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value: (currentQuestionIndex + 1) / questions.length,
              color: Colors.blueAccent,
            ),
            SizedBox(height: 16),
            Text(
              'Question ${currentQuestionIndex + 1}/${questions.length}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 100),
            Text(
              topics[currentQuestionIndex],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              questions[currentQuestionIndex],
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 50),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              Text(
                '1',
                style: GoogleFonts.lato(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '2',
                style: GoogleFonts.lato(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '3',
                style: GoogleFonts.lato(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]),
            Slider(
              value: responses[currentQuestionIndex]?.toDouble() ?? 2.0,
              activeColor: Colors.blueAccent, // Active part color
              inactiveColor: Colors.lightBlueAccent, // Inactive part color
              min: 1,
              max: 3,
              divisions: 2,
              label: responses[currentQuestionIndex]?.toString() ?? '2',
              onChanged: (value) {
                setState(() {
                  responses[currentQuestionIndex] = value.toInt();
                });
              },
            ),
            ElevatedButton(
              onPressed: () =>
                  nextQuestion(responses[currentQuestionIndex] ?? 2),
              child: Text(
                currentQuestionIndex == questions.length - 1
                    ? 'Submit'
                    : 'Next Question',
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

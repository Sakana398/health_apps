import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_apps/screens/user/training1.dart';
import 'package:health_apps/screens/user/training2.dart';
import 'package:health_apps/screens/user/training3.dart';
import 'package:health_apps/screens/user/training4.dart';

class MentalTrainingScreen extends StatelessWidget {
  const MentalTrainingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Light background
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Mental Training',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              'Train and experience for a stronger mind',
              style: GoogleFonts.lato(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildExerciseTile(
                    title: 'Training 1',
                    subtitle: '1-2 minutes',
                    icon: Icons.sensors,
                    iconColor: Colors.purple,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Training1(
                          ),
                        ),
                      );
                    },
                  ),
                  _buildExerciseTile(
                    title: 'Training 2',
                    subtitle: '4-5 minutes',
                    icon: Icons.monitor_heart_outlined,
                    iconColor: Colors.orangeAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Training2(
                          ),
                        ),
                      );
                    },
                  ),
                  _buildExerciseTile(
                    title: 'Training 3',
                    subtitle: '5-10 minutes',
                    icon: Icons.event_seat_outlined,
                    iconColor: Colors.pink,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Training3(
                          ),
                        ),
                      );
                    },
                  ),
                  _buildExerciseTile(
                    title: 'Training 4',
                    subtitle: '30-45 minutes',
                    icon: Icons.directions_walk,
                    iconColor: Colors.green,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Training4(
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap, // Pass the onTap function here
  }) {
    return Card(
      color: const Color.fromARGB(255, 187, 231, 251),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.2),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Color.fromARGB(255, 62, 62, 62)),
        ),
        onTap: onTap, // Use the onTap callback
      ),
    );
  }
}

class TrainingDetailScreen extends StatelessWidget {
  final String trainingName;
  final String duration;

  const TrainingDetailScreen({
    super.key,
    required this.trainingName,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text(trainingName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Text(
          '$trainingName - Duration: $duration',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

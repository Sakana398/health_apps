import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Training1 extends StatelessWidget {
  const Training1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Training 1',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Image
            Container(
              width: double.infinity,
              height: 250,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/training1.jpg'), // Replace with your image asset 
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Title Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  '5-4-3-2-1 Game',
                  style: GoogleFonts.lato(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Description Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                color: const Color.fromARGB(255, 187, 231, 251),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description',
                        style: GoogleFonts.lato(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '5 things you can see, 4 things you can touch, 3 things you can hear, '
                        '2 things you can smell, and 1 thing you can taste. This game helps bring your focus '
                        'to the present moment.',
                        style: GoogleFonts.lato(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // How to Practice Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Card(
                color: const Color.fromARGB(255, 187, 231, 251),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'How to Practice',
                        style: GoogleFonts.lato(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildPracticeStep(
                        icon: Icons.visibility,
                        text: 'Notice 5 things you can see around you',
                      ),
                      _buildPracticeStep(
                        icon: Icons.touch_app,
                        text: 'Identify 4 things you can touch',
                      ),
                      _buildPracticeStep(
                        icon: Icons.volume_up,
                        text: 'Listen for 3 things you can hear',
                      ),
                      _buildPracticeStep(
                        icon: Icons.hot_tub_outlined,
                        text: 'Acknowledge 2 things you can smell',
                      ),
                      _buildPracticeStep(
                        icon: Icons.restaurant,
                        text: 'Recognize 1 thing you can taste',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPracticeStep({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.teal.withOpacity(0.2),
            child: Icon(icon, color: Colors.teal),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.lato(
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

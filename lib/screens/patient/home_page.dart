import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_apps/carousel_slider.dart';
import 'package:health_apps/firestore_data/notification_list.dart';
import 'package:health_apps/model/card_model.dart';
import 'package:health_apps/screens/explore_list.dart';
import 'package:health_apps/screens/patient/chatbotPage.dart';
import 'package:health_apps/screens/patient/mentalTraining.dart';
import 'package:intl/intl.dart';
import 'package:health_apps/screens/patient/community.dart';
import 'package:health_apps/screens/patient/journal.dart';
import 'package:health_apps/screens/patient/maps.dart';
import 'package:health_apps/screens/patient/status.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  Future<void> _getUser() async {
    user = _auth.currentUser;
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  // To-Do List tasks
  List<String> toDoList = [];

  // Controller for the input field
  final TextEditingController taskController = TextEditingController();

  // Function to add a task to the list
  void addTask() {
    if (taskController.text.isNotEmpty) {
      setState(() {
        toDoList.add(taskController.text);
        taskController.clear();
      });
    }
  }

  // Function to remove a task from the list
  void removeTask(int index) {
    setState(() {
      toDoList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    String message = "Good";
    DateTime now = DateTime.now();
    String currentHour = DateFormat('kk').format(now);
    int hour = int.parse(currentHour);

    setState(
      () {
        if (hour >= 5 && hour < 12) {
          message = 'Good Morning';
        } else if (hour >= 12 && hour <= 17) {
          message = 'Good Afternoon';
        } else {
          message = 'Good Evening';
        }
      },
    );
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[Container()],
        backgroundColor: Colors.white,
        elevation: 0,
        title: Container(
          padding: const EdgeInsets.only(top: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                alignment: Alignment.center,
                child: Text(
                  message,
                  style: GoogleFonts.lato(
                    color: Colors.black54,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(
                width: 55,
              ),
              IconButton(
                splashRadius: 20,
                icon: const Icon(Icons.notifications_active),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (contex) => const NotificationList()));
                },
              ),
            ],
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overscroll) {
            overscroll.disallowIndicator();
            return true;
          },
          child: ListView(
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            children: <Widget>[
              Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 20, bottom: 10),
                    child: Text(
                      "Hello ${user?.displayName}",
                      style: GoogleFonts.lato(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 20, bottom: 25),
                    child: Text(
                      "Let us help you",
                      style: GoogleFonts.lato(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 23, bottom: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Quotes of the day:",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: const Carouselslider(),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Features:",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  Container(
                    height: 150,
                    padding: const EdgeInsets.only(top: 14),
                    child: ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      itemCount: cards.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(right: 14),
                          height: 150,
                          width: 140,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(cards[index].cardBackground),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade400,
                                  blurRadius: 4.0,
                                  spreadRadius: 0.0,
                                  offset: const Offset(3, 3),
                                ),
                              ]),
                          child: TextButton(
                            onPressed: () {
                              if (cards[index].doctor == "Status") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Status(),
                                  ),
                                );
                              } else if (cards[index].doctor ==
                                  "Mental Training") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MentalTrainingScreen(),
                                  ),
                                );
                              } else if (cards[index].doctor == "Journal") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => JournalScreen(),
                                  ),
                                );
                              } else if (cards[index].doctor == "Clinic") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MapsPage(),
                                  ),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ExploreList(
                                            type: cards[index].doctor,
                                          )),
                                );
                              }
                            },
                            style: ButtonStyle(
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 16,
                                ),
                                CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 29,
                                    child: Icon(
                                      cards[index].cardIcon,
                                      size: 26,
                                      color: Color(cards[index].cardBackground),
                                    )),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    cards[index].doctor,
                                    style: GoogleFonts.lato(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "To-Do List:",
                      style: GoogleFonts.lato(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  // Input field to add tasks
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: taskController,
                            decoration: InputDecoration(
                              hintText: "Enter a task",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: addTask,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[800],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text("Add", style: TextStyle(color: Colors.white)
                          )
                        ),
                      ],
                    ),
                  ),
                  // Display the To-Do List
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: toDoList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Checkbox(
                          value: false,
                          onChanged: (value) {
                            // For future expansion to mark tasks as complete
                          },
                        ),
                        title: Text(
                          toDoList[index],
                          style: GoogleFonts.lato(
                            fontSize: 16,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => removeTask(index),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

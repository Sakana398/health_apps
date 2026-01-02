# Reflectify 🧘‍♂️💙

**Reflectify** is a holistic mental health and wellness application designed to help users track their well-being, find professional help, and build healthy habits.

Built with **Flutter** and **Firebase**, it combines productivity tools (To-Do lists) with mental health resources (Training, Journaling, Chatbot) and real-world utility (Clinic Locator) to create a supportive digital environment.

## 🚀 Key Features

- **🤖 AI ChatBot**: A conversational assistant to support users (powered by custom logic/API).
- **🏥 Clinic Locator**: Integrated **Google Maps** to find nearby mental health clinics using data from local assets.
- **🧠 Mental Training**: A curated list of guided exercises (Training 1-4) ranging from 1 to 45 minutes to strengthen mental resilience.
- **📝 Daily Journal**: A private space for users to record their thoughts and feelings.
- **✅ Task Manager**: A real-time To-Do list synced with **Cloud Firestore** to manage daily goals.
- **🦠 Disease Info**: A dedicated section fetching medical data from Firestore to educate users about various conditions.
- **🌅 Daily Motivation**: A carousel of motivational quotes to start the day positively.

## 🛠️ Tech Stack

### Mobile App (Flutter)
- **Framework**: Flutter SDK 3.5+
- **Authentication**: `firebase_auth` (Email/Password & Social Login)
- **Database**: `cloud_firestore` (Real-time data for tasks and disease info)
- **Maps**: `Maps_flutter` (Location services)
- **UI Components**: `carousel_slider`, `google_fonts`, `google_nav_bar`

### Backend (Firebase)
- **Firebase Auth**: User management.
- **Cloud Firestore**: NoSQL database for storing user tasks and static content (disease info).

## 📸 Screenshots

| Home Dashboard | Mental Training | Clinic Locator |
|:---:|:---:|:---:|
| <img src="assets/poster2.png" width="250" alt="Home Screen" /> | <img src="assets/training1.jpg" width="250" alt="Training Screen" /> | <img src="assets/image-medical.jpg" width="250" alt="Clinic Map" /> |

*(Note: Replace the image paths above with actual screenshot URLs if you host them on GitHub, or use the assets provided in your project)*

## 📂 Project Structure

```bash
lib/
├── controller/       # Business logic (e.g., ChatBot service)
├── firestore_data/   # Data handling for user details
├── model/            # Data models (Card, Banner, Locations)
├── screens/
│   ├── user/         # User-facing screens (Home, Maps, Journal, ChatBot)
│   ├── disease.dart  # Disease information list
│   └── ...           # Auth and Onboarding screens
├── main.dart         # Entry point
└── firebase_options.dart # Firebase configuration

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

| Home Dashboard | Mental Health Progress | Clinic Locator | Community Chat |
|:---:|:---:|:---:|:---:|
| <img width="250" alt="image" src="https://github.com/user-attachments/assets/971ccdb3-f9ef-4326-b576-f1ed60f5d49e" />
 | <img width="250" alt="image" src="https://github.com/user-attachments/assets/42e59ac1-5a70-471b-9274-a7fc936cae97" />
 | <img width="800" height="1280" alt="image" src="https://github.com/user-attachments/assets/bf7a706a-817e-4f7e-b09e-616298d7964e" />
 | <img width="800" height="1280" alt="image" src="https://github.com/user-attachments/assets/15d046d4-ba41-4833-903a-e0199c00c9bd" /> |

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

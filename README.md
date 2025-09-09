Books Discovery App


Overview

Books Discovery App is a cross-platform mobile application built using Flutter. It allows users to explore, search, and analyze books data. The app supports barcode and QR code scanning for easy search and includes analytics based on user activity (users’ search data).



Features

Authentication: Email/password and Google Sign-In.

Search: Search books using text input, barcode, or QR code scanning.

Analytics: Visual representation of categories distribution and publishing trends.

Contacts Access: Fetch and display contacts from the device (with permission).

State Management: Uses Riverpod for managing application state.



Firebase Setup

Create a Firebase Project

Go to Firebase Console
 and create a new project.

Add App to Firebase

Add Android and iOS apps to your Firebase project.

Enable Firebase Services

Authentication: Enable Email/Password and Google Sign-In.

Download Configuration Files

google-services.json for Android

GoogleService-Info.plist for iOS

Add Flutter Dependencies

firebase_core: ^2.24.0
firebase_auth: ^4.9.0
firebase_storage: ^11.3.0
google_sign_in: ^6.2.4
flutter_riverpod: ^2.4.0


Initialize Firebase in main.dart

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}



Search Mechanism

Users can search books using:

Text Input: Manual entry of book title or author.

Barcode/QR Code Scanning:

The app scans the code using the device camera.

Extracted code (ISBN or title) is sent to the search API.

The API returns matching books which are displayed in the app.



Analytics Logic

Analytics are calculated based on local search history stored on the device.

Categories Distribution:

Counts how many times each book category has been searched.

Displayed as a doughnut chart.



Publishing Trend:

Counts books based on publishing year ranges.

Displayed as a combined column and line chart.

Charts are updated automatically whenever the local data changes.



Steps to Run the Project

Clone the repository:

git clone https://github.com/pawaravya/books_discovery_app.git


Navigate to the project folder:

cd books_discovery_app


Install dependencies:

flutter pub get


Run the app:

flutter run



screenshots of the app
<img width="1080" height="2160" alt="Screenshot_20250909-193525" src="https://github.com/user-attachments/assets/d2f02ddb-41e0-44d6-bc5a-8e24167f20f7" />
<img width="1080" height="2160" alt="Screenshot_20250909-193457" src="https://github.com/user-attachments/assets/465123b7-02e8-499b-9f58-4a49560172b7" />
<img width="1080" height="2160" alt="Screenshot_20250909-193355" src="https://github.com/user-attachments/assets/f8ea7ec4-3253-43c0-a044-640d1c00d138" />
<img width="1080" height="2160" alt="Screenshot_20250909-193344" src="https://github.com/user-attachments/assets/a9e757cd-fd32-49c1-85b8-44d8e127d200" />
<img width="1080" height="2160" alt="Screenshot_20250909-193425" src="https://github.com/user-attachments/assets/1ffa515b-d0d1-4c37-b9d1-6694d011d56b" />
<img width="1080" height="2160" alt="Screenshot_20250909-193509" src="https://github.com/user-attachments/assets/db9f3551-157f-44a2-8635-3014d7d14ad5" />
<img width="1080" height="2160" alt="Screenshot_20250909-193517" src="https://github.com/user-attachments/assets/25f9203d-65a7-463c-a945-12a6ce152331" />
<img width="1080" height="2160" alt="Screenshot_20250909-193429" src="https://github.com/user-attachments/assets/eaf8be33-be37-41e5-ac88-e8d328003dde" />
<img width="1080" height="2160" alt="Screenshot_20250909-193451" src="https://github.com/user-attachments/assets/b0b59b80-aaa5-41cc-b3d6-0f05adcdc2fd" />
<img width="1080" height="2160" alt="Screenshot_20250909-193441" src="https://github.com/user-attachments/assets/2283b4f6-d1a3-4828-8aa6-9fc46569c359" />
<img width="1080" height="2160" alt="Screenshot_20250909-193414" src="https://github.com/user-attachments/assets/5d0860b7-2747-4970-b480-c641a213c78d" />


























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

git clone <repo-url>


Navigate to the project folder:

cd books_discovery_app


Install dependencies:

flutter pub get


Run the app:

flutter run

Books Discovery App
#Overview
Books Discovery App is a cross-platform mobile application built using Flutter. It allows users to explore, search, and analyze books data. The app supports barcode and QR code scanning for easy search and includes analytics based on user activity(Users search data).

#Features
Authentication: Email/password and Google Sign-In.
Search: Search books using text, barcode, or QR code scanning.
Analytics: Visual representation of categories distribution and publishing trends.
Contacts Access: Fetch and display contacts from the device (with permission).
state management: used riverpod for state management 

#Firebase Setup
1.Create a Firebase Project
2.Go to Firebase Consoleand create a new project.
3.Add App to Firebase
4.Enable Firebase Services 
Authentication: Enable Email/Password and Google Sign-In.
5.Download and add google-services.json (Android) and GoogleService-Info.plist (iOS) to your project.
6.Add Flutter Dependencies
firebase_core: ^2.24.0
firebase_auth: ^4.9.0
firebase_storage: ^11.3.0
google_sign_in: ^6.2.4
flutter_riverpod: ^2.4.0

#Search Mechanism
Users can search books using:
Text input: Manual entry of book or author.

Barcode/QR code scanning:
The app scans the code using the device camera.
Extracted code is sent to the search API(ISBN or title).
API returns matching books which are displayed in the app.

#Analytics Logic
Analytics are calculated based on local search history stored in the device.
Two main charts:
Categories Distribution:
Counts how many times each book category has been searched.
Displayed as a doughnut chart.

Publishing Trend:
Counts books based on publishing year ranges.
Displayed as a combined column and line chart.
Charts are updated whenever the local data changes.

#Steps to run the code 
1. clone the using repo url :
2.flutter pub get
3.flutter run

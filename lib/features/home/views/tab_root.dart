import 'dart:ui';

import 'package:flutter/material.dart';

class TabRoot extends StatelessWidget {
  final String tab;
  final VoidCallback onNext;
  const TabRoot({required this.tab, required this.onNext, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title = "";
    Widget content;

    switch (tab) {
      case "home":
        title = "Home";
        content = const Text("🏠 This is the Home tab");
        break;
      case "analytics":
        title = "Analytics";
        content = const Text("📊 Analytics dashboard here");
        break;
      case "search":
        title = "Search";
        content = const Text("🔍 Search functionality goes here");
        break;
      case "contacts":
        title = "Contacts";
        content = const Text("📞 Your contacts list");
        break;
      case "profile":
        title = "Profile";
        content = const Text("👤 User Profile page");
        break;
      default:
        title = tab;
        content = Text("Unknown tab: $tab");
    }

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            content,
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onNext,
              child: Text("Go deeper in $title"),
            ),
          ],
        ),
      ),
    );
  }
}

// features/home/views/main_tab_screen.dart
import 'package:flutter/material.dart';
// Import your actual tab screen widgets
import 'home_tab.dart';
import '../../anyalytics/views/anyalytics_tab.dart'; // Assuming this is the correct filename/spelling
import '../../contacts/views/contacts_tab.dart';
import '../../profile/views/profile_tab.dart';

class MainTabScreen extends StatefulWidget {
  const MainTabScreen({super.key});

  @override
  State<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen> {
  int _currentIndex = 0; // Start with Home tab (index 0)

  // GlobalKey for each tab's Navigator to potentially access its state if needed
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(), // Home Tab Navigator Key
    GlobalKey<NavigatorState>(), // Analytics Tab Navigator Key
    GlobalKey<NavigatorState>(), // Contacts Tab Navigator Key
    GlobalKey<NavigatorState>(), // Profile Tab Navigator Key
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          // Each child is a Navigator managing its own stack
          _buildTabNavigator(0, const HomeTab()),
          _buildTabNavigator(1, const AnalyticsTab()),
          _buildTabNavigator(2, const ContactsTab()),
          _buildTabNavigator(3, const ProfileTab()),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Good for 3+ items
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: 'Contacts',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  // Helper to build a Navigator for a specific tab
  Widget _buildTabNavigator(int tabIndex, Widget firstScreen) {
    return Navigator(
      key: _navigatorKeys[tabIndex],
      // onGenerateRoute defines how routes are created within this specific Navigator
      onGenerateRoute: (settings) {
        Widget? pageChild;

        // Determine the widget to show based on the route name
        // For simplicity, we'll mostly push the 'firstScreen' for the base route
        // and demonstrate navigation with a placeholder for details.
        switch (settings.name) {
          case '/': // Default initial route for this Navigator
            // Show the initial screen passed for this tab
            pageChild = firstScreen;
            break;
          // --- Example: Specific route for Home Details ---
          case '/home/details':
            // In a real app, you'd pass arguments like an ID
            // final args = settings.arguments as Map<String, dynamic>?;
            pageChild = Scaffold(
              appBar: AppBar(title: Text("Home Detail")),
              body: Center(
                child: Text("This is a detail page within the Home tab!"),
              ),
            );
            break;
          // --- Example: Specific route for Profile Settings ---
          case '/profile/settings':
            pageChild = Scaffold(
              appBar: AppBar(title: Text("Settings")),
              body: Center(child: Text("Profile Settings Screen")),
            );
            break;
          // --- Add more cases for other tabs' nested routes as needed ---
          default:
            // Handle unknown routes within a tab
            pageChild = Scaffold(
              appBar: AppBar(title: const Text("Not Found")),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Unknown route: ${settings.name}'),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Go Back'),
                    ),
                  ],
                ),
              ),
            );
        }

        // Return a MaterialPageRoute to display the chosen widget
        return MaterialPageRoute(
          settings: settings, // Pass the original route settings
          builder: (context) => pageChild!,
        );
      },
    );
  }
}

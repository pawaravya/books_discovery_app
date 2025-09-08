// features/home/views/main_tab_screen.dart
import 'package:books_discovery_app/features/home/models/books_model.dart';
import 'package:books_discovery_app/features/home/views/book_details_screen.dart';
import 'package:books_discovery_app/features/home/views/qr_code_scanner_screen.dart';
import 'package:books_discovery_app/shared/widgets/app_view_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    return WillPopScope(
      onWillPop: () async {
        final NavigatorState currentTabNavigator =
            _navigatorKeys[_currentIndex].currentState!;

        if (currentTabNavigator.canPop()) {
          currentTabNavigator.pop(); // pop inside the tab
          return false; // prevent quitting the app
        }
        var isExit = AppViewUtils.showAppExitConfirmation(context, () {
          SystemNavigator.pop();
        });
        return isExit;
      },
      child: Scaffold(
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
      ),
    );
  }

  // Helper to build a Navigator for a specific tab
  Widget _buildTabNavigator(int tabIndex, Widget firstScreen) {
    return Navigator(
      key: _navigatorKeys[tabIndex],
      onGenerateRoute: (settings) {
        Widget? pageChild;
        switch (settings.name) {
          case '/': // Default initial route for this Navigator
            pageChild = firstScreen;
            break;
          case '/home/scanner_screen':
            pageChild = QrScannerScreen();
          case '/home/book_details':
            final book = settings.arguments as Book; // 👈 your Book model
            pageChild = BookDetailsScreen(book: book, heroTag: '');
            break;

          default:
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
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => pageChild!,
        );
      },
    );
  }
}

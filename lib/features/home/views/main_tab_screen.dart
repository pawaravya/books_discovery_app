// features/home/views/main_tab_screen.dart
import 'package:books_discovery_app/core/constants/color_constants.dart';
import 'package:books_discovery_app/core/constants/image_constants.dart';
import 'package:books_discovery_app/features/home/models/books_model.dart';
import 'package:books_discovery_app/features/home/views/book_details_screen.dart';
import 'package:books_discovery_app/features/home/views/qr_code_scanner_screen.dart';
import 'package:books_discovery_app/shared/widgets/app_view_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
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
        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
          return false;
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
            _buildTabNavigator(0, const HomeTab()),
            _buildTabNavigator(1, AnalyticsTab(key: ValueKey(_currentIndex))),
            _buildTabNavigator(2, const ContactsTab()),
            _buildTabNavigator(3, const ProfileTab()),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          elevation: 8,
          iconSize: 25,
          selectedItemColor: HexColor(ColorConstants.themeColor),

          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
          items: [
            _buildNavBarItem(ImageConstants.tabHomeIcon, "Home", 0),
            _buildNavBarItem(ImageConstants.tabAnyalyticsIcon, "Analytics", 1),
            _buildNavBarItem(ImageConstants.tabContactsIcon, "Contacts", 2),
            _buildNavBarItem(ImageConstants.tabProfileIcon, "Profile", 3),
          ],
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
        }
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => pageChild!,
        );
      },
    );
  }

  BottomNavigationBarItem _buildNavBarItem(
    String asset,
    String label,
    int index,
  ) {
    return BottomNavigationBarItem(
      label: label,
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_currentIndex == index)
            Container(
              height: 3,
              width: 30,
              margin: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                color: HexColor(
                  ColorConstants.themeColor,
                ), // change color as needed
                borderRadius: BorderRadius.circular(2),
              ),
            )
          else
            const SizedBox(height: 15), // keeps spacing same
          AppViewUtils.getAssetImageSVG(
            asset,
            color: index != _currentIndex
                ? HexColor(ColorConstants.searchInputColor)
                : HexColor(ColorConstants.themeColor),
          ),
        ],
      ),
    );
  }
}

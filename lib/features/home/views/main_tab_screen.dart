import 'package:books_discovery_app/features/home/views/anyalytics_tab.dart';
import 'package:books_discovery_app/features/home/views/contacts_tab.dart';
import 'package:books_discovery_app/features/home/views/home_tab.dart';
import 'package:books_discovery_app/features/home/views/nav_item.dart'; // Ensure this path is correct
import 'package:books_discovery_app/features/home/views/profile_tab.dart';
import 'package:flutter/material.dart';

// Make sure this matches the 'page' property in AppRouter for the main tab route
// @RoutePage(name: 'MainTabScreen') // Name matches AppRouter entry point name
class MainTabScreen extends StatelessWidget {
  const MainTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
        return  Container() ;

    // return
    //  AutoTabsScaffold(
    //   // Reference the named tab routes defined in AppRouter
    //   // These names correspond to the 'name' property in AppRouter's children
    //   routes: const [
    //     // HomeTab(),      
    //     // AnalyticsTab(),  // Name matches AppRouter's name: 'AnalyticsTab'
    //     // ContactsTab(),   // Name matches AppRouter's name: 'ContactsTab'
    //     // ProfileTab(),    // Name matches AppRouter's name: 'ProfileTab'
    //   ],
    //   floatingActionButton: FloatingActionButton(
    //     shape: const CircleBorder(),
    //     onPressed: () {
    //       // Example action for FAB
    //       ScaffoldMessenger.of(context)
    //           .showSnackBar(const SnackBar(content: Text("Search Clicked!")));
    //     },
    //     child: const Icon(Icons.search),
    //   ),
    //   floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    //   bottomNavigationBuilder: (_, tabsRouter) {
    //     return BottomAppBar(
    //       shape: const CircularNotchedRectangle(),
    //       notchMargin: 6,
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceAround,
    //         children: [
    //           NavItem(
    //             icon: Icons.home,
    //             label: "Home",
    //             index: 0,
    //             tabsRouter: tabsRouter,
    //           ),
    //           NavItem(
    //             icon: Icons.analytics,
    //             label: "Analytics",
    //             index: 1,
    //             tabsRouter: tabsRouter,
    //           ),
    //           const SizedBox(width: 48), // gap for FAB
    //           NavItem(
    //             icon: Icons.contacts,
    //             label: "Contacts",
    //             index: 2,
    //             tabsRouter: tabsRouter,
    //           ),
    //           NavItem(
    //             icon: Icons.person,
    //             label: "Profile",
    //             index: 3,
    //             tabsRouter: tabsRouter,
    //           ),
    //         ],
    //       ),
    //     );
    //   },
    // );
  }
}
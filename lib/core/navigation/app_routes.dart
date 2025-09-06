// routes.dart
class AppRoutes {
  static const String splash = '/'; // Initial route
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  
  // Main tab structure routes
  static const String mainTabs = '/main'; // Route for the main tabbed interface
  static const String homeTabBase = '/main/home'; // Base route for Home tab
  static const String homeTabDetails = '/main/home/details'; // Nested route for Home details
  // Add similar base/detail routes for other tabs
  static const String analyticsTabBase = '/main/analytics';
  static const String searchTabBase = '/main/search';
  static const String contactsTabBase = '/main/contacts';
  static const String profileTabBase = '/main/profile';
  // Example nested route for profile
  static const String profileSettings = '/main/profile/settings';
}
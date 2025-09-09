import 'package:permission_handler/permission_handler.dart';

class PermissionHandlerService {
  // Request a specific permission
  static Future<bool> requestPermission(Permission permission) async {
    final status = await permission.status;
    if (status.isGranted) return true;

    final result = await permission.request();
    return result.isGranted;
  }

  // Request multiple permissions at once
  static Future<Map<Permission, PermissionStatus>> requestPermissions(
    List<Permission> permissions,
  ) async {
    return await permissions.request();
  }

  // Check if permission is granted
  static Future<bool> isPermissionGranted(Permission permission) async {
    final status = await permission.status;
    return status.isGranted;
  }

  static Future<void> requestRequiredPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera, // 📸 Camera access
      Permission.photos, // 🖼 iOS Photos library
      Permission.videos, // 🎥 iOS Videos library
      Permission.storage, // 📂 Android storage (legacy)
      Permission.manageExternalStorage, // 📂 Android 11+ storage
      Permission.contacts, // 👥 Contacts
      Permission.microphone, // 🎤 For camera/video recording
    ].request();

    // Optional: print or handle results
    statuses.forEach((permission, status) {
      print('$permission: $status');
    });
  }
}

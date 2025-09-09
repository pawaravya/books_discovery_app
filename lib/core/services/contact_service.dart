import 'package:flutter_contacts/flutter_contacts.dart';
import 'permission_handler_service.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactService {
  static Future<List<Contact>> getAllContacts() async {
    final status = await Permission.contacts.status;

    if (status.isGranted) {
      return _fetchContacts();
    } else {
      bool isGranted = await PermissionHandlerService.requestPermission(
        Permission.contacts,
      );

      if (isGranted) {
        return _fetchContacts();
      } else {
        return [];
      }
    }
  }

  static Future<List<Contact>> _fetchContacts() async {
    return await FlutterContacts.getContacts(
      withProperties: true,
      withPhoto: true,
    );
  }
}

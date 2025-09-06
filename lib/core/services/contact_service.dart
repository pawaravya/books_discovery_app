import 'package:flutter_contacts/flutter_contacts.dart';
import 'permission_handler_service.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactService {
  // Fetch all contacts (after checking permission)
  static Future<List<Contact>> getAllContacts() async {
    // Request contacts permission
    bool isGranted = await PermissionHandlerService.requestPermission(Permission.contacts);
    if (!isGranted) return [];
    // Fetch contacts with phone and email
    List<Contact> contacts = await FlutterContacts.getContacts(
      withProperties: true, // include phone, email
      withPhoto: false,      // optional: set true if you want contact photos
    );

    return contacts;
  }
}

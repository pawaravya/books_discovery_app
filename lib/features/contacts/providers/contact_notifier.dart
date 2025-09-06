import 'package:books_discovery_app/core/services/contact_service.dart';
import 'package:books_discovery_app/features/contacts/models/contact_screen_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_contacts/flutter_contacts.dart';


class ContactsStateNotifier extends StateNotifier<ContactsScreenState> {
  ContactsStateNotifier() : super(ContactsScreenState.initial());

  Future<void> fetchContacts() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final contacts = await ContactService.getAllContacts();
      state = state.copyWith(contacts: contacts, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> refresh() async {
    await fetchContacts();
  }
}

final contactsProvider =
    StateNotifierProvider<ContactsStateNotifier, ContactsScreenState>((ref) {
  return ContactsStateNotifier();
});

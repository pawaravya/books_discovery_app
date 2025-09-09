import 'package:flutter_contacts/flutter_contacts.dart';

class ContactsScreenState {
  final List<Contact> contacts;
  final bool isLoading;
  final String? error;

  ContactsScreenState({
    required this.contacts,
    required this.isLoading,
    this.error,
  });

  ContactsScreenState copyWith({
    List<Contact>? contacts,
    bool? isLoading,
    String? error,
  }) {
    return ContactsScreenState(
      contacts: contacts ?? this.contacts,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  factory ContactsScreenState.initial() {
    return ContactsScreenState(
      contacts: [],
      isLoading: false,
      error: null,
    );
  }
}

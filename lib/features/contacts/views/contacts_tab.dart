import 'package:books_discovery_app/features/contacts/providers/contact_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class ContactsTab extends ConsumerWidget {
  const ContactsTab({Key? key}) : super(key: key);

  void _showContactDetail(BuildContext context, Contact contact) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Name: ${contact.displayName}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            if (contact.phones.isNotEmpty)
              Text("Phone: ${contact.phones.first.number}"),
            if (contact.emails.isNotEmpty)
              Text("Email: ${contact.emails.first.address}"),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(contactsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Contacts"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(contactsProvider.notifier).refresh(),
          ),
        ],
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Error: ${state.error}"),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        ref.read(contactsProvider.notifier).refresh(),
                    child: const Text("Retry"),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: state.contacts.length,
              itemBuilder: (context, index) {
                final contact = state.contacts[index];
                return ListTile(
                  title: Text(contact.displayName),
                  subtitle: contact.phones.isNotEmpty
                      ? Text(contact.phones.first.number)
                      : null,
                  onTap: () => _showContactDetail(context, contact),
                );
              },
            ),
    );
  }
}

import 'package:books_discovery_app/core/constants/color_constants.dart';
import 'package:books_discovery_app/features/contacts/providers/contact_notifier.dart';
import 'package:books_discovery_app/shared/widgets/app_loade.dart';
import 'package:books_discovery_app/shared/widgets/app_text.dart';
import 'package:books_discovery_app/shared/widgets/base_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:hexcolor/hexcolor.dart';

class ContactsTab extends ConsumerStatefulWidget {
  const ContactsTab({super.key});

  @override
  ConsumerState<ContactsTab> createState() => _ContactTabScreenState();
}

class _ContactTabScreenState extends ConsumerState<ContactsTab>
    with WidgetsBindingObserver {
  void _showContactDetail(BuildContext context, Contact contact) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 👈 makes it full width
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            Text(
              contact.displayName.isNotEmpty
                  ? contact.displayName
                  : "Unknown Name",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (contact.phones.isNotEmpty)
              Text(" Phone: ${contact.phones.first.number}"),
            if (contact.emails.isNotEmpty)
              Text("Email: ${contact.emails.first.address}"),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this); // 👈 add observer
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchContacts();
    });
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // 👈 remove observer

    super.dispose();
  }

  Future<void> fetchContacts() async {
    await ref.read(contactsProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(contactsProvider);

    return BaseWidget(
      screen: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: AppText(
              "Contacts",
              textAlign: TextAlign.start,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          if (state.isLoading)
            Expanded(child: Center(child: AppLoader.loaderWidget()))
          else if (state.error != null)
            Expanded(
              child: Center(
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
              ),
            )
          else if (state.contacts.isEmpty)
            AppText("No Contacts found!")
          else
            Expanded(
              child: ListView.builder(
                itemCount: state.contacts.length,
                itemBuilder: (context, index) {
                  final contact = state.contacts[index];
                  final phone = contact.phones.isNotEmpty
                      ? contact.phones.first.number
                      : "No number";
                  final initial = contact.displayName.isNotEmpty
                      ? contact.displayName[0].toUpperCase()
                      : "?";

                  return GestureDetector(
                    onTap: () => _showContactDetail(context, contact),
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 2,
                        vertical: 12,
                      ),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: HexColor(
                              ColorConstants.themeColor,
                            ),
                            child: AppText(
                              initial,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              phone,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../data/important_contacts_data.dart';
import '../../widgets/contact_card.dart';

class ImportantContactsScreen extends StatelessWidget {
  const ImportantContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Important Contacts')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: importantContacts.length,
            itemBuilder: (context, index) => ContactCard(contact: importantContacts[index]),
          ),
        ),
      ),
    );
  }
}

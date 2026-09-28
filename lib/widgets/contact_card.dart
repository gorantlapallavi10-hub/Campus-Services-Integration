import 'package:flutter/material.dart';

import '../models/important_contact_model.dart';
import '../utils/launcher_helper.dart';

/// Card for one entry on the Important Contacts screen.
class ContactCard extends StatelessWidget {
  final ImportantContact contact;

  const ContactCard({super.key, required this.contact});

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final color = contact.isEmergency ? Colors.red : Colors.indigo;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: contact.isEmergency ? const BorderSide(color: Colors.red, width: 1.5) : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withAlpha(30),
                  child: Icon(contact.isEmergency ? Icons.emergency : Icons.contacts, color: color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(contact.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(contact.department, style: TextStyle(color: Colors.grey.shade700)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.phone, size: 16),
                const SizedBox(width: 6),
                Text(contact.phone),
              ],
            ),
            if (contact.email != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.email_outlined, size: 16),
                  const SizedBox(width: 6),
                  Expanded(child: Text(contact.email!)),
                ],
              ),
            ],
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: [
                FilledButton.icon(
                  onPressed: () async {
                    final ok = await callNumber(contact.phone);
                    if (!ok && context.mounted) {
                      _showMessage(context, 'Unable to open the phone app.');
                    }
                  },
                  icon: const Icon(Icons.call),
                  label: const Text('Call'),
                ),
                if (contact.email != null)
                  OutlinedButton.icon(
                    onPressed: () async {
                      final ok = await sendEmail(contact.email!);
                      if (!ok && context.mounted) {
                        _showMessage(context, 'Unable to open the email app.');
                      }
                    },
                    icon: const Icon(Icons.email),
                    label: const Text('Email'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

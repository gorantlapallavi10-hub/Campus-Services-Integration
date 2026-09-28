import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/lost_found_model.dart';
import '../../utils/launcher_helper.dart';
import '../../widgets/lost_found_card.dart';

class ItemDetailsScreen extends StatelessWidget {
  final LostFoundItem item;

  const ItemDetailsScreen({super.key, required this.item});

  // Simple contact: email -> email app, otherwise -> phone dialer.
  Future<void> _contactPerson(BuildContext context) async {
    final contact = item.contact.trim();
    final ok = contact.contains('@') ? await sendEmail(contact) : await callNumber(contact);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to open the app. Contact: $contact')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Item Details')),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ItemImage(imageUrl: item.imageUrl, height: 260),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.itemName,
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                          StatusChip(type: item.type),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _DetailRow(icon: Icons.description_outlined, label: 'Description', value: item.description),
                      _DetailRow(icon: Icons.location_on_outlined, label: 'Location', value: item.location),
                      _DetailRow(
                        icon: Icons.calendar_today_outlined,
                        label: 'Date',
                        value: DateFormat('d MMMM yyyy').format(item.date),
                      ),
                      _DetailRow(icon: Icons.contact_phone_outlined, label: 'Contact', value: item.contact),
                      _DetailRow(
                        icon: Icons.access_time,
                        label: 'Reported on',
                        value: DateFormat('d MMMM yyyy, h:mm a').format(item.createdAt),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () => _contactPerson(context),
                          icon: const Icon(Icons.call),
                          label: const Text('Contact Person'),
                          style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.indigo),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                Text(value, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

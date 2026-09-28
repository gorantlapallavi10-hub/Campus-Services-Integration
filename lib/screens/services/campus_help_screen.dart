import 'package:flutter/material.dart';

import '../../data/campus_help_data.dart';
import '../../models/campus_service_model.dart';
import '../../utils/launcher_helper.dart';

/// Shows all help services, or only one when [filterName] is given
/// (e.g. the "Security" card on the Services screen).
class CampusHelpScreen extends StatelessWidget {
  final String? filterName;

  const CampusHelpScreen({super.key, this.filterName});

  @override
  Widget build(BuildContext context) {
    final services = filterName == null
        ? campusHelpServices
        : campusHelpServices.where((s) => s.name == filterName).toList();

    return Scaffold(
      appBar: AppBar(title: Text(filterName ?? 'Campus Help')),
      body: services.isEmpty
          ? const Center(child: Text('No services available.'))
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: services.length,
                  itemBuilder: (context, index) => _HelpCard(service: services[index]),
                ),
              ),
            ),
    );
  }
}

class _HelpCard extends StatelessWidget {
  final CampusService service;

  const _HelpCard({required this.service});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: service.color.withAlpha(30),
                  child: Icon(service.icon, color: service.color, size: 26),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    service.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(service.description),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 18),
                const SizedBox(width: 6),
                Expanded(child: Text(service.location)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.phone, size: 18),
                const SizedBox(width: 6),
                Text(service.contactNumber),
              ],
            ),
            const SizedBox(height: 10),
            FilledButton.icon(
              onPressed: () async {
                final ok = await callNumber(service.contactNumber);
                if (!ok && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Unable to open the phone app.')),
                  );
                }
              },
              icon: const Icon(Icons.call),
              label: const Text('Call'),
            ),
          ],
        ),
      ),
    );
  }
}

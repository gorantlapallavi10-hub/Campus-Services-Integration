import 'package:flutter/material.dart';

import '../../widgets/service_card.dart';
import 'campus_help_screen.dart';
import 'important_contacts_screen.dart';
import 'lost_found_screen.dart';

/// Main screen of the Services tab. This is the only entry point
/// teammates need for the bottom navigation.
class CampusServicesScreen extends StatelessWidget {
  const CampusServicesScreen({super.key});

  void _open(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Campus Services')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'How can we help you today?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text('Choose a service below.', style: TextStyle(color: Colors.grey.shade700)),
          const SizedBox(height: 16),
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            // Cards get wider on big screens and the number of columns adapts.
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 240,
              mainAxisExtent: 175,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            children: [
              ServiceCard(
                icon: Icons.search,
                title: 'Lost & Found',
                description: 'Report or find lost items on campus.',
                color: Colors.purple,
                onTap: () => _open(context, const LostFoundScreen()),
              ),
              ServiceCard(
                icon: Icons.support_agent,
                title: 'Campus Help',
                description: 'Security, medical, transport and technical help.',
                color: Colors.blue,
                onTap: () => _open(context, const CampusHelpScreen()),
              ),
              ServiceCard(
                icon: Icons.contacts,
                title: 'Important Contacts',
                description: 'Phone numbers and emails of key offices.',
                color: Colors.green,
                onTap: () => _open(context, const ImportantContactsScreen()),
              ),
              ServiceCard(
                icon: Icons.shield,
                title: 'Security',
                description: 'Contact campus security for safety issues.',
                color: Colors.indigo,
                onTap: () => _open(context, const CampusHelpScreen(filterName: 'Security')),
              ),
              ServiceCard(
                icon: Icons.local_hospital,
                title: 'Medical Help',
                description: 'First aid and health center details.',
                color: Colors.red,
                onTap: () => _open(context, const CampusHelpScreen(filterName: 'Medical Help')),
              ),
              ServiceCard(
                icon: Icons.directions_bus,
                title: 'Transport',
                description: 'College bus and transport information.',
                color: Colors.orange,
                onTap: () => _open(context, const CampusHelpScreen(filterName: 'Transport')),
              ),
              ServiceCard(
                icon: Icons.computer,
                title: 'Technical Help',
                description: 'Wi-Fi, labs and portal support.',
                color: Colors.teal,
                onTap: () => _open(context, const CampusHelpScreen(filterName: 'Technical Help')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

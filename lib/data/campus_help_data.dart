import 'package:flutter/material.dart';

import '../models/campus_service_model.dart';

// SAMPLE DATA - change the text/numbers here, no screen code needs to change.
// The "name" values must stay: Security, Medical Help, Transport, Technical Help
// (the Campus Services cards use them to open the right service).
const List<CampusService> campusHelpServices = [
  CampusService(
    name: 'Security',
    description: 'Campus security team available 24/7 for safety issues.',
    location: 'Main Gate Security Room',
    contactNumber: '+91 90000 00001',
    icon: Icons.shield,
    color: Colors.indigo,
  ),
  CampusService(
    name: 'Medical Help',
    description: 'First aid and basic medical care for students and staff.',
    location: 'Health Center, Ground Floor, Admin Block',
    contactNumber: '+91 90000 00002',
    icon: Icons.local_hospital,
    color: Colors.red,
  ),
  CampusService(
    name: 'Transport',
    description: 'College bus routes, timings and transport queries.',
    location: 'Transport Office, Near Parking Area',
    contactNumber: '+91 90000 00003',
    icon: Icons.directions_bus,
    color: Colors.orange,
  ),
  CampusService(
    name: 'Technical Help',
    description: 'Wi-Fi, lab computers, email and portal problems.',
    location: 'IT Help Desk, Library Building, 1st Floor',
    contactNumber: '+91 90000 00004',
    icon: Icons.computer,
    color: Colors.teal,
  ),
];

import 'package:flutter/material.dart';

/// One service shown on the Campus Help screen (Security, Medical, ...).
class CampusService {
  final String name;
  final String description;
  final String location;
  final String contactNumber;
  final IconData icon;
  final Color color;

  const CampusService({
    required this.name,
    required this.description,
    required this.location,
    required this.contactNumber,
    required this.icon,
    required this.color,
  });
}

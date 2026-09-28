/// One card on the Important Contacts screen.
class ImportantContact {
  final String name;
  final String department;
  final String phone;
  final String? email; // null when there is no email
  final bool isEmergency;

  const ImportantContact({
    required this.name,
    required this.department,
    required this.phone,
    this.email,
    this.isEmergency = false,
  });
}

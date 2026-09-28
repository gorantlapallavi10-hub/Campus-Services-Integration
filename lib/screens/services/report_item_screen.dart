import 'dart:async';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../models/lost_found_model.dart';
import '../../services/firebase_service.dart';
import '../../services/storage_service.dart';

class ReportItemScreen extends StatefulWidget {
  const ReportItemScreen({super.key});

  @override
  State<ReportItemScreen> createState() => _ReportItemScreenState();
}

class _ReportItemScreenState extends State<ReportItemScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _dateController = TextEditingController();
  final _contactController = TextEditingController();

  final _picker = ImagePicker();
  final _firebaseService = FirebaseService();
  final _storageService = StorageService();

  String _type = 'Lost'; // "Lost" or "Found"
  DateTime? _selectedDate;
  Uint8List? _imageBytes; // the picked image (used for preview + upload)
  String? _imageMimeType;
  bool _isLoading = false;

  // Uses the logged-in user's id (from Member 1's login module).
  // Falls back to 'anonymous' if nobody is signed in yet.
  String get _reportedBy => FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _dateController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  // ---------- Pick image from gallery ----------
  Future<void> _pickImage() async {
    try {
      final picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024, // make the image smaller = faster upload
        imageQuality: 75,
      );
      if (picked == null) return; // user cancelled

      final bytes = await picked.readAsBytes();
      setState(() {
        _imageBytes = bytes;
        _imageMimeType = picked.mimeType;
      });
    } catch (_) {
      _showMessage('Could not open the gallery. Please try again.');
    }
  }

  // ---------- Pick date ----------
  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('d MMMM yyyy').format(picked);
      });
    }
  }

  // ---------- Clear the form ----------
  void _clearForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _descriptionController.clear();
    _locationController.clear();
    _dateController.clear();
    _contactController.clear();
    setState(() {
      _type = 'Lost';
      _selectedDate = null;
      _imageBytes = null;
      _imageMimeType = null;
    });
  }

  // ---------- Submit ----------
  Future<void> _submit() async {
    // Stops here and shows red messages if any field is invalid.
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      // 1. Upload the image (optional) and get its download URL.
      String imageUrl = '';
      if (_imageBytes != null) {
        imageUrl = await _storageService.uploadImage(_imageBytes!, contentType: _imageMimeType);
      }

      // 2. Save the report in Firestore.
      final item = LostFoundItem(
        id: '', // Firestore creates the id
        itemName: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        location: _locationController.text.trim(),
        date: _selectedDate!,
        type: _type,
        contact: _contactController.text.trim(),
        imageUrl: imageUrl,
        reportedBy: _reportedBy,
        createdAt: DateTime.now(), // real value is set by the server
      );
      await _firebaseService.addItem(item);

      // 3. Success: clear form, show message, go back to the list.
      if (!mounted) return;
      _clearForm();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item reported successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      final message = e.toString().replaceFirst('Exception: ', '');
      _showMessage(message.isEmpty ? 'Failed to submit. Please try again.' : message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Report Item')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ----- Lost / Found -----
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'Lost', label: Text('Lost'), icon: Icon(Icons.search_off)),
                      ButtonSegment(value: 'Found', label: Text('Found'), icon: Icon(Icons.check_circle_outline)),
                    ],
                    selected: {_type},
                    onSelectionChanged: (selection) => setState(() => _type = selection.first),
                  ),
                  const SizedBox(height: 16),

                  // ----- Item name -----
                  TextFormField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: _fieldStyle('Item Name', Icons.inventory_2_outlined),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Please enter the item name.';
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  // ----- Description -----
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 3,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: _fieldStyle('Description', Icons.description_outlined),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Please enter a description.';
                      if (value.trim().length < 10) return 'Description must be at least 10 characters.';
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  // ----- Location -----
                  TextFormField(
                    controller: _locationController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: _fieldStyle('Location', Icons.location_on_outlined),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Please enter the location.';
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  // ----- Date (tap opens the calendar) -----
                  TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    onTap: _pickDate,
                    decoration: _fieldStyle('Date', Icons.calendar_today_outlined),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please select the date.';
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  // ----- Contact -----
                  TextFormField(
                    controller: _contactController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _fieldStyle('Contact (phone or email)', Icons.contact_phone_outlined),
                    validator: (value) {
                      final text = value?.trim() ?? '';
                      if (text.isEmpty) return 'Please enter your contact information.';
                      final isEmail = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(text);
                      final isPhone = RegExp(r'^\+?[0-9 ]{7,15}$').hasMatch(text);
                      if (!isEmail && !isPhone) return 'Enter a valid phone number or email.';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // ----- Image (optional) -----
                  if (_imageBytes != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(_imageBytes!, height: 200, fit: BoxFit.cover),
                    ),
                    const SizedBox(height: 8),
                  ],
                  OutlinedButton.icon(
                    onPressed: _isLoading ? null : _pickImage,
                    icon: const Icon(Icons.photo_library_outlined),
                    label: Text(_imageBytes == null ? 'Select Image from Gallery' : 'Change Image'),
                  ),
                  if (_imageBytes != null)
                    TextButton(
                      onPressed: _isLoading ? null : () => setState(() => _imageBytes = null),
                      child: const Text('Remove Image'),
                    ),
                  const SizedBox(height: 20),

                  // ----- Submit -----
                  FilledButton(
                    onPressed: _isLoading ? null : _submit,
                    style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                    child: _isLoading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                          )
                        : const Text('Submit', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _fieldStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}

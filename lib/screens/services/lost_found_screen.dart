import 'package:flutter/material.dart';

import '../../models/lost_found_model.dart';
import '../../services/firebase_service.dart';
import '../../widgets/lost_found_card.dart';
import 'item_details_screen.dart';
import 'report_item_screen.dart';

class LostFoundScreen extends StatefulWidget {
  const LostFoundScreen({super.key});

  @override
  State<LostFoundScreen> createState() => _LostFoundScreenState();
}

class _LostFoundScreenState extends State<LostFoundScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final TextEditingController _searchController = TextEditingController();

  // Create the stream ONCE, so typing in the search bar
  // does not restart the Firestore listener.
  late final Stream<List<LostFoundItem>> _itemsStream = _firebaseService.getItemsStream();

  String _searchText = '';
  String _selectedFilter = 'All'; // All / Lost / Found

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Applies the Lost/Found filter and the search text.
  List<LostFoundItem> _applyFilters(List<LostFoundItem> items) {
    final query = _searchText.trim().toLowerCase();
    return items.where((item) {
      final matchesFilter = _selectedFilter == 'All' || item.type == _selectedFilter;
      final matchesSearch = query.isEmpty ||
          item.itemName.toLowerCase().contains(query) ||
          item.description.toLowerCase().contains(query) ||
          item.location.toLowerCase().contains(query);
      return matchesFilter && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lost & Found')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ReportItemScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Report Item'),
      ),
      body: Column(
        children: [
          // ---------- Search bar ----------
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchText = value),
              decoration: InputDecoration(
                hintText: 'Search items...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchText.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchText = '');
                        },
                      ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // ---------- Filter chips ----------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: ['All', 'Lost', 'Found'].map((filter) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: _selectedFilter == filter,
                    onSelected: (_) => setState(() => _selectedFilter = filter),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),

          // ---------- List (updates automatically) ----------
          Expanded(
            child: StreamBuilder<List<LostFoundItem>>(
              stream: _itemsStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const _MessageView(
                    icon: Icons.wifi_off,
                    message: 'Unable to load items. Please try again.',
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final allItems = snapshot.data!;
                final items = _applyFilters(allItems);

                if (allItems.isEmpty) {
                  return const _MessageView(
                    icon: Icons.inbox_outlined,
                    message: 'No lost or found items reported yet.',
                  );
                }
                if (items.isEmpty) {
                  return const _MessageView(
                    icon: Icons.search_off,
                    message: 'No items match your search.',
                  );
                }

                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 700),
                    child: ListView.builder(
                      // Extra bottom space so the floating button does not hide the last card.
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return LostFoundCard(
                          item: item,
                          onViewDetails: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => ItemDetailsScreen(item: item)),
                            );
                          },
                        );
                      },
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

/// Icon + message used for empty and error states.
class _MessageView extends StatelessWidget {
  final IconData icon;
  final String message;

  const _MessageView({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: Colors.grey),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/lost_found_model.dart';

/// Card shown for every item in the Lost & Found list.
class LostFoundCard extends StatelessWidget {
  final LostFoundItem item;
  final VoidCallback onViewDetails;

  const LostFoundCard({super.key, required this.item, required this.onViewDetails});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ItemImage(imageUrl: item.imageUrl, height: 160),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.itemName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 8),
                    StatusChip(type: item.type),
                  ],
                ),
                const SizedBox(height: 8),
                _InfoRow(icon: Icons.location_on_outlined, text: 'Location: ${item.location}'),
                const SizedBox(height: 4),
                _InfoRow(
                  icon: Icons.calendar_today_outlined,
                  text: 'Date: ${DateFormat('d MMMM').format(item.date)}',
                ),
                const SizedBox(height: 8),
                Text(
                  item.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: onViewDetails,
                    child: const Text('View Details'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 6),
        Expanded(child: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis)),
      ],
    );
  }
}

/// Small "Lost" / "Found" badge (also used on the details screen).
class StatusChip extends StatelessWidget {
  final String type;

  const StatusChip({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final isLost = type == 'Lost';
    final baseColor = isLost ? Colors.red : Colors.green;
    final textColor = isLost ? Colors.red.shade700 : Colors.green.shade700;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: baseColor.withAlpha(30),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Status: $type',
        style: TextStyle(color: textColor, fontWeight: FontWeight.w600, fontSize: 12),
      ),
    );
  }
}

/// Shows the image from Firebase Storage, with loading and error states.
class ItemImage extends StatelessWidget {
  final String imageUrl;
  final double height;

  const ItemImage({super.key, required this.imageUrl, required this.height});

  Widget _placeholder() {
    return Container(
      height: height,
      width: double.infinity,
      color: Colors.grey.shade200,
      child: Icon(Icons.image_not_supported_outlined, size: 48, color: Colors.grey.shade500),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) return _placeholder();

    return Image.network(
      imageUrl,
      height: height,
      width: double.infinity,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return SizedBox(
          height: height,
          child: const Center(child: CircularProgressIndicator()),
        );
      },
      errorBuilder: (context, error, stackTrace) => _placeholder(),
    );
  }
}

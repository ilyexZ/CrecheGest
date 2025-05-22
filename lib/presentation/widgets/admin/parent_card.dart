// lib/presentation/widgets/admin/parent_card.dart
import 'package:flutter/material.dart';
import '../../../data/models/parent_model.dart';
import '../../../core/constants/app_colors.dart';

class ParentCard extends StatelessWidget {
  final Parent parent;
  final VoidCallback onDelete;

  const ParentCard({
    super.key,
    required this.parent,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.secondary,
          child: Text(
            parent.firstName[0].toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          parent.fullName,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(parent.phoneNumber),
            const SizedBox(height: 4),
            Text(
              '${parent.childrenIds.length} enfant(s) lié(s)',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _navigateToEdit(context),
              color: AppColors.primary,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDelete,
              color: AppColors.error,
            ),
          ],
        ),
        onTap: () => _navigateToDetails(context),
      ),
    );
  }

  void _navigateToDetails(BuildContext context) {
    // TODO: Navigate to parent details
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Détails de ${parent.fullName}')),
    );
  }

  void _navigateToEdit(BuildContext context) {
    // TODO: Navigate to parent edit
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Éditer ${parent.fullName}')),
    );
  }
}
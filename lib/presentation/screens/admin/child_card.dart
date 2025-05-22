// lib/presentation/widgets/admin/child_card.dart
import 'package:flutter/material.dart';
import '../../../data/models/child_model.dart';
import '../../../core/constants/app_colors.dart';

class ChildCard extends StatelessWidget {
  final Child child;
  final VoidCallback onDelete;

  const ChildCard({
    super.key,
    required this.child,
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
            child.firstName[0].toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          child.fullName,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${child.ageInYears} ans'),
            const SizedBox(height: 4),
            if (child.allergies.isNotEmpty)
              Text(
                'Allergies: ${child.allergies.join(', ')}',
                style: TextStyle(
                  color: AppColors.error,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
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
    // TODO: Navigate to child details
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Détails de ${child.fullName}')),
    );
  }

  void _navigateToEdit(BuildContext context) {
    // TODO: Navigate to child edit
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Éditer ${child.fullName}')),
    );
  }
}
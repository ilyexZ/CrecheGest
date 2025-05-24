
import 'package:creche/presentation/screens/admin/child_details_screen.dart';
import 'package:creche/presentation/screens/admin/edit_child_screen.dart';
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
        minTileHeight: 100,
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
        leading: CircleAvatar(
          backgroundColor: AppColors.primary,
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
   Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ChildDetailsScreen(child: child),
    ),
  );
  }

  void _navigateToEdit(BuildContext context) {
     Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditChildScreen(child: child),
              ),
            );
  }
}
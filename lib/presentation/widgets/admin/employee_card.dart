// lib/presentation/widgets/admin/employee_card.dart
import 'package:flutter/material.dart';
import '../../../data/models/employee_model.dart';
import '../../../core/constants/app_colors.dart';

class EmployeeCard extends StatelessWidget {
  final Employee employee;
  final VoidCallback onDelete;

  const EmployeeCard({
    super.key,
    required this.employee,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary,
          child: Text(
            employee.firstName[0].toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          employee.fullName,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(employee.position),
            const SizedBox(height: 4),
            Text(
              employee.email,
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
    // TODO: Navigate to employee details
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Détails de ${employee.fullName}')),
    );
  }

  void _navigateToEdit(BuildContext context) {
    // TODO: Navigate to employee edit
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Éditer ${employee.fullName}')),
    );
  }
}
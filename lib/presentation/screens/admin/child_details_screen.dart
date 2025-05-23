
import 'package:creche/core/constants/app_colors.dart';
import 'package:creche/data/models/child_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChildDetailsScreen extends StatelessWidget {
  final Child child;
  const ChildDetailsScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(child.fullName)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailItem('Birth Date', 
              DateFormat('dd/MM/yyyy').format(child.birthDate)),
            _buildDetailItem('Age', '${child.ageInYears} years'),
            _buildDetailItem('Medical Info', child.medicalInfo ?? 'None'),
            if (child.allergies.isNotEmpty)
              _buildDetailItem('Allergies', child.allergies.join(', ')),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style:  TextStyle(color: AppColors.textSecondary)),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

import 'package:creche/core/constants/app_colors.dart';
import 'package:creche/data/models/child_model.dart';
import 'package:creche/presentation/screens/admin/edit_child_screen.dart';
import 'package:creche/presentation/screens/admin/parent_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChildDetailsScreen extends StatelessWidget {
  final Child child;
  const ChildDetailsScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Détails d'enfant"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditChildScreen(child: child),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0,horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(),
            _buildDetailItem('Nom', child.firstName),
            Divider(),
            _buildDetailItem("Prénom", child.lastName),
             Divider(),
              _buildDetailItem("Identifiant", child.id),
               Divider(),
            _buildDetailItem('Date de naissance', 
              DateFormat('dd/MM/yyyy').format(child.birthDate)),
               Divider(),
            _buildDetailItem('Âge', '${child.ageInYears} ans'),
             Divider(),
            _buildDetailItem('Information médicale', 
              child.medicalInfo ?? 'Aucune information'),
               Divider(),
            
            const SizedBox(height: 24),
            _buildParentSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildParentSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Parent',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            child: Text(child.parent.firstName[0]),
          ),
          title: Text(child.parent.fullName),
          subtitle: Text(child.parent.phoneNumber),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ParentDetailsScreen(parent: child.parent),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
          ),
        
        ],
      ),
    );
  }
}
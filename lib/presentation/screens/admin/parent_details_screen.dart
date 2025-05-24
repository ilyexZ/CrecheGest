
import 'package:creche/core/constants/app_colors.dart';
import 'package:creche/data/models/parent_model.dart';
import 'package:creche/presentation/providers/child_provider.dart';
import 'package:creche/presentation/screens/admin/add_child_screen.dart';
import 'package:creche/presentation/screens/admin/child_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ParentDetailsScreen extends ConsumerWidget {
  final Parent parent;
  const ParentDetailsScreen({super.key, required this.parent});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final children = ref.watch(childProvider).children
        .where((child) => child.parentId == parent.id)
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text(parent.fullName)),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical:  8.0,horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(),
            _buildDetailItem('Email', parent.email),
            Divider(),
            _buildDetailItem('Phone', parent.phoneNumber),
            Divider(),
            _buildDetailItem('Address', parent.address),
            Divider(),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Children', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddChildScreen(parentId: parent.id),
                    ),
                  ),
                  child: const Text('Add Child')),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: children.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(children[index].fullName),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChildDetailsScreen(child: children[index]),
                    ),
                  ),
                ),
              ),
            ),
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
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
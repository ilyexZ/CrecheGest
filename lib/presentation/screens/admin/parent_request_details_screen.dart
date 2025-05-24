// lib/presentation/screens/admin/parent_request_details_screen.dart
import 'package:creche/core/constants/app_colors.dart';
import 'package:creche/data/models/parent_request_model.dart';
import 'package:creche/presentation/providers/parent_request_provider.dart';
import 'package:creche/presentation/widgets/common/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ParentRequestDetailsScreen extends ConsumerWidget {
  final ParentRequest request;

  const ParentRequestDetailsScreen({super.key, required this.request});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final notifier = ref.read(parentRequestProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: Text('Demande de ${request.firstName}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailItem('Nom complet', '${request.firstName} ${request.lastName}'),
            _buildDetailItem('Email', request.email),
            _buildDetailItem('Téléphone', request.phone),
            _buildDetailItem('Adresse', request.address),
            _buildDetailItem('Date de demande', DateFormat('dd/MM/yyyy').format(request.createdAt)),
            const Spacer(),
            Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Reject',
                  isSecondary: true,
                  onPressed: () {
                    notifier.rejectRequest(request.id);
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomButton(
                  text: 'Approve',
                  onPressed: () {
                    notifier.approveRequest(request);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          )
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  void _handleDecision(WidgetRef ref, bool approved, BuildContext context) {
    final notifier = ref.read(parentRequestProvider.notifier);
    if (approved) {
      notifier.approveRequest(request);
    } else {
      notifier.rejectRequest(request.id);
    }
    Navigator.pop(context);
  }
}
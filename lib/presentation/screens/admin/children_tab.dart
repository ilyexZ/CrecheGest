// lib/presentation/screens/admin/children_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../providers/child_provider.dart';
import '../../widgets/admin/child_card.dart';
import '../common/loading_screen.dart';

class ChildrenTab extends ConsumerStatefulWidget {
  const ChildrenTab({super.key});

  @override
  ConsumerState<ChildrenTab> createState() => _ChildrenTabState();
}

class _ChildrenTabState extends ConsumerState<ChildrenTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(childProvider.notifier).loadChildren();
    });
  }

  Future<void> _handleRefresh() async {
    await ref.read(childProvider.notifier).refreshChildren();
  }

  @override
  Widget build(BuildContext context) {
    final childState = ref.watch(childProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: _buildContent(childState),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddChildDialog(context),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildContent(ChildState state) {
    if (state.isLoading) return const LoadingScreen();
    
    if (state.errorMessage != null) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ErrorScreen(
          message: state.errorMessage!,
          onRetry: () => ref.read(childProvider.notifier).loadChildren(),
        ),
      );
    }

    if (state.children.isEmpty) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.child_care,
                size: 64,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: 16),
              Text(
                'Aucun enfant enregistré',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.children.length,
      itemBuilder: (context, index) => ChildCard(
        child: state.children[index],
        onDelete: () => _deleteChild(state.children[index].id.toString()),
      ),
    );
  }

  void _deleteChild(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Êtes-vous sûr de vouloir supprimer cet enfant ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(childProvider.notifier).deleteChild(id);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  void _showAddChildDialog(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fonctionnalité d\'ajout à venir')),
    );
  }
}
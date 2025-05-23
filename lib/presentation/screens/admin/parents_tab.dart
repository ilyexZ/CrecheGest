// lib/presentation/screens/admin/parents_tab.dart
import 'package:creche/presentation/screens/admin/add_parent_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../providers/parent_provider.dart';
import '../../widgets/admin/parent_card.dart';
import '../common/loading_screen.dart';

class ParentsTab extends ConsumerStatefulWidget {
  const ParentsTab({super.key});

  @override
  ConsumerState<ParentsTab> createState() => _ParentsTabState();
}

class _ParentsTabState extends ConsumerState<ParentsTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(parentProvider.notifier).loadParents();
    });
  }

  Future<void> _handleRefresh() async {
    await ref.read(parentProvider.notifier).refreshParents();
  }

  @override
  Widget build(BuildContext context) {
    final parentState = ref.watch(parentProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: _buildContent(parentState),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddParentDialog(context),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildContent(ParentState state) {
    if (state.isLoading) return const LoadingScreen();
    
    if (state.errorMessage != null) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ErrorScreen(
          message: state.errorMessage!,
          onRetry: () => ref.read(parentProvider.notifier).loadParents(),
        ),
      );
    }

    if (state.parents.isEmpty) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.family_restroom,
                size: 64,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: 16),
              Text(
                'Aucun parent enregistré',
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
      itemCount: state.parents.length,
      itemBuilder: (context, index) => ParentCard(
        parent: state.parents[index],
        onDelete: () => _deleteParent(state.parents[index].id),
      ),
    );
  }

  void _deleteParent(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Êtes-vous sûr de vouloir supprimer ce parent ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(parentProvider.notifier).deleteParent(id);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  void _showAddParentDialog(BuildContext context) {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const AddParentScreen()),
  );
  }
}
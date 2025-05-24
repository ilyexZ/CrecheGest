// lib/presentation/screens/admin/children_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../providers/child_provider.dart';
import '../../widgets/admin/child_card.dart';
import '../common/loading_screen.dart';

class ChildrenTab extends ConsumerStatefulWidget {
  final String? parentId;
  const ChildrenTab({super.key, this.parentId});

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
      persistentFooterButtons: [Center(child: IconButton(onPressed: _handleRefresh, icon: Icon(Icons.refresh, color: Colors.red,))),],
    );
  }
  

  Widget _buildContent(ChildState state) {
    // Filter children based on parentId if provided
    final filteredChildren = widget.parentId != null
        ? state.children.where((c) => c.parentId == widget.parentId).toList()
        : state.children;

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

    if (filteredChildren.isEmpty) {
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
                widget.parentId != null 
                    ? 'Aucun enfant enregistré pour ce parent'
                    : 'Aucun enfant enregistré',
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
      itemCount: filteredChildren.length,
      itemBuilder: (context, index) => ChildCard(
        child: filteredChildren[index],
        onDelete: () => _deleteChild(filteredChildren[index].id.toString()),
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
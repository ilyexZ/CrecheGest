import 'package:creche/core/constants/app_strings.dart';
import 'package:creche/presentation/providers/auth_provider.dart';
import 'package:creche/presentation/providers/parent_provider.dart';
import 'package:creche/presentation/screens/admin/children_tab.dart';
import 'package:creche/presentation/widgets/common/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ParentDashboard extends ConsumerWidget {
  const ParentDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final parentEmail = authState.currentUser?.email;

    // Fetch parent data using email
    final parentAsync = ref.watch(parentByEmailProvider(parentEmail ?? ''));

    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.children,
        showLogout: true,
        automaticallyImplyLeading: false,
      ),
      body: parentAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (parent) {
          if (parent == null) {
            return const Center(child: Text('Parent not found'));
          }
          return ChildrenTab(parentId: parent.id);
        },
      ),
    );
  }
}
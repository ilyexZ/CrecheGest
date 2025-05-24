import 'package:creche/core/constants/app_strings.dart';
import 'package:creche/presentation/providers/auth_provider.dart';
import 'package:creche/presentation/screens/admin/children_tab.dart';
import 'package:creche/presentation/widgets/common/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ParentDashboard extends ConsumerWidget {
  const ParentDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parentId = ref.watch(authProvider).currentUser!.id;
    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.children,
        showLogout: true,
        automaticallyImplyLeading: false,
      ),
      body: ChildrenTab(parentId: parentId),
    );
  }
}
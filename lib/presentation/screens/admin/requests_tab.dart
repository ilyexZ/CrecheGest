// lib/presentation/screens/admin/requests_tab.dart
import 'package:creche/data/models/parent_request_model.dart';
import 'package:creche/presentation/providers/parent_request_provider.dart';
import 'package:creche/presentation/screens/admin/parent_request_details_screen.dart';
import 'package:creche/presentation/screens/common/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RequestsTab extends ConsumerStatefulWidget {
  const RequestsTab({super.key});

  @override
  ConsumerState<RequestsTab> createState() => _RequestsTabState();
}

class _RequestsTabState extends ConsumerState<RequestsTab> {
  @override
  void initState() {
    super.initState();
    // Load requests once after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(parentRequestProvider.notifier).loadRequests();
    });
  }

  Future<void> _handleRefresh() async {
    await ref.read(parentRequestProvider.notifier).loadRequests();
  }

  @override
  Widget build(BuildContext context) {
    final requestState = ref.watch(parentRequestProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: _buildContent(requestState),
      ),
      persistentFooterButtons: [
        Center(
          child: IconButton(
            onPressed: _handleRefresh,
            icon: const Icon(Icons.refresh, color: Colors.red),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(ParentRequestState state) {
    if (state.isLoading) return const LoadingScreen();

    if (state.errorMessage != null) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ErrorScreen(
          message: state.errorMessage!,
          onRetry: _handleRefresh,
        ),
      );
    }

    if (state.requests.isEmpty) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Text(
              'Aucune demande en attente',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.requests.length,
      itemBuilder: (context, index) => _RequestItem(
        request: state.requests[index],
      ),
    );
  }
}

class _RequestItem extends StatelessWidget {
  final ParentRequest request;

  const _RequestItem({required this.request});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('${request.firstName} ${request.lastName}'),
        subtitle: Text(request.email),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ParentRequestDetailsScreen(request: request),
          ),
        ),
      ),
    );
  }
}

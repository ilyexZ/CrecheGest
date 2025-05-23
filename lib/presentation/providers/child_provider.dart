import 'package:creche/core/services/api_service.dart';
import 'package:creche/presentation/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/child_model.dart';

class ChildState {
  final List<Child> children;
  final bool isLoading;
  final String? errorMessage;

  ChildState({
    this.children = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  ChildState copyWith({
    List<Child>? children,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ChildState(
      children: children ?? this.children,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class ChildNotifier extends StateNotifier<ChildState> {
  final ApiService _apiService;
  ChildNotifier(this._apiService) : super(ChildState());

  Future<void> loadChildren() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final response = await _apiService.getChildren();
      final children = response.map((json) => Child.fromJson(json)).toList();
      state = state.copyWith(children: children, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load children: ${e.toString()}',
      );
    }
  }

  Future<void> refreshChildren() async {
    await loadChildren();
  }

  Future<void> deleteChild(String id) async {
    state = state.copyWith(isLoading: true);
    try {
      await _apiService.dio.delete('/children/$id');
      await loadChildren(); // Refresh the list after deletion
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to delete child: ${e.toString()}',
      );
    }
  }
}

final childProvider = StateNotifierProvider<ChildNotifier, ChildState>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return ChildNotifier(apiService);
});
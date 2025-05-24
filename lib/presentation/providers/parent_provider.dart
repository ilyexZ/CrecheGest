// lib/presentation/providers/parent_provider.dart
import 'package:creche/core/services/api_service.dart';
import 'package:creche/presentation/providers/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/parent_model.dart';

class ParentState {
  final List<Parent> parents;
  final bool isLoading;
  final String? errorMessage;

  ParentState({
    this.parents = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  ParentState copyWith({
    List<Parent>? parents,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ParentState(
      parents: parents ?? this.parents,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class ParentNotifier extends StateNotifier<ParentState> {
  final ApiService _apiService;
  ParentNotifier(this._apiService) : super(ParentState());

  Future<void> loadParents() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final response = await _apiService.getParents();
      final parents = response.map((json) => Parent.fromJson(json)).toList();
      state = state.copyWith(parents: parents, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load parents: ${e.toString()}',
      );
    }
  }

  Future<void> refreshParents() async {
    await loadParents();
  }

  Future<void> deleteParent(String id) async {
    state = state.copyWith(isLoading: true);
    try {
      await _apiService.dio.delete('/parents/$id');
      await loadParents(); // Refresh the list after deletion
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to delete parent: ${e.toString()}',
      );
    }
  }
  
}

final parentProvider = StateNotifierProvider<ParentNotifier, ParentState>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return ParentNotifier(apiService);
});
final parentByEmailProvider = FutureProvider.autoDispose.family<Parent?, String>((ref, email) async {
  final apiService = ref.read(apiServiceProvider);
  try {
    final response = await apiService.dio.get('/parents/email/$email');
    return Parent.fromJson(response.data);
  } on DioException catch (e) {
    if (e.response?.statusCode == 404) return null;
    throw Exception('Failed to fetch parent: ${e.message}');
  }
});
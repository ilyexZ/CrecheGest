// lib/presentation/providers/parent_provider.dart
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
  ParentNotifier() : super(ParentState());

  Future<void> addParent(Parent parent) async {
    state = state.copyWith(isLoading: true);
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      state = state.copyWith(
        parents: [...state.parents, parent],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erreur lors de l\'ajout du parent',
      );
    }
  }

  Future<void> updateParent(Parent parent) async {
    state = state.copyWith(isLoading: true);
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final index = state.parents.indexWhere((p) => p.id == parent.id);
      if (index != -1) {
        final newParents = List<Parent>.from(state.parents);
        newParents[index] = parent;
        state = state.copyWith(parents: newParents, isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erreur lors de la mise à jour',
      );
    }
  }

  Future<void> deleteParent(String parentId) async {
    state = state.copyWith(isLoading: true);
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      state = state.copyWith(
        parents: state.parents.where((p) => p.id != parentId).toList(),
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erreur lors de la suppression',
      );
    }
  }

  void loadMockData() {
    state = state.copyWith(isLoading: true);
    final mockParents = [
      Parent(
        id: 'p1',
        firstName: 'Pierre',
        lastName: 'Martin',
        email: 'pierre.martin@email.com',
        phoneNumber: '06 12 34 56 78',
        address: '123 Rue de la Paix, 75001 Paris',
        childrenIds: ['1'],
      ),
      Parent(
        id: 'p2',
        firstName: 'Claire',
        lastName: 'Dubois',
        email: 'claire.dubois@email.com',
        phoneNumber: '06 98 76 54 32',
        address: '456 Avenue des Champs, 75008 Paris',
        childrenIds: ['2'],
      ),
      Parent(
        id: 'p3',
        firstName: 'Antoine',
        lastName: 'Rousseau',
        email: 'antoine.rousseau@email.com',
        phoneNumber: '06 11 22 33 44',
        address: '789 Boulevard Saint-Michel, 75005 Paris',
        childrenIds: [],
      ),
    ];
    state = state.copyWith(parents: mockParents, isLoading: false);
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

final parentProvider = StateNotifierProvider<ParentNotifier, ParentState>((ref) => ParentNotifier());
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
  ChildNotifier() : super(ChildState());

  Future<void> addChild(Child child) async {
    state = state.copyWith(isLoading: true);
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      state = state.copyWith(
        children: [...state.children, child],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erreur lors de l\'ajout de l\'enfant',
      );
    }
  }

  Future<void> updateChild(Child child) async {
    state = state.copyWith(isLoading: true);
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final index = state.children.indexWhere((c) => c.id == child.id);
      if (index != -1) {
        final newChildren = List<Child>.from(state.children);
        newChildren[index] = child;
        state = state.copyWith(children: newChildren, isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erreur lors de la mise à jour',
      );
    }
  }

  Future<void> deleteChild(String childId) async {
    state = state.copyWith(isLoading: true);
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      state = state.copyWith(
        children: state.children.where((c) => c.id != childId).toList(),
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
    final mockChildren = [
      Child(
        id: '1',
        firstName: 'Emma',
        lastName: 'Martin',
        birthDate: DateTime(2020, 5, 15),
        parentId: 'p1',
        enrollmentDate: DateTime(2023, 9, 1),
        allergies: ['Nuts'],
      ),
      Child(
        id: '2',
        firstName: 'Lucas',
        lastName: 'Dubois',
        birthDate: DateTime(2019, 8, 22),
        parentId: 'p2',
        enrollmentDate: DateTime(2023, 9, 1),
      ),
    ];
    state = state.copyWith(children: mockChildren, isLoading: false);
  }
}

final childProvider = StateNotifierProvider<ChildNotifier, ChildState>((ref) => ChildNotifier());
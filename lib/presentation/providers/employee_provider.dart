// lib/presentation/providers/employee_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/employee_model.dart';

class EmployeeState {
  final List<Employee> employees;
  final bool isLoading;
  final String? errorMessage;

  EmployeeState({
    this.employees = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  EmployeeState copyWith({
    List<Employee>? employees,
    bool? isLoading,
    String? errorMessage,
  }) {
    return EmployeeState(
      employees: employees ?? this.employees,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class EmployeeNotifier extends StateNotifier<EmployeeState> {
  EmployeeNotifier() : super(EmployeeState());

  Future<void> addEmployee(Employee employee) async {
    state = state.copyWith(isLoading: true);
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      state = state.copyWith(
        employees: [...state.employees, employee],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erreur lors de l\'ajout de l\'employé',
      );
    }
  }

  Future<void> updateEmployee(Employee employee) async {
    state = state.copyWith(isLoading: true);
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final index = state.employees.indexWhere((e) => e.id == employee.id);
      if (index != -1) {
        final newEmployees = List<Employee>.from(state.employees);
        newEmployees[index] = employee;
        state = state.copyWith(employees: newEmployees, isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erreur lors de la mise à jour',
      );
    }
  }

  Future<void> deleteEmployee(String employeeId) async {
    state = state.copyWith(isLoading: true);
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      state = state.copyWith(
        employees: state.employees.where((e) => e.id != employeeId).toList(),
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
    final mockEmployees = [
      Employee(
        id: '1',
        firstName: 'Marie',
        lastName: 'Leclerc',
        email: 'marie.leclerc@crechegest.com',
        position: 'Éducatrice principale',
        hireDate: DateTime(2020, 3, 15),
        phoneNumber: '01 23 45 67 89',
      ),
      Employee(
        id: '2',
        firstName: 'Sophie',
        lastName: 'Bernard',
        email: 'sophie.bernard@crechegest.com',
        position: 'Éducatrice',
        hireDate: DateTime(2021, 9, 1),
        phoneNumber: '01 23 45 67 90',
      ),
      Employee(
        id: '3',
        firstName: 'Thomas',
        lastName: 'Moreau',
        email: 'thomas.moreau@crechegest.com',
        position: 'Assistant éducateur',
        hireDate: DateTime(2022, 1, 10),
        phoneNumber: '01 23 45 67 91',
      ),
    ];
    state = state.copyWith(employees: mockEmployees, isLoading: false);
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

final employeeProvider = StateNotifierProvider<EmployeeNotifier, EmployeeState>((ref) => EmployeeNotifier());
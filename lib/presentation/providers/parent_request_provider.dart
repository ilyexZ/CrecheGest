// lib/presentation/providers/parent_request_provider.dart
import 'package:creche/core/services/api_service.dart';
import 'package:creche/data/models/parent_request_model.dart';
import 'package:creche/presentation/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ParentRequestState {
  final List<ParentRequest> requests;
  final bool isLoading;
  final String? errorMessage;

  ParentRequestState({
    this.requests = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  ParentRequestState copyWith({
    List<ParentRequest>? requests,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ParentRequestState(
      requests: requests ?? this.requests,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class ParentRequestNotifier extends StateNotifier<ParentRequestState> {
  final ApiService _apiService;

  ParentRequestNotifier(this._apiService) : super(ParentRequestState());

  Future<void> loadRequests() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final response = await _apiService.dio.get('/parent-requests');
      final requests = (response.data as List)
          .map((json) => ParentRequest.fromJson(json))
          .toList();
          print("REQUESTS: $requests !!!");
      state = state.copyWith(requests: requests, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load requests: ${e.toString()}',
      );
    }
  }

  Future<void> approveRequest(ParentRequest request) async {
    try {
      // Convert request to parent data
      final parentData = {
        'firstName': request.firstName,
        'lastName': request.lastName,
        'email': request.email,
        'phone': request.phone,
        'address': request.address,
        "emergencyContact": true
      };

      // Create parent using existing endpoint
      await _apiService.createParent(parentData);
      
      // Delete the request
      await _apiService.dio.delete('/parent-requests/${request.id}');
      
      // Update state
      state = state.copyWith(
        requests: state.requests.where((r) => r.id != request.id).toList(),
      );
      
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to approve request: ${e.toString()}'
      );
    }
  }

  Future<void> rejectRequest(String requestId) async {
    try {
      // Delete the request
      await _apiService.dio.delete('/parent-requests/$requestId');
      
      // Update state
      state = state.copyWith(
        requests: state.requests.where((r) => r.id != requestId).toList(),
      );
      
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to reject request: ${e.toString()}'
      );
    }
  }
}

final parentRequestProvider = StateNotifierProvider<ParentRequestNotifier, ParentRequestState>((ref) {
  return ParentRequestNotifier(ref.read(apiServiceProvider));
});
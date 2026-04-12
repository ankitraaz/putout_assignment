import 'dart:convert';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kuttot/core/providers/auth_provider.dart';

class SupportRequest {
  final String ticketId;
  final String phone;
  final String description;
  final String timestamp;
  final String status; // pending, resolved

  SupportRequest({
    required this.ticketId,
    required this.phone,
    required this.description,
    required this.timestamp,
    this.status = 'pending',
  });

  Map<String, dynamic> toJson() => {
    'ticketId': ticketId,
    'phone': phone,
    'description': description,
    'timestamp': timestamp,
    'status': status,
  };

  factory SupportRequest.fromJson(Map<String, dynamic> json) {
    return SupportRequest(
      ticketId: json['ticketId'] as String,
      phone: json['phone'] as String,
      description: json['description'] as String,
      timestamp: json['timestamp'] as String,
      status: json['status'] as String? ?? 'pending',
    );
  }
}

class SupportNotifier extends StateNotifier<List<SupportRequest>> {
  final String phoneKey;

  SupportNotifier(this.phoneKey) : super([]) {
    _loadRequests();
  }

  String _key(String base) => phoneKey.isEmpty ? base : '${base}_$phoneKey';

  Future<void> _loadRequests() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_key('support_requests'));
    if (data != null) {
      final List<dynamic> jsonList = json.decode(data);
      state = jsonList.map((e) => SupportRequest.fromJson(e)).toList();
    }
  }

  Future<void> _saveRequests() async {
    final prefs = await SharedPreferences.getInstance();
    final data = json.encode(state.map((e) => e.toJson()).toList());
    await prefs.setString(_key('support_requests'), data);
  }


  /// Submit a new support request. Returns the generated ticket ID.
  Future<String> submitRequest(String phone, String description) async {
    final ticketId = '#KT-${10000 + Random().nextInt(89999)}';
    final request = SupportRequest(
      ticketId: ticketId,
      phone: phone,
      description: description,
      timestamp: DateTime.now().toIso8601String(),
    );
    state = [...state, request];
    await _saveRequests();
    return ticketId;
  }

  /// Get all pending requests (for admin later)
  List<SupportRequest> get pendingRequests =>
      state.where((r) => r.status == 'pending').toList();
}

final supportProvider = StateNotifierProvider<SupportNotifier, List<SupportRequest>>((ref) {
  final authState = ref.watch(authProvider);
  return SupportNotifier(authState.phone ?? '');
});

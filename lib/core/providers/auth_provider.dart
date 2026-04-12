import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Model for a user from the dummy JSON
class DummyUser {
  final String id;
  final String name;
  final String phone;
  final String otp;
  final String email;
  final int points;

  DummyUser({
    required this.id,
    required this.name,
    required this.phone,
    required this.otp,
    required this.email,
    required this.points,
  });

  factory DummyUser.fromJson(Map<String, dynamic> json) {
    return DummyUser(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      otp: json['otp'] as String,
      email: json['email'] as String,
      points: json['points'] as int,
    );
  }
}

/// Auth state
enum AuthStatus { checking, initial, loading, otpSent, authenticated, error }

class AuthState {
  final AuthStatus status;
  final String? phone;
  final String? otp; // The generated OTP for display/testing
  final DummyUser? user;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.checking,
    this.phone,
    this.otp,
    this.user,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? phone,
    String? otp,
    DummyUser? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      phone: phone ?? this.phone,
      otp: otp ?? this.otp,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState()) {
    _checkLoggedIn();
  }

  List<DummyUser> _users = [];

  /// Check if user is already logged in from SharedPreferences
  Future<void> _checkLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    if (isLoggedIn) {
      final savedPhone = prefs.getString('user_phone') ?? '';
      final name = prefs.getString('user_name_$savedPhone') ?? '';
      final phone = prefs.getString('user_phone_$savedPhone') ?? savedPhone;
      final email = prefs.getString('user_email_$savedPhone') ?? '';
      final id = prefs.getString('user_id_$savedPhone') ?? '';
      final points = prefs.getInt('user_points_$savedPhone') ?? 0;
      
      state = state.copyWith(
        status: AuthStatus.authenticated,
        phone: phone, // Added phone explicitly
        user: DummyUser(
          id: id,
          name: name,
          phone: phone,
          otp: '',
          email: email,
          points: points,
        ),
      );
    } else {
      state = state.copyWith(status: AuthStatus.initial);
    }
  }

  /// Load dummy users from JSON asset
  Future<List<DummyUser>> _loadUsers() async {
    if (_users.isNotEmpty) return _users;
    final data = await rootBundle.loadString('assets/data/users.json');
    final List<dynamic> jsonList = json.decode(data);
    _users = jsonList.map((e) => DummyUser.fromJson(e)).toList();
    return _users;
  }

  /// Send OTP: find user by phone or generate random OTP for new user
  Future<void> sendOtp(String phone) async {
    state = state.copyWith(status: AuthStatus.loading, phone: phone);

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    final users = await _loadUsers();
    final existingUser = users.where((u) => u.phone == phone).toList();

    String otp;
    if (existingUser.isNotEmpty) {
      otp = existingUser.first.otp;
    } else {
      // Generate random 4-digit OTP for unknown numbers
      otp = (1000 + Random().nextInt(9000)).toString();
    }

    state = state.copyWith(
      status: AuthStatus.otpSent,
      otp: otp,
      phone: phone,
    );
  }

  /// Verify OTP
  Future<bool> verifyOtp(String enteredOtp) async {
    state = state.copyWith(status: AuthStatus.loading);

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));

    if (enteredOtp == state.otp) {
      final prefs = await SharedPreferences.getInstance();
      final savedPhone = prefs.getString('user_phone');
      
      DummyUser user;
      
      // If logging in with the same phone number, retrieve their locally preserved, edited data!
      final keySuffix = state.phone ?? '';
      
      if (savedPhone == state.phone && prefs.containsKey('user_name_$keySuffix')) {
        user = DummyUser(
          id: prefs.getString('user_id_$keySuffix') ?? 'USR999',
          name: prefs.getString('user_name_$keySuffix') ?? 'Kutoot User',
          phone: state.phone ?? '',
          otp: enteredOtp,
          email: prefs.getString('user_email_$keySuffix') ?? '',
          points: prefs.getInt('user_points_$keySuffix') ?? 0,
        );
      } else {
        // Different number or fresh install, fetch from dummy JSON or spawn new
        final users = await _loadUsers();
        final existing = users.where((u) => u.phone == state.phone).toList();

        if (existing.isNotEmpty) {
          user = existing.first;
        } else {
          // Create a new user for unknown numbers
          user = DummyUser(
            id: 'USR${100 + Random().nextInt(900)}',
            name: 'Kutoot User',
            phone: state.phone ?? '',
            otp: enteredOtp,
            email: '',
            points: 0,
          );
        }
      }

      // Save to local storage safely
      await prefs.setBool('is_logged_in', true);
      // Ensure local phone session tracker logic is preserved globally to detect same-session returns
      await prefs.setString('user_phone', state.phone ?? ''); 
      
      // Sandbox the specific data dynamically with suffix
      final suffix = state.phone ?? '';
      await prefs.setString('user_name_$suffix', user.name);
      await prefs.setString('user_phone_$suffix', user.phone);
      await prefs.setString('user_email_$suffix', user.email);
      await prefs.setString('user_id_$suffix', user.id);
      await prefs.setInt('user_points_$suffix', user.points);

      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      );
      return true;
    } else {
      state = state.copyWith(
        status: AuthStatus.otpSent,
        errorMessage: 'Invalid OTP. Please try again.',
      );
      return false;
    }
  }

  /// Resend OTP (regenerate)
  Future<void> resendOtp() async {
    if (state.phone != null) {
      await sendOtp(state.phone!);
    }
  }

  /// Logout safely without destroying the local data cache for this user
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Only kill the session. Persist the user data on disk.
    await prefs.setBool('is_logged_in', false);
    
    state = const AuthState(status: AuthStatus.initial);
  }

  bool get isLoggedIn => state.status == AuthStatus.authenticated;
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

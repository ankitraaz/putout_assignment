import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile {
  final String name;
  final String phone;

  UserProfile({this.name = '', this.phone = ''});

  UserProfile copyWith({String? name, String? phone}) {
    return UserProfile(
      name: name ?? this.name,
      phone: phone ?? this.phone,
    );
  }
}

class ProfileNotifier extends StateNotifier<UserProfile> {
  ProfileNotifier() : super(UserProfile()) {
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('user_name') ?? '';
    final phone = prefs.getString('user_phone') ?? '';
    state = UserProfile(name: name, phone: phone);
  }

  Future<void> saveProfile(String name, String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    await prefs.setString('user_phone', phone);
    state = UserProfile(name: name, phone: phone);
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, UserProfile>((ref) {
  return ProfileNotifier();
});

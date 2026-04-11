import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile {
  final String name;
  final String phone;
  final String email;
  final bool isVIP;
  final String subscriptionExpiry;
  final int luxuryVillaStamps;
  final int goldBarStamps;
  final String? profileImageUrl;
  final bool notificationsEnabled;

  UserProfile({
    this.name = '',
    this.phone = '',
    this.email = 'alex.johnson@example.com',
    this.isVIP = true,
    this.subscriptionExpiry = 'OCT 2024',
    this.luxuryVillaStamps = 8,
    this.goldBarStamps = 4,
    this.profileImageUrl,
    this.notificationsEnabled = true,
  });

  UserProfile copyWith({
    String? name,
    String? phone,
    String? email,
    bool? isVIP,
    String? subscriptionExpiry,
    int? luxuryVillaStamps,
    int? goldBarStamps,
    String? profileImageUrl,
    bool? notificationsEnabled,
  }) {
    return UserProfile(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      isVIP: isVIP ?? this.isVIP,
      subscriptionExpiry: subscriptionExpiry ?? this.subscriptionExpiry,
      luxuryVillaStamps: luxuryVillaStamps ?? this.luxuryVillaStamps,
      goldBarStamps: goldBarStamps ?? this.goldBarStamps,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}

class ProfileNotifier extends StateNotifier<UserProfile> {
  ProfileNotifier() : super(UserProfile()) {
    _loadProfile();
  }
  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    state = UserProfile(
      name: prefs.getString('user_name') ?? '',
      phone: prefs.getString('user_phone') ?? '',
      email: prefs.getString('user_email') ?? 'alex.johnson@example.com',
      isVIP: prefs.getBool('user_is_vip') ?? true,
      subscriptionExpiry: prefs.getString('user_sub_expiry') ?? 'OCT 2024',
      luxuryVillaStamps: prefs.getInt('user_stamps_villa') ?? 8,
      goldBarStamps: prefs.getInt('user_stamps_gold') ?? 4,
      profileImageUrl: prefs.getString('user_image_url'),
      notificationsEnabled: prefs.getBool('user_notifications_enabled') ?? true,
    );
  }

  Future<void> saveProfile(String name, String phone, {String? email, String? imageUrl}) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Capitalize name (Title Case)
    final formattedName = name.isEmpty 
        ? '' 
        : name.trim().split(' ').map((word) {
            if (word.isEmpty) return word;
            return word[0].toUpperCase() + word.substring(1).toLowerCase();
          }).join(' ');

    // Normalize email (Lowercase)
    final formattedEmail = email?.trim().toLowerCase();

    await prefs.setString('user_name', formattedName);
    await prefs.setString('user_phone', phone.trim());
    if (formattedEmail != null) await prefs.setString('user_email', formattedEmail);
    if (imageUrl != null) await prefs.setString('user_image_url', imageUrl);
    
    state = state.copyWith(
      name: formattedName,
      phone: phone.trim(),
      email: formattedEmail,
      profileImageUrl: imageUrl,
    );
  }

  Future<void> updateStamps(int villa, int gold) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_stamps_villa', villa);
    await prefs.setInt('user_stamps_gold', gold);
    state = state.copyWith(luxuryVillaStamps: villa, goldBarStamps: gold);
  }

  Future<void> toggleNotifications(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('user_notifications_enabled', enabled);
    state = state.copyWith(notificationsEnabled: enabled);
  }

  Future<void> clearProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_name');
    await prefs.remove('user_phone');
    await prefs.remove('user_email');
    await prefs.remove('user_image_url');
    await prefs.remove('user_stamps_villa');
    await prefs.remove('user_stamps_gold');
    await prefs.remove('user_is_vip');
    await prefs.remove('user_sub_expiry');
    await prefs.remove('user_notifications_enabled');
    
    state = UserProfile(); // Reset to default blank state
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, UserProfile>((ref) {
  return ProfileNotifier();
});

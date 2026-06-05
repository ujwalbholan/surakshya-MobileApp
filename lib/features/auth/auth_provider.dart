library auth_provider;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suraksha/core/constants/app_constants.dart';
import 'package:suraksha/models/user_model.dart';
import 'package:suraksha/services/ams_api_service.dart';
import 'package:suraksha/theme/suraksha_animations.dart';

class AuthData {
  const AuthData({required this.isLoggedIn, this.user});

  final bool isLoggedIn;
  final UserModel? user;

  AuthData copyWith({bool? isLoggedIn, UserModel? user}) => AuthData(
        isLoggedIn: isLoggedIn ?? this.isLoggedIn,
        user: user ?? this.user,
      );
}

class AuthNotifier extends StateNotifier<AuthData> {
  AuthNotifier(this._ams) : super(const AuthData(isLoggedIn: false));

  final AmsApiService _ams;

  Future<void> restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool(AppConstants.prefsLoggedIn) ?? false;
    if (!loggedIn) return;

    final name = prefs.getString('user_name') ?? 'Priya Sharma';
    final email = prefs.getString('user_email') ?? 'user@suraksha.app';
    final phone = prefs.getString('user_phone');
    state = AuthData(
      isLoggedIn: true,
      user: UserModel(
        name: name,
        email: email,
        phone: phone,
        bloodType: prefs.getString('user_blood'),
        age: prefs.getInt('user_age'),
        avatarPath: 'assets/images/avatars/avatar_profile.png',
      ),
    );
  }

  Future<bool> registerAccount({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pending_signup_email', email.trim());
    await prefs.setString('pending_signup_name', name.trim());
    await prefs.setString('pending_signup_password', password);
    return true;
  }

  Future<void> login(String email, String password) async {
    await Future<void>.delayed(SurakshaAnimations.authLoad);
    UserModel user;
    try {
      user = await _ams.login(email, password);
    } on AmsApiException {
      final prefs = await SharedPreferences.getInstance();
      final pendingName = prefs.getString('pending_signup_name');
      user = UserModel(
        name: pendingName ?? 'Priya Sharma',
        email: email,
        phone: '+91 98765 43210',
        bloodType: 'O+',
        age: 24,
        avatarPath: 'assets/images/avatars/avatar_profile.png',
      );
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.prefsLoggedIn, true);
    await prefs.setString('user_name', user.name);
    await prefs.setString('user_email', user.email);
    if (user.phone != null) await prefs.setString('user_phone', user.phone!);
    if (user.bloodType != null) {
      await prefs.setString('user_blood', user.bloodType!);
    }
    if (user.age != null) await prefs.setInt('user_age', user.age!);
    await prefs.setBool(AppConstants.prefsOnboardingDone, true);

    state = AuthData(isLoggedIn: true, user: user);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.prefsLoggedIn, false);
    state = const AuthData(isLoggedIn: false);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthData>(
  (ref) => AuthNotifier(ref.read(amsApiServiceProvider)),
);

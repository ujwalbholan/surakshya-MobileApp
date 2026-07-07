library surakshya_api_service;

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:suraksha/core/constants/app_constants.dart';
import 'package:suraksha/models/guardian_models.dart';
import 'package:suraksha/models/parent_models.dart';
import 'package:suraksha/models/user_model.dart';
import 'package:suraksha/services/token_storage.dart';

class SurakshyaApiException implements Exception {
  SurakshyaApiException(this.message, {this.statusCode});
  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

class AuthSession {
  const AuthSession({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  final UserModel user;
  final String accessToken;
  final String refreshToken;
}

class SurakshyaApiService {
  SurakshyaApiService({
    http.Client? client,
    TokenStorage? tokenStorage,
  })  : _client = client ?? http.Client(),
        _tokenStorage = tokenStorage ?? TokenStorage();

  final http.Client _client;
  final TokenStorage _tokenStorage;

  String get _base => AppConstants.surakshyaBaseUrl;

  Future<AuthSession> login(String email, String password) async {
    final response = await _client.post(
      Uri.parse('$_base/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email.trim(), 'password': password}),
    );
    final data = _decode(response);
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw SurakshyaApiException(
        _errorMessage(response, data, fallback: 'Login failed'),
        statusCode: response.statusCode,
      );
    }
    final userJson = data['user'] as Map<String, dynamic>? ?? {};
    final accessToken = data['accessToken'] as String? ?? '';
    final refreshToken = data['refreshToken'] as String? ?? '';
    if (accessToken.isEmpty) {
      throw SurakshyaApiException('Login response missing access token');
    }
    await _tokenStorage.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
    return AuthSession(
      user: UserModel.fromSurakshyaJson(userJson),
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    final response = await _client.post(
      Uri.parse('$_base/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'full_name': fullName,
        'email': email.trim().toLowerCase(),
        'phone': phone.trim(),
        'password': password,
        'role': 'USER',
      }),
    );
    final data = _decode(response);
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw SurakshyaApiException(
        _errorMessage(response, data, fallback: 'Registration failed'),
        statusCode: response.statusCode,
      );
    }
  }

  Future<Map<String, String>> _authHeaders() async {
    final token = await _tokenStorage.getAccessToken();
    if (token == null || token.isEmpty) {
      throw SurakshyaApiException('Not authenticated');
    }
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<LinkedGuardian>> fetchMyGuardians({
    int page = 1,
    int limit = 20,
  }) async {
    final headers = await _authHeaders();
    final response = await _client.get(
      Uri.parse('$_base/guardians?page=$page&limit=$limit'),
      headers: headers,
    );
    final data = _decode(response);
    if (response.statusCode != 200) {
      throw SurakshyaApiException(
        _messageFrom(data) ?? 'Failed to load guardians',
        statusCode: response.statusCode,
      );
    }
    final list = data['guardians'] as List<dynamic>? ?? [];
    return list
        .map((e) => LinkedGuardian.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<ChildPendingRequest>> fetchChildPendingRequests() async {
    final headers = await _authHeaders();
    final response = await _client.get(
      Uri.parse('$_base/guardians/requests'),
      headers: headers,
    );
    final data = _decode(response);
    if (response.statusCode != 200) {
      throw SurakshyaApiException(
        _messageFrom(data) ?? 'Failed to load requests',
        statusCode: response.statusCode,
      );
    }
    final list = data['requests'] as List<dynamic>? ?? [];
    return list
        .map((e) => ChildPendingRequest.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<String> inviteGuardian({
    required String fullName,
    required String email,
    required String phone,
  }) async {
    final headers = await _authHeaders();
    final response = await _client.post(
      Uri.parse('$_base/guardians'),
      headers: headers,
      body: jsonEncode({
        'full_name': fullName,
        'email': email.trim().toLowerCase(),
        'phone': phone.trim(),
      }),
    );
    final data = _decode(response);
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw SurakshyaApiException(
        _messageFrom(data) ?? 'Failed to send invite',
        statusCode: response.statusCode,
      );
    }
    return data['message'] as String? ?? 'Guardian invite sent';
  }

  Future<String> acceptChildRequest(String requestId) async {
    final headers = await _authHeaders();
    final response = await _client.post(
      Uri.parse('$_base/guardians/requests/$requestId/accept'),
      headers: headers,
    );
    final data = _decode(response);
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw SurakshyaApiException(
        _messageFrom(data) ?? 'Failed to accept request',
        statusCode: response.statusCode,
      );
    }
    return data['message'] as String? ?? 'Request accepted';
  }

  Future<String> rejectChildRequest(String requestId) async {
    final headers = await _authHeaders();
    final response = await _client.post(
      Uri.parse('$_base/guardians/requests/$requestId/reject'),
      headers: headers,
    );
    final data = _decode(response);
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw SurakshyaApiException(
        _messageFrom(data) ?? 'Failed to reject request',
        statusCode: response.statusCode,
      );
    }
    return data['message'] as String? ?? 'Request rejected';
  }

  Future<List<LinkedWard>> fetchMyWards({
    int page = 1,
    int limit = 20,
  }) async {
    final headers = await _authHeaders();
    final response = await _client.get(
      Uri.parse('$_base/guardian/me?page=$page&limit=$limit'),
      headers: headers,
    );
    if (response.statusCode == 404) {
      return [];
    }
    final data = _decode(response);
    if (response.statusCode != 200) {
      throw SurakshyaApiException(
        _messageFrom(data) ?? 'Failed to load wards',
        statusCode: response.statusCode,
      );
    }
    final list = data['wards'] as List<dynamic>? ?? [];
    return list
        .map((e) => LinkedWard.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<GuardianPendingRequest>> fetchGuardianPendingRequests() async {
    final headers = await _authHeaders();
    final response = await _client.get(
      Uri.parse('$_base/guardian/requests'),
      headers: headers,
    );
    final data = _decode(response);
    if (response.statusCode != 200) {
      throw SurakshyaApiException(
        _messageFrom(data) ?? 'Failed to load requests',
        statusCode: response.statusCode,
      );
    }
    final list = data['requests'] as List<dynamic>? ?? [];
    return list
        .map((e) => GuardianPendingRequest.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<String> acceptGuardianRequest(String requestId) async {
    final headers = await _authHeaders();
    final response = await _client.post(
      Uri.parse('$_base/guardian/requests/$requestId/accept'),
      headers: headers,
    );
    final data = _decode(response);
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw SurakshyaApiException(
        _messageFrom(data) ?? 'Failed to accept request',
        statusCode: response.statusCode,
      );
    }
    return data['message'] as String? ?? 'Request accepted';
  }

  Future<List<WardSosEvent>> fetchWardSos(String wardId) async {
    final headers = await _authHeaders();
    final response = await _client.get(
      Uri.parse('$_base/guardian/wards/$wardId/sos'),
      headers: headers,
    );
    final data = _decode(response);
    if (response.statusCode != 200) {
      throw SurakshyaApiException(
        _messageFrom(data) ?? 'Failed to load SOS events',
        statusCode: response.statusCode,
      );
    }
    final list = data['data'] as List<dynamic>? ?? [];
    return list
        .map((e) => WardSosEvent.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> clearSession() => _tokenStorage.clearTokens();

  Map<String, dynamic> _decode(http.Response response) {
    if (response.body.isEmpty) return {};
    try {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }

  String? _messageFrom(Map<String, dynamic> data) {
    final message = data['message'];
    if (message is String && message.isNotEmpty) {
      return _humanizeServerMessage(message);
    }
    if (message is List && message.isNotEmpty) {
      return _humanizeServerMessage(message.first.toString());
    }
    return null;
  }

  String _errorMessage(
    http.Response response,
    Map<String, dynamic> data, {
    required String fallback,
  }) {
    if (response.statusCode == 429) {
      return 'Too many attempts. Please wait about a minute, then try again.';
    }
    return _messageFrom(data) ?? fallback;
  }

  String _humanizeServerMessage(String message) {
    if (message.contains('ThrottlerException') ||
        message.toLowerCase().contains('too many requests')) {
      return 'Too many attempts. Please wait about a minute, then try again.';
    }
    if (message == 'email must be an email') {
      return 'That email address looks invalid. Enter only the username (e.g. bikram1), not @gmail.com.';
    }
    return message;
  }

  void dispose() => _client.close();
}

final surakshyaApiServiceProvider = Provider<SurakshyaApiService>((ref) {
  final service = SurakshyaApiService(
    tokenStorage: ref.read(tokenStorageProvider),
  );
  ref.onDispose(service.dispose);
  return service;
});

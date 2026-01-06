import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
	final ApiService _api = ApiService();

	bool _loggedIn = false;
	Map<String, dynamic>? _user;

	bool get loggedIn => _loggedIn;
	Map<String, dynamic>? get user => _user;

	static const String _prefKeepSignedInKey = 'keep_signed_in';

	Future<void> login(String email, String password, {bool keepSignedIn = false}) async {
		final cleanedEmail = email.trim();
		if (cleanedEmail.isEmpty || password.isEmpty) {
			throw Exception('Email and password must not be empty');
		}

		try {
			final res = await _api.login(cleanedEmail, password);
			_user = res['data'] ?? {};
			_loggedIn = true;
			try {
				final prefs = await SharedPreferences.getInstance();
				await prefs.setBool(_prefKeepSignedInKey, keepSignedIn);
			} catch (_) {}
			notifyListeners();
		} catch (e) {
			rethrow;
		}
	}

	Future<void> register(Map<String, dynamic> payload) async {
		if (payload['email'] == null || payload['password'] == null) {
			throw Exception('Email and password are required');
		}

		try {
			final res = await _api.register(payload);
			_user = res['data'] ?? {};
			_loggedIn = true;
			notifyListeners();
		} catch (e) {
			rethrow;
		}
	}

	void logout() {
		_loggedIn = false;
		_user = null;
		try {
			SharedPreferences.getInstance().then((prefs) => prefs.remove(_prefKeepSignedInKey));
		} catch (_) {}
		notifyListeners();
	}
}
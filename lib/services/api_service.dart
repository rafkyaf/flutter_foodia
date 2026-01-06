import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

class ApiService {
	/// Default base URL for Android emulator. Change to your machine IP for real devices.
	final String baseUrl;

	/// Default base URL targets the Android emulator host forwarding.
	/// For web builds use `http://localhost/...`.
	/// For iOS simulator use `http://localhost/...` and for a real device
	/// replace with your machine IP like `http://192.168.0.5/...`.
	ApiService({String? baseUrl}) : baseUrl = baseUrl ?? (kIsWeb ? 'http://localhost/Kelompok_3_Project_UTS/api' : 'http://10.0.2.2/Kelompok_3_Project_UTS/api');

	Future<void> init() async {}

	Future<List<dynamic>> getUsers() async {
		final res = await http.get(Uri.parse('$baseUrl/users.php'));
		if (res.statusCode == 200) {
			final body = json.decode(res.body);
			return body['data'] ?? [];
		}
		throw Exception('Failed to load users');
	}

	Future<Map<String, dynamic>> login(String username, String password) async {
		final uri = Uri.parse('$baseUrl/users.php?action=login');
		final res = await http.post(uri, body: json.encode({'username': username, 'password': password}), headers: {'Content-Type': 'application/json'});
		final body = json.decode(res.body);
		if (res.statusCode == 200 && body['success'] == true) return body;
		throw Exception(body['message'] ?? 'Login failed');
	}

	Future<Map<String, dynamic>> register(Map<String, dynamic> payload) async {
		final uri = Uri.parse('$baseUrl/users.php?action=register');
		final res = await http.post(uri, body: json.encode(payload), headers: {'Content-Type': 'application/json'});
		final body = json.decode(res.body);
		if (res.statusCode == 200 && body['success'] == true) return body;
		throw Exception(body['message'] ?? 'Register failed');
	}

	Future<List<dynamic>> getProducts() async {
		final res = await http.get(Uri.parse('$baseUrl/products.php'));
		if (res.statusCode == 200) {
			final body = json.decode(res.body);
			return body['data'] ?? [];
		}
		throw Exception('Failed to load products');
	}
}
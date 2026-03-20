import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ficha_model.dart';

class ApiService {
  // ATENÇÃO: Substitua pela URL real do seu Render quando estiver online
  // Se for testar no emulador local, use 'http://10.0.2.2:3000/api'
  static const String baseUrl = 'https://catequese-api-6cgg.onrender.com/api';

  // --- LÓGICA DE TOKEN E PREFERÊNCIAS ---

  static Future<void> _salvarDadosLogin(String token, String role, String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('role', role);
    await prefs.setString('userId', userId);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // --- NOVAS ROTAS DE AUTENTICAÇÃO POR E-MAIL ---

  // 1. Pede para o servidor enviar o código de 6 dígitos
  static Future<bool> solicitarCodigoEmail(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/request-code'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email.trim()}),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // 2. Envia o código que o usuário digitou para validar
  static Future<bool> validarCodigoEmail(String email, String codigo) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/verify-code'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email.trim(), 'code': codigo.trim()}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _salvarDadosLogin(data['token'], data['user']['role'], data['user']['_id']);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // --- LOGIN INTERNO PARA CATEQUISTAS/ADMIN ---
  static Future<bool> loginInterno(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/internal'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username.trim(), 'password': password.trim()}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _salvarDadosLogin(data['token'], data['user']['role'], data['user']['_id']);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // --- ROTAS DE FICHAS (COM TOKEN) - MANTIDAS IGUAIS ---

  static Future<List<Ficha>> getFichas() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/fichas'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((item) => Ficha.fromJson(item)).toList();
    }
    return [];
  }

  static Future<bool> salvarFicha(Ficha ficha) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/fichas'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(ficha.toJson()),
    );
    return response.statusCode == 201;
  }

  static Future<bool> atualizarFicha(Ficha ficha) async {
    if (ficha.id == null) return false;
    final token = await getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/fichas/${ficha.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(ficha.toJson()),
    );
    return response.statusCode == 200;
  }

  static Future<bool> inativarFicha(String id) async {
    final token = await getToken();
    final response = await http.patch(
      Uri.parse('$baseUrl/fichas/$id/inativar'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return response.statusCode == 200;
  }

  // --- ROTAS DE ADMINISTRAÇÃO DE USUÁRIOS ---

  static Future<List<dynamic>> getUsers() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/admin/users'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Falha ao carregar usuários');
  }

  static Future<void> createUser(Map<String, dynamic> userData) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/admin/users'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(userData),
    );
    if (response.statusCode != 201) throw Exception('Falha ao criar usuário');
  }

  static Future<void> updateUser(String id, Map<String, dynamic> userData) async {
    final token = await getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/admin/users/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(userData),
    );
    if (response.statusCode != 200) throw Exception('Falha ao atualizar usuário');
  }

  static Future<void> deleteUser(String id) async {
    final token = await getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/admin/users/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 200) throw Exception('Falha ao deletar usuário');
  }
}
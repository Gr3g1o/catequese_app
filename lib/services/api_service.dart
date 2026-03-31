import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ficha_model.dart';

class ApiService {
  // ATENÇÃO: Substitua pela URL real do seu Render quando estiver online
  // Se for testar no emulador local, use 'http://10.0.2.2:3000/api'
  static const String baseUrl = 'https://catequese-api-6cgg.onrender.com/api';

  // --- LÓGICA DE TOKEN E PREFERÊNCIAS ---
  static Future<void> _salvarDadosLogin(String token, String role,
      String userId, String nome, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('role', role);
    await prefs.setString('userId', userId);
    await prefs.setString('userName', nome);
    await prefs.setString('userEmail', email);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // --- ROTAS DE AUTENTICAÇÃO ---
  static Future<Map<String, dynamic>> solicitarCodigoEmail(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/request-code'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email.trim()}),
      );

      if (response.statusCode == 200) {
        return {'sucesso': true};
      } else {
        // Se der erro (como o 429 do Rate Limit), pegamos a mensagem exata do servidor
        final data = jsonDecode(response.body);
        return {
          'sucesso': false,
          'erro': data['erro'] ?? 'Erro ao enviar código.'
        };
      }
    } catch (e) {
      return {'sucesso': false, 'erro': 'Erro de conexão com o servidor.'};
    }
  }

  // Agora retorna um Map para sabermos qual o nome do usuário
  static Future<Map<String, dynamic>> validarCodigoEmail(
      String email, String codigo) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/verify-code'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email.trim(), 'code': codigo.trim()}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user = data['user'];
        await _salvarDadosLogin(data['token'], user['role'], user['_id'],
            user['nome'], user['email']);
        return {'sucesso': true, 'nome': user['nome'], 'email': user['email']};
      }
      return {'sucesso': false};
    } catch (e) {
      return {'sucesso': false};
    }
  }

  static Future<Map<String, dynamic>> loginInterno(
      String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/internal'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
            {'username': username.trim(), 'password': password.trim()}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user = data['user'];
        await _salvarDadosLogin(data['token'], user['role'], user['_id'],
            user['nome'], user['email']);
        return {'sucesso': true, 'nome': user['nome'], 'email': user['email']};
      }
      return {'sucesso': false};
    } catch (e) {
      return {'sucesso': false};
    }
  }

  // --- ROTAS DO MEU PERFIL (NOVAS) ---
  static Future<bool> atualizarMeuPerfil(String nome, String email) async {
    final token = await getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/users/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({'nome': nome, 'email': email}),
    );
    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', nome);
      await prefs.setString('userEmail', email);
      return true;
    }
    return false;
  }

  static Future<bool> inativarMinhaConta() async {
    final token = await getToken();
    final response = await http.patch(
      Uri.parse('$baseUrl/users/me/inativar'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return response.statusCode == 200;
  }

  // --- ROTAS DE FICHAS (COM PAGINAÇÃO) ---
  static Future<List<Ficha>> getFichas({bool incluirInativos = false}) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/fichas?incluirInativos=$incluirInativos'),
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
        'Authorization': 'Bearer $token'
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
        'Authorization': 'Bearer $token'
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
        'Authorization': 'Bearer $token'
      },
    );
    return response.statusCode == 200;
  }

  static Future<bool> deletarFicha(String id) async {
    final token = await getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/fichas/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return response.statusCode == 200;
  }

  // --- ROTAS DE ADMINISTRAÇÃO DE USUÁRIOS (COM PAGINAÇÃO) ---
  static Future<List<dynamic>> getUsers({int page = 1, int limit = 10}) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/admin/users?page=$page&limit=$limit'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) return jsonDecode(response.body);
    throw Exception('Falha ao carregar usuários');
  }

  static Future<void> createUser(Map<String, dynamic> userData) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/admin/users'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(userData),
    );
    if (response.statusCode != 201) throw Exception('Falha ao criar usuário');
  }

  static Future<void> updateUser(
      String id, Map<String, dynamic> userData) async {
    final token = await getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/admin/users/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(userData),
    );
    if (response.statusCode != 200)
      throw Exception('Falha ao atualizar usuário');
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

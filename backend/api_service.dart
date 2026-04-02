import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Use 10.0.2.2 para o emulador Android ou seu IP real para celular físico
  final String baseUrl = "http://10.0.2.2:3000";

  Future<Map<String, dynamic>> register(String nome, String email, String telefone, String senha, String confirmacao) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "nome": nome,
        "email": email,
        "telefone": telefone,
        "senha": senha,
        "confirmacaoSenha": confirmacao
      }),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> login(String email, String senha) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "senha": senha}),
    );
    return jsonDecode(response.body);
  }
}
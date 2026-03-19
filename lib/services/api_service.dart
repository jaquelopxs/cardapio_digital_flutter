import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/produto.dart';
import '../models/pedido.dart';

class ApiService {
  // Use 10.0.2.2 para Emulador Android ou o IP da sua máquina para dispositivo real
  static const String baseUrl = 'http://10.0.2.2:3000'; 

  // --- PRODUTOS ---

  Future<List<Produto>> getProdutos() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/produtos'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Produto.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Erro ao buscar produtos: $e');
      return [];
    }
  }

  Future<bool> salvarProduto(Map<String, dynamic> produto, String token, {int? id}) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      final body = json.encode(produto);
      
      final response = id != null 
        ? await http.put(Uri.parse('$baseUrl/produtos/$id'), headers: headers, body: body)
        : await http.post(Uri.parse('$baseUrl/produtos'), headers: headers, body: body);
        
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  Future<bool> excluirProduto(int id, String token) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/produtos/$id'),
        headers: {'Authorization': 'Bearer $token'},
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // --- PEDIDOS ---

  Future<Map<String, dynamic>> finalizarPedido(Map<String, dynamic> dadosPedido) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/pedidos'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(dadosPedido),
      );
      return json.decode(response.body);
    } catch (e) {
      return {'error': 'Erro de conexão com o servidor'};
    }
  }

  Future<Pedido?> getPedidoById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/pedidos/$id'));
      if (response.statusCode == 200) {
        return Pedido.fromJson(json.decode(response.body));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<Pedido>> getTodosPedidos(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/pedidos'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Pedido.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<bool> atualizarStatusPedido(int id, String novoStatus, String token) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/pedidos/$id/status'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'status': novoStatus}),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // --- AUTENTICAÇÃO ---

  Future<Map<String, dynamic>> login(String email, String senha) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'senha': senha}),
      );
      return json.decode(response.body);
    } catch (e) {
      return {'error': 'Servidor offline ou erro de rede'};
    }
  }
}

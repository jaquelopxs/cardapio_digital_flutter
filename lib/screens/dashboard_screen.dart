import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../models/pedido.dart';
import '../core/constants/app_colors.dart';
import '../providers/auth_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ApiService _apiService = ApiService();
  List<Pedido> _pedidos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarTodosPedidos();
  }

  Future<void> _carregarTodosPedidos() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    try {
      final pedidos = await _apiService.getTodosPedidos(auth.token!);
      setState(() {
        _pedidos = pedidos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _mudarStatus(int pedidoId, String novoStatus) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final sucesso = await _apiService.atualizarStatusPedido(pedidoId, novoStatus, auth.token!);
    
    if (sucesso) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pedido #$pedidoId atualizado para: $novoStatus')),
      );
      _carregarTodosPedidos(); // Recarrega a lista
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Cozinha', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black87,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _carregarTodosPedidos),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _pedidos.length,
              itemBuilder: (context, index) {
                final pedido = _pedidos[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ExpansionTile(
                    title: Text('Pedido #${pedido.id} - ${pedido.nomeCliente}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Status: ${pedido.status.toUpperCase()}', style: TextStyle(color: _corStatus(pedido.status))),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Itens:', style: TextStyle(fontWeight: FontWeight.bold)),
                            ...pedido.itens.map((i) => Text('${i.quantidade}x ${i.nomeProduto}')),
                            const Divider(),
                            Text('Total: ${currencyFormatter.format(pedido.total)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _statusButton(pedido.id, 'em_preparo', 'Preparar', Colors.orange),
                                _statusButton(pedido.id, 'pronto', 'Pronto', Colors.green),
                                _statusButton(pedido.id, 'entregue', 'Entregar', Colors.blue),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _statusButton(int id, String status, String label, Color color) {
    return ElevatedButton(
      onPressed: () => _mudarStatus(id, status),
      style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white),
      child: Text(label),
    );
  }

  Color _corStatus(String status) {
    switch (status) {
      case 'recebido': return Colors.blue;
      case 'em_preparo': return Colors.orange;
      case 'pronto': return Colors.green;
      default: return Colors.grey;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../models/pedido.dart';
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
    setState(() => _isLoading = true);
    
    final sucesso = await _apiService.atualizarStatusPedido(pedidoId, novoStatus, auth.token!);
    
    if (sucesso) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Pedido #$pedidoId atualizado para: ${novoStatus.toUpperCase()}'),
            backgroundColor: Colors.green,
          ),
        );
      }
      _carregarTodosPedidos(); // Recarrega a lista
    } else {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao atualizar status do pedido.'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
          IconButton(
            icon: const Icon(Icons.logout), 
            onPressed: () => context.read<AuthProvider>().logout(),
          ),
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
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text('Itens:', style: TextStyle(fontWeight: FontWeight.bold)),
                            ...pedido.itens.map((i) => Text('${i.quantidade}x ${i.nomeProduto}')),
                            const Divider(),
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined, size: 16, color: Colors.red),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Entrega em: ${pedido.endereco}',
                                    style: const TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),
                            Text('Pagamento: ${pedido.formaPagamento.toUpperCase()}', style: const TextStyle(fontSize: 12)),
                            Text('Total: ${currencyFormatter.format(pedido.total)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 16),
                            // Lógica de botões inteligente
                            if (pedido.status != 'entregue')
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  if (pedido.status == 'pendente' || pedido.status == 'recebido')
                                    Expanded(child: _statusButton(pedido.id, 'em preparo', 'Começar Preparo', Colors.orange)),
                                  if (pedido.status == 'em preparo')
                                    Expanded(child: _statusButton(pedido.id, 'pronto', 'Pedido Pronto', Colors.green)),
                                  if (pedido.status == 'pronto')
                                    Expanded(child: _statusButton(pedido.id, 'entregue', 'Confirmar Entrega', Colors.blue)),
                                ],
                              )
                            else
                              const Center(
                                child: Text('✅ Pedido Finalizado e Entregue', 
                                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        onPressed: () => _mudarStatus(id, status),
        style: ElevatedButton.styleFrom(
          backgroundColor: color, 
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
      ),
    );
  }

  Color _corStatus(String status) {
    switch (status) {
      case 'recebido': return Colors.blue;
      case 'em preparo':
      case 'em_preparo': return Colors.orange;
      case 'pronto': return Colors.green;
      case 'entregue': return Colors.grey;
      default: return Colors.black;
    }
  }
}

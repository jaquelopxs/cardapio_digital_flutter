import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../models/pedido.dart';
import '../core/constants/app_colors.dart';
import '../providers/auth_provider.dart';

class StatusPedidoScreen extends StatefulWidget {
  final int? pedidoId;
  const StatusPedidoScreen({super.key, this.pedidoId});

  @override
  State<StatusPedidoScreen> createState() => _StatusPedidoScreenState();
}

class _StatusPedidoScreenState extends State<StatusPedidoScreen> {
  final ApiService _apiService = ApiService();
  List<Pedido> _pedidos = [];
  bool _isLoading = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _carregarPedidos();
    // Atualizar a cada 10 segundos
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) => _carregarPedidos());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _carregarPedidos() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (!auth.isAuthenticated) return;

    try {
      final pedidos = await _apiService.getTodosPedidos(auth.token!);
      if (mounted) {
        setState(() {
          // Se for admin, vê tudo. Se for cliente, vê apenas os dele.
          if (auth.isAdmin) {
             _pedidos = pedidos;
          } else {
             // Filtra pelo nome ou telefone do usuário logado
             final userName = auth.user?['nome'];
             final userPhone = auth.user?['telefone'];
             _pedidos = pedidos.where((p) => 
                p.nomeCliente == userName || p.telefone == userPhone
             ).toList();
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _formatarStatus(String status) {
    switch (status) {
      case 'recebido': return 'Pedido Recebido';
      case 'em_preparo': return 'Em Preparo';
      case 'pronto': return 'Pronto para Entrega';
      case 'entregue': return 'Entregue';
      default: return status.replaceAll('_', ' ');
    }
  }

  Color _corStatus(String status) {
    switch (status) {
      case 'recebido': return Colors.blue;
      case 'em_preparo': return Colors.orange;
      case 'pronto': return Colors.green;
      case 'entregue': return Colors.grey;
      default: return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Pedidos', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      backgroundColor: Colors.grey[50],
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _pedidos.isEmpty
              ? _buildSemPedidos()
              : RefreshIndicator(
                  onRefresh: _carregarPedidos,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _pedidos.length,
                    itemBuilder: (context, index) {
                      final pedido = _pedidos[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 1,
                        child: InkWell(
                          onTap: () => _mostrarDetalhesPedido(pedido),
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Pedido #${pedido.id}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: _corStatus(pedido.status).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        _formatarStatus(pedido.status),
                                        style: TextStyle(
                                          color: _corStatus(pedido.status),
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 24),
                                Row(
                                  children: [
                                    const Icon(Icons.shopping_bag_outlined, size: 20, color: Colors.grey),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        pedido.itens.map((i) => '${i.quantidade}x ${i.nomeProduto}').join(', '),
                                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      currencyFormatter.format(pedido.total),
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                    const Text('Ver detalhes', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  Widget _buildSemPedidos() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text('Você ainda não fez nenhum pedido', style: TextStyle(fontSize: 18, color: Colors.grey)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
               Navigator.pushReplacementNamed(context, '/main');
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            child: const Text('Fazer meu primeiro pedido'),
          ),
        ],
      ),
    );
  }

  void _mostrarDetalhesPedido(Pedido pedido) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 24),
              Text('Pedido #${pedido.id}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Status: ${_formatarStatus(pedido.status)}', style: TextStyle(color: _corStatus(pedido.status), fontWeight: FontWeight.bold)),
              const Divider(height: 40),
              const Text('Itens do Pedido', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ...pedido.itens.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${item.quantidade}x ${item.nomeProduto}', style: const TextStyle(fontSize: 16)),
                    Text('R\$ ${item.subtotal.toStringAsFixed(2)}'),
                  ],
                ),
              )),
              const Divider(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text('R\$ ${pedido.total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
                ],
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Fechar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

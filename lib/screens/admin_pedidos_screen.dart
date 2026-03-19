import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';
import '../models/pedido.dart';
import '../core/constants/app_colors.dart';

class AdminPedidosScreen extends StatefulWidget {
  const AdminPedidosScreen({super.key});

  @override
  State<AdminPedidosScreen> createState() => _AdminPedidosScreenState();
}

class _AdminPedidosScreenState extends State<AdminPedidosScreen> {
  final ApiService _apiService = ApiService();
  List<Pedido> _pedidos = [];
  String _filtroStatus = 'todos';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarPedidos();
  }

  Future<void> _carregarPedidos() async {
    final auth = context.read<AuthProvider>();
    if (!auth.isAuthenticated) return;

    setState(() => _isLoading = true);
    final pedidos = await _apiService.getTodosPedidos(auth.token!);
    setState(() {
      _pedidos = pedidos;
      _isLoading = false;
    });
  }

  Future<void> _atualizarStatus(int id, String novoStatus) async {
    final auth = context.read<AuthProvider>();
    final success = await _apiService.atualizarStatusPedido(id, novoStatus, auth.token!);
    if (success) {
      _carregarPedidos();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Status atualizado para $novoStatus')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final pedidosFiltrados = _filtroStatus == 'todos'
        ? _pedidos
        : _pedidos.where((p) => p.status == _filtroStatus).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel de Pedidos', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _carregarPedidos),
          IconButton(icon: const Icon(Icons.inventory), onPressed: () => Navigator.pushNamed(context, '/admin/produtos')),
          IconButton(icon: const Icon(Icons.logout), onPressed: () {
            context.read<AuthProvider>().logout();
            Navigator.pushReplacementNamed(context, '/admin');
          }),
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              _buildFiltros(),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: pedidosFiltrados.length,
                  itemBuilder: (context, index) {
                    final pedido = pedidosFiltrados[index];
                    return _buildPedidoCard(pedido);
                  },
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildFiltros() {
    final status = ['todos', 'recebido', 'em_preparo', 'pronto', 'entregue'];
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: status.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final s = status[index];
          final isSelected = _filtroStatus == s;
          return ChoiceChip(
            label: Text(s.toUpperCase()),
            selected: isSelected,
            onSelected: (val) => setState(() => _filtroStatus = s),
            selectedColor: AppColors.primary,
            labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87),
          );
        },
      ),
    );
  }

  Widget _buildPedidoCard(Pedido pedido) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Pedido #${pedido.id}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                _buildStatusBadge(pedido.status),
              ],
            ),
            const SizedBox(height: 8),
            Text('Cliente: ${pedido.nomeCliente}'),
            Text('Telefone: ${pedido.telefone}'),
            const Divider(),
            ...(pedido.itens.map((item) => Text('${item.quantidade}x ${item.nomeProduto}'))),
            const Divider(),
            Text('Total: R\$ ${pedido.total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _statusButton(pedido.id, 'recebido', Colors.red),
                  const SizedBox(width: 4),
                  _statusButton(pedido.id, 'em_preparo', Colors.orange),
                  const SizedBox(width: 4),
                  _statusButton(pedido.id, 'pronto', Colors.lightGreen),
                  const SizedBox(width: 4),
                  _statusButton(pedido.id, 'entregue', Colors.blue),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(20)),
      child: Text(status.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _statusButton(int id, String status, Color color) {
    return ElevatedButton(
      onPressed: () => _atualizarStatus(id, status),
      style: ElevatedButton.styleFrom(
        backgroundColor: color, 
        foregroundColor: Colors.white, 
        padding: const EdgeInsets.symmetric(horizontal: 12),
        minimumSize: const Size(80, 36),
      ),
      child: Text(status.replaceAll('_', ' '), style: const TextStyle(fontSize: 10)),
    );
  }
}

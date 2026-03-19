import 'dart:async';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/pedido.dart';
import '../core/constants/app_colors.dart';
import '../widgets/custom_navbar.dart';

class StatusPedidoScreen extends StatefulWidget {
  final int? pedidoId;
  const StatusPedidoScreen({super.key, this.pedidoId});

  @override
  State<StatusPedidoScreen> createState() => _StatusPedidoScreenState();
}

class _StatusPedidoScreenState extends State<StatusPedidoScreen> {
  final ApiService _apiService = ApiService();
  Pedido? _pedido;
  Timer? _timer;
  int? _id;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _id = widget.pedidoId ?? (ModalRoute.of(context)!.settings.arguments as int);
      _carregarPedido();
      _timer = Timer.periodic(const Duration(seconds: 5), (timer) => _carregarPedido());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _carregarPedido() async {
    if (_id == null) return;
    final pedido = await _apiService.getPedidoById(_id!);
    if (mounted) {
      setState(() => _pedido = pedido);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_pedido == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final statusEtapas = ["recebido", "em_preparo", "pronto", "entregue"];
    final etapaAtual = statusEtapas.indexOf(_pedido!.status);

    return Scaffold(
      appBar: const CustomNavbar(),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
            ),
            child: Column(
              children: [
                Text('Pedido #${_pedido!.id}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Cliente: ${_pedido!.nomeCliente}', style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 32),

                // Barra de Progresso
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(statusEtapas.length, (index) {
                    final isActive = index <= etapaAtual;
                    return Column(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isActive ? Colors.green : Colors.grey[300],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          statusEtapas[index].replaceAll('_', ' '),
                          style: TextStyle(
                            fontSize: 10,
                            color: isActive ? Colors.green : Colors.grey,
                            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    );
                  }),
                ),

                const Divider(height: 60),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Itens do Pedido', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 16),
                ...(_pedido!.itens.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item.nomeProduto),
                      Text('x${item.quantidade}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ))),

                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('R\$ ${_pedido!.total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),

                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, '/'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Voltar ao Cardápio'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

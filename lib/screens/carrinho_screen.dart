import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/carrinho_provider.dart';
import '../services/api_service.dart';
import '../core/constants/app_colors.dart';
import '../widgets/custom_navbar.dart';

class CarrinhoScreen extends StatefulWidget {
  const CarrinhoScreen({super.key});

  @override
  State<CarrinhoScreen> createState() => _CarrinhoScreenState();
}

class _CarrinhoScreenState extends State<CarrinhoScreen> {
  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  String _formaPagamento = 'dinheiro';
  bool _isFinalizando = false;

  final ApiService _apiService = ApiService();
  final currencyFormatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  Future<void> _finalizarPedido(CarrinhoProvider carrinho) async {
    if (_nomeController.text.isEmpty || _telefoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha nome e telefone')),
      );
      return;
    }

    setState(() => _isFinalizando = true);

    final dadosPedido = {
      'nome_cliente': _nomeController.text,
      'telefone': _telefoneController.text,
      'forma_pagamento': _formaPagamento,
      'total': double.parse(carrinho.valorTotal.toStringAsFixed(2)),
      'itens': carrinho.itens.map((item) => {
        'produto_id': item.produto.id,
        'quantidade': item.quantidade,
      }).toList(),
    };

    final result = await _apiService.finalizarPedido(dadosPedido);

    setState(() => _isFinalizando = false);

    if (result.containsKey('pedido_id')) {
      final pedidoId = result['pedido_id'];
      carrinho.limpar();
      
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Pedido Realizado!'),
          content: Text('Seu pedido #$pedidoId foi enviado com sucesso.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(
                  context, 
                  '/status', 
                  arguments: pedidoId,
                );
              },
              child: const Text('Acompanhar Pedido'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: ${result['error'] ?? 'Erro desconhecido'}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomNavbar(),
      backgroundColor: AppColors.surface,
      body: Consumer<CarrinhoProvider>(
        builder: (context, carrinho, child) {
          if (carrinho.itens.isEmpty) {
            return _buildCarrinhoVazio();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Meu Carrinho',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Lista de Itens
                _buildCardContainer(
                  title: 'Itens do Pedido',
                  child: Column(
                    children: [
                      ...carrinho.itens.map((item) => _buildItemCarrinho(item, carrinho)),
                      const Divider(height: 32, thickness: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          Text(
                            currencyFormatter.format(carrinho.valorTotal),
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Dados do Cliente
                _buildCardContainer(
                  title: 'Dados para Entrega',
                  child: Column(
                    children: [
                      _buildTextField('Nome', _nomeController, 'Seu nome completo'),
                      const SizedBox(height: 16),
                      _buildTextField('Telefone', _telefoneController, '(00) 00000-0000', keyboardType: TextInputType.phone),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _formaPagamento,
                        decoration: const InputDecoration(labelText: 'Forma de Pagamento', border: OutlineInputBorder()),
                        items: const [
                          DropdownMenuItem(value: 'dinheiro', child: Text('Dinheiro')),
                          DropdownMenuItem(value: 'cartao', child: Text('Cartão')),
                          DropdownMenuItem(value: 'pix', child: Text('Pix')),
                        ],
                        onChanged: (val) => setState(() => _formaPagamento = val!),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Botão Finalizar
                ElevatedButton(
                  onPressed: _isFinalizando ? null : () => _finalizarPedido(carrinho),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isFinalizando
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Finalizar Pedido — ${currencyFormatter.format(carrinho.valorTotal)}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCarrinhoVazio() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text('Seu carrinho está vazio', style: TextStyle(fontSize: 20, color: Colors.grey)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/cardapio'),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            child: const Text('Ver Cardápio'),
          ),
        ],
      ),
    );
  }

  Widget _buildCardContainer({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildItemCarrinho(item, CarrinhoProvider carrinho) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.produto.nome, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(currencyFormatter.format(item.produto.preco), style: const TextStyle(color: Colors.green)),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: () => carrinho.atualizarQuantidade(item.produto.id, item.quantidade - 1),
              ),
              Text('${item.quantidade}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () => carrinho.atualizarQuantidade(item.produto.id, item.quantidade + 1),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () => carrinho.remover(item.produto.id),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint, {TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
    );
  }
}

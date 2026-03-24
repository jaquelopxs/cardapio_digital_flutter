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

  Future<void> _confirmarFinalizacao(CarrinhoProvider carrinho) async {
    // RF009: Validação inicial
    if (_nomeController.text.isEmpty || _telefoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha seu nome e telefone para entrega.')),
      );
      return;
    }

    // RF009: Apresentar resumo e solicitar confirmação
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Pedido'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Deseja finalizar seu pedido agora?'),
            const SizedBox(height: 15),
            Text('Itens selecionados: ${carrinho.quantidadeTotal}'),
            Text('Total: ${currencyFormatter.format(carrinho.valorTotal)}', 
                 style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCELAR', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _finalizarPedido(carrinho);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
            child: const Text('CONFIRMAR'),
          ),
        ],
      ),
    );
  }

  Future<void> _finalizarPedido(CarrinhoProvider carrinho) async {
    setState(() => _isFinalizando = true);

    // RF009: Enviar dados do pedido para a API
    final dadosPedido = {
      'nome_cliente': _nomeController.text,
      'telefone': _telefoneController.text,
      'forma_pagamento': _formaPagamento,
      'total': double.parse(carrinho.valorTotal.toStringAsFixed(2)),
      'itens': carrinho.itens.map((item) => {
        'produto_id': item.produto.id,
        'quantidade': item.quantidade,
        'preco_unitario': item.produto.preco,
      }).toList(),
    };

    final result = await _apiService.finalizarPedido(dadosPedido);

    setState(() => _isFinalizando = false);

    if (result.containsKey('pedido_id') || result.containsKey('message')) {
      carrinho.limpar();
      
      // RF009: Mensagem de sucesso
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Pedido Realizado!'),
          content: const Text('Seu pedido foi realizado com sucesso e já está sendo preparado.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/cardapio');
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: ${result['error'] ?? 'Erro ao processar pedido'}')),
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

                // RF007: Visualizar Carrinho (Lista de Itens)
                _buildCardContainer(
                  title: 'Itens do Pedido',
                  child: Column(
                    children: [
                      ...carrinho.itens.map((item) => _buildItemCarrinho(item, carrinho)),
                      const Divider(height: 32, thickness: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total do Pedido:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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

                // Dados do Cliente para Finalização
                _buildCardContainer(
                  title: 'Dados para Entrega',
                  child: Column(
                    children: [
                      _buildTextField('Nome do Cliente', _nomeController, 'Informe seu nome'),
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

                // RF009: Botão Finalizar
                ElevatedButton(
                  onPressed: _isFinalizando ? null : () => _confirmarFinalizacao(carrinho),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isFinalizando
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'FINALIZAR PEDIDO',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                // RF007: Nome, preço e quantidade
                Text(item.produto.nome, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(
                  '${item.quantidade}x ${currencyFormatter.format(item.produto.preco)}', 
                  style: const TextStyle(color: Colors.green)
                ),
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
              // RF008: Remover item do pedido
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

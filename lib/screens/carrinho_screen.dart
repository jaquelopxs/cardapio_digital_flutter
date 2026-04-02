import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/carrinho_provider.dart';
import '../providers/auth_provider.dart';
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
  final _enderecoController = TextEditingController();
  String _formaPagamento = 'dinheiro';
  bool _isFinalizando = false;

  final ApiService _apiService = ApiService();
  final currencyFormatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  @override
  void initState() {
    super.initState();
    // Pre-preencher com dados do usuário logado se existirem
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      if (auth.user != null) {
        _nomeController.text = auth.user!['nome'] ?? '';
        _telefoneController.text = auth.user!['telefone'] ?? '';
        _enderecoController.text = auth.user!['endereco'] ?? '';
      }
    });
  }

  Future<void> _finalizarPedido(CarrinhoProvider carrinho) async {
    if (_nomeController.text.isEmpty || _telefoneController.text.isEmpty || _enderecoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha nome, telefone e endereço/mesa'), behavior: SnackBarBehavior.floating),
      );
      return;
    }

    // Solicitar confirmação
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Pedido'),
        content: const Text('Deseja realmente finalizar seu pedido agora?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Voltar')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Confirmar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    setState(() => _isFinalizando = true);

    final dadosPedido = {
      'nome_cliente': _nomeController.text,
      'telefone': _telefoneController.text,
      'endereco': _enderecoController.text,
      'forma_pagamento': _formaPagamento,
      'total': double.parse(carrinho.valorTotal.toStringAsFixed(2)),
      'itens': carrinho.itens.map((item) => {
        'produto_id': item.produto.id,
        'quantidade': item.quantidade,
        'subtotal': double.parse((item.produto.preco * item.quantidade).toStringAsFixed(2)),
      }).toList(),
    };

    try {
      final result = await _apiService.finalizarPedido(dadosPedido);

      if (result.containsKey('id')) {
        final pedidoId = result['id'];
        carrinho.limpar();
        
        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text('Pedido Realizado!'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 64),
                  const SizedBox(height: 16),
                  Text('Seu pedido #$pedidoId foi enviado com sucesso.'),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // No MainScreen, mudar para a aba de pedidos
                    // Por enquanto vamos apenas navegar se for fora da MainScreen
                    Navigator.pushReplacementNamed(context, '/main');
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                  child: const Text('OK', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro: ${result['error'] ?? 'Erro desconhecido'}'), behavior: SnackBarBehavior.floating),
          );
        }
      }
    } catch (e) {
       if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao finalizar pedido: $e'), behavior: SnackBarBehavior.floating),
          );
        }
    } finally {
      if (mounted) setState(() => _isFinalizando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Carrinho', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      backgroundColor: Colors.grey[50],
      body: Consumer<CarrinhoProvider>(
        builder: (context, carrinho, child) {
          if (carrinho.itens.isEmpty) {
            return _buildCarrinhoVazio();
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Lista de Itens
                      _buildCardContainer(
                        title: 'Itens Selecionados',
                        child: Column(
                          children: [
                            ...carrinho.itens.map((item) => _buildItemCarrinho(item, carrinho)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Dados do Cliente
                      _buildCardContainer(
                        title: 'Entrega e Pagamento',
                        child: Column(
                          children: [
                            _buildTextField('Nome', _nomeController, 'Seu nome completo', Icons.person_outline),
                            const SizedBox(height: 16),
                            _buildTextField('Telefone', _telefoneController, '(00) 00000-0000', Icons.phone_outlined, keyboardType: TextInputType.phone),
                            const SizedBox(height: 16),
                            _buildTextField('Endereço ou Mesa', _enderecoController, 'Rua, número e bairro ou nº da mesa', Icons.location_on_outlined),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              value: _formaPagamento,
                              decoration: InputDecoration(
                                labelText: 'Forma de Pagamento', 
                                prefixIcon: const Icon(Icons.payment_outlined),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                filled: true,
                                fillColor: Colors.grey[50],
                              ),
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
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              
              // Resumo e Botão Fixo
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total do pedido', style: TextStyle(fontSize: 16, color: Colors.grey)),
                          Text(
                            currencyFormatter.format(carrinho.valorTotal),
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isFinalizando ? null : () => _finalizarPedido(carrinho),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          child: _isFinalizando
                              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : const Text('Finalizar Pedido', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(color: Colors.grey[100], shape: BoxShape.circle),
            child: Icon(Icons.shopping_basket_outlined, size: 80, color: Colors.grey[400]),
          ),
          const SizedBox(height: 24),
          const Text('Seu carrinho está vazio', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 8),
          const Text('Adicione itens para começar seu pedido', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
               // No MainScreen, mudar para a aba de cardápio
               Navigator.pushReplacementNamed(context, '/main');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary, 
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: const Text('Ver Cardápio'),
          ),
        ],
      ),
    );
  }

  Widget _buildCardContainer({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildItemCarrinho(item, CarrinhoProvider carrinho) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.produto.nome, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                Text(currencyFormatter.format(item.produto.preco), style: TextStyle(color: Colors.grey[600], fontSize: 13)),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, size: 18, color: AppColors.primary),
                  onPressed: () => carrinho.atualizarQuantidade(item.produto.id, item.quantidade - 1),
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  padding: EdgeInsets.zero,
                ),
                Text('${item.quantidade}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.add, size: 18, color: AppColors.primary),
                  onPressed: () => carrinho.atualizarQuantidade(item.produto.id, item.quantidade + 1),
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
            onPressed: () => carrinho.remover(item.produto.id),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint, IconData icon, {TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }
}

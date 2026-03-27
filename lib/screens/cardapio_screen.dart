import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../models/produto.dart';
import '../widgets/produto_card.dart';
import '../widgets/custom_navbar.dart';
import '../providers/carrinho_provider.dart';
import '../core/constants/app_colors.dart';

class CardapioScreen extends StatefulWidget {
  const CardapioScreen({super.key});

  @override
  State<CardapioScreen> createState() => _CardapioScreenState();
}

class _CardapioScreenState extends State<CardapioScreen> {
  final ApiService _apiService = ApiService();
  List<Produto> _produtos = [];
  List<String> _categorias = ['Todos'];
  String _categoriaSelecionada = 'Todos';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    setState(() => _isLoading = true);
    final produtos = await _apiService.getProdutos();
    
    final cats = ['Todos'];
    for (var p in produtos) {
      if (p.categoria.isNotEmpty && !cats.contains(p.categoria)) {
        cats.add(p.categoria);
      }
    }

    setState(() {
      _produtos = produtos;
      _categorias = cats;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final produtosFiltrados = _categoriaSelecionada == 'Todos'
        ? _produtos
        : _produtos.where((p) => p.categoria == _categoriaSelecionada).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Empório Sophia', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: Colors.grey[50],
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : Column(
              children: [
                // Filtros de Categoria (Horizontal)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: SizedBox(
                    height: 40,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: _categorias.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final cat = _categorias[index];
                        final isSelected = _categoriaSelecionada == cat;
                        return FilterChip(
                          label: Text(cat),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() => _categoriaSelecionada = cat);
                          },
                          selectedColor: AppColors.primary.withOpacity(0.2),
                          checkmarkColor: AppColors.primary,
                          labelStyle: TextStyle(
                            color: isSelected ? AppColors.primary : Colors.black87,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: isSelected ? AppColors.primary : Colors.grey[300]!),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Lista de Produtos
                Expanded(
                  child: produtosFiltrados.isEmpty
                      ? const Center(
                          child: Text('Nenhum produto nesta categoria.', style: TextStyle(color: Colors.grey)),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: produtosFiltrados.length,
                          itemBuilder: (context, index) {
                            final produto = produtosFiltrados[index];
                            return ProdutoCard(
                              produto: produto,
                              onAdicionar: () {
                                context.read<CarrinhoProvider>().adicionar(produto);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${produto.nome} adicionado!'),
                                    duration: const Duration(seconds: 1),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: AppColors.primary,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}

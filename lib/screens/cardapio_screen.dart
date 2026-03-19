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
      appBar: const CustomNavbar(),
      backgroundColor: AppColors.surface,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Header
                  const SizedBox(height: 16),
                  const Text(
                    'Nosso Cardápio',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                  const Text('Escolha seus favoritos', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 32),

                  // Filtros
                  SizedBox(
                    height: 45,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categorias.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final cat = _categorias[index];
                        final isSelected = _categoriaSelecionada == cat;
                        return InkWell(
                          onTap: () => setState(() => _categoriaSelecionada = cat),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary : Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: isSelected ? AppColors.primary.withOpacity(0.3) : Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                )
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              cat,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Grid de Produtos
                  produtosFiltrados.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.only(top: 50),
                          child: Text('Nenhum produto encontrado.', style: TextStyle(fontSize: 18, color: Colors.grey)),
                        )
                      : LayoutBuilder(builder: (context, constraints) {
                          int crossAxisCount = constraints.maxWidth > 900 ? 3 : (constraints.maxWidth > 600 ? 2 : 1);
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              childAspectRatio: 0.8,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                            itemCount: produtosFiltrados.length,
                            itemBuilder: (context, index) {
                              final produto = produtosFiltrados[index];
                              return ProdutoCard(
                                produto: produto,
                                onAdicionar: () {
                                  context.read<CarrinhoProvider>().adicionar(produto);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${produto.nome} adicionado ao carrinho!'),
                                      duration: const Duration(seconds: 1),
                                      backgroundColor: AppColors.primaryLight,
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        }),
                ],
              ),
            ),
    );
  }
}

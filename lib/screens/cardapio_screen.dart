import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../models/produto.dart';
import '../widgets/produto_card.dart';
import '../providers/carrinho_provider.dart';
import '../providers/auth_provider.dart';
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

  Future<void> _excluirProduto(int id) async {
    final auth = context.read<AuthProvider>();
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Produto'),
        content: const Text('Tem certeza que deseja remover este item do cardápio?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      final sucesso = await _apiService.excluirProduto(id, auth.token!);
      if (sucesso) {
        _carregarDados();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Produto removido!')));
      }
    }
  }

  void _abrirFormularioProduto({Produto? produto}) {
    final nomeController = TextEditingController(text: produto?.nome ?? '');
    final descController = TextEditingController(text: produto?.descricao ?? '');
    final precoController = TextEditingController(text: produto?.preco.toString() ?? '');
    final catController = TextEditingController(text: produto?.categoria ?? '');
    final imgController = TextEditingController(text: produto?.imagem ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(produto == null ? 'Novo Produto' : 'Editar Produto'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nomeController, decoration: const InputDecoration(labelText: 'Nome')),
              TextField(controller: descController, decoration: const InputDecoration(labelText: 'Descrição')),
              TextField(controller: precoController, decoration: const InputDecoration(labelText: 'Preço'), keyboardType: TextInputType.number),
              TextField(controller: catController, decoration: const InputDecoration(labelText: 'Categoria')),
              TextField(controller: imgController, decoration: const InputDecoration(labelText: 'URL da Imagem')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              final auth = context.read<AuthProvider>();
              final dados = {
                'nome': nomeController.text,
                'descricao': descController.text,
                'preco': double.tryParse(precoController.text) ?? 0,
                'categoria': catController.text,
                'imagem': imgController.text,
              };
              final sucesso = await _apiService.salvarProduto(dados, auth.token!, id: produto?.id);
              if (sucesso) {
                Navigator.pop(context);
                _carregarDados();
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isAdmin = auth.isAdmin;

    final produtosFiltrados = _categoriaSelecionada == 'Todos'
        ? _produtos
        : _produtos.where((p) => p.categoria == _categoriaSelecionada).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Empório Sophia', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthProvider>().logout();
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[50],
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              onPressed: () => _abrirFormularioProduto(),
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : Column(
              children: [
                // Filtros de Categoria
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
                        );
                      },
                    ),
                  ),
                ),

                // Lista de Produtos
                Expanded(
                  child: produtosFiltrados.isEmpty
                      ? const Center(child: Text('Nenhum produto encontrado.'))
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
                                  SnackBar(content: Text('${produto.nome} adicionado!')),
                                );
                              },
                              onEditar: isAdmin ? () => _abrirFormularioProduto(produto: produto) : null,
                              onExcluir: isAdmin ? () => _excluirProduto(produto.id) : null,
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}

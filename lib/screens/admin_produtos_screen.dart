import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';
import '../models/produto.dart';
import '../core/constants/app_colors.dart';

class AdminProdutosScreen extends StatefulWidget {
  const AdminProdutosScreen({super.key});

  @override
  State<AdminProdutosScreen> createState() => _AdminProdutosScreenState();
}

class _AdminProdutosScreenState extends State<AdminProdutosScreen> {
  final ApiService _apiService = ApiService();
  List<Produto> _produtos = [];
  bool _isLoading = true;

  final _nomeController = TextEditingController();
  final _precoController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _categoriaController = TextEditingController();
  final _imagemController = TextEditingController();
  int? _editId;

  @override
  void initState() {
    super.initState();
    _carregarProdutos();
  }

  Future<void> _carregarProdutos() async {
    setState(() => _isLoading = true);
    final produtos = await _apiService.getProdutos();
    setState(() {
      _produtos = produtos;
      _isLoading = false;
    });
  }

  Future<void> _salvar() async {
    final auth = context.read<AuthProvider>();
    final produto = {
      'nome': _nomeController.text,
      'preco': double.parse(_precoController.text),
      'descricao': _descricaoController.text,
      'categoria': _categoriaController.text,
      'imagem': _imagemController.text,
    };

    final success = await _apiService.salvarProduto(produto, auth.token!, id: _editId);
    if (success) {
      _limpar();
      _carregarProdutos();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Produto salvo com sucesso!')));
    }
  }

  void _limpar() {
    setState(() {
      _editId = null;
      _nomeController.clear();
      _precoController.clear();
      _descricaoController.clear();
      _categoriaController.clear();
      _imagemController.clear();
    });
  }

  void _preencherParaEditar(Produto p) {
    setState(() {
      _editId = p.id;
      _nomeController.text = p.nome;
      _precoController.text = p.preco.toString();
      _descricaoController.text = p.descricao;
      _categoriaController.text = p.categoria;
      _imagemController.text = p.imagem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Produtos', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Formulário
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(_editId == null ? 'Novo Produto' : 'Editar Produto', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    TextField(controller: _nomeController, decoration: const InputDecoration(labelText: 'Nome')),
                    TextField(controller: _precoController, decoration: const InputDecoration(labelText: 'Preço'), keyboardType: TextInputType.number),
                    TextField(controller: _categoriaController, decoration: const InputDecoration(labelText: 'Categoria (lanches, bebidas...)')),
                    TextField(controller: _descricaoController, decoration: const InputDecoration(labelText: 'Descrição')),
                    TextField(controller: _imagemController, decoration: const InputDecoration(labelText: 'URL da Imagem')),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _salvar,
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                            child: Text(_editId == null ? 'CRIAR' : 'ATUALIZAR'),
                          ),
                        ),
                        if (_editId != null) ...[
                          const SizedBox(width: 8),
                          TextButton(onPressed: _limpar, child: const Text('CANCELAR')),
                        ]
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Lista
            const Text('Produtos Cadastrados', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            if (_isLoading) 
              const CircularProgressIndicator()
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _produtos.length,
                itemBuilder: (context, index) {
                  final p = _produtos[index];
                  return ListTile(
                    leading: Image.network(p.imagem, width: 50, height: 50, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.image)),
                    title: Text(p.nome),
                    subtitle: Text('R\$ ${p.preco} - ${p.categoria}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _preencherParaEditar(p)),
                        IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () async {
                          final auth = context.read<AuthProvider>();
                          if (await _apiService.excluirProduto(p.id, auth.token!)) _carregarProdutos();
                        }),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

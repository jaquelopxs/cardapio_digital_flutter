import 'package:flutter/material.dart';
import '../models/produto.dart';

class ItemCarrinho {
  final Produto produto;
  int quantidade;

  ItemCarrinho({
    required this.produto,
    this.quantidade = 1,
  });
}

class CarrinhoProvider with ChangeNotifier {
  final List<ItemCarrinho> _itens = [];

  List<ItemCarrinho> get itens => _itens;

  int get quantidadeTotal => _itens.fold(0, (sum, item) => sum + item.quantidade);

  double get valorTotal => _itens.fold(0, (sum, item) => sum + (item.produto.preco * item.quantidade));

  void adicionar(Produto produto) {
    final index = _itens.indexWhere((item) => item.produto.id == produto.id);
    
    if (index >= 0) {
      _itens[index].quantidade++;
    } else {
      _itens.add(ItemCarrinho(produto: produto));
    }
    notifyListeners();
  }

  void remover(int produtoId) {
    _itens.removeWhere((item) => item.produto.id == produtoId);
    notifyListeners();
  }

  void atualizarQuantidade(int produtoId, int novaQuantidade) {
    final index = _itens.indexWhere((item) => item.produto.id == produtoId);
    if (index >= 0) {
      if (novaQuantidade <= 0) {
        remover(produtoId);
      } else {
        _itens[index].quantidade = novaQuantidade;
        notifyListeners();
      }
    }
  }

  void limpar() {
    _itens.clear();
    notifyListeners();
  }
}

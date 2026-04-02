class Pedido {
  final int id;
  final String nomeCliente;
  final String telefone;
  final String endereco;
  final String formaPagamento;
  final double total;
  final String status;
  final DateTime dataPedido;
  final List<ItemPedido> itens;

  Pedido({
    required this.id,
    required this.nomeCliente,
    required this.telefone,
    required this.endereco,
    required this.formaPagamento,
    required this.total,
    required this.status,
    required this.dataPedido,
    required this.itens,
  });

  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      id: json['id'],
      nomeCliente: json['nome_cliente'] ?? 'Cliente',
      telefone: json['telefone'] ?? '',
      endereco: json['endereco'] ?? 'Não informado',
      formaPagamento: json['forma_pagamento'] ?? '',
      total: double.parse((json['total'] ?? 0).toString()),
      status: json['status'] ?? 'recebido',
      dataPedido: DateTime.parse(json['data_pedido'] ?? DateTime.now().toIso8601String()),
      itens: (json['itens'] as List? ?? [])
          .map((i) => ItemPedido.fromJson(i))
          .toList(),
    );
  }
}

class ItemPedido {
  final String nomeProduto;
  final int quantidade;
  final double subtotal;

  ItemPedido({
    required this.nomeProduto,
    required this.quantidade,
    required this.subtotal,
  });

  factory ItemPedido.fromJson(Map<String, dynamic> json) {
    return ItemPedido(
      nomeProduto: json['nome_produto'] ?? 'Produto',
      quantidade: json['quantidade'] ?? 0,
      subtotal: double.parse((json['subtotal'] ?? 0).toString()),
    );
  }
}

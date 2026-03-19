class Pedido {
  final int id;
  final String nomeCliente;
  final String telefone;
  final String formaPagamento;
  final double total;
  final String status;
  final DateTime dataPedido;
  final List<ItemPedido> itens;

  Pedido({
    required this.id,
    required this.nomeCliente,
    required this.telefone,
    required this.formaPagamento,
    required this.total,
    required this.status,
    required this.dataPedido,
    required this.itens,
  });

  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      id: json['id'],
      nomeCliente: json['nome_cliente'],
      telefone: json['telefone'],
      formaPagamento: json['forma_pagamento'],
      total: double.parse(json['total'].toString()),
      status: json['status'],
      dataPedido: DateTime.parse(json['data_pedido']),
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

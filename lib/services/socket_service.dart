import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'api_service.dart';

class SocketService {
  static IO.Socket? _socket;

  static void connect(BuildContext context, {required bool isAdmin, String? userName}) {
    if (_socket != null && _socket!.connected) return;

    _socket = IO.io(ApiService.baseUrl, IO.OptionBuilder()
      .setTransports(['websocket'])
      .disableAutoConnect()
      .build());

    _socket!.connect();

    _socket!.onConnect((_) => print('Conectado ao WebSocket'));

    // Ouvir novos pedidos (Para o ADMIN)
    if (isAdmin) {
      _socket!.on('novoPedido', (data) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🔔 Novo Pedido recebido de ${data['nome_cliente']}!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 5),
          ),
        );
      });
    }

    // Ouvir mudanças de status (Para o CLIENTE)
    _socket!.on('statusAlterado', (data) {
      // Se for o pedido do cliente logado (checar nome ou ID se possível)
      if (!isAdmin && (userName == null || data['nome_cliente'] == userName)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🍕 Seu pedido #${data['id']} agora está: ${data['status'].toString().toUpperCase()}'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    });

    _socket!.onDisconnect((_) => print('Desconectado do WebSocket'));
  }

  static void disconnect() {
    _socket?.disconnect();
    _socket = null;
  }
}

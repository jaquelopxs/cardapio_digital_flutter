import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../providers/carrinho_provider.dart';
import '../providers/auth_provider.dart';
import 'cardapio_screen.dart';
import 'carrinho_screen.dart';
import 'status_pedido_screen.dart';
import 'dashboard_screen.dart';
import '../services/socket_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Conectar ao WebSocket após o carregamento inicial
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      if (auth.isAuthenticated) {
        SocketService.connect(
          context, 
          isAdmin: auth.isAdmin, 
          userName: auth.user?['nome']
        );
      }
    });
  }

  @override
  void dispose() {
    SocketService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    // Se o usuário deslogar, volta para a tela de login automaticamente
    if (!authProvider.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final isAdmin = authProvider.isAdmin;

    // Telas do Administrador
    final List<Widget> adminScreens = [
      const DashboardScreen(),
      const CardapioScreen(), // Admin também pode ver o cardápio
    ];

    // Telas do Cliente
    final List<Widget> clientScreens = [
      const CardapioScreen(),
      const CarrinhoScreen(),
      const StatusPedidoScreen(),
    ];

    final screens = isAdmin ? adminScreens : clientScreens;

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        items: isAdmin 
          ? [
              const BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Pedidos (Admin)'),
              const BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Cardápio'),
            ]
          : [
              const BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Cardápio'),
              BottomNavigationBarItem(
                icon: Stack(
                  children: [
                    const Icon(Icons.shopping_cart),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Consumer<CarrinhoProvider>(
                        builder: (context, carrinho, child) {
                          if (carrinho.quantidadeTotal == 0) return const SizedBox();
                          return Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                            constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                            child: Text(
                              '${carrinho.quantidadeTotal}',
                              style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                label: 'Carrinho',
              ),
              const BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Meus Pedidos'),
            ],
      ),
    );
  }
}

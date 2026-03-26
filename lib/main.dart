import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/constants/app_colors.dart';
import 'providers/carrinho_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/home_screen.dart';
import 'screens/cardapio_screen.dart';
import 'screens/carrinho_screen.dart';
import 'screens/status_pedido_screen.dart';
import 'screens/admin_login_screen.dart';
import 'screens/admin_pedidos_screen.dart';
import 'screens/admin_produtos_screen.dart';
import 'screens/cadastro_screen.dart';
import 'screens/esqueceu_senha_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CarrinhoProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Empório Sophia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.primaryLight,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
        useMaterial3: true,
      ),
      // SIMULADOR DE CELULAR COMPLETO
      builder: (context, child) {
        return Scaffold(
          backgroundColor: const Color(0xFF1A1A1A), // Fundo escuro atrás do celular
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // MOLDURA DO CELULAR
                    Container(
                      width: 380, // Largura padrão de um smartphone
                      height: 780, // Altura padrão
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: const Color(0xFF333333), width: 12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 40,
                            offset: const Offset(0, 20),
                          )
                        ],
                      ),
                      child: Stack(
                        children: [
                          // TELA DO APP
                          ClipRRect(
                            borderRadius: BorderRadius.circular(38),
                            child: Container(
                              color: Colors.white,
                              child: child,
                            ),
                          ),
                          
                          // NOTCH DA CÂMERA (O furinho/barra no topo)
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              margin: const EdgeInsets.top(12),
                              width: 150,
                              height: 30,
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
                              ),
                              child: Center(
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(color: Color(0xFF1A1A1A), shape: BoxShape.circle),
                                ),
                              ),
                            ),
                          ),

                          // INDICADOR DE HOME (A barrinha de baixo)
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              width: 120,
                              height: 5,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Modo Visualização: Smartphone',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/cardapio': (context) => const CardapioScreen(),
        '/carrinho': (context) => const CarrinhoScreen(),
        '/status': (context) => const StatusPedidoScreen(),
        '/admin': (context) => const AdminLoginScreen(),
        '/admin/pedidos': (context) => const AdminPedidosScreen(),
        '/admin/produtos': (context) => const AdminProdutosScreen(),
        '/register': (context) => const CadastroScreen(),
        '/forgot-password': (context) => const EsqueceuSenhaScreen(),
      },
    );
  }
}

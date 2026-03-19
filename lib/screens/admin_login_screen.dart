import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../core/constants/app_colors.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  Future<void> _handleLogin() async {
    final auth = context.read<AuthProvider>();
    final result = await auth.login(_emailController.text, _senhaController.text);

    if (result.containsKey('token')) {
      Navigator.pushReplacementNamed(context, '/admin/pedidos'); // TODO: Criar AdminPedidosScreen
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: ${result['error'] ?? 'Credenciais inválidas'}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.heroGradient),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 48),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 40, offset: Offset(0, 20))],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo Circle
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.heroGradient,
                    ),
                    alignment: Alignment.center,
                    child: const Text('ES', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 24),
                  const Text('Área Administrativa', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const Text('Faça login para gerenciar', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 32),

                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'E-mail', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _senhaController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Senha', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 32),

                  Consumer<AuthProvider>(
                    builder: (context, auth, child) {
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: auth.isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: auth.isLoading 
                            ? const CircularProgressIndicator(color: Colors.white) 
                            : const Text('Entrar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, '/'),
                    child: const Text('Voltar ao site', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

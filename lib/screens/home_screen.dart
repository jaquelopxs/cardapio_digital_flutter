import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre o Projeto', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair da conta',
            onPressed: () => _confirmarLogout(context),
          ),
        ],
      ),
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Logo ou Ícone Principal
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.info_outline, size: 80, color: AppColors.primary),
            ),
            const SizedBox(height: 32),
            
            _buildSectionTitle('Objetivo'),
            const Text(
              'Desenvolver um aplicativo multiplataforma que funcione como um cardápio digital, permitindo que clientes visualizem produtos disponíveis e realizem pedidos de forma intuitiva e rápida.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
            ),
            
            const Divider(height: 48),
            
            _buildSectionTitle('Equipe de Desenvolvimento'),
            const Text(
              'Integrantes da Equipe',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
            const SizedBox(height: 12),
            const Text('• Jaqueline Santos Lopes', 
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, height: 1.8),
            ),
            
            const Divider(height: 48),
            
            // Seção visível apenas para Admin
            Consumer<AuthProvider>(
              builder: (context, auth, child) {
                if (auth.user?['is_admin'] != true) return const SizedBox();
                
                return Column(
                  children: [
                    _buildSectionTitle('Área do Estabelecimento'),
                    const Text(
                      'Acesse a dashboard para gerenciar pedidos em tempo real.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.pushNamed(context, '/dashboard'),
                      icon: const Icon(Icons.dashboard_outlined),
                      label: const Text('Dashboard Cozinha'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),
                    const Divider(height: 48),
                  ],
                );
              },
            ),
            
            _buildInfoRow('Disciplina', 'Prática Extensionista VIII'),
            _buildInfoRow('Instituição', 'UNAERP - Ribeirão Preto'),
            _buildInfoRow('Professor', 'Rodrigo Plotz'),
            _buildInfoRow('Versão', '1.0.0'),
            
            const SizedBox(height: 40),
            const Text(
              '© 2026 Empório Sophia',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _confirmarLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair'),
        content: const Text('Deseja realmente sair da sua conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AuthProvider>().logout();
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87)),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre o Projeto', style: TextStyle(fontWeight: FontWeight.bold)),
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
            // Substitua pelos nomes reais dos integrantes
            const Text('• Integrante 1\n• Integrante 2\n• Integrante 3', 
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, height: 1.8),
            ),
            
            const Divider(height: 48),
            
            _buildInfoRow('Disciplina', 'Prática Extensionista VIII'),
            _buildInfoRow('Instituição', 'Nome da Instituição'),
            _buildInfoRow('Professor', 'Nome do Professor'),
            _buildInfoRow('Versão', '1.0.0'),
            
            const SizedBox(height: 40),
            const Text(
              '© 2025 Empório Sophia',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
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

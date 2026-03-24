import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class SobreScreen extends StatelessWidget {
  const SobreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre o Projeto'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Icon(Icons.restaurant, size: 80, color: AppColors.primary),
            ),
            const SizedBox(height: 20),
            const Text(
              'Empório Sophia',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
            const SizedBox(height: 10),
            const Text(
              'Objetivo:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Desenvolver um aplicativo de cardápio digital moderno e funcional para facilitar o processo de pedidos em estabelecimentos comerciais, aplicando conceitos de desenvolvimento multiplataforma e integração com APIs REST.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Equipe de Desenvolvimento:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text(
              '• [Nome do Integrante 1]\n• [Nome do Integrante 2]\n• [Nome do Integrante 3]',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),
            _buildInfoRow('Disciplina:', 'Desenvolvimento de Apps'),
            _buildInfoRow('Instituição:', 'Sua Instituição'),
            _buildInfoRow('Professor:', 'Seu Professor'),
            _buildInfoRow('Versão:', '1.0.0'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(width: 10),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class SobreScreen extends StatelessWidget {
  const SobreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre o Empório Sophia'),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Icon(Icons.restaurant, size: 80, color: AppColors.primary),
            ),
            const SizedBox(height: 32),
            const Text(
              'O Empório Sophia',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            const Text(
              'O Empório Sophia é o seu destino digital para saborear o melhor da culinária local. '
              'Nosso aplicativo foi desenvolvido para oferecer uma experiência de compra ágil, '
              'segura e intuitiva, conectando você aos sabores que ama com apenas alguns cliques.',
              style: TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
            ),
            const SizedBox(height: 32),
            const Text(
              'Nossa Missão',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
            const SizedBox(height: 12),
            const Text(
              'Nossa missão é proporcionar momentos de prazer e conveniência através de produtos frescos, '
              'selecionados e um atendimento de excelência, transformando cada pedido em uma experiência única.',
              style: TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
            ),
            const SizedBox(height: 48),
            const Divider(),
            const SizedBox(height: 24),
            const Center(
              child: Column(
                children: [
                  Text('Versão 1.0.0', style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 4),
                  Text('© 2026 Empório Sophia - Todos os direitos reservados', 
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

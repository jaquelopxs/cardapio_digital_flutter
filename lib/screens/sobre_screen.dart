import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class SobreScreen extends StatelessWidget {
  const SobreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre o Aplicativo'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo
            const Center(
              child: CircleAvatar(
                radius: 48,
                backgroundColor: AppColors.primary,
                child: Icon(Icons.restaurant, size: 48, color: Colors.white),
              ),
            ),
            const SizedBox(height: 24),
            const Center(
              child: Text(
                'Cardápio Digital',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            const Center(
              child: Text(
                'Empório Sophia',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 32),

            // Objetivo
            _buildSecao(
              icone: Icons.info_outline,
              titulo: 'Objetivo do Aplicativo',
              conteudo:
                  'O Cardápio Digital do Empório Sophia permite que clientes '
                  'visualizem o cardápio completo do estabelecimento e realizem '
                  'pedidos de forma rápida, prática e intuitiva, diretamente '
                  'pelo celular ou navegador.',
            ),
            const SizedBox(height: 24),

            // Disciplina
            _buildSecao(
              icone: Icons.school_outlined,
              titulo: 'Informações Acadêmicas',
              conteudo:
                  'Disciplina: Prática Extensionista VIII\n'
                  'Instituição: UNAERP\n'
                  'Professor(a): Rodrigo Plotz',
            ),
            const SizedBox(height: 24),

            // Equipe
            _buildSecao(
              icone: Icons.people_outline,
              titulo: 'Equipe de Desenvolvimento',
              conteudo: '',
            ),
            _buildIntegrante('Jaqueline S. Lopes'),
            const SizedBox(height: 32),

            // Tecnologias
            _buildSecao(
              icone: Icons.code_outlined,
              titulo: 'Tecnologias Utilizadas',
              conteudo:
                  'Frontend: Flutter (Dart)\n'
                  'Backend: Node.js + Express\n'
                  'Banco de dados: PostgreSQL\n'
                  'Gerenciamento de estado: Provider',
            ),
            const SizedBox(height: 40),
            const Divider(),
            const SizedBox(height: 24),

            // Versão e copyright
            const Center(
              child: Column(
                children: [
                  Text(
                    'Versão 1.0.0',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '© 2026 Empório Sophia — Todos os direitos reservados',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSecao({
    required IconData icone,
    required String titulo,
    required String conteudo,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icone, color: AppColors.primary, size: 22),
            const SizedBox(width: 8),
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (conteudo.isNotEmpty)
          Text(
            conteudo,
            style: const TextStyle(fontSize: 15, height: 1.6, color: Colors.black87),
          ),
      ],
    );
  }

  Widget _buildIntegrante(String nome) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primary,
            child: Icon(Icons.person, size: 20, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Text(
            nome,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

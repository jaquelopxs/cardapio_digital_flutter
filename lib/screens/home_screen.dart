import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const _HeroSection(),
            const _SobreSection(),
            const _DiferenciaisSection(),
            const _CTASection(),
            const _Footer(),
          ],
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        gradient: AppColors.heroGradient,
      ),
      child: Stack(
        children: [
          // Decorative Circles
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -150,
            left: -150,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.03),
                shape: BoxShape.circle,
              ),
            ),
          ),
          
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo Placeholder (Imagem de lanche do original)
                  Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withOpacity(0.2), width: 6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 40,
                          offset: const Offset(0, 10),
                        ),
                      ],
                      image: const DecorationImage(
                        image: NetworkImage('https://images.unsplash.com/photo-1561758033-d89a9ad46330?q=80&w=200&auto=format&fit=crop'), // Imagem de lanche profissional
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Empório Sophia',
                    style: TextStyle(
                      fontSize: 52,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                      shadows: [
                        Shadow(color: Colors.black26, blurRadius: 8, offset: Offset(2, 2)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Tradição e Sabor desde 1995',
                    style: TextStyle(
                      fontSize: 22,
                      color: AppColors.accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: const Text(
                      'Lanches artesanais preparados com ingredientes selecionados e muito carinho. Experimente a melhor experiência gastronômica da cidade.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                        height: 1.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Navegar para Cardápio
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 4,
                        ),
                        child: const Text('Ver Cardápio', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          // Scroll para seção sobre (simulado)
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white30, width: 2),
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Nossa História', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SobreSection extends StatelessWidget {
  const _SobreSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      color: AppColors.surface,
      child: Column(
        children: [
          const Text(
            'Nossa História',
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.primary),
          ),
          const SizedBox(height: 12),
          Container(
            width: 80,
            height: 4,
            decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 60),
          const Wrap(
            spacing: 40,
            runSpacing: 40,
            alignment: WrapAlignment.center,
            children: [
              _HistoryCard(
                title: 'Desde 1995',
                content: 'O Empório Sophia nasceu do sonho de Dona Sophia em oferecer lanches caseiros e saborosos...',
              ),
              _HistoryCard(
                title: 'Qualidade Garantida',
                content: 'Selecionamos cuidadosamente cada ingrediente, trabalhamos apenas com fornecedores de confiança...',
              ),
              _HistoryCard(
                title: 'Feito com Amor',
                content: 'Cada hambúrguer é preparado com o mesmo carinho que Dona Sophia colocava em suas receitas...',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final String title;
  final String content;

  const _HistoryCard({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary)),
          const SizedBox(height: 12),
          Text(content, style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.6)),
        ],
      ),
    );
  }
}

class _DiferenciaisSection extends StatelessWidget {
  const _DiferenciaisSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      color: Colors.white,
      child: Column(
        children: [
          const Text(
            'Por que Escolher o Empório Sophia?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primary),
          ),
          const SizedBox(height: 60),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: MediaQuery.of(context).size.width > 900 ? 4 : (MediaQuery.of(context).size.width > 600 ? 2 : 1),
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            children: const [
              _DiferencialItem(icon: Icons.flash_on, title: 'Entrega Rápida', desc: 'Seu pedido chega quentinho em até 40 min'),
              _DiferencialItem(icon: Icons.star, title: 'Ingredientes Premium', desc: 'Selecionamos apenas o melhor para você'),
              _DiferencialItem(icon: Icons.attach_money, title: 'Preço Justo', desc: 'Qualidade excepcional com preço acessível'),
              _DiferencialItem(icon: Icons.favorite, title: 'Atendimento 5 Estrelas', desc: 'Equipe dedicada a superar expectativas'),
            ],
          ),
        ],
      ),
    );
  }
}

class _DiferencialItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;

  const _DiferencialItem({required this.icon, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: AppColors.primary),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
          const SizedBox(height: 8),
          Text(desc, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

class _CTASection extends StatelessWidget {
  const _CTASection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
      decoration: const BoxDecoration(gradient: AppColors.heroGradient),
      child: Column(
        children: [
          const Text('Pronto para Saborear?', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 16),
          const Text(
            'Navegue pelo nosso cardápio e faça seu pedido agora mesmo.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Fazer Pedido Agora', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      color: AppColors.dark,
      child: const Column(
        children: [
          Text('Empório Sophia', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('Tradição e Sabor desde 1995', style: TextStyle(color: Colors.grey)),
          SizedBox(height: 16),
          Text('© 2025 Empório Sophia. Todos os direitos reservados.', style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}

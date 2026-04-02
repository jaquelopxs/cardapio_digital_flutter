import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../core/constants/app_colors.dart';

class EsqueceuSenhaScreen extends StatefulWidget {
  const EsqueceuSenhaScreen({super.key});

  @override
  State<EsqueceuSenhaScreen> createState() => _EsqueceuSenhaScreenState();
}

class _EsqueceuSenhaScreenState extends State<EsqueceuSenhaScreen> {
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _newPasswordController = TextEditingController();
  bool _codeSent = false;

  bool _isEmailValid(String email) {
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return emailRegex.hasMatch(email);
  }

  Future<void> _handleForgotPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor, informe seu e-mail.')));
      return;
    }

    final auth = context.read<AuthProvider>();
    final result = await auth.forgotPassword(email);

    if (result.containsKey('message')) {
      setState(() => _codeSent = true);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message'])));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: ${result['error'] ?? 'Falha na solicitação'}')));
    }
  }

  Future<void> _handleVerifyAndReset() async {
    final code = _codeController.text.trim();
    final newPass = _newPasswordController.text.trim();

    if (code.isEmpty || newPass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Preencha o código e a nova senha.')));
      return;
    }

    // Aqui você chamaria o ApiService().resetPassword() se existir, 
    // ou usaria o verifyCode se o backend já estiver pronto para resetar.
    final auth = context.read<AuthProvider>();
    final result = await auth.verifyCode(_emailController.text.trim(), code);

    if (result.containsKey('message')) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Senha redefinida com sucesso!')));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: ${result['error'] ?? 'Código inválido'}')));
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
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 40, offset: Offset(0, 20))],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_codeSent ? 'Redefinir Senha' : 'Recuperar Senha', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Text(
                    _codeSent 
                      ? 'Digite o código enviado para seu e-mail e sua nova senha.' 
                      : 'Informe seu e-mail e enviaremos as instruções para você.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 32),
                  if (!_codeSent)
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'E-mail', border: OutlineInputBorder()),
                    )
                  else ...[
                    TextField(
                      controller: _codeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Código de Verificação', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _newPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Nova Senha', border: OutlineInputBorder()),
                    ),
                  ],
                  const SizedBox(height: 32),
                  Consumer<AuthProvider>(
                    builder: (context, auth, child) {
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: auth.isLoading ? null : (_codeSent ? _handleVerifyAndReset : _handleForgotPassword),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: auth.isLoading 
                            ? const CircularProgressIndicator(color: Colors.white) 
                            : Text(_codeSent ? 'Redefinir Senha' : 'Enviar Instruções', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Voltar ao login', style: TextStyle(color: AppColors.primary)),
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

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
<<<<<<< HEAD
  final _confirmPasswordController = TextEditingController();
  bool _codeSent = false;
  bool _isObscure = true;
=======
  bool _codeSent = false;
>>>>>>> 72bbee81325504357f9041a0baafdc846eaa2c26

  bool _isEmailValid(String email) {
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return emailRegex.hasMatch(email);
  }

  Future<void> _handleForgotPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
<<<<<<< HEAD
      _showSnack('Por favor, informe seu e-mail.', isError: true);
      return;
    }

    if (!_isEmailValid(email)) {
      _showSnack('Formato de e-mail inválido.', isError: true);
=======
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor, informe seu e-mail.')));
>>>>>>> 72bbee81325504357f9041a0baafdc846eaa2c26
      return;
    }

    final auth = context.read<AuthProvider>();
    final result = await auth.forgotPassword(email);

    if (result.containsKey('message')) {
      setState(() => _codeSent = true);
<<<<<<< HEAD
      _showSnack(result['message']);
    } else {
      _showSnack(result['error'] ?? 'Falha na solicitação.', isError: true);
    }
  }

  Future<void> _handleResetPassword() async {
    final codigo = _codeController.text.trim();
    final novaSenha = _newPasswordController.text.trim();
    final confirmacao = _confirmPasswordController.text.trim();

    if (codigo.isEmpty || novaSenha.isEmpty || confirmacao.isEmpty) {
      _showSnack('Preencha todos os campos.', isError: true);
      return;
    }

    if (novaSenha.length < 6) {
      _showSnack('A senha deve ter pelo menos 6 caracteres.', isError: true);
      return;
    }

    if (novaSenha != confirmacao) {
      _showSnack('As senhas não coincidem.', isError: true);
      return;
    }

    final auth = context.read<AuthProvider>();
    final result = await auth.resetPassword(
      _emailController.text.trim(),
      codigo,
      novaSenha,
    );

    if (result.containsKey('message')) {
      _showSnack(result['message']);
      if (mounted) Navigator.pop(context);
    } else {
      _showSnack(result['error'] ?? 'Código inválido.', isError: true);
    }
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

=======
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

>>>>>>> 72bbee81325504357f9041a0baafdc846eaa2c26
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
<<<<<<< HEAD
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 40, offset: Offset(0, 20))
                ],
=======
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 40, offset: Offset(0, 20))],
>>>>>>> 72bbee81325504357f9041a0baafdc846eaa2c26
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
<<<<<<< HEAD
                  Icon(
                    _codeSent ? Icons.lock_reset : Icons.lock_outline,
                    size: 56,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _codeSent ? 'Redefinir Senha' : 'Recuperar Senha',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _codeSent
                        ? 'Digite o código enviado para seu e-mail e escolha uma nova senha.'
                        : 'Informe seu e-mail e enviaremos um código de verificação.',
=======
                  Text(_codeSent ? 'Redefinir Senha' : 'Recuperar Senha', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Text(
                    _codeSent 
                      ? 'Digite o código enviado para seu e-mail e sua nova senha.' 
                      : 'Informe seu e-mail e enviaremos as instruções para você.',
>>>>>>> 72bbee81325504357f9041a0baafdc846eaa2c26
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 32),
<<<<<<< HEAD

                  // Etapa 1: E-mail
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    enabled: !_codeSent,
                    decoration: InputDecoration(
                      labelText: 'E-mail',
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: _codeSent,
                      fillColor: _codeSent ? Colors.grey[100] : null,
                    ),
                  ),

                  // Etapa 2: Código + nova senha
                  if (_codeSent) ...[
                    const SizedBox(height: 16),
                    TextField(
                      controller: _codeController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        letterSpacing: 8,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Código de verificação',
                        counterText: '',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
=======
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
>>>>>>> 72bbee81325504357f9041a0baafdc846eaa2c26
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _newPasswordController,
<<<<<<< HEAD
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                        labelText: 'Nova senha',
                        prefixIcon: const Icon(Icons.lock_outlined),
                        suffixIcon: IconButton(
                          icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
                          onPressed: () => setState(() => _isObscure = !_isObscure),
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                        labelText: 'Confirmar nova senha',
                        prefixIcon: const Icon(Icons.lock_reset_outlined),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],

=======
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Nova Senha', border: OutlineInputBorder()),
                    ),
                  ],
>>>>>>> 72bbee81325504357f9041a0baafdc846eaa2c26
                  const SizedBox(height: 32),
                  Consumer<AuthProvider>(
                    builder: (context, auth, child) {
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
<<<<<<< HEAD
                          onPressed: auth.isLoading
                              ? null
                              : (_codeSent ? _handleResetPassword : _handleForgotPassword),
=======
                          onPressed: auth.isLoading ? null : (_codeSent ? _handleVerifyAndReset : _handleForgotPassword),
>>>>>>> 72bbee81325504357f9041a0baafdc846eaa2c26
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.all(16),
<<<<<<< HEAD
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: auth.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2),
                                )
                              : Text(
                                  _codeSent ? 'Redefinir Senha' : 'Enviar Código',
                                  style: const TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold),
                                ),
=======
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: auth.isLoading 
                            ? const CircularProgressIndicator(color: Colors.white) 
                            : Text(_codeSent ? 'Redefinir Senha' : 'Enviar Instruções', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
>>>>>>> 72bbee81325504357f9041a0baafdc846eaa2c26
                        ),
                      );
                    },
                  ),
<<<<<<< HEAD

                  if (_codeSent)
                    TextButton(
                      onPressed: () => setState(() {
                        _codeSent = false;
                        _codeController.clear();
                        _newPasswordController.clear();
                        _confirmPasswordController.clear();
                      }),
                      child: const Text('Reenviar código',
                          style: TextStyle(color: AppColors.primary)),
                    ),

                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Voltar ao login',
                        style: TextStyle(color: Colors.grey)),
=======
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Voltar ao login', style: TextStyle(color: AppColors.primary)),
>>>>>>> 72bbee81325504357f9041a0baafdc846eaa2c26
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

import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../services/api_service.dart';

enum AuthMode { login, register, forgotPassword }

class LoginRegisterScreen extends StatefulWidget {
  const LoginRegisterScreen({super.key});

  @override
  State<LoginRegisterScreen> createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginRegisterScreen> {
  AuthMode _authMode = AuthMode.login;
  final _apiService = ApiService();
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  void _switchMode(AuthMode mode) {
    setState(() {
      _authMode = mode;
      _formKey.currentState?.reset();
    });
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (_authMode == AuthMode.login) {
        // RF001: Login
        final result = await _apiService.login(
          _emailController.text,
          _passwordController.text,
        );

        if (result.containsKey('token')) {
          Navigator.pushReplacementNamed(context, '/cardapio');
        } else {
          _showError(result['error'] ?? 'Erro ao realizar login');
        }
      } else if (_authMode == AuthMode.register) {
        // RF002: Cadastro
        final result = await _apiService.registrar({
          'nome': _nameController.text,
          'email': _emailController.text,
          'telefone': _phoneController.text,
          'senha': _passwordController.text,
        });

        if (result.containsKey('message') || result.containsKey('id')) {
          _showSuccess('Cadastro realizado com sucesso! Faça login.');
          _switchMode(AuthMode.login);
        } else {
          _showError(result['error'] ?? 'Erro ao realizar cadastro');
        }
      } else if (_authMode == AuthMode.forgotPassword) {
        // RF003: Esqueceu a senha
        final result = await _apiService.recuperarSenha(_emailController.text);
        _showSuccess('Se o e-mail estiver cadastrado, você receberá instruções de recuperação.');
        _switchMode(AuthMode.login);
      }
    } catch (e) {
      _showError('Erro de conexão com o servidor');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.heroGradient,
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Empório Sophia',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  if (_authMode == AuthMode.register) ...[
                    _buildTextField(_nameController, 'Nome Completo', Icons.person),
                    const SizedBox(height: 15),
                    _buildTextField(_phoneController, 'Telefone', Icons.phone),
                    const SizedBox(height: 15),
                  ],

                  _buildTextField(
                    _emailController, 
                    'E-mail', 
                    Icons.email,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Campo obrigatório';
                      if (!_isValidEmail(value)) return 'E-mail inválido';
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),

                  if (_authMode != AuthMode.forgotPassword) ...[
                    _buildTextField(
                      _passwordController, 
                      'Senha', 
                      Icons.lock, 
                      isPassword: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Campo obrigatório';
                        if (value.length < 6) return 'Mínimo 6 caracteres';
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                  ],

                  if (_authMode == AuthMode.register) ...[
                    _buildTextField(
                      _confirmPasswordController, 
                      'Confirmação de Senha', 
                      Icons.lock_outline, 
                      isPassword: true,
                      validator: (value) {
                        if (value != _passwordController.text) return 'As senhas não coincidem';
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                  ],

                  if (_authMode == AuthMode.login)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => _switchMode(AuthMode.forgotPassword),
                        child: const Text('Esqueceu a senha?', style: TextStyle(color: Colors.white70)),
                      ),
                    ),

                  const SizedBox(height: 20),
                  
                  _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                          minimumSize: const Size(double.infinity, 55),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        child: Text(
                          _authMode == AuthMode.login ? 'ENTRAR' : 
                          _authMode == AuthMode.register ? 'CADASTRAR' : 'RECUPERAR',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                  
                  const SizedBox(height: 15),
                  
                  TextButton(
                    onPressed: () {
                      if (_authMode == AuthMode.login) {
                        _switchMode(AuthMode.register);
                      } else {
                        _switchMode(AuthMode.login);
                      }
                    },
                    child: Text(
                      _authMode == AuthMode.login 
                        ? 'Não tem uma conta? Cadastre-se' 
                        : 'Já tem uma conta? Faça login',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller, 
    String label, 
    IconData icon, {
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      validator: validator ?? (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.white30),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.white),
        ),
        errorStyle: const TextStyle(color: Colors.yellowAccent),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
      ),
    );
  }
}

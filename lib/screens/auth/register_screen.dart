import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../themes/app_theme.dart';
import '../../widgets/index.dart';
import '../../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final user = await AuthService.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (!mounted) return;
      setState(() => _isLoading = false);
      if (user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      String message = 'Erro no cadastro';
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'invalid-email':
            message = 'E-mail inválido. Use um endereço de e-mail válido.';
            break;
          case 'email-already-in-use':
            message = 'Este e-mail já está em uso.';
            break;
          case 'weak-password':
            message = 'Senha muito fraca. Use ao menos 6 caracteres.';
            break;
          case 'operation-not-allowed':
            message = 'Método de autenticação não habilitado no Firebase.';
            break;
          default:
            message = '${e.code}: ${e.message ?? 'Erro no cadastro'}';
        }
      } else {
        message = 'Erro no cadastro: ${e.toString()}';
      }
      if (kDebugMode) {
        debugPrint('Register error: ${e.runtimeType} - $message');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro no cadastro: $message')),
      );
    }
  }

  Future<void> _handleGoogleRegister() async {
    setState(() => _isLoading = true);
    try {
      final user = await AuthService.signInWithGoogle();
      if (!mounted) return;
      setState(() => _isLoading = false);
      if (user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro no cadastro com Google: ${e.toString()}')),
      );
    }
  }

  void _handleAppleRegister() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cadastro com Apple (em desenvolvimento)'),
      ),
    );
  }

  void _navigateToLogin() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _handleForgotPassword() {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite um e-mail válido para recuperação')),
      );
      return;
    }

    setState(() => _isLoading = true);
    AuthService.sendPasswordResetEmail(email: email).then((_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('E-mail de recuperação enviado')),
      );
    }).catchError((e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao enviar e-mail: ${e.toString()}')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 600;
            final horizontalPadding = isWide ? 48.0 : 24.0;
            final titleFontSize = constraints.maxWidth >= 360 ? 28.0 : 24.0;

            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back,
                            color: AppColors.primary),
                        onPressed: () => Navigator.maybePop(context),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'CompreFácil',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: AppColors.primary,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.shopping_cart_outlined,
                        color: AppColors.primary,
                        size: 28,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: 8,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints(maxWidth: isWide ? 560 : 560),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Center(
                              child: SizedBox(
                                width: 80,
                                height: 80,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: AppColors.primarySoft,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.shopping_bag_outlined,
                                    size: 40,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Cadastre sua conta',
                              style: theme.textTheme.displayMedium?.copyWith(
                                fontSize: titleFontSize,
                                color: AppColors.textPrimary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 4,
                              shadowColor: AppColors.cardShadow,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Form(
                                  key: _formKey,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      CustomTextField(
                                        label: 'E-MAIL',
                                        hint: 'nome@exemplo.com',
                                        prefixIcon: Icons.email_outlined,
                                        controller: _emailController,
                                        validator: (value) {
                                          if (value?.isEmpty ?? true) {
                                            return 'E-mail é obrigatório';
                                          }
                                          if (!value!.contains('@')) {
                                            return 'E-mail inválido';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 16),
                                      CustomTextField(
                                        label: 'SENHA',
                                        hint: '••••••••',
                                        prefixIcon: Icons.lock_outline,
                                        controller: _passwordController,
                                        isPassword: true,
                                        validator: (value) {
                                          if (value?.isEmpty ?? true) {
                                            return 'Senha é obrigatória';
                                          }
                                          if (value!.length < 6) {
                                            return 'Mínimo 6 caracteres';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 16),
                                      CustomTextField(
                                        label: 'CONFIRME A SENHA',
                                        hint: '••••••••',
                                        prefixIcon: Icons.lock_outline,
                                        controller: _confirmPasswordController,
                                        isPassword: true,
                                        validator: (value) {
                                          if (value?.isEmpty ?? true) {
                                            return 'Confirmação de senha é obrigatória';
                                          }
                                          if (value !=
                                              _passwordController.text) {
                                            return 'As senhas não coincidem';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 12),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                          onPressed: _handleForgotPassword,
                                          style: TextButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            textStyle: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          child: const Text(
                                            'Esqueceu a senha?',
                                            style: TextStyle(
                                                color: AppColors.primary),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      PrimaryButton(
                                        label: 'Cadastrar-se',
                                        onPressed: _handleRegister,
                                        isLoading: _isLoading,
                                      ),
                                      const SizedBox(height: 20),
                                      const Row(
                                        children: [
                                          Expanded(
                                            child: Divider(
                                              color: AppColors.border,
                                              thickness: 1,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12),
                                            child: Text(
                                              'OU CADASTRE-SE COM',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.textSecondary,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Divider(
                                              color: AppColors.border,
                                              thickness: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        children: [
                                          SocialButton(
                                            label: 'Google',
                                            icon: Icons.g_mobiledata,
                                            onPressed: _handleGoogleRegister,
                                          ),
                                          const SizedBox(width: 12),
                                          SocialButton(
                                            label: 'Apple',
                                            icon: Icons.apple,
                                            onPressed: _handleAppleRegister,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: AuthBottomNavigation(
        onEnterPressed: _navigateToLogin,
        onSignUpPressed: _handleRegister,
        isSignUpActive: true,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../themes/app_theme.dart';
import '../../widgets/index.dart';
import '../../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final user = await AuthService.signIn(
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
      String message = 'Erro ao entrar';
      if (e is FirebaseAuthException) {
        message = e.message ?? message;
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Future<void> _handleGoogleLogin() async {
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
        SnackBar(content: Text('Erro no login com Google: ${e.toString()}')),
      );
    }
  }

  void _handleAppleLogin() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Login com Apple (em desenvolvimento)')),
    );
  }

  void _handleSignUp() {
    Navigator.pushNamed(context, '/register');
  }

  void _handleForgotPassword() {
    final email = _emailController.text.trim();
    // Validate email with robust regex pattern to prevent invalid emails
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite um e-mail válido')),
      );
      return;
    }

    setState(() => _isLoading = true);
    AuthService.sendPasswordResetEmail(email: email).then((_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      // Generic message to prevent email enumeration attacks
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Se o e-mail existir, você receberá instruções de recuperação')),
      );
    }).catchError((e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      // Generic error message without exposing technical details
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao processar recuperação')),
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
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
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
                        const SizedBox(width: 48),
                      ],
                    ),
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
                                    Icons.location_on_rounded,
                                    size: 40,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Bem-vindo de volta',
                              style: theme.textTheme.displayMedium?.copyWith(
                                fontSize: titleFontSize,
                                color: AppColors.textPrimary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Seu caminho otimizado para uma experiência de compra inteligente espera por você.',
                              style: theme.textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
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
                                      const SizedBox(height: 16),
                                      PrimaryButton(
                                        label: 'Entrar',
                                        onPressed: _handleLogin,
                                        isLoading: _isLoading,
                                      ),
                                      const SizedBox(height: 16),
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
                                              'OU CONTINUE COM',
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
                                      const SizedBox(height: 16),
                                      Row(
                                        children: [
                                          SocialButton(
                                            label: 'Google',
                                            icon: Icons.g_mobiledata,
                                            onPressed: _handleGoogleLogin,
                                          ),
                                          const SizedBox(width: 12),
                                          SocialButton(
                                            label: 'Apple',
                                            icon: Icons.apple,
                                            onPressed: _handleAppleLogin,
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
        onEnterPressed: _handleLogin,
        onSignUpPressed: _handleSignUp,
      ),
    );
  }
}

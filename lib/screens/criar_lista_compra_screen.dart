import 'package:flutter/material.dart';
import '../themes/app_theme.dart';
import '../widgets/app_shell.dart';

class CriarListaCompraScreen extends StatefulWidget {
  const CriarListaCompraScreen({Key? key}) : super(key: key);

  @override
  State<CriarListaCompraScreen> createState() => _CriarListaCompraScreenState();
}

class _CriarListaCompraScreenState extends State<CriarListaCompraScreen> {
  final TextEditingController _nomeListaController = TextEditingController();

  @override
  void dispose() {
    _nomeListaController.dispose();
    super.dispose();
  }

  void _voltar() {
    Navigator.pop(context);
  }

  void _proximoPasso() {
    if (_nomeListaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, digite o nome da lista')),
      );
      return;
    }

    // Passar o nome da lista para a próxima tela
    Navigator.pushNamed(
      context,
      '/listaCompras',
      arguments: _nomeListaController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      selectedIndex: 0,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                // Main content
                Text(
                  'Comece Sua',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Nova Jornada.',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Dê um nome à sua lista para começar\nsua experiência de compra otimizada.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 32),
                // Input field
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'TÍTULO DA LISTA',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _nomeListaController,
                          decoration: InputDecoration(
                            hintText: 'Essenciais da Semana...',
                            hintStyle: const TextStyle(
                              color: AppColors.textSecondary,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _voltar,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primary),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.arrow_back, color: AppColors.primary),
                            SizedBox(width: 8),
                            Text(
                              'Voltar',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _proximoPasso,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Próximo',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward,
                                color: Colors.white, size: 18),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

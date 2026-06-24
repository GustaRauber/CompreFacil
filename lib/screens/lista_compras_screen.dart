import 'package:flutter/material.dart';
import '../themes/app_theme.dart';
import '../widgets/app_shell.dart';

class ListaComprasScreen extends StatefulWidget {
  final String nomeList;

  const ListaComprasScreen({Key? key, required this.nomeList})
      : super(key: key);

  @override
  State<ListaComprasScreen> createState() => _ListaComprasScreenState();
}

class _ListaComprasScreenState extends State<ListaComprasScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, dynamic>> _items = [
    {
      'id': 1,
      'name': 'Abacates Orgânicos',
      'quantity': 3,
      'unit': 'UNIDADES',
      'status': 'MADUROS',
      'completed': false,
    },
    {
      'id': 2,
      'name': 'Mini Couve',
      'quantity': 1,
      'unit': 'MAÇO',
      'completed': false,
    },
    {
      'id': 3,
      'name': 'Leite de Amêndoas não Adoçado',
      'quantity': 1.8,
      'unit': 'L',
      'completed': true,
    },
    {
      'id': 4,
      'name': 'Iogurte Grego 0%',
      'quantity': 500,
      'unit': 'NATURAL',
      'completed': false,
    },
  ];

  void _adicionarProduto() {
    if (_searchController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite o nome do produto')),
      );
      return;
    }

    // Adicionar novo item à lista
    setState(() {
      _items.add({
        'id': _items.length + 1,
        'name': _searchController.text,
        'quantity': 1,
        'unit': 'UNIDADE',
        'completed': false,
      });
    });

    _searchController.clear();
  }

  void _otimizarRota() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Rota otimizada! Preparando checkout...')),
    );
    // TODO: Navegar para a próxima tela de checkout/finalização
  }

  void _toggleItem(int id) {
    setState(() {
      final item = _items.firstWhere((item) => item['id'] == id);
      item['completed'] = !item['completed'];
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemsNaoMarcados = _items.where((item) => !item['completed']).length;

    return AppShell(
      selectedIndex: 1,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                const Text(
                  'Lista de Compras',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$itemsNaoMarcados itens restantes na sua rota selecionada.',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),

                // Search and Add buttons
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Adicionar\nProduto...',
                          hintStyle: const TextStyle(
                            color: AppColors.textSecondary,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          prefixIcon:
                              const Icon(Icons.search, color: Colors.grey),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _adicionarProduto,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add, color: Colors.white),
                            SizedBox(width: 4),
                            Text(
                              'Adicionar',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Optimization card
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: AppColors.primary,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ANÁLISE DE EFICIÊNCIA',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white70,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Otimização de Rota Pronta',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Reduza o tempo da sua viagem em 14 minutos usando nosso sequenciamento algorítmico de corredores.',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _otimizarRota,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.navigation,
                                    color: AppColors.primary, size: 18),
                                SizedBox(width: 8),
                                Text(
                                  'Otimizar Rota',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Items list
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Aisle separators and items
                    const Text(
                      'CORREDOR 1-3: HORTIFRUTÍ',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ..._items.asMap().entries.map((entry) {
                      final item = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: item['completed'],
                                  onChanged: (_) => _toggleItem(item['id']),
                                  activeColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['name'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: item['completed']
                                              ? AppColors.textSecondary
                                              : AppColors.textPrimary,
                                          decoration: item['completed']
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${item['quantity']} ${item['unit']}',
                                        style: const TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (item['completed'])
                                  const Icon(
                                    Icons.check_circle,
                                    color: AppColors.primary,
                                    size: 20,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

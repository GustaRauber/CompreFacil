import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../themes/app_theme.dart';
import '../widgets/app_shell.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _createNewList() {
    Navigator.pushNamed(context, '/createList');
  }

  void _exploreStores() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Buscando mercados próximos...')),
    );
  }

  void _openList(ShoppingList list) {
    Navigator.pushNamed(context, '/listaCompras', arguments: list.title);
  }

  Future<void> _handleSignOut() async {
    await AuthService.signOut();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppShell(
      selectedIndex: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.logout, color: AppColors.primary),
          onPressed: _handleSignOut,
          tooltip: 'Sair',
        ),
      ],
      body: StreamBuilder<User?>(
        stream: AuthService.userChanges(),
        builder: (context, userSnapshot) {
          final user = userSnapshot.data ?? AuthService.currentUser;
          if (user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final displayName = user.displayName?.isNotEmpty == true
              ? user.displayName!
              : user.email?.split('@').first ?? 'Usuário';

          return StreamBuilder<List<ShoppingList>>(
            stream: FirestoreService.userShoppingLists(user.uid),
            builder: (context, snapshot) {
              final isLoading =
                  snapshot.connectionState == ConnectionState.waiting;
              final shoppingLists = snapshot.data ?? const [];

              return SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 680),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Hero card
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryShadow,
                                blurRadius: 10,
                                offset: const Offset(0, 6),
                              )
                            ],
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pronto para otimizar sua rota?',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                shoppingLists.isEmpty
                                    ? 'Você não possui nenhuma lista de compras'
                                    : 'Você possui ${shoppingLists.length} listas de compras ativas',
                                style: const TextStyle(color: Colors.white70),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: 180,
                                child: ElevatedButton(
                                  onPressed: _createNewList,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: AppColors.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text('Criar Nova Lista'),
                                ),
                              )
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Map card
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFFAF3E8),
                                  ),
                                  child: const Icon(Icons.map,
                                      color: Color(0xFFB8860B)),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Mapa do Mercado',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600)),
                                      const SizedBox(height: 4),
                                      const Text(
                                          'Veja as rotas ideais em sua loja local.'),
                                      TextButton(
                                        onPressed: _exploreStores,
                                        child: const Text('EXPLORAR LOJA'),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Olá, $displayName',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Aqui estão suas listas recentes e ideias de mercado.',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Listas Ativas',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600)),
                            TextButton(
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/listas'),
                              child: const Text('Ver Tudo'),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),
                        if (isLoading)
                          const Center(child: CircularProgressIndicator())
                        else if (shoppingLists.isEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                vertical: 40, horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Column(
                              children: const [
                                Icon(Icons.shopping_basket_outlined,
                                    size: 48, color: AppColors.textSecondary),
                                SizedBox(height: 16),
                                Text(
                                  'Você não possui nenhuma lista de compras',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Crie sua primeira lista e comece a organizar suas compras.',
                                  textAlign: TextAlign.center,
                                  style:
                                      TextStyle(color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          )
                        else
                          Column(
                            children: shoppingLists.map((list) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: GestureDetector(
                                  onTap: () => _openList(list),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(14),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  list.title,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                const SizedBox(height: 6),
                                                Text(
                                                  '${list.itemsCount} itens',
                                                  style: const TextStyle(
                                                    color:
                                                        AppColors.textSecondary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Icon(Icons.arrow_forward_ios,
                                              size: 18,
                                              color: AppColors.textSecondary),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

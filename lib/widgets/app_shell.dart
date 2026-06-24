import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../themes/app_theme.dart';

class AppShell extends StatelessWidget {
  final Widget body;
  final int selectedIndex;
  final List<Widget>? actions;

  const AppShell({
    Key? key,
    required this.body,
    required this.selectedIndex,
    this.actions,
  }) : super(key: key);

  void _navigate(BuildContext context, int index) {
    const routeNames = ['/home', '/listas', '/mapa', '/perfil'];
    final route = routeNames[index];
    if (ModalRoute.of(context)?.settings.name != route) {
      Navigator.pushReplacementNamed(context, route);
    }
  }

  void _navigateDrawer(BuildContext context, String route) async {
    if (route == '/logout') {
      await AuthService.signOut();
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
      return;
    }

    if (ModalRoute.of(context)?.settings.name != route) {
      Navigator.pushReplacementNamed(context, route);
    } else {
      Navigator.pop(context);
    }
  }

  // User display data is provided by the StreamBuilder in the drawer and
  // app bar so dedicated getters are not needed here.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
        title: const Text('Compre Fácil',
            style: TextStyle(color: AppColors.textPrimary)),
        actions: [
          ...?actions,
          StreamBuilder<User?>(
            stream: AuthService.userChanges(),
            builder: (context, snapshot) {
              final user = snapshot.data ?? AuthService.currentUser;
              final avatarUrl = user?.photoURL ?? 'https://i.pravatar.cc/100';
              return Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(avatarUrl),
                ),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StreamBuilder<User?>(
                stream: AuthService.userChanges(),
                builder: (context, snapshot) {
                  final user = snapshot.data ?? AuthService.currentUser;
                  final displayName = user?.displayName?.isNotEmpty == true
                      ? user!.displayName!
                      : user?.email?.split('@').first ?? 'Usuário';
                  final email = user?.email ?? 'seu@email.com';
                  final avatarUrl =
                      user?.photoURL ?? 'https://i.pravatar.cc/100';
                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundImage: NetworkImage(avatarUrl),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                displayName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                email,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
              _DrawerTile(
                icon: Icons.home,
                label: 'Início',
                selected: selectedIndex == 0,
                onTap: () => _navigateDrawer(context, '/home'),
              ),
              _DrawerTile(
                icon: Icons.list,
                label: 'Listas',
                selected: selectedIndex == 1,
                onTap: () => _navigateDrawer(context, '/listas'),
              ),
              _DrawerTile(
                icon: Icons.map,
                label: 'Mapa',
                selected: selectedIndex == 2,
                onTap: () => _navigateDrawer(context, '/mapa'),
              ),
              _DrawerTile(
                icon: Icons.person,
                label: 'Perfil',
                selected: selectedIndex == 3,
                onTap: () => _navigateDrawer(context, '/perfil'),
              ),
              const Divider(),
              const Spacer(),
              _DrawerTile(
                icon: Icons.logout,
                label: 'Sair',
                selected: false,
                onTap: () => _navigateDrawer(context, '/logout'),
              ),
            ],
          ),
        ),
      ),
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        onTap: (index) => _navigate(context, index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'INÍCIO'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'LISTAS'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'MAPA'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'PERFIL'),
        ],
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _DrawerTile({
    Key? key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon,
          color: selected ? AppColors.primary : AppColors.textPrimary),
      title: Text(
        label,
        style: TextStyle(
          color: selected ? AppColors.primary : AppColors.textPrimary,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}

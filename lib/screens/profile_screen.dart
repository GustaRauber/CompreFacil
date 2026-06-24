import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../themes/app_theme.dart';
import '../widgets/app_shell.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppShell(
      selectedIndex: 3,
      body: StreamBuilder<User?>(
        stream: AuthService.userChanges(),
        builder: (context, snapshot) {
          final user = snapshot.data ?? AuthService.currentUser;
          final displayName = user?.displayName?.isNotEmpty == true
              ? user!.displayName!
              : user?.email?.split('@').first ?? 'Usuário';
          final email = user?.email ?? 'seu@email.com';
          final avatarUrl = user?.photoURL ?? 'https://i.pravatar.cc/100';
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 680),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),
                    const Text(
                      'Perfil',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 36,
                              backgroundImage: NetworkImage(avatarUrl),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    displayName,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    email,
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Informações do usuário',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text('Nome: $displayName'),
                            const SizedBox(height: 6),
                            Text('E-mail: $email'),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/settings');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                              ),
                              child: const Text('Editar configurações'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

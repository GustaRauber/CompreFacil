import 'package:flutter/material.dart';
import '../themes/app_theme.dart';

class AuthBottomNavigation extends StatelessWidget {
  final VoidCallback onEnterPressed;
  final VoidCallback onSignUpPressed;
  final bool isSignUpActive;

  const AuthBottomNavigation({
    Key? key,
    required this.onEnterPressed,
    required this.onSignUpPressed,
    this.isSignUpActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: _NavButton(
                label: 'ENTRAR',
                isActive: !isSignUpActive,
                onPressed: onEnterPressed,
                icon: Icons.login,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _NavButton(
                label: 'CADASTRAR-SE',
                isActive: isSignUpActive,
                onPressed: onSignUpPressed,
                icon: Icons.person_add,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onPressed;
  final IconData icon;

  const _NavButton({
    required this.label,
    required this.isActive,
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primary.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isActive ? AppColors.primary : AppColors.textSecondary,
              ),
              SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isActive ? AppColors.primary : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

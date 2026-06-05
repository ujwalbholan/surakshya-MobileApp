library login_screen;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:suraksha/core/constants/copy_constants.dart';
import 'package:suraksha/features/auth/auth_provider.dart';
import 'package:suraksha/router/app_routes.dart';
import 'package:suraksha/theme/suraksha_colors.dart';
import 'package:suraksha/theme/suraksha_spacing.dart';
import 'package:suraksha/theme/suraksha_typography.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  late final AnimationController _entryController;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _entryController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _isLoading = true);
    await ref.read(authProvider.notifier).login(
          _emailController.text.trim(),
          _passwordController.text,
        );
    if (mounted) {
      setState(() => _isLoading = false);
      context.go(AppRoutes.tracking);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: surakshaAuthRight,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 768;
            return isDesktop
                ? Row(
                    children: [
                      Expanded(child: _buildLeftPanel()),
                      Expanded(child: _buildForm()),
                    ],
                  )
                : _buildForm();
          },
        ),
      );

  Widget _buildLeftPanel() => Container(
        color: surakshaAuthLeft,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.shield_outlined, color: surakshaCrimson, size: 48),
              const SizedBox(height: S.lg),
              Text(
                'THE SURAKSHA',
                style: SurakshaTypography.playfairDisplay.copyWith(
                  fontSize: 20,
                  letterSpacing: 4,
                  color: surakshaAuthText,
                ),
              ),
              const SizedBox(height: S.sm),
              Text(
                'Wear it. Trust it. Stay safe.',
                style: SurakshaTypography.monoLabel,
              ),
            ],
          ),
        ),
      );

  Widget _buildForm() => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: FadeTransition(
            opacity: _entryController,
            child: Padding(
              padding: const EdgeInsets.all(S.xl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(CopyConstants.loginTitle,
                      style: SurakshaTypography.playfairDisplay),
                  const SizedBox(height: S.sm),
                  Text(CopyConstants.loginSubtitle,
                      style: SurakshaTypography.monoLabel),
                  const SizedBox(height: S.xl2),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: surakshaAuthText),
                    decoration: const InputDecoration(labelText: 'EMAIL'),
                  ),
                  const SizedBox(height: S.lg),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: const TextStyle(color: surakshaAuthText),
                    decoration: InputDecoration(
                      labelText: 'PASSWORD',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: S.xl),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submit,
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Sign In'),
                    ),
                  ),
                  const SizedBox(height: S.lg),
                  Center(
                    child: TextButton(
                      onPressed: () => context.go(AppRoutes.signup),
                      child: const Text('Create account'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

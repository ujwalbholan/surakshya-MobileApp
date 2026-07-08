library signup_screen;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:suraksha/core/constants/copy_constants.dart';
import 'package:suraksha/core/utils/email_utils.dart';
import 'package:suraksha/features/auth/auth_provider.dart';
import 'package:suraksha/features/auth/widgets/auth_cinematic_background.dart';
import 'package:suraksha/features/auth/widgets/auth_field_decoration.dart';
import 'package:suraksha/features/auth/widgets/auth_reveal_transition.dart';
import 'package:suraksha/features/auth/widgets/auth_ticket_status_overlay.dart';
import 'package:suraksha/features/auth/widgets/auth_ticket_status_presenter.dart';
import 'package:suraksha/services/surakshya_api_service.dart';
import 'package:suraksha/router/app_routes.dart';
import 'package:suraksha/theme/suraksha_colors.dart';
import 'package:suraksha/theme/suraksha_spacing.dart';
import 'package:suraksha/theme/suraksha_typography.dart';
import 'package:suraksha/widgets/origin_button.dart';
import 'package:suraksha/widgets/suraksha_email_input.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailLocalController = TextEditingController();
  final _phoneController = TextEditingController(text: '98');
  final _passwordController = TextEditingController();
  String _emailDomain = EmailDomains.defaultSelected;
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  late final bool _reducedMotion;
  late final AuthTicketStatusPresenter _statusPresenter;

  @override
  void initState() {
    super.initState();
    _reducedMotion = WidgetsBinding
        .instance.platformDispatcher.accessibilityFeatures.disableAnimations;
    _statusPresenter = AuthTicketStatusPresenter((fn) => setState(fn));
  }

  @override
  void dispose() {
    _statusPresenter.dispose();
    _nameController.dispose();
    _emailLocalController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    final emailLocal = _emailLocalController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (name.isEmpty || emailLocal.isEmpty) {
      _statusPresenter.showError(
        'Missing details',
        'Please enter your name and email',
      );
      return;
    }

    if (phone.length < 10) {
      _statusPresenter.showError(
        'Invalid phone',
        'Please enter a valid phone number',
      );
      return;
    }

    if (password.isEmpty) {
      _statusPresenter.showError(
        'Password required',
        'Please enter a password',
      );
      return;
    }

    if (password.length < 6) {
      _statusPresenter.showError(
        'Password too short',
        'Password must be at least 6 characters',
      );
      return;
    }

    if (password != confirmPassword) {
      _statusPresenter.showError(
        'Passwords do not match',
        'Make sure both password fields match',
      );
      return;
    }

    setState(() => _isLoading = true);
    final email = buildEmailAddress(emailLocal, _emailDomain);
    if (!isValidEmail(email)) {
      if (mounted) {
        _statusPresenter.showInfo(
          'Invalid email',
          'Enter a valid email. Use only the username — @gmail.com is added for you.',
        );
        setState(() => _isLoading = false);
      }
      return;
    }
    try {
      await ref.read(authProvider.notifier).registerAccount(
            name: name,
            email: email,
            phone: phone,
            password: password,
          );
      if (!mounted) return;
      _statusPresenter.showSuccess(
        'Account created',
        CopyConstants.signupSuccess,
        onDismissed: () {
          if (mounted) context.go(AppRoutes.login);
        },
      );
    } on SurakshyaApiException catch (e) {
      if (mounted) {
        _statusPresenter.showError('Sign up failed', e.message);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          fit: StackFit.expand,
          children: [
            AuthCinematicBackground(
              disableAnimations: _reducedMotion ||
                  MediaQuery.disableAnimationsOf(context),
            ),
            Container(color: Colors.black.withValues(alpha: authScrimOpacity)),
            SafeArea(
              child: AuthRevealTransition(
                disableAnimations: _reducedMotion,
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: S.xl),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Padding(
                        padding: const EdgeInsets.all(S.xl),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(CopyConstants.signupTitle,
                                style: SurakshaTypography.playfairDisplay),
                            const SizedBox(height: S.sm),
                            Text(CopyConstants.signupSubtitle,
                                style: SurakshaTypography.monoLabel),
                            const SizedBox(height: S.xl2),
                            TextField(
                              controller: _nameController,
                              style: const TextStyle(color: surakshaAuthText),
                              decoration:
                                  authFieldDecoration(labelText: 'NAME'),
                            ),
                            const SizedBox(height: S.lg),
                            SurakshaEmailInput(
                              localPartController: _emailLocalController,
                              initialDomain: _emailDomain,
                              placeholder: 'EMAIL USERNAME',
                              textInputAction: TextInputAction.next,
                              onDomainChanged: (domain) =>
                                  setState(() => _emailDomain = domain),
                            ),
                            const SizedBox(height: S.lg),
                            TextField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              style: const TextStyle(color: surakshaAuthText),
                              decoration: authFieldDecoration(
                                labelText: 'PHONE',
                                hintText: '98XXXXXXXX',
                              ),
                            ),
                            const SizedBox(height: S.lg),
                            TextField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              style: const TextStyle(color: surakshaAuthText),
                              decoration: authFieldDecoration(
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
                            const SizedBox(height: S.lg),
                            TextField(
                              controller: _confirmPasswordController,
                              obscureText: _obscureConfirmPassword,
                              style: const TextStyle(color: surakshaAuthText),
                              decoration: authFieldDecoration(
                                labelText: 'CONFIRM PASSWORD',
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureConfirmPassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                  ),
                                  onPressed: () => setState(
                                    () => _obscureConfirmPassword =
                                        !_obscureConfirmPassword,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: S.xl),
                            SizedBox(
                              width: double.infinity,
                              child: OriginButton(
                                onPressed: _submit,
                                loading: _isLoading,
                                child: const Text('Create Account'),
                              ),
                            ),
                            const SizedBox(height: S.lg),
                            Center(
                              child: TextButton(
                                onPressed: () => context.go(AppRoutes.login),
                                style: authFooterLinkButtonStyle(),
                                child: Text(
                                  'Already have an account? Sign in',
                                  style: authFooterLinkStyle(),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            AuthTicketStatusOverlay(presenter: _statusPresenter),
          ],
        ),
      );
}

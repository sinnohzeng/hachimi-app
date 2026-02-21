import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/providers/auth_provider.dart';

import 'components/email_auth_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isGoogleLoading = false;

  Future<void> _signInWithGoogle() async {
    setState(() => _isGoogleLoading = true);

    try {
      final authService = ref.read(authServiceProvider);
      final analyticsService = ref.read(analyticsServiceProvider);
      final result = await authService.signInWithGoogle();

      if (result != null && result.additionalUserInfo?.isNewUser == true) {
        await analyticsService.logSignUp(method: 'google');
        final uid = result.user!.uid;
        await ref
            .read(firestoreServiceProvider)
            .createUserProfile(
              uid: uid,
              email: result.user!.email ?? '',
              displayName: result.user!.displayName,
            );
      }
      // AuthGate will automatically navigate to HomeScreen
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  void _navigateToEmailAuth() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const EmailAuthScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.primary,
              colorScheme.primary.withValues(alpha: 0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: AppSpacing.paddingHLg,
            child: Column(
              children: [
                const Spacer(flex: 3),

                // App icon
                Icon(
                  Icons.local_fire_department,
                  size: 80,
                  color: colorScheme.onPrimary,
                ),
                const SizedBox(height: AppSpacing.base),

                // App name
                Text(
                  context.l10n.loginAppName,
                  style: textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),

                // Tagline
                Text(
                  context.l10n.loginTagline,
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onPrimary.withValues(alpha: 0.7),
                  ),
                ),

                const Spacer(flex: 4),

                // Google sign-in button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton.icon(
                    onPressed: _isGoogleLoading ? null : _signInWithGoogle,
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.onPrimary,
                      foregroundColor: colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: _isGoogleLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Image.network(
                            'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
                            width: 20,
                            height: 20,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.g_mobiledata, size: 24),
                          ),
                    label: Text(context.l10n.loginContinueGoogle),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // Email sign-in button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton.icon(
                    onPressed: _navigateToEmailAuth,
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.onPrimary,
                      foregroundColor: colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: const Icon(Icons.email_outlined, size: 20),
                    label: Text(context.l10n.loginContinueEmail),
                  ),
                ),
                const SizedBox(height: AppSpacing.base),

                // Login link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      context.l10n.loginAlreadyHaveAccount,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimary.withValues(alpha: 0.7),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                const EmailAuthScreen(startAsLogin: true),
                          ),
                        );
                      },
                      child: Text(
                        context.l10n.loginLogIn,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

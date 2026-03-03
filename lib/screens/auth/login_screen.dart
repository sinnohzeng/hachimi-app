import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/core/utils/auth_error_mapper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/core/backend/auth_backend.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/user_profile_notifier.dart';

import 'components/email_auth_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  /// linkMode: 匿名用户关联账号（而非全新登录）。
  final bool linkMode;

  const LoginScreen({super.key, this.linkMode = false});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isGoogleLoading = false;

  Future<void> _signInWithGoogle() async {
    setState(() => _isGoogleLoading = true);

    try {
      final authBackend = ref.read(authBackendProvider);
      final analyticsService = ref.read(analyticsServiceProvider);
      final notifier = ref.read(userProfileNotifierProvider.notifier);
      final oldUid = ref.read(currentUidProvider);
      final wasAnonymous = authBackend.isAnonymous;
      final result = widget.linkMode
          ? await authBackend.linkWithGoogle()
          : await authBackend.signInWithGoogle();
      if (result == null) return;

      await notifier.ensureProfile(
        uid: result.uid,
        email: result.email ?? '',
        displayName: result.displayName,
      );

      if (result.isNewUser) {
        await analyticsService.logSignUp(
          method: widget.linkMode ? 'google_link' : 'google',
        );
      }

      await _resolveGuestConflictIfNeeded(
        result: result,
        oldUid: oldUid,
        wasAnonymous: wasAnonymous,
      );

      if (widget.linkMode && mounted) {
        Navigator.of(context).popUntil((r) => r.isFirst);
      }
    } on Exception catch (e) {
      if (mounted) {
        final message = mapAuthError(e, context.l10n);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  Future<void> _resolveGuestConflictIfNeeded({
    required AuthResult result,
    required String? oldUid,
    required bool wasAnonymous,
  }) async {
    if (oldUid == null || !mounted) return;
    if (!_shouldResolveConflict(oldUid, result.uid, wasAnonymous)) return;
    await ref
        .read(guestUpgradeCoordinatorProvider)
        .resolve(
          context: context,
          oldUid: oldUid,
          newUid: result.uid,
          email: result.email ?? '',
          displayName: result.displayName,
        );
  }

  bool _shouldResolveConflict(String oldUid, String newUid, bool wasAnonymous) {
    if (oldUid == newUid) return false;
    if (widget.linkMode) return true;
    return oldUid.startsWith('guest_') || wasAnonymous;
  }

  void _navigateToEmailAuth() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EmailAuthScreen(
          linkMode: widget.linkMode,
          startAsLogin: widget.linkMode,
        ),
      ),
    );
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
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
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
                      semanticLabel: 'Hachimi',
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
                      widget.linkMode
                          ? context.l10n.loginLinkTagline
                          : context.l10n.loginTagline,
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
                            borderRadius: AppShape.borderLarge,
                          ),
                        ),
                        icon: _isGoogleLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Image.network(
                                'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
                                width: 20,
                                height: 20,
                                errorBuilder: (_, _, _) =>
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
                            borderRadius: AppShape.borderLarge,
                          ),
                        ),
                        icon: const Icon(Icons.email_outlined, size: 20),
                        label: Text(context.l10n.loginContinueEmail),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.base),

                    // Login link (hidden in linkMode)
                    if (!widget.linkMode)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            context.l10n.loginAlreadyHaveAccount,
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onPrimary.withValues(
                                alpha: 0.7,
                              ),
                            ),
                          ),
                          Semantics(
                            button: true,
                            label: context.l10n.loginLogIn,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const EmailAuthScreen(
                                      startAsLogin: true,
                                    ),
                                  ),
                                );
                              },
                              child: ExcludeSemantics(
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
        ),
      ),
    );
  }
}

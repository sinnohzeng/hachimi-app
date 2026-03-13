import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/core/utils/app_feedback.dart';
import 'package:hachimi_app/core/utils/auth_error_mapper.dart';
import 'package:hachimi_app/core/utils/error_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/core/backend/auth_backend.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/user_profile_notifier.dart';
import 'package:hachimi_app/core/router/app_router.dart';

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
      final migrationSourceUid = ref
          .read(identityTransitionResolverProvider)
          .resolveMigrationSourceUid(currentUid: ref.read(currentUidProvider));
      final wasAnonymous = authBackend.isAnonymous;

      // Phase A: 认证 — 失败才显示 SnackBar
      final result = widget.linkMode
          ? await authBackend.linkWithGoogle()
          : await authBackend.signInWithGoogle();
      if (result == null) return;

      // Phase B: 账号设置 — 失败仅记录，不阻塞用户
      await _finalizeAccountSetup(
        result: result,
        migrationSourceUid: migrationSourceUid,
        wasAnonymous: wasAnonymous,
      );
    } on Exception catch (e) {
      ErrorHandler.recordOperation(
        e,
        feature: 'auth',
        operation: 'sign_in_google',
        errorCode: e is FirebaseAuthException ? e.code : 'google_sign_in_error',
      );
      if (mounted) {
        final message = mapAuthError(e, context.l10n);
        AppFeedback.error(context, message);
      }
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  /// 登录后账号初始化 — best-effort，失败不影响用户进入主页。
  /// 未完成的访客迁移由 _FirstHabitGate._recoverOrphanedGuestData 兜底恢复。
  Future<void> _finalizeAccountSetup({
    required AuthResult result,
    required String? migrationSourceUid,
    required bool wasAnonymous,
  }) async {
    try {
      final notifier = ref.read(userProfileNotifierProvider.notifier);
      await notifier.ensureProfile(
        uid: result.uid,
        email: result.email ?? '',
        displayName: result.displayName,
      );

      if (result.isNewUser) {
        await ref
            .read(analyticsServiceProvider)
            .logSignUp(method: widget.linkMode ? 'google_link' : 'google');
      }

      await _resolveGuestConflictIfNeeded(
        result: result,
        migrationSourceUid: migrationSourceUid,
        wasAnonymous: wasAnonymous,
      );
    } on Exception catch (e) {
      ErrorHandler.recordOperation(
        e,
        feature: 'auth',
        operation: 'finalize_account_setup',
        errorCode: 'finalize_account_setup_failed',
      );
    } finally {
      if (mounted) {
        Navigator.of(context).popUntil((r) => r.isFirst);
      }
    }
  }

  Future<void> _resolveGuestConflictIfNeeded({
    required AuthResult result,
    required String? migrationSourceUid,
    required bool wasAnonymous,
  }) async {
    if (migrationSourceUid == null || !mounted) return;
    if (!_shouldResolveConflict(migrationSourceUid, result.uid, wasAnonymous)) {
      return;
    }
    await ref
        .read(guestUpgradeCoordinatorProvider)
        .resolve(
          context: context,
          migrationSourceUid: migrationSourceUid,
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
    Navigator.of(context).pushNamed(
      AppRouter.emailAuth,
      arguments: {
        'linkMode': widget.linkMode,
        'startAsLogin': widget.linkMode,
      },
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
                                semanticLabel: 'Google logo',
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
                                Navigator.of(context).pushNamed(
                                  AppRouter.emailAuth,
                                  arguments: {'startAsLogin': true},
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

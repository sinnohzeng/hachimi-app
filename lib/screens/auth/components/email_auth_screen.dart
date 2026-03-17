import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/widgets/app_scaffold.dart';
import 'package:hachimi_app/widgets/particle_overlay.dart';
import 'package:hachimi_app/core/backend/auth_backend.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/core/utils/app_feedback.dart';
import 'package:hachimi_app/core/utils/auth_error_mapper.dart';
import 'package:hachimi_app/core/utils/error_handler.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/user_profile_notifier.dart';
import 'package:hachimi_app/screens/auth/components/auth_cat_hero.dart';

class EmailAuthScreen extends ConsumerStatefulWidget {
  final bool startAsLogin;

  /// linkMode: 匿名用户关联 Email 账号（而非全新注册）。
  final bool linkMode;

  const EmailAuthScreen({
    super.key,
    this.startAsLogin = false,
    this.linkMode = false,
  });

  @override
  ConsumerState<EmailAuthScreen> createState() => _EmailAuthScreenState();
}

class _EmailAuthScreenState extends ConsumerState<EmailAuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  late bool _isLogin;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _isLogin = widget.startAsLogin;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authBackend = ref.read(authBackendProvider);
      final migrationSourceUid = ref
          .read(identityTransitionResolverProvider)
          .resolveMigrationSourceUid(currentUid: ref.read(currentUidProvider));

      // Phase A: 认证 — 失败才显示 SnackBar
      final result = await _authenticate(authBackend);

      // Phase B: 账号设置 — 失败仅记录，不阻塞用户
      await _finalizeAccountSetup(
        result: result,
        migrationSourceUid: migrationSourceUid,
      );
    } on Exception catch (e) {
      ErrorHandler.recordOperation(
        e,
        feature: 'auth',
        operation: _isLogin ? 'sign_in_email' : 'sign_up_email',
        errorCode: e is FirebaseAuthException ? e.code : 'email_auth_error',
      );
      if (mounted) {
        AppFeedback.error(context, mapAuthError(e, context.l10n));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  static const _setupTimeout = Duration(seconds: 8);

  /// 登录后账号初始化 — best-effort，失败不影响用户进入主页。
  /// 未完成的访客迁移由 _FirstHabitGate._recoverOrphanedGuestData 兜底恢复。
  Future<void> _finalizeAccountSetup({
    required AuthResult result,
    required String? migrationSourceUid,
  }) async {
    try {
      await _doFinalizeSetup(
        result: result,
        migrationSourceUid: migrationSourceUid,
      ).timeout(_setupTimeout);
    } on TimeoutException {
      debugPrint('[Auth] 登录后设置超时 — 进入主页，后台重试');
    } on Exception catch (e) {
      ErrorHandler.recordOperation(
        e,
        feature: 'auth',
        operation: 'finalize_account_setup',
        errorCode: 'finalize_account_setup_failed',
      );
    } finally {
      if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  Future<void> _doFinalizeSetup({
    required AuthResult result,
    required String? migrationSourceUid,
  }) async {
    final notifier = ref.read(userProfileNotifierProvider.notifier);
    await notifier.ensureProfile(
      uid: result.uid,
      email: _emailController.text.trim(),
      displayName: result.displayName,
    );
    await _logSignUpIfNeeded(result);
    await _resolveGuestConflictIfNeeded(
      result: result,
      migrationSourceUid: migrationSourceUid,
    );
  }

  Future<AuthResult> _authenticate(AuthBackend authBackend) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (_isLogin) {
      return authBackend.signIn(email: email, password: password);
    }
    if (widget.linkMode) {
      return authBackend.linkWithEmail(email: email, password: password);
    }
    return authBackend.signUp(email: email, password: password);
  }

  Future<void> _logSignUpIfNeeded(AuthResult result) async {
    if (!result.isNewUser) return;
    final method = widget.linkMode ? 'email_link' : 'email';
    await ref.read(analyticsServiceProvider).logSignUp(method: method);
  }

  Future<void> _resolveGuestConflictIfNeeded({
    required AuthResult result,
    required String? migrationSourceUid,
  }) async {
    if (migrationSourceUid == null || !mounted) return;
    if (!_shouldResolveConflict(migrationSourceUid, result.uid)) return;
    await ref
        .read(guestUpgradeCoordinatorProvider)
        .resolve(
          context: context,
          migrationSourceUid: migrationSourceUid,
          newUid: result.uid,
          email: _emailController.text.trim(),
          displayName: result.displayName,
        );
  }

  Future<void> _showForgotPasswordDialog() async {
    final l10n = context.l10n;
    final resetEmailController = TextEditingController(
      text: _emailController.text.trim(),
    );
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.loginForgotPasswordTitle),
        content: TextField(
          controller: resetEmailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: l10n.loginEmail,
            prefixIcon: const Icon(Icons.email_outlined),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.loginSendResetEmail),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final email = resetEmailController.text.trim();
    resetEmailController.dispose();
    if (email.isEmpty) return;
    try {
      await ref.read(authBackendProvider).sendPasswordResetEmail(email);
      if (mounted) AppFeedback.success(context, l10n.loginResetEmailSent);
    } on Exception catch (e) {
      if (mounted) AppFeedback.error(context, mapAuthError(e, l10n));
    }
  }

  bool _shouldResolveConflict(String oldUid, String newUid) {
    if (oldUid == newUid) return false;
    if (widget.linkMode) return true;
    return oldUid.startsWith('guest_');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return AppScaffold(
      body: Stack(
        children: [
          const ParticleOverlay(
            mode: ParticleMode.firefly,
            child: SizedBox.expand(),
          ),
          SafeArea(
            child: Column(
              children: [
                // 返回按钮
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: context.l10n.adoptionBack,
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: AppSpacing.paddingHLg,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: AppSpacing.base),

                          // 像素猫主视觉
                          const AuthCatHero(size: 96),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            context.l10n.loginAppName,
                            style: textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),

                          // 状态提示
                          Text(
                            _isLogin
                                ? context.l10n.loginWelcomeBack
                                : context.l10n.loginCreateAccount,
                            style: textTheme.bodyLarge?.copyWith(
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.7,
                              ),
                            ),
                          ),
                          if (widget.linkMode) ...[
                            const SizedBox(height: AppSpacing.md),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ChoiceChip(
                                  label: Text(context.l10n.loginLogIn),
                                  selected: _isLogin,
                                  onSelected: (_) => setState(() {
                                    _isLogin = true;
                                    _confirmPasswordController.clear();
                                  }),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                ChoiceChip(
                                  label: Text(
                                    context.l10n.loginCreateAccountButton,
                                  ),
                                  selected: !_isLogin,
                                  onSelected: (_) => setState(() {
                                    _isLogin = false;
                                    _confirmPasswordController.clear();
                                  }),
                                ),
                              ],
                            ),
                          ],
                          const SizedBox(height: AppSpacing.xl),

                          // Email field
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: context.l10n.loginEmail,
                              prefixIcon: const Icon(Icons.email_outlined),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return context.l10n.loginValidEmail;
                              }
                              final emailRegex = RegExp(
                                r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                              );
                              if (!emailRegex.hasMatch(value.trim())) {
                                return context.l10n.loginValidEmailFormat;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppSpacing.base),

                          // Password field
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: context.l10n.loginPassword,
                              prefixIcon: const Icon(Icons.lock_outlined),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword,
                                ),
                                tooltip: _obscurePassword
                                    ? context.l10n.loginShowPassword
                                    : context.l10n.loginHidePassword,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return context.l10n.loginValidPassword;
                              }
                              if (value.length < 6) {
                                return context.l10n.loginValidPasswordLength;
                              }
                              return null;
                            },
                          ),

                          // Forgot password (login only)
                          if (_isLogin) ...[
                            Align(
                              alignment: AlignmentDirectional.centerEnd,
                              child: TextButton(
                                onPressed: _showForgotPasswordDialog,
                                child: Text(context.l10n.loginForgotPassword),
                              ),
                            ),
                          ],

                          // Confirm password (register only)
                          if (!_isLogin) ...[
                            const SizedBox(height: AppSpacing.base),
                            TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: _obscureConfirmPassword,
                              decoration: InputDecoration(
                                labelText: context.l10n.loginConfirmPassword,
                                prefixIcon: const Icon(Icons.lock_outlined),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureConfirmPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () => setState(
                                    () => _obscureConfirmPassword =
                                        !_obscureConfirmPassword,
                                  ),
                                  tooltip: _obscureConfirmPassword
                                      ? context.l10n.loginShowPassword
                                      : context.l10n.loginHidePassword,
                                ),
                              ),
                              validator: (value) {
                                if (value != _passwordController.text) {
                                  return context.l10n.loginValidPasswordMatch;
                                }
                                return null;
                              },
                            ),
                          ],
                          const SizedBox(height: AppSpacing.xl),

                          // Submit button
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: FilledButton(
                              onPressed: _isLoading ? null : _submit,
                              style: FilledButton.styleFrom(
                                backgroundColor: colorScheme.primary,
                                foregroundColor: colorScheme.onPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: AppShape.borderLarge,
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      _isLogin
                                          ? context.l10n.loginLogIn
                                          : context
                                                .l10n
                                                .loginCreateAccountButton,
                                      style: textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: colorScheme.onPrimary,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),

                          // Toggle login/register
                          if (!widget.linkMode)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _isLogin
                                      ? context.l10n.loginNoAccount
                                      : context.l10n.loginAlreadyHaveAccount,
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurface.withValues(
                                      alpha: 0.7,
                                    ),
                                  ),
                                ),
                                Semantics(
                                  button: true,
                                  label: _isLogin
                                      ? context.l10n.loginRegister
                                      : context.l10n.loginLogIn,
                                  child: GestureDetector(
                                    onTap: () => setState(() {
                                      _isLogin = !_isLogin;
                                      _confirmPasswordController.clear();
                                    }),
                                    child: ExcludeSemantics(
                                      child: Text(
                                        _isLogin
                                            ? context.l10n.loginRegister
                                            : context.l10n.loginLogIn,
                                        style: textTheme.bodyMedium?.copyWith(
                                          color: colorScheme.primary,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                          decorationColor: colorScheme.primary,
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}

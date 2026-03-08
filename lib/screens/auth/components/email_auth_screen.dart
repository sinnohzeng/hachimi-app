import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/backend/auth_backend.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/core/utils/auth_error_mapper.dart';
import 'package:hachimi_app/core/utils/error_handler.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/user_profile_notifier.dart';
import 'package:hachimi_app/services/analytics_service.dart';

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
      final wasAnonymous = authBackend.isAnonymous;

      // Phase A: 认证 — 失败才显示 SnackBar
      final result = await _authenticate(authBackend);

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
        operation: _isLogin ? 'sign_in_email' : 'sign_up_email',
        errorCode: e is FirebaseAuthException ? e.code : 'email_auth_error',
      );
      if (mounted) {
        final message = mapAuthError(e, context.l10n);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
        email: _emailController.text.trim(),
        displayName: result.displayName,
      );
      await _logSignUpIfNeeded(ref.read(analyticsServiceProvider), result);
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
      if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
    }
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

  Future<void> _logSignUpIfNeeded(
    AnalyticsService analyticsService,
    AuthResult result,
  ) async {
    if (!result.isNewUser) return;
    final method = widget.linkMode ? 'email_link' : 'email';
    await analyticsService.logSignUp(method: method);
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
          email: _emailController.text.trim(),
          displayName: result.displayName,
        );
  }

  bool _shouldResolveConflict(String oldUid, String newUid, bool wasAnonymous) {
    if (oldUid == newUid) return false;
    if (widget.linkMode) return true;
    return oldUid.startsWith('guest_') || wasAnonymous;
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
          child: Column(
            children: [
              // App bar
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: colorScheme.onPrimary),
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

                        // App icon
                        Icon(
                          Icons.local_fire_department,
                          size: 56,
                          color: colorScheme.onPrimary,
                          semanticLabel: 'Hachimi',
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          context.l10n.loginAppName,
                          style: textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),

                        // Toggle hint
                        Text(
                          _isLogin
                              ? context.l10n.loginWelcomeBack
                              : context.l10n.loginCreateAccount,
                          style: textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onPrimary.withValues(alpha: 0.7),
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
                                onSelected: (_) =>
                                    setState(() => _isLogin = true),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              ChoiceChip(
                                label: Text(
                                  context.l10n.loginCreateAccountButton,
                                ),
                                selected: !_isLogin,
                                onSelected: (_) =>
                                    setState(() => _isLogin = false),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: AppSpacing.xl),

                        // Email field
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(color: colorScheme.onPrimary),
                          decoration: _inputDecoration(
                            colorScheme: colorScheme,
                            label: context.l10n.loginEmail,
                            icon: Icons.email_outlined,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return context.l10n.loginValidEmail;
                            }
                            if (!value.contains('@')) {
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
                          style: TextStyle(color: colorScheme.onPrimary),
                          decoration: _inputDecoration(
                            colorScheme: colorScheme,
                            label: context.l10n.loginPassword,
                            icon: Icons.lock_outlined,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: colorScheme.onPrimary.withValues(
                                  alpha: 0.54,
                                ),
                              ),
                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                              tooltip: _obscurePassword
                                  ? 'Show password'
                                  : 'Hide password',
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

                        // Confirm password (register only)
                        if (!_isLogin) ...[
                          const SizedBox(height: AppSpacing.base),
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: _obscureConfirmPassword,
                            style: TextStyle(color: colorScheme.onPrimary),
                            decoration: _inputDecoration(
                              colorScheme: colorScheme,
                              label: context.l10n.loginConfirmPassword,
                              icon: Icons.lock_outlined,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: colorScheme.onPrimary.withValues(
                                    alpha: 0.54,
                                  ),
                                ),
                                onPressed: () => setState(
                                  () => _obscureConfirmPassword =
                                      !_obscureConfirmPassword,
                                ),
                                tooltip: _obscureConfirmPassword
                                    ? 'Show password'
                                    : 'Hide password',
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
                              backgroundColor: colorScheme.onPrimary,
                              foregroundColor: colorScheme.primary,
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
                                        : context.l10n.loginCreateAccountButton,
                                    style: textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.primary,
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
                                  color: colorScheme.onPrimary.withValues(
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
                                  onTap: () =>
                                      setState(() => _isLogin = !_isLogin),
                                  child: ExcludeSemantics(
                                    child: Text(
                                      _isLogin
                                          ? context.l10n.loginRegister
                                          : context.l10n.loginLogIn,
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
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required ColorScheme colorScheme,
    required String label,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    final onPrimary = colorScheme.onPrimary;
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: onPrimary.withValues(alpha: 0.7)),
      prefixIcon: Icon(icon, color: onPrimary.withValues(alpha: 0.7)),
      suffixIcon: suffixIcon,
      enabledBorder: OutlineInputBorder(
        borderRadius: AppShape.borderMedium,
        borderSide: BorderSide(color: onPrimary.withValues(alpha: 0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppShape.borderMedium,
        borderSide: BorderSide(color: onPrimary),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppShape.borderMedium,
        borderSide: BorderSide(color: colorScheme.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppShape.borderMedium,
        borderSide: BorderSide(color: colorScheme.error),
      ),
      filled: true,
      fillColor: onPrimary.withValues(alpha: 0.1),
    );
  }
}

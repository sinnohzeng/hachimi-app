import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/ledger_action.dart';
import 'package:hachimi_app/providers/auth_provider.dart';

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
    // linkMode 总是"注册"形式（关联新凭证）
    _isLogin = widget.linkMode ? false : widget.startAsLogin;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// 初始化本地 materialized_state（注册时调用）。
  Future<void> _initLocalState(String uid) async {
    final ledger = ref.read(ledgerServiceProvider);
    await ledger.setMaterialized(uid, 'coins', '0');
    await ledger.setMaterialized(uid, 'last_check_in_date', '');
    await ledger.setMaterialized(uid, 'inventory', '[]');
    ledger.notifyChange(const LedgerChange(type: 'hydrate'));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authService = ref.read(authServiceProvider);
      final analyticsService = ref.read(analyticsServiceProvider);

      if (widget.linkMode) {
        // 匿名用户关联 Email 账号
        final result = await authService.linkWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
        await analyticsService.logSignUp(method: 'email_link');
        final uid = result.user!.uid;
        await ref
            .read(firestoreServiceProvider)
            .createUserProfile(uid: uid, email: _emailController.text.trim());
        await _initLocalState(uid);
      } else if (_isLogin) {
        await authService.signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
      } else {
        await authService.signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
        await analyticsService.logSignUp();

        final uid = authService.currentUser!.uid;
        await ref
            .read(firestoreServiceProvider)
            .createUserProfile(uid: uid, email: _emailController.text.trim());
        await _initLocalState(uid);
      }
      // AuthGate will automatically navigate to HomeScreen.
      // Pop this screen so we don't leave it on the stack.
      if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
                          widget.linkMode
                              ? context.l10n.loginLinkTagline
                              : _isLogin
                              ? context.l10n.loginWelcomeBack
                              : context.l10n.loginCreateAccount,
                          style: textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onPrimary.withValues(alpha: 0.7),
                          ),
                        ),
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

                        // Toggle login/register (hidden in linkMode)
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

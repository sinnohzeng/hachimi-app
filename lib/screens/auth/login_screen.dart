import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/providers/auth_provider.dart';

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
        await ref.read(firestoreServiceProvider).createUserProfile(
              uid: uid,
              email: result.user!.email ?? '',
              displayName: result.user!.displayName,
            );
      }
      // AuthGate will automatically navigate to HomeScreen
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  void _navigateToEmailAuth() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const _EmailAuthScreen()),
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const Spacer(flex: 3),

                // App icon
                Icon(
                  Icons.local_fire_department,
                  size: 80,
                  color: Colors.white,
                ),
                const SizedBox(height: 16),

                // App name
                Text(
                  'Hachimi',
                  style: textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),

                // Tagline
                Text(
                  'Raise cats. Build habits.',
                  style: textTheme.bodyLarge?.copyWith(
                    color: Colors.white70,
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
                      backgroundColor: Colors.white,
                      foregroundColor: colorScheme.onSurface,
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
                    label: const Text('Continue with Google'),
                  ),
                ),
                const SizedBox(height: 12),

                // Email sign-in button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton.icon(
                    onPressed: _navigateToEmailAuth,
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: colorScheme.onSurface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: const Icon(Icons.email_outlined, size: 20),
                    label: const Text('Continue with Email'),
                  ),
                ),
                const SizedBox(height: 16),

                // Login link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                const _EmailAuthScreen(startAsLogin: true),
                          ),
                        );
                      },
                      child: Text(
                        'Log In',
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Email Auth Screen (Register / Login) ───

class _EmailAuthScreen extends ConsumerStatefulWidget {
  final bool startAsLogin;

  const _EmailAuthScreen({this.startAsLogin = false});

  @override
  ConsumerState<_EmailAuthScreen> createState() => _EmailAuthScreenState();
}

class _EmailAuthScreenState extends ConsumerState<_EmailAuthScreen> {
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
      final authService = ref.read(authServiceProvider);
      final analyticsService = ref.read(analyticsServiceProvider);

      if (_isLogin) {
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
        await ref.read(firestoreServiceProvider).createUserProfile(
              uid: uid,
              email: _emailController.text.trim(),
            );
      }
      // AuthGate will automatically navigate to HomeScreen.
      // Pop this screen so we don't leave it on the stack.
      if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
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
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 16),

                        // App icon
                        Icon(
                          Icons.local_fire_department,
                          size: 56,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Hachimi',
                          style: textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Toggle hint
                        Text(
                          _isLogin ? 'Welcome back!' : 'Create your account',
                          style: textTheme.bodyLarge?.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Email field
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: Colors.white),
                          decoration: _inputDecoration(
                            label: 'Email',
                            icon: Icons.email_outlined,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Password field
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          style: const TextStyle(color: Colors.white),
                          decoration: _inputDecoration(
                            label: 'Password',
                            icon: Icons.lock_outlined,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.white54,
                              ),
                              onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),

                        // Confirm password (register only)
                        if (!_isLogin) ...[
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: _obscureConfirmPassword,
                            style: const TextStyle(color: Colors.white),
                            decoration: _inputDecoration(
                              label: 'Confirm Password',
                              icon: Icons.lock_outlined,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.white54,
                                ),
                                onPressed: () => setState(() =>
                                    _obscureConfirmPassword =
                                        !_obscureConfirmPassword),
                              ),
                            ),
                            validator: (value) {
                              if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                        ],
                        const SizedBox(height: 32),

                        // Submit button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: FilledButton(
                            onPressed: _isLoading ? null : _submit,
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  )
                                : Text(
                                    _isLogin ? 'Log In' : 'Create Account',
                                    style: textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Toggle login/register
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _isLogin
                                  ? "Don't have an account? "
                                  : 'Already have an account? ',
                              style: textTheme.bodyMedium?.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                            GestureDetector(
                              onTap: () =>
                                  setState(() => _isLogin = !_isLogin),
                              child: Text(
                                _isLogin ? 'Register' : 'Log In',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
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
    required String label,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      prefixIcon: Icon(icon, color: Colors.white70),
      suffixIcon: suffixIcon,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white30),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red.shade300),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red.shade300),
      ),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.1),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/neon_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  void _handleRegister() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() => _isLoading = false);
        // Direct to Fitness Onboarding intake
        context.push('/onboarding');
      }
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('CREATE PLAYER ID', style: AppTypography.headlineSmall),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              Text(
                'BEGIN YOUR EVOLUTION',
                style: AppTypography.displaySmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Create your gaming alias and configure your fitness baseline.',
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: 28),

              // Username Input
              TextField(
                controller: _usernameController,
                style: AppTypography.titleMedium,
                decoration: const InputDecoration(
                  labelText: 'PLAYER USERNAME',
                  hintText: 'e.g. IronTitan_99',
                  prefixIcon: Icon(Icons.badge_outlined, color: AppColors.neonLime),
                ),
              ),
              const SizedBox(height: 18),

              // Email Input
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: AppTypography.titleMedium,
                decoration: const InputDecoration(
                  labelText: 'EMAIL ADDRESS',
                  hintText: 'user@example.com',
                  prefixIcon: Icon(Icons.email_outlined, color: AppColors.neonLime),
                ),
              ),
              const SizedBox(height: 18),

              // Password Input
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: AppTypography.titleMedium,
                decoration: InputDecoration(
                  labelText: 'SECURITY PASSWORD',
                  prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.neonLime),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                      color: AppColors.textMuted,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Register Button
              NeonButton(
                text: 'CONTINUE TO ONBOARDING',
                icon: Icons.arrow_forward_rounded,
                isLoading: _isLoading,
                onPressed: _handleRegister,
              ),
              const SizedBox(height: 20),

              // Google Auth Button
              NeonButton(
                text: 'SIGN UP WITH GOOGLE',
                icon: Icons.g_mobiledata_rounded,
                variant: NeonButtonVariant.secondary,
                onPressed: _handleRegister,
              ),

              const SizedBox(height: 32),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already registered? ', style: AppTypography.bodyMedium),
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Text(
                      'Log In',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.neonLime,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


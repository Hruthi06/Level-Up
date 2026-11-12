import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/neon_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _submitted = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('RECOVER ACCESS', style: AppTypography.headlineSmall),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('RESET PASSWORD', style: AppTypography.displaySmall),
              const SizedBox(height: 8),
              Text(
                'Enter your registered email address and we will dispatch a recovery link to restore your player credentials.',
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: 32),

              if (!_submitted) ...[
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: AppTypography.titleMedium,
                  decoration: const InputDecoration(
                    labelText: 'ACCOUNT EMAIL',
                    hintText: 'player@example.com',
                    prefixIcon: Icon(Icons.email_outlined, color: AppColors.neonLime),
                  ),
                ),
                const SizedBox(height: 28),
                NeonButton(
                  text: 'SEND RESET LINK',
                  onPressed: () {
                    setState(() => _submitted = true);
                  },
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.neonLime.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.neonLime, width: 1.2),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.mark_email_read_rounded, color: AppColors.neonLime, size: 48),
                      const SizedBox(height: 12),
                      Text(
                        'RESET LINK DISPATCHED',
                        style: AppTypography.headlineSmall.copyWith(color: AppColors.neonLime),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Check your inbox for password reset instructions.',
                        textAlign: TextAlign.center,
                        style: AppTypography.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                NeonButton(
                  text: 'RETURN TO LOGIN',
                  variant: NeonButtonVariant.secondary,
                  onPressed: () => context.go('/login'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}


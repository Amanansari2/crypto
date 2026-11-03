
import 'package:crypto_app/core/utils/constants/app_images.dart';
import 'package:crypto_app/features/trade/ui/widgets/text_field/trade_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../data/providers/login_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginProvider);
    final notifier = ref.read(loginProvider.notifier);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background =
    isDark ? AppColors.darkBg : const Color(0xFFF1F6FC);
    final textColor = isDark ? AppColors.white : AppColors.black;
    final secondaryText =
    isDark ? Colors.white70 : const Color(0xFF555B63);

    ref.listen(loginProvider, (previous, next) {
      next.whenOrNull(
        data: (response) {
          if (response == null || !response.success) return;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login successful')),
          );

          context.goNamed(RouteNames.homeName);
        },
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                error.toString().replaceFirst('Exception: ', ''),
              ),
            ),
          );
        },
      );
    });

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 28,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            context.goNamed(RouteNames.homeName);
                          },
                          child: Text(
                            'Skip',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Image.asset(
                          AppImages.logoBg,
                          height: 150,
                          width: 200,
                          fit: BoxFit.contain,
                        ),
                      ),

                      Text(
                        'Welcome Back',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.6,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        'Sign in to access your global crypto market.',
                        style: TextStyle(
                          color: secondaryText,
                          fontSize: 14,
                          height: 1.4,
                          letterSpacing: 0.2,
                        ),
                      ),

                      const SizedBox(height: 28),

                      TradeTextField(
                        dark: isDark,
                        controller: notifier.emailController,
                        hintText: 'Email Address',
                        keyboardType: TextInputType.emailAddress,
                        height: 56,
                        onChanged: (_) {},
                        validator: notifier.validateEmail,
                        prefix: const Icon(Icons.mail_outline),
                      ),

                      const SizedBox(height: 16),

                      TradeTextField(
                        dark: isDark,
                        controller: notifier.passwordController,
                        hintText: 'Password',
                        keyboardType: TextInputType.visiblePassword,
                        height: 56,
                        obscureText: _obscurePassword,
                        onChanged: (_) {},
                        validator: notifier.validatePassword,
                        prefix: const Icon(Icons.lock_outline),
                        suffix: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                        onSuffixTap: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),

                      const SizedBox(height: 12),

                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            context.pushNamed(RouteNames.forgotPasswordName);
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      SizedBox(
                        height: 62,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: loginState.isLoading
                              ? null
                              : () {
                            if (!(_formKey.currentState?.validate() ?? false)) {
                              return;
                            }
                            notifier.login(
                              email: notifier.emailController.text.trim(),
                              password: notifier.passwordController.text,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            disabledBackgroundColor: Colors.blue.withValues(alpha: 0.5),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: loginState.isLoading
                              ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                              : const Text(
                            'Sign In',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      Center(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: TextStyle(
                                color: textColor,
                                fontSize: 14,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                context.pushNamed(RouteNames.registerName);
                              },
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

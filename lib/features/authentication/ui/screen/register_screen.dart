import 'package:crypto_app/core/utils/constants/app_images.dart';
import 'package:crypto_app/features/trade/ui/widgets/text_field/trade_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../data/providers/register_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  bool _obscurePassword = true;
  bool _acceptedTerms = false;
  bool _termsError = false;
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    final registerState = ref.watch(registerProvider);
    final notifier = ref.read(registerProvider.notifier);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final background = isDark ? AppColors.darkBg : const Color(0xFFF1F6FC);


    final textColor = isDark ? AppColors.white : AppColors.black;

    final secondaryText = isDark ? Colors.white70 : const Color(0xFF555B63);


    ref.listen(registerProvider, (previous, next) {
      next.whenOrNull(
        data: (response) {
          if (response == null) return;

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(response.message)));
          if (response.success) {
            context.pushNamed(
              RouteNames.otpName,
              extra: {
                'email' : notifier.emailController.text.trim(),
              'password': notifier.passwordController.text,}
            );
          }
        },
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.toString().replaceFirst('Exception: ', '')),
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
                      // Globe
                      Center(
                        child: Image.asset(
                          AppImages.logoBg,
                          height: 150,
                          width: 200,
                          fit: BoxFit.contain,
                        ),
                      ),

                      // Heading
                      Text(
                        'Join Terminal1',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.6,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        'Create an account and access\n'
                        'a global crypto market.',
                        style: TextStyle(
                          color: secondaryText,
                          fontSize: 14,
                          height: 1.4,
                          letterSpacing: 0.2,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // First Name + Last Name
                      Row(
                        children: [
                          Expanded(
                            child: TradeTextField(
                              dark: isDark,
                              controller: notifier.firstNameController,
                              hintText: 'First Name',
                              keyboardType: TextInputType.name,
                              height: 56,
                              onChanged: (_) {},
                              validator: notifier.validateFirstName,
                              prefix: const Icon(Icons.person_outline),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TradeTextField(
                              dark: isDark,
                              controller: notifier.lastNameController,
                              hintText: 'Last Name',
                              keyboardType: TextInputType.name,
                              height: 56,
                              onChanged: (_) {},
                              validator: notifier.validateLastName,
                              prefix: const Icon(Icons.person_outline),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Email
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

                      const SizedBox(height: 14),

                      // Password
                      TradeTextField(
                        dark: isDark,
                        keyboardType: TextInputType.visiblePassword,
                        controller: notifier.passwordController,
                        hintText: 'Password',
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
                          debugPrint('UI obscurePassword: $_obscurePassword');
                        },
                      ),

                      const SizedBox(height: 14),

                      // Terms and Conditions
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 26,
                            width: 26,
                            child: Checkbox(
                              value: _acceptedTerms,
                              activeColor: AppColors.blue,
                              side: BorderSide(
                                color: secondaryText,
                                width: 1.5,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _acceptedTerms = value ?? false;
                                  _termsError = false;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Wrap(
                                children: [
                                  Text(
                                    'I agree to the ',
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 15,
                                      height: 1.4,
                                    ),
                                  ),

                                  GestureDetector(
                                    onTap: () {
                                      context.pushNamed(RouteNames.termsConditionName);
                                    },
                                    child: const Text(
                                      'Terms & Conditions',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 15,
                                        height: 1.4,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),

                                  Text(
                                    ' and ',
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 15,
                                      height: 1.4,
                                    ),
                                  ),

                                  GestureDetector(
                                    onTap: () {
                                      context.pushNamed(RouteNames.privacyPolicyName);
                                    },
                                    child: const Text(
                                      'Privacy Policy',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 15,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),

                                  Text(
                                    '.',
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      if (_termsError)
                        const Padding(
                          padding: EdgeInsets.only(left: 38, top: 4),
                          child: Text(
                            'Please accept Terms & Conditions',
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),

                      const SizedBox(height: 24),

                      // Register Button
                      SizedBox(
                        height: 62,
                        width: double.infinity,
                        child: DecoratedBox(
                          decoration: BoxDecoration(

                              color: Colors.blue,

                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ElevatedButton(
                            onPressed: registerState.isLoading
                                ? null
                                : () {
                                    if (!_acceptedTerms) {
                                      setState(() {
                                        _termsError = true;
                                      });
                                      return;
                                    }
                                    if (!(_formKey.currentState?.validate() ?? false)) {
                                      return;
                                    }
                                    notifier.register();
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              disabledBackgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: registerState.isLoading
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Register',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Sign In
                      Center(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: TextStyle(color: textColor, fontSize: 14),
                            ),
                            GestureDetector(
                              onTap: () {
                                context.pushNamed(RouteNames.signInName);
                              },
                              child: const Text(
                                'Sign In',
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

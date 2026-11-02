
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../trade/ui/widgets/text_field/trade_text_field.dart';
import '../../data/providers/login_provider.dart';
import '../../data/providers/otp_provider.dart';

class OtpScreen extends ConsumerStatefulWidget {
  final String email;
  final String password;

  const OtpScreen({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();

  bool _isEmailVerified = false;

  final FocusNode _otpFocusNode = FocusNode();

  Timer? _timer;

  int _remainingSeconds = 30;

  bool _isVerifying = false;
  bool _isResending = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  // 30-second countdown
  void _startTimer() {
    _timer?.cancel();

    setState(() {
      _remainingSeconds = 30;
    });

    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) {
        if (!mounted) return;

        if (_remainingSeconds <= 1) {
          timer.cancel();

          setState(() {
            _remainingSeconds = 0;
          });
        } else {
          setState(() {
            _remainingSeconds--;
          });
        }
      },
    );
  }

  String get _formattedTime {
    final seconds =
    _remainingSeconds.toString().padLeft(2, '0');

    return '00:$seconds';
  }

  // Verify OTP
  Future<void> _verifyOtp() async {
    if (!_isEmailVerified && _otpController.text.length != 6) {
      _showMessage('Please enter the 6-digit OTP');
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _isVerifying = true;
    });

    try {
      // Step 1: Verify OTP only once
      if (!_isEmailVerified) {
        final otpResponse = await ref
            .read(otpProvider.notifier)
            .verifyOtp(
          email: widget.email,
          otp: _otpController.text.trim(),
        );

        if (!mounted) return;

        if (otpResponse?.success != true) {
          _showMessage(
            otpResponse?.message ?? 'OTP verification failed',
          );
          return;
        }

        _isEmailVerified = true;
      }

      // Step 2: Login after successful email verification
      final loginResponse = await ref
          .read(loginProvider.notifier)
          .login(
        email: widget.email,
        password: widget.password,
      );

      if (!mounted) return;

      if (loginResponse?.success == true &&
          loginResponse!.token.isNotEmpty) {
        // Token and user should already be saved
        // inside LoginNotifier after successful login.

        _showMessage('Login successful');

        context.goNamed(RouteNames.homeName);
      } else {
        _showMessage(
          loginResponse?.message ?? 'Login failed. Please try again.',
        );
      }
    } catch (error) {
      if (!mounted) return;

      _showMessage(
        error.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isVerifying = false;
        });
      }
    }
  }

  // Resend OTP
  Future<void> _resendOtp() async {
    if (_remainingSeconds > 0 || _isResending) return;

    setState(() {
      _isResending = true;
    });

    try {
      final response = await ref
          .read(otpProvider.notifier)
          .resendOtp(email: widget.email);

      if (!mounted) return;

      if (response?.success == true) {
        _otpController.clear();
        _startTimer();

        _showMessage(response!.message);
      }
    } catch (error) {
      if (!mounted) return;

      _showMessage(
        error.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isResending = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message)),
      );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    _otpFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final textColor =
    isDark ? AppColors.white : AppColors.black;

    final secondaryColor =
    isDark ? Colors.white70 : Colors.black54;

    final background =
    isDark ? AppColors.darkBg : const Color(0xFFF1F6FC);

    final surface =
    isDark ? AppColors.darkSurface : Colors.white;

    final otpLength = _otpController.text.length;

    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back,
            color: textColor,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 20,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 35),

              // Email icon
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: AppColors.blue.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mark_email_read_outlined,
                  size: 48,
                  color: Colors.blue,
                ),
              ),

              const SizedBox(height: 30),

              // Heading
              Text(
                'Verify Your Email',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                'We have sent a 6-digit verification code to',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: secondaryColor,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                widget.email,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),

              const SizedBox(height: 38),

              TradeTextField(
                hintLetterSpacing: 12,
                textLetterSpacing: 12,
                textAlign: TextAlign.center,
                dark: isDark,
                controller: _otpController,
                labelText: 'OTP',
                hintText: '------',

                keyboardType: TextInputType.number,
                height: 66,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                onChanged: (value) {},
              ),



              const SizedBox(height: 25),

              // Verify Button
              SizedBox(
                height: 56,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: otpLength == 6 &&
                      !_isVerifying &&
                      !_isResending
                      ? _verifyOtp
                      : null,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    disabledBackgroundColor:
                    AppColors.blue.withOpacity(0.4),

                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  child: _isVerifying
                      ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Text(
                    'Verify OTP',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Resend section
              Text(
                "Didn't receive the code?",
                style: TextStyle(
                  color: secondaryColor,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 12),

              if (_remainingSeconds > 0)
                Text(
                  'Resend OTP in $_formattedTime',
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                )
              else
                TextButton(
                  onPressed: _isResending
                      ? null
                      : _resendOtp,

                  child: _isResending
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                      : const Text(
                    'Resend OTP',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

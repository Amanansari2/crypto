
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../trade/ui/widgets/text_field/trade_text_field.dart';
import '../../data/providers/forgot_password_provider.dart';

class ResetOtpScreen extends ConsumerStatefulWidget {
  final String email;

  const ResetOtpScreen({
    super.key,
    required this.email,
  });

  @override
  ConsumerState<ResetOtpScreen> createState() =>
      _ResetOtpScreenState();
}

class _ResetOtpScreenState extends ConsumerState<ResetOtpScreen> {
  final TextEditingController _otpController =
  TextEditingController();

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
    return '00:${_remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> _verifyOtp() async {
    if (_otpController.text.trim().length != 6) {
      _showMessage('Please enter the 6-digit OTP');
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _isVerifying = true;
    });

    try {
      final response = await ref
          .read(forgotPasswordProvider.notifier)
          .verifyResetOtp(
        email: widget.email,
        otp: _otpController.text.trim(),
      );

      if (!mounted) return;

      if (response.success && response.resetToken.isNotEmpty) {
        context.pushNamed(RouteNames.resetPasswordName);
      } else {
        _showMessage(
          response.message.isNotEmpty
              ? response.message
              : 'OTP verification failed',
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

  Future<void> _resendOtp() async {
    if (_remainingSeconds > 0 || _isResending) return;

    setState(() {
      _isResending = true;
    });

    try {
      final response = await ref
          .read(forgotPasswordProvider.notifier)
          .forgotPassword(email: widget.email);

      if (!mounted) return;

      _otpController.clear();
      _startTimer();

      _showMessage(response.message);
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

    final otpLength = _otpController.text.length;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
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

              Text(
                'Reset Your Password',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                'Enter the 6-digit OTP sent to your email address.',
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
                onChanged: (_) {
                  setState(() {});
                },
              ),

              const SizedBox(height: 25),

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
                  onPressed: _isResending || _isVerifying
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

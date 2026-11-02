
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/register/register_response_model.dart';
import '../models/register/register_request_model.dart';
import '../repository/auth_repository.dart';

final registerProvider =
AsyncNotifierProvider<RegisterNotifier, AuthResponseModel?>(
  RegisterNotifier.new,
);

class RegisterNotifier extends AsyncNotifier<AuthResponseModel?> {
  late final AuthRepository _repository;

  // Form

  // Controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();



  @override
  Future<AuthResponseModel?> build() async {
    _repository = AuthRepository();

    ref.onDispose(() {
      firstNameController.dispose();
      lastNameController.dispose();
      emailController.dispose();
      passwordController.dispose();
    });

    return null;
  }




  // First name validation
  String? validateFirstName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'First name is required';
    }

    if (value.trim().length > 100) {
      return 'Maximum 100 characters allowed';
    }

    return null;
  }

  // Last name validation
  String? validateLastName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Last name is required';
    }

    if (value.trim().length > 100) {
      return 'Maximum 100 characters allowed';
    }

    return null;
  }

  // Email validation
  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$')
        .hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }

    return null;
  }

  // Password validation
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8 || value.length > 128) {
      return 'Password must be between 8 and 128 characters';
    }

    return null;
  }

  // Registration API
  Future<void> register() async {


    state = const AsyncLoading();

    try {
      final response = await _repository.register(
        RegisterRequestModel(
          firstName: firstNameController.text.trim(),
          lastName: lastNameController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text,
        ),
      );

      state = AsyncData(response);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }
}

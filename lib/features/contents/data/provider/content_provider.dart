import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/model/content_model.dart';
import '../model/faq_model.dart';
import '../repository/content_repository.dart';

final termsConditionProvider =
FutureProvider<ContentResponseModel>((ref) async {
  final repository = TermsConditionRepository();

  return repository.getTermsCondition();
});


final privacyPolicyProvider =
FutureProvider<ContentResponseModel>((ref) async {
  final repository = PrivacyPolicyRepository();
  return repository.getPrivacyPolicy();
});


final refundPolicyProvider =
FutureProvider<ContentResponseModel>((ref) async {
  final repository = RefundPolicyRepository();

  return repository.getRefundPolicy();
});



final rewardReferralPolicyProvider =
FutureProvider<ContentResponseModel>((ref) async {
  final repository = RewardReferralPolicyRepository();
  return repository.getRewardReferralPolicy();
});



final subscriptionPolicyProvider =
FutureProvider<ContentResponseModel>((ref) async {
  final repository = SubscriptionPolicyRepository();
  return repository.getSubscriptionPolicy();
});



final faqProvider = FutureProvider<FaqResponseModel>((ref) async {
  final repository = FaqRepository();
  return repository.getFaq();
});


final aboutUsProvider =
FutureProvider<ContentResponseModel>((ref) async {
  final repository = AboutUsRepository();

  return repository.getAboutUs();
});
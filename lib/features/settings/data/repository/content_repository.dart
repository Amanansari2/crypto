import '../../../../../core/network/methods/get_method.dart';
import '../../../../../core/utils/constants/api_urls.dart';
import '../model/content_model.dart';
import '../model/faq_model.dart';

class PrivacyPolicyRepository {
  final GetMethod _getMethod = GetMethod();

  Future<ContentResponseModel> getPrivacyPolicy() async {
    final response = await _getMethod.getRequest(
      endpoint: ApiUrls.privacyPolicy,
    );

    return ContentResponseModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }
}


class TermsConditionRepository {
  final GetMethod _getMethod = GetMethod();

  Future<ContentResponseModel> getTermsCondition() async {
    final response = await _getMethod.getRequest(
      endpoint: ApiUrls.termsCondition,
    );

    return ContentResponseModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }
}


class RefundPolicyRepository {
  final GetMethod _getMethod = GetMethod();

  Future<ContentResponseModel> getRefundPolicy() async {
    final response = await _getMethod.getRequest(
      endpoint: ApiUrls.refundPolicy,
    );

    return ContentResponseModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }
}


class RewardReferralPolicyRepository {
  final GetMethod _getMethod = GetMethod();

  Future<ContentResponseModel> getRewardReferralPolicy() async {
    final response = await _getMethod.getRequest(
      endpoint: ApiUrls.rewardReferralPolicy,
    );

    return ContentResponseModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }
}


class SubscriptionPolicyRepository {
  final GetMethod _getMethod = GetMethod();

  Future<ContentResponseModel> getSubscriptionPolicy() async {
    final response = await _getMethod.getRequest(
      endpoint: ApiUrls.subscriptionPolicy,
    );

    return ContentResponseModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }
}





class FaqRepository {
  final GetMethod _getMethod = GetMethod();

  Future<FaqResponseModel> getFaq() async {
    final response = await _getMethod.getRequest(
      endpoint: ApiUrls.faq,
    );

    return FaqResponseModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }
}



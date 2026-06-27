import '../../../common/services/api_client.dart';

class PolicyContent {
  final int id;
  final String policyType;
  final String policyTypeDisplay;
  final String title;
  final String? titleBn;
  final String content;
  final String? contentBn;
  final String updatedAt;
  final bool isActive;

  PolicyContent({
    required this.id,
    required this.policyType,
    required this.policyTypeDisplay,
    required this.title,
    this.titleBn,
    required this.content,
    this.contentBn,
    required this.updatedAt,
    required this.isActive,
  });

  factory PolicyContent.fromJson(Map<String, dynamic> json) {
    return PolicyContent(
      id: json['id'] ?? 0,
      policyType: json['policyType'] ?? '',
      policyTypeDisplay: json['policyTypeDisplay'] ?? '',
      title: json['title'] ?? '',
      titleBn: json['titleBn'],
      content: json['content'] ?? '',
      contentBn: json['contentBn'],
      updatedAt: json['updatedAt'] ?? '',
      isActive: json['isActive'] ?? true,
    );
  }
}

class PolicyService {
  /// Fetches a policy by type: TERMS | PRIVACY | REFUND | ABOUT_US
  Future<PolicyContent?> getPolicyByType(String type) async {
    try {
      final response = await ApiClient().get(
        '/main/policies/by-type/?type=$type',
      );
      if (response.statusCode == 200 && response.data != null) {
        return PolicyContent.fromJson(
          Map<String, dynamic>.from(response.data),
        );
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}

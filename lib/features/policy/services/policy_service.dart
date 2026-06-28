import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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
    debugPrint('╔══════════════════════════════════════════════════════');
    debugPrint('║ [POLICY] Parsing JSON fields:');
    debugPrint('║  id               = ${json['id']}');
    debugPrint('║  policyType       = ${json['policyType']}');
    debugPrint('║  policy_type      = ${json['policy_type']}');
    debugPrint('║  policyTypeDisplay= ${json['policyTypeDisplay']}');
    debugPrint('║  title            = ${json['title']}');
    debugPrint('║  titleBn          = ${json['titleBn']}');
    debugPrint('║  title_bn         = ${json['title_bn']}');
    debugPrint('║  content length   = ${(json['content'] ?? '').toString().length}');
    debugPrint('║  contentBn length = ${(json['contentBn'] ?? json['content_bn'] ?? '').toString().length}');
    debugPrint('║  updatedAt        = ${json['updatedAt'] ?? json['updated_at']}');
    debugPrint('║  isActive         = ${json['isActive'] ?? json['is_active']}');
    debugPrint('╚══════════════════════════════════════════════════════');

    // Support both camelCase and snake_case field names
    return PolicyContent(
      id: json['id'] ?? 0,
      policyType: json['policyType'] ?? json['policy_type'] ?? '',
      policyTypeDisplay: json['policyTypeDisplay'] ?? json['policy_type_display'] ?? '',
      title: json['title'] ?? '',
      titleBn: json['titleBn'] ?? json['title_bn'],
      content: json['content'] ?? '',
      contentBn: json['contentBn'] ?? json['content_bn'],
      updatedAt: json['updatedAt'] ?? json['updated_at'] ?? '',
      isActive: json['isActive'] ?? json['is_active'] ?? true,
    );
  }
}

class PolicyService {
  /// Base of the API without the /r segment (e.g. https://demoapi.bideshgami.com/api)
  String get _apiBase {
    final raw = ApiClient().baseUrl; // e.g. https://demoapi.bideshgami.com/api/r
    // Strip trailing /r so we can hit /api/main/... directly
    if (raw.endsWith('/r')) return raw.substring(0, raw.length - 2);
    if (raw.endsWith('/r/')) return raw.substring(0, raw.length - 3);
    return raw;
  }

  /// Fetches a policy by type: TERMS | PRIVACY | REFUND | ABOUT_US
  Future<PolicyContent?> getPolicyByType(String type) async {
    // Build full URL that skips the /r prefix used by the ApiClient base
    final fullUrl = '$_apiBase/main/policies/by-type/?type=$type';

    debugPrint('╔══════════════════════════════════════════════════════');
    debugPrint('║ [POLICY] PolicyService.getPolicyByType()');
    debugPrint('║  type       = $type');
    debugPrint('║  baseUrl    = ${ApiClient().baseUrl}');
    debugPrint('║  apiBase    = $_apiBase');
    debugPrint('║  fullUrl    = $fullUrl');
    debugPrint('╚══════════════════════════════════════════════════════');

    try {
      // Use Dio directly with the full URL to bypass the ApiClient base path
      final dio = Dio(BaseOptions(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ));

      // Attach auth cookies and API key from the shared ApiClient token storage
      final cookies = await ApiClient().tokenStorage.getCookies();
      final apiKey = await ApiClient().tokenStorage.getApiKey();
      final extraHeaders = <String, String>{};
      if (cookies != null && cookies.isNotEmpty) {
        extraHeaders['Cookie'] = cookies;
      }
      if (apiKey != null) {
        extraHeaders['X-API-KEY'] = apiKey;
      }

      final response = await dio.get(
        fullUrl,
        options: Options(headers: extraHeaders),
      );

      debugPrint('╔══════════════════════════════════════════════════════');
      debugPrint('║ [POLICY] API Response received');
      debugPrint('║  statusCode = ${response.statusCode}');
      debugPrint('║  dataType   = ${response.data?.runtimeType}');
      debugPrint('║  rawData    = ${response.data}');
      debugPrint('╚══════════════════════════════════════════════════════');

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        if (data is Map) {
          debugPrint('[POLICY] ✅ Data is a Map — parsing PolicyContent');
          return PolicyContent.fromJson(Map<String, dynamic>.from(data));
        } else if (data is List && data.isNotEmpty) {
          debugPrint('[POLICY] ⚠️ Data is a List — using first item');
          return PolicyContent.fromJson(Map<String, dynamic>.from(data.first));
        } else {
          debugPrint('[POLICY] ❌ Unexpected data format: ${data.runtimeType}');
          return null;
        }
      }

      debugPrint('[POLICY] ❌ Non-200 status or null data. StatusCode: ${response.statusCode}');
      return null;
    } catch (e, stack) {
      debugPrint('╔══════════════════════════════════════════════════════');
      debugPrint('║ [POLICY] ❌ Exception in getPolicyByType()');
      debugPrint('║  error = $e');
      debugPrint('║  stack = $stack');
      debugPrint('╚══════════════════════════════════════════════════════');
      return null;
    }
  }
}

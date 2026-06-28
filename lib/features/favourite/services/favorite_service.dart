import 'package:flutter/foundation.dart';
import '../../../common/services/api_client.dart';
import '../../home/models/home_models.dart';

class FavoriteWorkPermit {
  final int id;
  final WorkPermitItem workPermit;
  final DateTime createdAt;

  FavoriteWorkPermit({
    required this.id,
    required this.workPermit,
    required this.createdAt,
  });

  factory FavoriteWorkPermit.fromJson(Map<String, dynamic> json) {
    final wp = json['workPermit'] ?? json['work_permit'] ?? {};
    
    // Parse flag and country safely
    String countryName = 'Unknown';
    String countryFlag = 'assets/img/customer/appointment/world.png';
    if (wp['country'] is Map) {
      countryName = wp['country']['name'] ?? 'Unknown';
      countryFlag = wp['country']['flag'] ?? 'assets/img/customer/appointment/world.png';
    }

    // Parse job category/work type safely
    String workTypeStr = 'Unknown';
    if (wp['job_category'] is Map) {
      workTypeStr = wp['job_category']['name'] ?? 'Unknown';
    } else if (wp['workType'] is Map) {
      workTypeStr = wp['workType']['name'] ?? 'Unknown';
    }

    final item = WorkPermitItem(
      id: wp['id'] is int ? wp['id'] : int.tryParse(wp['id']?.toString() ?? ''),
      title: wp['title'] ?? 'Unknown',
      slug: wp['slug'] ?? '',
      image: wp['image'] ?? 'assets/img/work-permit/1.jpg',
      customerPrice: wp['customerPrice'] ?? wp['customer_price'] ?? 0,
      agentPrice: wp['agentPrice'] ?? wp['agent_price'] ?? 0,
      countryName: countryName,
      countryFlag: countryFlag,
      workType: workTypeStr,
      selectionType: wp['selectionType'] ?? wp['selection_type'] ?? 'DIRECT',
      createdAt: wp['created_at'] != null ? DateTime.tryParse(wp['created_at']) ?? DateTime.now() : DateTime.now(),
    );

    return FavoriteWorkPermit(
      id: json['id'] ?? 0,
      workPermit: item,
      createdAt: json['createdAt'] != null || json['created_at'] != null
          ? DateTime.tryParse(json['createdAt'] ?? json['created_at']) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

class FavoriteService {
  final ApiClient _apiClient = ApiClient();

  Future<List<FavoriteWorkPermit>> getFavorites() async {
    try {
      final response = await _apiClient.get('/profile/favorite/');
      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .map((e) => FavoriteWorkPermit.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
    } catch (e) {
      debugPrint('Error getting favorites: $e');
    }
    return [];
  }

  Future<bool> addToFavorite(int workPermitId) async {
    try {
      final response = await _apiClient.post(
        '/profile/favorite/',
        data: {'work_permit': workPermitId},
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      debugPrint('Error adding to favorite: $e');
    }
    return false;
  }

  Future<bool> removeFavorite(int favoriteId) async {
    try {
      final response = await _apiClient.delete('/profile/favorite/$favoriteId/');
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      debugPrint('Error removing favorite: $e');
    }
    return false;
  }
}

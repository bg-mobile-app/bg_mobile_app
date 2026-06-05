import 'dart:convert';

import 'api_client.dart';

class DistrictOption {
  const DistrictOption({required this.id, required this.name});

  final int id;
  final String name;

  factory DistrictOption.fromJson(Map<String, dynamic> json) {
    return DistrictOption(id: json['id'] ?? 0, name: json['name'] ?? '');
  }
}

class PoliceStationOption {
  const PoliceStationOption({required this.id, required this.name});

  final int id;
  final String name;

  factory PoliceStationOption.fromJson(Map<String, dynamic> json) {
    return PoliceStationOption(id: json['id'] ?? 0, name: json['name'] ?? '');
  }
}

class LocationService {
  final ApiClient _apiClient = ApiClient();

  Future<List<DistrictOption>> getDistricts() async {
    final response = await _apiClient.get('/main/district/');
    return _listFromResponse(
      response.data,
    ).map(DistrictOption.fromJson).toList();
  }

  Future<List<PoliceStationOption>> getPoliceStations(int districtId) async {
    final response = await _apiClient.get(
      '/main/police-station/',
      queryParameters: {'district': districtId},
    );
    return _listFromResponse(
      response.data,
    ).map(PoliceStationOption.fromJson).toList();
  }

  List<Map<String, dynamic>> _listFromResponse(dynamic raw) {
    final data = raw is String ? jsonDecode(raw) : raw;
    final list = data is List
        ? data
        : data is Map<String, dynamic>
        ? data['results'] ?? data['data'] ?? data['items']
        : null;

    if (list is! List) return [];
    return list.whereType<Map<String, dynamic>>().toList();
  }
}

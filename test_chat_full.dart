import 'dart:io';
import 'package:dio/dio.dart';

// Test: Can we send attachmentUrl + attachmentName via WebSocket chat_message?
// We can't test WS here, but we CAN test if there's ANY REST upload endpoint
// that returns a URL we can then send over WS.

void main() async {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://demoapi.bideshgami.com/api/r',
    headers: {
      'Accept': 'application/json',
      'X-API-KEY': 'eef0787fa713f76_mobile_app_key_2026 xsmtpsib-206808a735e9f7cdbff5b-cMceaL6wYHHzIFkK',
      'Origin': 'https://demoapi.bideshgami.com',
      'Referer': 'https://demoapi.bideshgami.com/',
      'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
    },
    validateStatus: (status) => true,
  ));

  final dummyFile = File('dummy_test_file.txt');
  dummyFile.writeAsStringSync('Test attachment content');

  // 1. Probe chat-specific upload paths
  final chatPaths = [
    '/chat/attachments/',
    '/chat/attachment/',
    '/chat/upload/',
    '/chat/media/',
    '/chat/files/',
    '/chat/message-attachments/',
  ];

  print('=== Chat-specific upload endpoints ===');
  for (var path in chatPaths) {
    try {
      final form = FormData.fromMap({
        'file': await MultipartFile.fromFile(dummyFile.path, filename: 'test.txt'),
        'attachment': await MultipartFile.fromFile(dummyFile.path, filename: 'test.txt'),
      });
      final res = await dio.post(path, data: form);
      print('POST $path → ${res.statusCode}: ${res.data}');
    } catch (e) { print('POST $path → ERROR: $e'); }

    try {
      final res = await dio.get(path);
      print('GET  $path → ${res.statusCode}: ${res.data}');
    } catch (e) { print('GET  $path → ERROR: $e'); }
  }

  // 2. Check OPTIONS on the WS endpoint via HTTP (some servers expose WS endpoints as HTTP too)
  print('\n=== OPTIONS on /ws/ paths ===');
  final wsPaths = ['/ws/chat/', '/ws/'];
  for (var path in wsPaths) {
    try {
      final res = await dio.request(path, options: Options(method: 'OPTIONS'));
      print('OPTIONS $path → ${res.statusCode}');
    } catch (e) { print('OPTIONS $path → $e'); }
  }

  // 3. Probe common/generic upload paths
  print('\n=== Generic upload endpoints ===');
  final genericPaths = [
    '/common/file-upload/',
    '/common/upload/',
    '/files/upload/',
    '/uploads/',
    '/api/upload/',
    '/storage/upload/',
    '/media/upload/',
  ];
  for (var path in genericPaths) {
    try {
      final form = FormData.fromMap({
        'file': await MultipartFile.fromFile(dummyFile.path, filename: 'test.txt'),
      });
      final res = await dio.post(path, data: form);
      if (res.statusCode != 404) {
        print('POST $path → ${res.statusCode}: ${res.data}');
      }
    } catch (e) { /* skip 404s */ }

    try {
      final res = await dio.get(path);
      if (res.statusCode != 404) {
        print('GET $path → ${res.statusCode}: ${res.data}');
      }
    } catch (e) { /* skip */ }
  }

  print('\nDone.');
  dummyFile.deleteSync();
}

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

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
  ));

  final imageFile = File('flutter_01.png');
  if (!imageFile.existsSync()) {
    print('Error: flutter_01.png not found at root.');
    return;
  }

  final randomPhone = '018${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
  final email = 'john.doe$randomPhone@example.com';
  final password = 'a_strong_password';
  final rlNo = randomPhone.substring(randomPhone.length - 5);

  print('1. Registering user...');
  try {
    final regFormData = FormData.fromMap({
      'agency_name': 'Test Agency $randomPhone',
      'agency_phone': '01234567890',
      'rl_no': rlNo,
      'agency_address': '123 Main Street, Dhaka',
      'district': '1',
      'police_station': '1',
      'contact_number': randomPhone,
      'gender': 'Male',
      'designation': 'Owner',
      'full_name': 'John Doe',
      'phone': randomPhone,
      'email': email,
      'password': password,
      'is_privacy_terms': 'true',
      'image': await MultipartFile.fromFile(imageFile.path, filename: 'owner.png'),
      'nid_image': await MultipartFile.fromFile(imageFile.path, filename: 'nid.png'),
    });

    final regResponse = await dio.post('/user/register/agency/', data: regFormData);
    print('Registration Status: ${regResponse.statusCode}');
  } on DioException catch (e) {
    print('Registration Error: ${e.response?.statusCode} ${e.response?.data}');
    return;
  }

  print('\n2. Verifying OTP...');
  final commonOtps = ['123456', '000000', '111111', '999999', '1234'];
  bool verified = false;
  for (var otp in commonOtps) {
    try {
      print('Trying OTP: $otp');
      final otpRes = await dio.post(
        '/auth/otp/verify/',
        data: {'username': email, 'otp': otp},
      );
      if (otpRes.statusCode == 200 || otpRes.statusCode == 201) {
        print('OTP $otp verified successfully!');
        verified = true;
        break;
      }
    } on DioException catch (e) {
      print('OTP $otp failed: ${e.response?.statusCode} ${e.response?.data}');
    }
  }

  if (!verified) {
    print('Error: Could not verify OTP with common trial codes.');
    return;
  }

  print('\n3. Logging in...');
  String? cookies;
  try {
    final loginResponse = await dio.post(
      '/auth/login/',
      data: {
        'username': email,
        'password': password,
      },
    );
    print('Login Status: ${loginResponse.statusCode}');
    final setCookie = loginResponse.headers['set-cookie'];
    if (setCookie != null && setCookie.isNotEmpty) {
      cookies = setCookie.join('; ');
      print('Login Cookies obtained successfully.');
    } else {
      print('Warning: No set-cookie headers in login response.');
    }
  } on DioException catch (e) {
    print('Login Error: ${e.response?.statusCode} ${e.response?.data}');
    return;
  }

  // Update dio to use cookies
  if (cookies != null) {
    dio.options.headers['Cookie'] = cookies;
    // Extract CSRF token if present
    final pairs = cookies.split(';');
    for (var pair in pairs) {
      final trimmed = pair.trim();
      if (trimmed.startsWith('csrftoken=')) {
        final token = trimmed.substring('csrftoken='.length);
        dio.options.headers['X-CSRFToken'] = token;
        print('Extracted CSRFToken: $token');
      }
    }
  }

  print('\n4. Creating conversation as logged-in user...');
  String? conversationId;
  try {
    final response = await dio.post(
      '/chat/conversations/',
      data: {
        "participant_name": "John Doe",
        "participant_role": "AGENT",
        "receiver_role": "CALL_CENTER",
        "work_permit_id": "13"
      },
    );
    print('Create Conversation Success: ${response.statusCode}');
    print('Response: ${response.data}');
    conversationId = response.data['id'];
  } on DioException catch (e) {
    print('Create Conversation Error: ${e.response?.statusCode} ${e.response?.data}');
    return;
  }

  if (conversationId == null) {
    print('Error: Conversation ID is null');
    return;
  }

  print('\n5. Getting history with /chat/conversations/$conversationId/messages/...');
  try {
    final res = await dio.get('/chat/conversations/$conversationId/messages/');
    print('GET /chat/... history Success: ${res.statusCode}');
    print('Response data: ${res.data}');
  } on DioException catch (e) {
    print('GET /chat/... history Error: ${e.response?.statusCode} ${e.response?.data}');
  }

  // Create a dummy chat attachment
  final dummyFile = File('dummy_chat_attachment.txt');
  dummyFile.writeAsStringSync('Hello, this is a test attachment from authenticated user!');

  print('\n6. Posting attachment with /chat/conversations/$conversationId/messages/...');
  try {
    final formData = FormData.fromMap({
      'attachment': await MultipartFile.fromFile(dummyFile.path, filename: 'test_attachment.txt'),
      'content': 'Test attachment upload over /chat/...',
    });
    final res = await dio.post('/chat/conversations/$conversationId/messages/', data: formData);
    print('POST /chat/... attachment Success: ${res.statusCode}');
    print('Response: ${res.data}');
  } on DioException catch (e) {
    print('POST /chat/... attachment Error: ${e.response?.statusCode} ${e.response?.data}');
  }

  // Cleanup
  if (dummyFile.existsSync()) {
    dummyFile.deleteSync();
  }
}

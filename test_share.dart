import 'package:share_plus/share_plus.dart';

void main() {
  print('Checking Share class...');
  try {
    // Check if Share class exists and has methods
    print('Share: $Share');
  } catch (e) {
    print('Share error: $e');
  }

  print('Checking SharePlus class...');
  try {
    print('SharePlus: $SharePlus');
    print('SharePlus.instance: ${SharePlus.instance}');
  } catch (e) {
    print('SharePlus error: $e');
  }
}

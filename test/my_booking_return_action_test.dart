import 'package:flutter_test/flutter_test.dart';
import 'package:bideshgami_merchant/features/booking/my_booking_screen.dart';

void main() {
  group('shouldShowReturnPassportAction', () {
    test('shows return passport action from BG_COLLECT_PP onward', () {
      expect(shouldShowReturnPassportAction('BG_COLLECT_PP'), isTrue);
      expect(shouldShowReturnPassportAction('BG_SENT_PP'), isTrue);
      expect(shouldShowReturnPassportAction('SUCCESS_FLIGHT'), isFalse);
    });

    test('hides return passport action before BG_COLLECT_PP', () {
      expect(shouldShowReturnPassportAction('APPLIED_FILE'), isFalse);
      expect(shouldShowReturnPassportAction('UNDER_PROCESSING'), isTrue);
    });
  });
}

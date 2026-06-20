import '../../../common/services/api_client.dart';

class PaymentHistoryPage {
  const PaymentHistoryPage({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
    required this.pageSize,
  });

  final int count;
  final String? next;
  final String? previous;
  final List<PaymentHistoryItem> results;
  final int pageSize;
}

class PaymentHistoryItem {
  const PaymentHistoryItem({
    required this.id,
    required this.agency,
    required this.agencyName,
    required this.totalAmount,
    required this.totalRequests,
    required this.paymentMethod,
    required this.paymentReference,
    required this.status,
    required this.accountName,
    required this.accountNo,
    required this.paidBy,
    required this.paidByName,
    required this.paidAt,
    required this.receiptFile,
    required this.createdAt,
    required this.note,
  });

  final int id;
  final int agency;
  final String agencyName;
  final String totalAmount;
  final int totalRequests;
  final String paymentMethod;
  final String paymentReference;
  final String status;
  final String accountName;
  final String accountNo;
  final String paidBy;
  final String paidByName;
  final String paidAt;
  final String receiptFile;
  final String createdAt;
  final String note;

  factory PaymentHistoryItem.fromJson(Map<String, dynamic> json) {
    int toInt(dynamic value) {
      if (value is int) return value;
      if (value is num) return value.toInt();
      final normalized = value?.toString().trim().replaceAll(',', '') ?? '';
      if (normalized.isEmpty) return 0;
      return int.tryParse(normalized) ?? double.tryParse(normalized)?.toInt() ?? 0;
    }

    String toStringValue(dynamic value) {
      if (value == null) return '';
      return value.toString().trim();
    }

    return PaymentHistoryItem(
      id: toInt(json['id']),
      agency: toInt(json['agency']),
      agencyName: toStringValue(json['agencyName'] ?? json['agency_name']),
      totalAmount: toStringValue(json['totalAmount'] ?? json['total_amount']),
      totalRequests: toInt(json['totalRequests'] ?? json['total_requests']),
      paymentMethod: toStringValue(json['paymentMethod'] ?? json['payment_method']),
      paymentReference: toStringValue(json['paymentReference'] ?? json['payment_reference']),
      status: toStringValue(json['status']),
      accountName: toStringValue(json['accountName'] ?? json['account_name']),
      accountNo: toStringValue(json['accountNo'] ?? json['account_no']),
      paidBy: toStringValue(json['paidBy'] ?? json['paid_by']),
      paidByName: toStringValue(json['paidByName'] ?? json['paid_by_name']),
      paidAt: toStringValue(json['paidAt'] ?? json['paid_at']),
      receiptFile: toStringValue(json['receiptFile'] ?? json['receipt_file']),
      createdAt: toStringValue(json['createdAt'] ?? json['created_at']),
      note: toStringValue(json['note']),
    );
  }
}

class PaymentHistoryService {
  PaymentHistoryService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<PaymentHistoryPage> getHistory({
    String? status,
    String? search,
    int page = 1,
  }) async {
    final query = <String, dynamic>{'page': page};
    if ((status ?? '').isNotEmpty) query['status'] = status;
    if ((search ?? '').isNotEmpty) query['search'] = search;

    final response = await _apiClient.get(
      '/payment/history-agency/',
      queryParameters: query,
    );
    final data = response.data is Map<String, dynamic>
        ? response.data as Map<String, dynamic>
        : Map<String, dynamic>.from(response.data as Map);
    final rawResults = data['results'] as List? ?? const [];

    return PaymentHistoryPage(
      count: int.tryParse('${data['count'] ?? 0}') ?? 0,
      next: data['next']?.toString(),
      previous: data['previous']?.toString(),
      pageSize: int.tryParse('${data['pageSize'] ?? 20}') ?? 20,
      results: rawResults
          .whereType<Map>()
          .map((e) => PaymentHistoryItem.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }

  Future<BillDetails> getBillDetails(String billId) async {
    final response = await _apiClient.get('/payment/bill/$billId/');
    final data = response.data is Map<String, dynamic>
        ? response.data as Map<String, dynamic>
        : Map<String, dynamic>.from(response.data as Map);
    return BillDetails.fromJson(data);
  }

  Future<void> confirmBill(int billId) async {
    await _apiClient.post('/payment/bill/$billId/confirm/');
  }
}

class BillDetails {
  final int id;
  final int agency;
  final String agencyName;
  final String totalAmount;
  final int totalRequests;
  final String paymentMethod;
  final String paymentReference;
  final String status;
  final String accountName;
  final String accountNo;
  final String paidBy;
  final String paidByName;
  final String paidAt;
  final String receiptFile;
  final List<BillItem> items;
  final String createdAt;
  final String note;

  const BillDetails({
    required this.id,
    required this.agency,
    required this.agencyName,
    required this.totalAmount,
    required this.totalRequests,
    required this.paymentMethod,
    required this.paymentReference,
    required this.status,
    required this.accountName,
    required this.accountNo,
    required this.paidBy,
    required this.paidByName,
    required this.paidAt,
    required this.receiptFile,
    required this.items,
    required this.createdAt,
    required this.note,
  });

  factory BillDetails.fromJson(Map<String, dynamic> json) {
    int toInt(dynamic value) {
      if (value is int) return value;
      if (value is num) return value.toInt();
      final normalized = value?.toString().trim().replaceAll(',', '') ?? '';
      if (normalized.isEmpty) return 0;
      return int.tryParse(normalized) ?? double.tryParse(normalized)?.toInt() ?? 0;
    }

    String toStringValue(dynamic value) {
      if (value == null) return '';
      return value.toString().trim();
    }

    final rawItems = json['items'] as List? ?? const [];

    return BillDetails(
      id: toInt(json['id']),
      agency: toInt(json['agency']),
      agencyName: toStringValue(json['agencyName'] ?? json['agency_name']),
      totalAmount: toStringValue(json['totalAmount'] ?? json['total_amount']),
      totalRequests: toInt(json['totalRequests'] ?? json['total_requests']),
      paymentMethod: toStringValue(json['paymentMethod'] ?? json['payment_method']),
      paymentReference: toStringValue(json['paymentReference'] ?? json['payment_reference']),
      status: toStringValue(json['status']),
      accountName: toStringValue(json['accountName'] ?? json['account_name']),
      accountNo: toStringValue(json['accountNo'] ?? json['account_no']),
      paidBy: toStringValue(json['paidBy'] ?? json['paid_by']),
      paidByName: toStringValue(json['paidByName'] ?? json['paid_by_name']),
      paidAt: toStringValue(json['paidAt'] ?? json['paid_at']),
      receiptFile: toStringValue(json['receiptFile'] ?? json['receipt_file']),
      items: rawItems
          .whereType<Map>()
          .map((e) => BillItem.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      createdAt: toStringValue(json['createdAt'] ?? json['created_at']),
      note: toStringValue(json['note']),
    );
  }
}

class BillItem {
  final int id;
  final int postId;
  final int bookingId;
  final String passportNo;
  final String customerName;
  final String step;
  final String requestType;
  final String amount;

  const BillItem({
    required this.id,
    required this.postId,
    required this.bookingId,
    required this.passportNo,
    required this.customerName,
    required this.step,
    required this.requestType,
    required this.amount,
  });

  factory BillItem.fromJson(Map<String, dynamic> json) {
    int toInt(dynamic value) {
      if (value is int) return value;
      if (value is num) return value.toInt();
      final normalized = value?.toString().trim().replaceAll(',', '') ?? '';
      if (normalized.isEmpty) return 0;
      return int.tryParse(normalized) ?? double.tryParse(normalized)?.toInt() ?? 0;
    }

    String toStringValue(dynamic value) {
      if (value == null) return '';
      return value.toString().trim();
    }

    return BillItem(
      id: toInt(json['id']),
      postId: toInt(json['postId'] ?? json['post_id']),
      bookingId: toInt(json['bookingId'] ?? json['booking_id']),
      passportNo: toStringValue(json['passportNo'] ?? json['passport_no']),
      customerName: toStringValue(json['customerName'] ?? json['customer_name']),
      step: toStringValue(json['step']),
      requestType: toStringValue(json['requestType'] ?? json['request_type']),
      amount: toStringValue(json['amount']),
    );
  }
}

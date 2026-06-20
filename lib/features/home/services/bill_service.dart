import '../../../common/services/api_client.dart';

class BillPage {
  const BillPage({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
    required this.pageSize,
  });

  final int count;
  final String? next;
  final String? previous;
  final List<BillItem> results;
  final int pageSize;
}

class BillItem {
  const BillItem({
    required this.id,
    required this.agency,
    required this.agencyName,
    required this.totalAmount,
    required this.totalRequests,
    required this.paymentMethod,
    required this.paidByName,
    required this.paidAt,
    required this.status,
    required this.items,
  });

  final int id;
  final int agency;
  final String agencyName;
  final String totalAmount;
  final int totalRequests;
  final String paymentMethod;
  final String paidByName;
  final String paidAt;
  final String status;
  final List<BillSubItem> items;

  factory BillItem.fromJson(Map<String, dynamic> json) {
    int toInt(dynamic v) {
      if (v is int) return v;
      if (v is num) return v.toInt();
      return int.tryParse(v?.toString() ?? '') ?? 0;
    }

    String toStr(dynamic v) => v == null ? '' : v.toString();

    final rawItems = json['items'] as List? ?? const [];
    return BillItem(
      id: toInt(json['id']),
      agency: toInt(json['agency']),
      agencyName: toStr(json['agencyName'] ?? json['agency_name']),
      totalAmount: toStr(json['totalAmount'] ?? json['total_amount']),
      totalRequests: toInt(json['totalRequests'] ?? json['total_requests']),
      paymentMethod: toStr(json['paymentMethod'] ?? json['payment_method']),
      paidByName: toStr(json['paidByName'] ?? json['paid_by_name'] ?? json['paidBy']),
      paidAt: toStr(json['paidAt'] ?? json['paid_at'] ?? ''),
      status: toStr(json['status']),
      items: rawItems.whereType<Map>().map((e)=>BillSubItem.fromJson(Map<String,dynamic>.from(e))).toList(),
    );
  }
}

class BillSubItem {
  const BillSubItem({
    required this.id,
    required this.postId,
    required this.bookingId,
    required this.passportNo,
    required this.customerName,
    required this.step,
    required this.requestType,
    required this.amount,
  });

  final int id;
  final int postId;
  final int bookingId;
  final String passportNo;
  final String customerName;
  final String step;
  final String requestType;
  final String amount;

  factory BillSubItem.fromJson(Map<String, dynamic> json) {
    int toInt(dynamic v) {
      if (v is int) return v;
      if (v is num) return v.toInt();
      return int.tryParse(v?.toString() ?? '') ?? 0;
    }
    String toStr(dynamic v) => v == null ? '' : v.toString();
    return BillSubItem(
      id: toInt(json['id']),
      postId: toInt(json['postId'] ?? json['post_id']),
      bookingId: toInt(json['bookingId'] ?? json['booking']),
      passportNo: toStr(json['passportNo'] ?? json['passport_no']),
      customerName: toStr(json['customerName'] ?? json['customer_name']),
      step: toStr(json['step']),
      requestType: toStr(json['requestType'] ?? json['request_type']),
      amount: toStr(json['amount']),
    );
  }
}

class BillService {
  BillService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();
  final ApiClient _apiClient;

  Future<BillPage> getBills({String? search, int page = 1}) async {
    final query = <String, dynamic>{'page': page};
    if ((search ?? '').isNotEmpty) query['search'] = search;
    final response = await _apiClient.get('/payment/bill/', queryParameters: query);
    final data = response.data is Map<String, dynamic>
        ? response.data as Map<String, dynamic>
        : Map<String, dynamic>.from(response.data as Map);
    final raw = data['results'] as List? ?? const [];
    return BillPage(
      count: int.tryParse('${data['count'] ?? 0}') ?? 0,
      next: data['next']?.toString(),
      previous: data['previous']?.toString(),
      pageSize: int.tryParse('${data['pageSize'] ?? 20}') ?? 20,
      results: raw.whereType<Map>().map((e) => BillItem.fromJson(Map<String,dynamic>.from(e))).toList(),
    );
  }
}

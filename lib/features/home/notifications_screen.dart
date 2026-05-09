import 'dart:async';

import 'package:flutter/material.dart';

import 'dashboard_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _loading = false;
  List<AppNotificationItem> _notifications = [];

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 450));
    if (!mounted) return;
    setState(() {
      _notifications = [
        AppNotificationItem(
          id: 1,
          title: 'Payment received',
          message: 'Your payment invoice #1022 has been confirmed.',
          createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
          linkUrl: '/dashboard/my-payments',
          isRead: false,
        ),
        AppNotificationItem(
          id: 2,
          title: 'Appointment updated',
          message: 'Your appointment date has been moved to next week.',
          createdAt: DateTime.now().subtract(const Duration(hours: 3)),
          linkUrl: '/dashboard/booking/appointment',
          isRead: false,
        ),
        AppNotificationItem(
          id: 3,
          title: 'Profile verification',
          message: 'Your profile verification is now complete.',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          isRead: true,
        ),
      ];
      _loading = false;
    });
  }

  Future<void> _markRead(int id) async {
    if (_loading) return;
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 220));
    if (!mounted) return;
    setState(() {
      _notifications = _notifications.map((n) => n.id == id ? n.copyWith(isRead: true) : n).toList();
      _loading = false;
    });
  }

  Future<void> _markAllRead() async {
    if (_loading) return;
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 250));
    if (!mounted) return;
    setState(() {
      _notifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DashboardPageScaffold(
      currentHref: '/dashboard/notifications',
      child: SafeArea(
        child: _loading && _notifications.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 920),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isCompact = constraints.maxWidth < 640;
                          return Flex(
                            direction: isCompact ? Axis.vertical : Axis.horizontal,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: isCompact ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                            children: [
                              const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Row(children: [Icon(Icons.notifications, color: Color(0xFF2563EB)), SizedBox(width: 8), Text('Notifications', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold))]),
                                SizedBox(height: 4),
                                Text('Manage your latest activity and alerts', style: TextStyle(color: Color(0xFF64748B))),
                              ]),
                              if (_notifications.any((n) => !n.isRead)) ...[
                                if (isCompact) const SizedBox(height: 12),
                                TextButton.icon(
                                  onPressed: _loading ? null : _markAllRead,
                                  icon: const Icon(Icons.done_all),
                                  label: const Text('Mark all as read'),
                                ),
                              ],
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: _notifications.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 80),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Icon(Icons.inbox_outlined, size: 48, color: Color(0xFF94A3B8)),
                                      SizedBox(height: 12),
                                      Text('Your inbox is empty', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
                                      SizedBox(height: 6),
                                      Text("We'll notify you when something happens.", style: TextStyle(color: Color(0xFF94A3B8))),
                                    ],
                                  ),
                                ),
                              )
                            : Column(
                                children: _notifications.map((n) => _notificationItem(n)).toList(),
                              ),
                      ),
                    ]),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _notificationItem(AppNotificationItem n) {
    return Container(
      decoration: BoxDecoration(
        color: n.isRead ? Colors.white : const Color(0x050B61FF),
        border: const Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: n.isRead ? const Color(0xFFF1F5F9) : const Color(0xFF2563EB),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.notifications, size: 18, color: n.isRead ? const Color(0xFF94A3B8) : Colors.white),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final isCompact = constraints.maxWidth < 420;
                if (isCompact) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        n.title,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: n.isRead ? const Color(0xFF64748B) : const Color(0xFF0F172A)),
                      ),
                      const SizedBox(height: 4),
                      Text(timeAgo(n.createdAt), style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                    ],
                  );
                }
                return Row(
                  children: [
                    Expanded(
                      child: Text(
                        n.title,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: n.isRead ? const Color(0xFF64748B) : const Color(0xFF0F172A)),
                      ),
                    ),
                    Text(timeAgo(n.createdAt), style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                  ],
                );
              },
            ),
            const SizedBox(height: 6),
            Text(n.message, style: const TextStyle(color: Color(0xFF64748B))),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                if (n.linkUrl != null)
                  TextButton.icon(
                    onPressed: () => _markRead(n.id),
                    icon: const Icon(Icons.open_in_new, size: 16),
                    label: const Text('Take Action'),
                  ),
                if (!n.isRead)
                  TextButton(
                    onPressed: () => _markRead(n.id),
                    child: const Text('Mark as read'),
                  ),
              ],
            ),
          ]),
        ),
      ]),
    );
  }
}

String timeAgo(DateTime? date) {
  if (date == null) return 'N/A';
  final seconds = DateTime.now().difference(date).inSeconds;
  if (seconds < 5) return 'just now';

  const intervals = [
    ('year', 31536000),
    ('month', 2592000),
    ('week', 604800),
    ('day', 86400),
    ('hour', 3600),
    ('min', 60),
    ('sec', 1),
  ];

  for (final interval in intervals) {
    final count = seconds ~/ interval.$2;
    if (count >= 1) {
      return '$count ${interval.$1}${count > 1 ? 's' : ''} ago';
    }
  }
  return 'just now';
}

class AppNotificationItem {
  const AppNotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.isRead,
    this.linkUrl,
  });

  final int id;
  final String title;
  final String message;
  final DateTime createdAt;
  final bool isRead;
  final String? linkUrl;

  AppNotificationItem copyWith({bool? isRead}) {
    return AppNotificationItem(
      id: id,
      title: title,
      message: message,
      createdAt: createdAt,
      isRead: isRead ?? this.isRead,
      linkUrl: linkUrl,
    );
  }
}

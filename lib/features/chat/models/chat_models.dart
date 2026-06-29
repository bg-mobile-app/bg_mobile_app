class Conversation {
  final String id;
  final int workPermitId;
  final String? workPermitRef;
  final String? receiverRole;
  final String? branchId;
  final String? branchName;
  final String? assignedToName;
  final String? assignedToCode;
  final String? assignedToRole;
  final String? status;
  final String createdAt;
  final String updatedAt;
  final String? lastMessageContent;
  final String? lastMessageTime;
  final int unreadCount;
  final String participantName;
  final String participantRole;
  final bool isOnline;
  final bool? isNew;

  Conversation({
    required this.id,
    required this.workPermitId,
    this.workPermitRef,
    this.receiverRole,
    this.branchId,
    this.branchName,
    this.assignedToName,
    this.assignedToCode,
    this.assignedToRole,
    this.status,
    required this.createdAt,
    required this.updatedAt,
    this.lastMessageContent,
    this.lastMessageTime,
    required this.unreadCount,
    required this.participantName,
    required this.participantRole,
    required this.isOnline,
    this.isNew,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'] as String,
      workPermitId: (json['workPermitId'] ?? json['work_permit_id']) as int? ?? 0,
      workPermitRef: (json['workPermitRef'] ?? json['work_permit_ref']) as String?,
      receiverRole: (json['receiverRole'] ?? json['receiver_role']) as String?,
      branchId: (json['branchId'] ?? json['branch_id'])?.toString(),
      branchName: (json['branchName'] ?? json['branch_name']) as String?,
      assignedToName: (json['assignedToName'] ?? json['assigned_to_name']) as String?,
      assignedToCode: (json['assignedToCode'] ?? json['assigned_to_code']) as String?,
      assignedToRole: (json['assignedToRole'] ?? json['assigned_to_role']) as String?,
      status: json['status'] as String?,
      createdAt: (json['createdAt'] ?? json['created_at']) as String? ?? '',
      updatedAt: (json['updatedAt'] ?? json['updated_at']) as String? ?? '',
      lastMessageContent: (json['lastMessageContent'] ?? json['last_message_content']) as String?,
      lastMessageTime: (json['lastMessageTime'] ?? json['last_message_time']) as String?,
      unreadCount: (json['unreadCount'] ?? json['unread_count']) as int? ?? 0,
      participantName: (json['participantName'] ?? json['participant_name']) as String? ?? '',
      participantRole: (json['participantRole'] ?? json['participant_role']) as String? ?? '',
      isOnline: (json['isOnline'] ?? json['is_online']) as bool? ?? false,
      isNew: (json['isNew'] ?? json['is_new']) as bool?,
    );
  }
}

class ChatMessage {
  final String id;
  final String? senderName;
  final String? senderRole;
  final String? senderExternalId;
  final String? senderUserCode;
  final String? content;
  final String timestamp;
  final bool isRead;
  final String? readAt;
  final String? attachmentUrl;
  final String? attachmentName;
  /// Base64-encoded file content — populated for locally-sent messages before
  /// the server has stored and returned a URL.
  final String? attachmentData;
  /// MIME type matching [attachmentData], e.g. 'image/png', 'application/pdf'.
  final String? attachmentType;

  ChatMessage({
    required this.id,
    this.senderName,
    this.senderRole,
    this.senderExternalId,
    this.senderUserCode,
    this.content,
    required this.timestamp,
    required this.isRead,
    this.readAt,
    this.attachmentUrl,
    this.attachmentName,
    this.attachmentData,
    this.attachmentType,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: (json['id'] ?? json['message_id'])?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      senderName: (json['senderName'] ?? json['sender_name']) as String?,
      senderRole: (json['senderRole'] ?? json['sender_role']) as String?,
      senderExternalId: (json['senderExternalId'] ?? json['sender_external_id']) as String?,
      senderUserCode: (json['senderUserCode'] ?? json['sender_user_code']) as String?,
      content: json['content'] as String?,
      timestamp: (json['timestamp'] ?? json['created_at'] ?? json['created_time']) as String? ?? '',
      isRead: (json['isRead'] ?? json['is_read']) as bool? ?? false,
      readAt: (json['readAt'] ?? json['read_at']) as String?,
      attachmentUrl: (json['attachmentUrl'] ?? json['attachment_url']) as String?,
      attachmentName: (json['attachmentName'] ?? json['attachment_name']) as String?,
      attachmentData: (json['attachmentData'] ?? json['attachment_data']) as String?,
      attachmentType: (json['attachmentType'] ?? json['attachment_type']) as String?,
    );
  }
}

class ChatHistoryResponse {
  final List<ChatMessage> messages;
  final bool hasMore;
  final String? oldestId;

  ChatHistoryResponse({
    required this.messages,
    required this.hasMore,
    this.oldestId,
  });

  factory ChatHistoryResponse.fromJson(Map<String, dynamic> json) {
    return ChatHistoryResponse(
      messages: (json['messages'] as List<dynamic>?)
              ?.map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      hasMore: json['hasMore'] as bool? ?? false,
      oldestId: json['oldestId'] as String?,
    );
  }
}

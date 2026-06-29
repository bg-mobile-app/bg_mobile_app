import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../common/services/api_client.dart';
import 'models/chat_models.dart';
import 'services/chat_service.dart';

// ─────────────────────────── Colours ────────────────────────────────────────
const _blue = Color(0xFF2563EB);
const _darkBlue = Color(0xFF004AC6);
const _bgChat = Color(0xFFDCE7F7);
const _outlineColor = Color(0xFFC3C6D7);
const _mutedText = Color(0xFF737686);
const _darkText = Color(0xFF0B1C30);

// ─────────────────────────── Helpers ────────────────────────────────────────
bool _isImage(String name) {
  final ext = name.split('.').last.toLowerCase();
  return ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'].contains(ext);
}

bool _isPdf(String name) => name.toLowerCase().endsWith('.pdf');

IconData _fileIcon(String name) {
  if (_isPdf(name)) return Icons.picture_as_pdf_rounded;
  final ext = name.split('.').last.toLowerCase();
  if (['doc', 'docx'].contains(ext)) return Icons.description_rounded;
  if (['xls', 'xlsx'].contains(ext)) return Icons.table_chart_rounded;
  if (['zip', 'rar', '7z'].contains(ext)) return Icons.folder_zip_rounded;
  return Icons.insert_drive_file_rounded;
}

// ═══════════════════════════════════════════════════════════════════════════
class ChatConversationScreen extends StatefulWidget {
  const ChatConversationScreen({
    super.key,
    required this.chat,
    this.initialMessage,
  });

  final Conversation chat;
  final String? initialMessage;

  @override
  State<ChatConversationScreen> createState() => _ChatConversationScreenState();
}

class _ChatConversationScreenState extends State<ChatConversationScreen> {
  final ChatService _chatService = ChatService();
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<ChatMessage> _messages = [];
  bool _isLoading = true;
  bool _isOnline = false;
  bool _isSendingAttachment = false;

  // Pending attachment picked by the user but not yet sent
  PlatformFile? _pendingFile;

  // Cache of sent attachments to merge into server messages/history
  final List<ChatMessage> _sentAttachmentsCache = [];

  @override
  void initState() {
    super.initState();
    _isOnline = widget.chat.isOnline;
    _initChat();
  }

  @override
  void dispose() {
    _chatService.disconnectWebSocket();
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ──────────────────────────── Init ──────────────────────────────────────
  Future<void> _initChat() async {
    debugPrint('╔══════════════════════════════════════════════════════');
    debugPrint('║ [CONVO] _initChat  conversationId=${widget.chat.id}');
    debugPrint('╚══════════════════════════════════════════════════════');

    final history = await _chatService.getMessageHistory(widget.chat.id);
    if (mounted) {
      setState(() {
        _messages = _mergeAttachments(history?.messages ?? []);
        _isLoading = false;
      });
      _chatService.markMessagesAsRead(widget.chat.id);
      _scrollToBottom();
    }

    final cookieStr = await ApiClient().tokenStorage.getCookies();
    debugPrint('[CONVO] cookies present? ${cookieStr != null && cookieStr.isNotEmpty}');

    final channel = _chatService.connectWebSocket(widget.chat.id);

    if (_messages.isEmpty &&
        widget.initialMessage != null &&
        widget.initialMessage!.isNotEmpty) {
      _chatService.sendChatMessage(widget.initialMessage!);
    }

    channel?.stream.listen(
      (messageStr) {
        debugPrint('[CONVO WS ←] $messageStr');
        try {
          final data = jsonDecode(messageStr as String);
          final type = data['type'];
          if (type == 'chat_message') {
            var msg = ChatMessage.fromJson(data['message']);
            // Merge with local cache
            final mergedList = _mergeAttachments([msg]);
            if (mergedList.isNotEmpty) {
              msg = mergedList.first;
            }

            // Deduplicate: replace matching local optimistic message (id starts with 'local_')
            // with this server version, or add it if not found.
            final existingIndex = _messages.indexWhere((m) {
              if (m.id == msg.id) return true;
              if (m.id.startsWith('local_')) {
                final isOurMessage = msg.senderRole == 'CUSTOMER' || 
                                     msg.senderName == 'You' || 
                                     msg.senderName == 'CUSTOMER' ||
                                     msg.senderExternalId == 'Guest';
                if (!isOurMessage) return false;
                
                final mContent = m.content?.trim() ?? '';
                final msgContent = msg.content?.trim() ?? '';
                if (mContent != msgContent) return false;
                
                try {
                  final mTime = DateTime.parse(m.timestamp).toUtc();
                  final msgTime = DateTime.parse(msg.timestamp).toUtc();
                  return msgTime.difference(mTime).abs().inSeconds <= 45;
                } catch (_) {
                  return true;
                }
              }
              return false;
            });

            setState(() {
              if (existingIndex != -1) {
                _messages[existingIndex] = msg;
              } else {
                _messages.add(msg);
              }
            });
            _scrollToBottom();
            _chatService.sendReadReceipt();
          } else if (type == 'user_status') {
            setState(() => _isOnline = data['is_online'] == true);
          }
        } catch (e) {
          debugPrint('[CONVO WS ←] parse error: $e');
        }
      },
      onDone: () => debugPrint('[CONVO WS] closed'),
      onError: (e) => debugPrint('[CONVO WS] error: $e'),
    );
  }

  // ─────────────────────────── Scroll ─────────────────────────────────────
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// Merges locally-sent attachments from cache into fetched/echoed messages
  /// if the server returns them without attachment metadata.
  List<ChatMessage> _mergeAttachments(List<ChatMessage> incoming) {
    if (_sentAttachmentsCache.isEmpty) return incoming;
    
    final result = List<ChatMessage>.from(incoming);
    for (int i = 0; i < result.length; i++) {
      final msg = result[i];
      final hasAttachment = (msg.attachmentUrl?.isNotEmpty == true) ||
          (msg.attachmentData?.isNotEmpty == true);
      if (hasAttachment) continue;
      
      final matchIndex = _sentAttachmentsCache.indexWhere((cached) {
        final isOurMessage = msg.senderRole == 'CUSTOMER' || 
                             msg.senderName == 'You' || 
                             msg.senderName == 'CUSTOMER' ||
                             msg.senderExternalId == 'Guest';
        if (!isOurMessage) return false;
        
        try {
          final cachedTime = DateTime.parse(cached.timestamp).toUtc();
          final msgTime = DateTime.parse(msg.timestamp).toUtc();
          final diff = msgTime.difference(cachedTime).abs();
          
          if (diff.inSeconds <= 45) {
            final cachedContent = cached.content?.trim() ?? '';
            final msgContent = msg.content?.trim() ?? '';
            if (cachedContent.isNotEmpty && msgContent.isNotEmpty) {
              return cachedContent == msgContent;
            }
            return true;
          }
        } catch (_) {}
        return false;
      });
      
      if (matchIndex != -1) {
        final cached = _sentAttachmentsCache[matchIndex];
        result[i] = ChatMessage(
          id: msg.id,
          senderName: msg.senderName,
          senderRole: msg.senderRole,
          senderExternalId: msg.senderExternalId,
          senderUserCode: msg.senderUserCode,
          content: msg.content,
          timestamp: msg.timestamp,
          isRead: msg.isRead,
          readAt: msg.readAt,
          attachmentUrl: cached.attachmentUrl,
          attachmentName: cached.attachmentName,
          attachmentData: cached.attachmentData,
          attachmentType: cached.attachmentType,
        );
      }
    }
    return result;
  }

  // ─────────────────────────── Text send ──────────────────────────────────
  void _sendMessage() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;
    _chatService.sendChatMessage(text);
    _inputController.clear();
  }

  // ─────────────────────────── Attachment pick ────────────────────────────
  Future<void> _pickFile() async {
    debugPrint('╔══════════════════════════════════════════════════════');
    debugPrint('║ [PICK] Opening file picker (type=any, withData=false)');
    debugPrint('╠══════════════════════════════════════════════════════');
    try {
      // withData: false — rely on the cached local path.
      // This avoids silent memory failures when picking large PDFs / Office
      // documents from Google Drive (the plugin caches them to disk regardless).
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        withData: false,
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        debugPrint('║  User cancelled or no file returned');
        debugPrint('╚══════════════════════════════════════════════════════');
        return;
      }

      final picked = result.files.first;
      debugPrint('║  ✅ File selected:');
      debugPrint('║    name      = ${picked.name}');
      debugPrint('║    size      = ${picked.size} bytes');
      debugPrint('║    ext       = ${picked.extension ?? "(none)"}');
      debugPrint('║    path      = ${picked.path ?? "(null — content URI only)"}');
      debugPrint('║    bytes?    = ${picked.bytes != null}');
      debugPrint('╚══════════════════════════════════════════════════════');

      if (picked.path == null && picked.bytes == null) {
        if (mounted) {
          _showSnack(
            'Could not access file — try picking from local storage instead of Google Drive.',
          );
        }
        return;
      }

      if (mounted) setState(() => _pendingFile = picked);
    } catch (e, stack) {
      debugPrint('║  ❌ Error during file pick: $e');
      debugPrint('║     stack: $stack');
      debugPrint('╚══════════════════════════════════════════════════════');
      if (mounted) {
        _showSnack('Could not pick file: $e');
      }
    }
  }

  void _clearPending() => setState(() => _pendingFile = null);

  // ─────────────────────────── Attachment send (WebSocket) ────────────────
  Future<void> _sendAttachment() async {
    final file = _pendingFile;
    if (file == null) return;

    // Guard: WebSocket must be connected
    if (_chatService.channel == null) {
      _showSnack('Not connected. Please wait for reconnection and try again.');
      return;
    }

    setState(() {
      _isSendingAttachment = true;
      _pendingFile = null;
    });

    debugPrint('╔══════════════════════════════════════════════════════');
    debugPrint('║ [ATTACH] _sendAttachment via WebSocket');
    debugPrint('║  file.name = ${file.name}');
    debugPrint('║  file.size = ${file.size} bytes');
    debugPrint('║  has bytes = ${file.bytes != null}');
    debugPrint('║  has path  = ${file.path != null}');
    debugPrint('╠══════════════════════════════════════════════════════');

    try {
      final mime = _mimeFromExt(file.name);
      final caption = _inputController.text.trim();

      final ok = await _chatService.sendChatMessageWithAttachment(
        fileName: file.name,
        mimeType: mime,
        filePath: file.path,
        fileBytes: file.bytes,
        content: caption,
      );

      if (!mounted) return;

      if (ok) {
        _inputController.clear();
        debugPrint('║  ✅ Attachment frame sent via WS');
        debugPrint('╚══════════════════════════════════════════════════════');

        // Optimistic UI — show the attachment immediately in the bubble list
        // without waiting for the server echo.
        final Uint8List? localBytes = file.bytes ??
            (file.path != null ? await File(file.path!).readAsBytes() : null);
        if (mounted && localBytes != null) {
          final optimistic = ChatMessage(
            id: 'local_${DateTime.now().millisecondsSinceEpoch}',
            senderName: 'You',
            senderRole: 'CUSTOMER',
            content: caption.isNotEmpty ? caption : null,
            timestamp: DateTime.now().toIso8601String(),
            isRead: false,
            attachmentName: file.name,
            attachmentData: base64Encode(localBytes),
            attachmentType: mime,
          );
          
          _sentAttachmentsCache.add(optimistic);
          setState(() => _messages.add(optimistic));
          _scrollToBottom();
        }

        // After a delay, refresh history so the server-stored URL replaces
        // the local base64 copy (avoids keeping large base64 in memory).
        await Future.delayed(const Duration(milliseconds: 1200));
        if (!mounted) return;
        final history = await _chatService.getMessageHistory(widget.chat.id);
        if (mounted && history != null) {
          final mergedMessages = _mergeAttachments(history.messages);
          setState(() => _messages = mergedMessages);
          _scrollToBottom();
        }
      } else {
        debugPrint('║  ❌ sendChatMessageWithAttachment returned false (WS disconnected)');
        debugPrint('╚══════════════════════════════════════════════════════');
        if (mounted) _showSnack('Could not send — not connected. Please try again.');
      }
    } catch (e, stack) {
      debugPrint('║  ❌ Unexpected error: $e');
      debugPrint('║     $stack');
      debugPrint('╚══════════════════════════════════════════════════════');
      if (mounted) _showSnack('Could not send attachment. Please try again.');
    } finally {
      if (mounted) setState(() => _isSendingAttachment = false);
    }
  }

  /// Maps a file extension to a MIME type for the WebSocket attachment frame.
  String _mimeFromExt(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    switch (ext) {
      case 'jpg':
      case 'jpeg': return 'image/jpeg';
      case 'png':  return 'image/png';
      case 'gif':  return 'image/gif';
      case 'webp': return 'image/webp';
      case 'pdf':  return 'application/pdf';
      case 'doc':  return 'application/msword';
      case 'docx': return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case 'xls':  return 'application/vnd.ms-excel';
      case 'xlsx': return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      case 'ppt':  return 'application/vnd.ms-powerpoint';
      case 'pptx': return 'application/vnd.openxmlformats-officedocument.presentationml.presentation';
      case 'txt':  return 'text/plain';
      case 'zip':  return 'application/zip';
      case 'mp4':  return 'video/mp4';
      case 'mp3':  return 'audio/mpeg';
      default:     return 'application/octet-stream';
    }
  }


  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ─────────────────────────── Title ──────────────────────────────────────
  String _getChatTitle(Conversation item) {
    if (item.workPermitId > 0 && item.workPermitRef?.isNotEmpty == true) {
      return 'WP#${item.workPermitId} (${item.workPermitRef})';
    } else if (item.workPermitId > 0) {
      return 'WP#${item.workPermitId}';
    } else if (item.workPermitRef?.isNotEmpty == true) {
      return 'WP: ${item.workPermitRef}';
    } else if (item.participantName.isNotEmpty) {
      return item.participantName;
    }
    return 'Conversation';
  }

  String _formatTime(String? timeStr) {
    if (timeStr == null || timeStr.isEmpty) return '';
    try {
      final dt = DateTime.parse(timeStr).toLocal();
      final h = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
      final m = dt.minute.toString().padLeft(2, '0');
      final ampm = dt.hour >= 12 ? 'PM' : 'AM';
      return '$h:$m $ampm';
    } catch (_) {
      return '';
    }
  }

  // ─────────────────────────── Build ──────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgChat,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _TopBar(
              name: _getChatTitle(widget.chat),
              isOnline: _isOnline,
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _messages.isEmpty
                      ? _buildEmpty()
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                          itemCount: _messages.length,
                          itemBuilder: (ctx, i) {
                            final msg = _messages[i];
                            final isOutgoing = msg.senderRole == 'CUSTOMER';
                            return _MessageBubble(
                              message: msg,
                              isOutgoing: isOutgoing,
                              time: _formatTime(msg.timestamp),
                            );
                          },
                        ),
            ),
            _BottomInputArea(
              controller: _inputController,
              pendingFile: _pendingFile,
              isSendingAttachment: _isSendingAttachment,
              onPickFile: _pickFile,
              onClearPending: _clearPending,
              onSendAttachment: _sendAttachment,
              onSendText: _sendMessage,
              onTyping: () => _chatService.sendTypingIndicator(''),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.chat_bubble_outline, size: 52, color: _mutedText.withValues(alpha: 0.4)),
          const SizedBox(height: 12),
          Text(
            'No messages yet.\nSay hello! 👋',
            textAlign: TextAlign.center,
            style: TextStyle(color: _mutedText, fontSize: 15),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Top bar
// ═══════════════════════════════════════════════════════════════════════════
class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.name,
    required this.isOnline,
    required this.onBack,
  });

  final String name;
  final bool isOnline;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: _bgChat,
        border: Border(bottom: BorderSide(color: _outlineColor)),
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back, color: _darkBlue),
          ),
          const SizedBox(width: 4),
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFFE2E8F0),
                child: Text(
                  _initials(name),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF334155),
                  ),
                ),
              ),
              Positioned(
                bottom: -1,
                right: -1,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: isOnline ? _darkBlue : _mutedText,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: _bgChat, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _darkBlue,
                  ),
                ),
                Text(
                  isOnline ? 'Online' : 'Offline',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: _mutedText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _initials(String s) {
    final parts = s.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Message bubble — handles text, image attachment, file attachment
// ═══════════════════════════════════════════════════════════════════════════
class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
    required this.isOutgoing,
    required this.time,
  });

  final ChatMessage message;
  final bool isOutgoing;
  final String time;

  @override
  Widget build(BuildContext context) {
    final hasAttachment = (message.attachmentUrl?.isNotEmpty == true) ||
        (message.attachmentData?.isNotEmpty == true);
    final hasText = message.content?.isNotEmpty == true;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Align(
        alignment: isOutgoing ? Alignment.centerRight : Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          child: Column(
            crossAxisAlignment:
                isOutgoing ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              // Bubble
              Container(
                decoration: BoxDecoration(
                  color: isOutgoing ? _blue : Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft:
                        isOutgoing ? const Radius.circular(16) : const Radius.circular(4),
                    bottomRight:
                        isOutgoing ? const Radius.circular(4) : const Radius.circular(16),
                  ),
                  border: isOutgoing
                      ? null
                      : Border.all(color: const Color(0x4DC3C6D7)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: isOutgoing
                        ? const Radius.circular(16)
                        : const Radius.circular(4),
                    bottomRight: isOutgoing
                        ? const Radius.circular(4)
                        : const Radius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (hasAttachment) _buildAttachment(context),
                      if (hasText)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          child: Text(
                            message.content!,
                            style: TextStyle(
                              fontSize: 15,
                              color: isOutgoing
                                  ? const Color(0xFFEEEFFF)
                                  : _darkText,
                              height: 1.4,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Timestamp + read tick
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 11,
                      color: _mutedText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (isOutgoing) ...[
                    const SizedBox(width: 4),
                    const Icon(Icons.check_circle, size: 14, color: _darkBlue),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _buildFullAttachmentUrl(String path) {
    if (path.isEmpty) return '';
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }
    try {
      final uri = Uri.parse(ApiClient().baseUrl);
      final origin = '${uri.scheme}://${uri.host}${uri.hasPort ? ":${uri.port}" : ""}';
      if (path.startsWith('/media/') || path.startsWith('media/')) {
        final cleanPath = path.startsWith('/') ? path : '/$path';
        return '$origin$cleanPath';
      }
    } catch (_) {}

    final base = ApiClient().baseUrl.endsWith('/')
        ? ApiClient().baseUrl.substring(0, ApiClient().baseUrl.length - 1)
        : ApiClient().baseUrl;
    final cleanPath = path.startsWith('/') ? path : '/$path';
    return '$base$cleanPath';
  }

  void _showAttachmentOptions(BuildContext context, String url, String fileName) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  fileName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _darkText,
                  ),
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.open_in_new_rounded, color: _blue),
                title: const Text('Open File', style: TextStyle(fontWeight: FontWeight.w500)),
                subtitle: const Text('View the file in an external app or browser'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _openUrl(url);
                },
              ),
              ListTile(
                leading: const Icon(Icons.download_rounded, color: Colors.green),
                title: const Text('Download & Share', style: TextStyle(fontWeight: FontWeight.w500)),
                subtitle: const Text('Save or send this file to other apps'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _downloadAndShareFile(context, url, fileName);
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Future<void> _downloadAndShareFile(BuildContext context, String url, String fileName) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Downloading $fileName...'),
          duration: const Duration(seconds: 2),
        ),
      );

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/$fileName');
        await file.writeAsBytes(response.bodyBytes);

        await SharePlus.instance.share(
          ShareParams(
            text: fileName,
            files: [XFile(file.path)],
          ),
        );
      } else {
        throw Exception('Server returned HTTP ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('[DOWNLOAD] Error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not download file: $e')),
        );
      }
    }
  }

  Widget _buildAttachment(BuildContext context) {
    final name = message.attachmentName ?? '';

    // ── 1. Render from base64 attachmentData (locally sent, no URL yet) ──
    final b64 = message.attachmentData;
    if (b64 != null && b64.isNotEmpty) {
      final Uint8List bytes = base64Decode(b64);
      final mime = message.attachmentType ?? '';
      final isImg = mime.startsWith('image/') || _isImage(name);

      if (isImg) {
        return GestureDetector(
          onTap: () {}, // nothing to open yet — no URL
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.memory(
              bytes,
              fit: BoxFit.cover,
              width: double.infinity,
              errorBuilder: (_, e, s) => _localFileTile(name),
            ),
          ),
        );
      }
      return _localFileTile(name);
    }

    // ── 2. Render from server-provided URL ────────────────────────────────
    final rawUrl = message.attachmentUrl!;
    final url = _buildFullAttachmentUrl(rawUrl);
    final displayName = name.isNotEmpty ? name : rawUrl.split('/').last;

    if (_isImage(displayName)) {
      return GestureDetector(
        onTap: () => _showAttachmentOptions(context, url, displayName),
        child: Image.network(
          url,
          fit: BoxFit.cover,
          width: double.infinity,
          loadingBuilder: (ctx, child, progress) => progress == null
              ? child
              : SizedBox(
                  height: 160,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: progress.expectedTotalBytes != null
                          ? progress.cumulativeBytesLoaded /
                              progress.expectedTotalBytes!
                          : null,
                      color: isOutgoing ? Colors.white : _blue,
                    ),
                  ),
                ),
          errorBuilder: (ctx, err, stack) => _fileTile(displayName, url, context),
        ),
      );
    }

    return _fileTile(displayName, url, context);
  }

  /// File tile for locally-sent attachments (no URL yet).
  Widget _localFileTile(String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isOutgoing
                  ? Colors.white.withValues(alpha: 0.2)
                  : _blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _fileIcon(name),
              size: 24,
              color: isOutgoing ? Colors.white : _blue,
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.isNotEmpty ? name : 'Attachment',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isOutgoing ? Colors.white : _darkText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Sent',
                  style: TextStyle(
                    fontSize: 11,
                    color: isOutgoing
                        ? Colors.white.withValues(alpha: 0.7)
                        : _mutedText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _fileTile(String name, String url, BuildContext context) {
    return GestureDetector(
      onTap: () => _showAttachmentOptions(context, url, name),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isOutgoing
                    ? Colors.white.withValues(alpha: 0.2)
                    : _blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _fileIcon(name),
                size: 24,
                color: isOutgoing ? Colors.white : _blue,
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isOutgoing ? Colors.white : _darkText,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Tap to open',
                    style: TextStyle(
                      fontSize: 11,
                      color: isOutgoing
                          ? Colors.white.withValues(alpha: 0.7)
                          : _mutedText,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.open_in_new_rounded,
              size: 16,
              color: isOutgoing ? Colors.white70 : _mutedText,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('[BUBBLE] Could not open url: $e');
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Bottom input area — text field + attachment picker + preview
// ═══════════════════════════════════════════════════════════════════════════
class _BottomInputArea extends StatelessWidget {
  const _BottomInputArea({
    required this.controller,
    required this.pendingFile,
    required this.isSendingAttachment,
    required this.onPickFile,
    required this.onClearPending,
    required this.onSendAttachment,
    required this.onSendText,
    required this.onTyping,
  });

  final TextEditingController controller;
  final PlatformFile? pendingFile;
  final bool isSendingAttachment;
  final VoidCallback onPickFile;
  final VoidCallback onClearPending;
  final VoidCallback onSendAttachment;
  final VoidCallback onSendText;
  final VoidCallback onTyping;

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).viewInsets.bottom +
        MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(12, 8, 12, 8 + bottomPad),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Pending-file preview ─────────────────────────────────────
          if (pendingFile != null)
            _PendingFilePreview(
              file: pendingFile!,
              isSending: isSendingAttachment,
              onClear: onClearPending,
              onSend: onSendAttachment,
            ),

          // ── Input row ────────────────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Attachment button
              _CircleIconBtn(
                icon: Icons.attach_file_rounded,
                color: const Color(0xFF64748B),
                onTap: isSendingAttachment ? null : onPickFile,
              ),
              const SizedBox(width: 8),

              // Text field
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: controller,
                    onChanged: (_) => onTyping(),
                    onSubmitted: (_) => onSendText(),
                    minLines: 1,
                    maxLines: 5,
                    style: const TextStyle(fontSize: 15, color: _darkText),
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 15,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Send button
              _SendBtn(
                onTap: pendingFile != null ? onSendAttachment : onSendText,
                isLoading: isSendingAttachment,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────── Pending file preview ───────────────────────────
class _PendingFilePreview extends StatelessWidget {
  const _PendingFilePreview({
    required this.file,
    required this.isSending,
    required this.onClear,
    required this.onSend,
  });

  final PlatformFile file;
  final bool isSending;
  final VoidCallback onClear;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final isImg = _isImage(file.name);
    final bytes = file.bytes;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Row(
        children: [
          // Preview thumbnail or file icon
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: isImg && bytes != null
                ? Image.memory(
                    bytes,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  )
                : isImg && file.path != null
                    ? Image.file(
                        File(file.path!),
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (_, e, s) => Container(
                          width: 56,
                          height: 56,
                          color: _blue.withValues(alpha: 0.1),
                          child: Icon(_fileIcon(file.name), color: _blue, size: 28),
                        ),
                      )
                    : Container(
                        width: 56,
                        height: 56,
                        color: _blue.withValues(alpha: 0.1),
                        child: Icon(_fileIcon(file.name), color: _blue, size: 28),
                      ),
          ),
          const SizedBox(width: 12),

          // File name + size
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _darkText,
                  ),
                ),
                if (file.size > 0) ...[
                  const SizedBox(height: 2),
                  Text(
                    _formatSize(file.size),
                    style: const TextStyle(fontSize: 11, color: _mutedText),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Send / Clear
          if (isSending)
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            )
          else ...[
            IconButton(
              onPressed: onClear,
              icon: const Icon(Icons.close_rounded, size: 20, color: _mutedText),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onSend,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Send',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  static String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

// ─────────────────────────── Small helpers ──────────────────────────────────
class _CircleIconBtn extends StatelessWidget {
  const _CircleIconBtn({
    required this.icon,
    required this.color,
    this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 22),
      ),
    );
  }
}

class _SendBtn extends StatelessWidget {
  const _SendBtn({required this.onTap, this.isLoading = false});
  final VoidCallback onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: _blue.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: isLoading
            ? const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
              )
            : const Icon(Icons.send_rounded, color: Colors.white, size: 20),
      ),
    );
  }
}

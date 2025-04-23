import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final TextEditingController _emailController = TextEditingController();
  final List<Map<String, dynamic>> _mockChats = [
    {
      'id': '1',
      'name': 'John Doe',
      'lastMessage': 'Hey, how are you?',
      'time': '09:30',
      'unreadCount': 2,
    },
    {
      'id': '2',
      'name': 'Jane Smith',
      'lastMessage': 'See you tomorrow!',
      'time': '08:45',
      'unreadCount': 0,
    },
    {
      'id': '3',
      'name': 'Mike Johnson',
      'lastMessage': 'Thanks for your help',
      'time': 'Yesterday',
      'unreadCount': 1,
    },
  ];

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _signOut(BuildContext context) {
    context.go('/login');
  }

  Future<void> _showNewChatDialog() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Chat'),
        content: TextField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'Enter email address',
            hintText: 'user@example.com',
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final email = _emailController.text.trim();
              if (email.isEmpty) return;
              Navigator.pop(context);
              context.push('/chats/new_user', extra: email);
            },
            child: const Text('Start Chat'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: _mockChats.isEmpty
          ? const _NoMessagesWidget()
          : ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              itemCount: _mockChats.length,
              itemBuilder: (context, index) {
                final chat = _mockChats[index];
                return _ChatListItem(
                  name: chat['name'],
                  lastMessage: chat['lastMessage'],
                  time: chat['time'],
                  unreadCount: chat['unreadCount'],
                  onTap: () =>
                      context.push('/chats/${chat['id']}', extra: chat['name']),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNewChatDialog,
        child: const Icon(Icons.chat),
      ),
    );
  }
}

class _ChatListItem extends StatelessWidget {
  final String name;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final VoidCallback onTap;

  const _ChatListItem({
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        child: Text(name[0]),
      ),
      title: Text(name),
      subtitle: Text(
        lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            time,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12.sp,
            ),
          ),
          if (unreadCount > 0) ...[
            const SizedBox(height: 4),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                unreadCount.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _NoMessagesWidget extends StatelessWidget {
  const _NoMessagesWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64.r,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16.h),
          Text(
            'No chats yet',
            style: TextStyle(
              fontSize: 18.sp,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Start a new conversation!',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}

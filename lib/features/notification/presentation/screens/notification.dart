import 'package:flutter/material.dart';

// Static notification model
class NotificationModel {
  final int id;
  bool viewed;
  final User user;
  final String description;
  final DateTime createdDate;

  NotificationModel({
    required this.id,
    required this.viewed,
    required this.user,
    required this.description,
    required this.createdDate,
  });
}

class User {
  final String firstName;

  User({required this.firstName});
}

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // Static data
  List<NotificationModel> _notifications = [
    NotificationModel(
      id: 1,
      viewed: false,
      user: User(firstName: "John Doe"),
      description: "Your Appointment with Dr. John Doe is scheduled",
      createdDate: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    NotificationModel(
      id: 2,
      viewed: true,
      user: User(firstName: "Jane Smith"),
      description: "Your Medication Alert is due",
      createdDate: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    NotificationModel(
      id: 3,
      viewed: false,
      user: User(firstName: "Mike Johnson"),
      description: "Your Appointment with Dr. Mike Johnson is scheduled",
      createdDate: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inHours < 1) {
      return 'Just now';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }

  Widget _buildNotificationItem(NotificationModel notification) {
    return GestureDetector(
      onTap: () {
        if (!notification.viewed) {
          setState(() {
            notification.viewed = true;
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: notification.viewed
              ? Colors.transparent
              : Colors.blue.withOpacity(0.1),
          border: Border.all(width: .5, color: Colors.grey.shade300),
        ),
        padding: const EdgeInsets.all(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: notification.viewed
                              ? Border.all(
                                  color: Theme.of(context).primaryColor,
                                  width: 1)
                              : null,
                          shape: BoxShape.circle,
                          color: notification.viewed
                              ? Colors.transparent
                              : Theme.of(context).primaryColor,
                        ),
                        width: 8,
                        height: 8,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        notification.user.firstName,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          notification.description,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Text(
                _getTimeAgo(notification.createdDate),
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Notifications',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              for (var notification in _notifications) {
                                notification.viewed = true;
                              }
                            });
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.done_all,
                                size: 14,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(width: 5),
                              const Text(
                                'Mark all as read',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: TabBar(
                        indicatorWeight: 5,
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,
                        labelColor: Theme.of(context).colorScheme.primary,
                        unselectedLabelColor: Colors.black,
                        tabs: const [
                          Tab(text: "Unread"),
                          Tab(text: "All"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    // Unread notifications tab
                    _notifications.where((n) => !n.viewed).isEmpty
                        ? const Center(
                            child: Icon(
                              Icons.notifications_off_outlined,
                              size: 48,
                              color: Colors.grey,
                            ),
                          )
                        : ListView.builder(
                            itemCount:
                                _notifications.where((n) => !n.viewed).length,
                            itemBuilder: (context, index) =>
                                _buildNotificationItem(
                              _notifications
                                  .where((n) => !n.viewed)
                                  .toList()[index],
                            ),
                          ),

                    // All notifications tab
                    _notifications.isEmpty
                        ? const Center(
                            child: Icon(
                              Icons.notifications_off_outlined,
                              size: 48,
                              color: Colors.grey,
                            ),
                          )
                        : ListView.builder(
                            itemCount: _notifications.length,
                            itemBuilder: (context, index) =>
                                _buildNotificationItem(_notifications[index]),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

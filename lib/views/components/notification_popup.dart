import 'package:flutter/material.dart';

void showNotificationPopup(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Row(
        children: [
          Icon(Icons.notifications, color: Colors.white),
          SizedBox(width: 10),
          Text('Notifications enabled'),
        ],
      ),
      duration: Duration(seconds: 2),
    ),
  );
}
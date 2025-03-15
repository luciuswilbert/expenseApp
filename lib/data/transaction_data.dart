import 'package:flutter/material.dart';

/// Transaction Data File (Can be replaced with Database in the future)
final List<Map<String, dynamic>> transactions = [
  {
    'icon': Icons.shopping_cart,           // Icon to display
    'iconColor': Color(0xffFCAC12),           // Color of the icon
    'category': 'Groceries',              // Transaction category
    'description': 'Buy some grocery items from the supermarket', // Details
    'amount': '- RM 120',                 // Transaction amount
    'dateTime': '28 Feb @ 10:00 AM',      // Date and time
    'color': Color(0xFFFCEED4),          // Background color of the card
  },{
    'icon': Icons.subscriptions,
    'iconColor': Color(0xff8B4513),
    'category': 'Subscription',
    'description': 'Disney+ Annual subscription renewal',
    'amount': '- RM 80',
    'dateTime': '28 Feb @ 03:30 PM',
    'color': Color(0xFFEADDCB), // Light beige
  },
  {
    'icon': Icons.fastfood,
    'iconColor': Color(0xff556B2F),
    'category': 'Food',
    'description': 'Buy a ramen from the local restaurant',
    'amount': '- RM 32',
    'dateTime': '28 Feb @ 07:30 PM',
    'color': Color(0xFFE1DEBC), // Light green
  },
  {
    'icon': Icons.shopping_bag,
    'iconColor': Color(0xffFF2D55),
    'category': 'Shopping',
    'description': 'Buy a pair of shoes from the mall',
    'amount': '- RM 32',
    'dateTime': '28 Feb @ 07:30 PM',
    'color': Color(0xFFFFD8D1), // Light pink
  },
  {
    'icon': Icons.category_outlined,           // Icon to display
    'iconColor': Color(0xff8B4513),           // Color of the icon
    'category': 'Miscellaneous',              // Transaction category
    'description': 'Pay Barbershop', // Details
    'amount': '- RM 120',                 // Transaction amount
    'dateTime': '28 Feb @ 10:00 AM',      // Date and time
    'color': Color(0xFFFAFAD2),          // Background color of the card
  },{
    'icon': Icons.health_and_safety_outlined,
    'iconColor': Color(0xffFF1493),
    'category': 'Healthcare',
    'description': 'Buy Vitamin',
    'amount': '- RM 80',
    'dateTime': '28 Feb @ 03:30 PM',
    'color': Color(0xFFFFE1F0), // Light beige
  },
  {
    'icon': Icons.emoji_transportation,
    'iconColor': Color(0xff556B2F),
    'category': 'Food',
    'description': 'Buy a ramen from the local restaurant',
    'amount': '- RM 32',
    'dateTime': '28 Feb @ 07:30 PM',
    'color': Color(0xFFE1DEBC), // Light green
  },
  {
    'icon': Icons.shopping_bag,
    'iconColor': Color(0xffFF2D55),
    'category': 'Shopping',
    'description': 'Buy a pair of shoes from the mall',
    'amount': '- RM 32',
    'dateTime': '28 Feb @ 07:30 PM',
    'color': Color(0xFFFFD8D1), // Light pink
  },{
    'icon': Icons.shopping_cart,           // Icon to display
    'iconColor': Color(0xffFCAC12),           // Color of the icon
    'category': 'Groceries',              // Transaction category
    'description': 'Buy some grocery items from the supermarket', // Details
    'amount': '- RM 120',                 // Transaction amount
    'dateTime': '28 Feb @ 10:00 AM',      // Date and time
    'color': Color(0xFFFCEED4),          // Background color of the card
  },{
    'icon': Icons.subscriptions,
    'iconColor': Color(0xff8B4513),
    'category': 'Subscription',
    'description': 'Disney+ Annual subscription renewal',
    'amount': '- RM 80',
    'dateTime': '28 Feb @ 03:30 PM',
    'color': Color(0xFFEADDCB), // Light beige
  },
  {
    'icon': Icons.fastfood,
    'iconColor': Color(0xff556B2F),
    'category': 'Food',
    'description': 'Buy a ramen from the local restaurant',
    'amount': '- RM 32',
    'dateTime': '28 Feb @ 07:30 PM',
    'color': Color(0xFFE1DEBC), // Light green
  },
  {
    'icon': Icons.shopping_bag,
    'iconColor': Color(0xffFF2D55),
    'category': 'Shopping',
    'description': 'Buy a pair of shoes from the mall',
    'amount': '- RM 32',
    'dateTime': '28 Feb @ 07:30 PM',
    'color': Color(0xFFFFD8D1), // Light pink
  },{
    'icon': Icons.shopping_cart,           // Icon to display
    'iconColor': Color(0xffFCAC12),           // Color of the icon
    'category': 'Groceries',              // Transaction category
    'description': 'Buy some grocery items from the supermarket', // Details
    'amount': '- RM 120',                 // Transaction amount
    'dateTime': '28 Feb @ 10:00 AM',      // Date and time
    'color': Color(0xFFFCEED4),          // Background color of the card
  },{
    'icon': Icons.subscriptions,
    'iconColor': Color(0xff8B4513),
    'category': 'Subscription',
    'description': 'Disney+ Annual subscription renewal',
    'amount': '- RM 80',
    'dateTime': '28 Feb @ 03:30 PM',
    'color': Color(0xFFEADDCB), // Light beige
  },
  {
    'icon': Icons.fastfood,
    'iconColor': Color(0xff556B2F),
    'category': 'Food',
    'description': 'Buy a ramen from the local restaurant',
    'amount': '- RM 32',
    'dateTime': '28 Feb @ 07:30 PM',
    'color': Color(0xFFE1DEBC), // Light green
  },
  {
    'icon': Icons.shopping_bag,
    'iconColor': Color(0xffFF2D55),
    'category': 'Shopping',
    'description': 'Buy a pair of shoes from the mall',
    'amount': '- RM 32',
    'dateTime': '28 Feb @ 07:30 PM',
    'color': Color(0xFFFFD8D1), // Light pink
  },{
    'icon': Icons.shopping_cart,           // Icon to display
    'iconColor': Color(0xffFCAC12),           // Color of the icon
    'category': 'Groceries',              // Transaction category
    'description': 'Buy some grocery items from the supermarket', // Details
    'amount': '- RM 120',                 // Transaction amount
    'dateTime': '28 Feb @ 10:00 AM',      // Date and time
    'color': Color(0xFFFCEED4),          // Background color of the card
  },{
    'icon': Icons.subscriptions,
    'iconColor': Color(0xff8B4513),
    'category': 'Subscription',
    'description': 'Disney+ Annual subscription renewal',
    'amount': '- RM 80',
    'dateTime': '28 Feb @ 03:30 PM',
    'color': Color(0xFFEADDCB), // Light beige
  },
  {
    'icon': Icons.fastfood,
    'iconColor': Color(0xff556B2F),
    'category': 'Food',
    'description': 'Buy a ramen from the local restaurant',
    'amount': '- RM 32',
    'dateTime': '28 Feb @ 07:30 PM',
    'color': Color(0xFFE1DEBC), // Light green
  },
  {
    'icon': Icons.shopping_bag,
    'iconColor': Color(0xffFF2D55),
    'category': 'Shopping',
    'description': 'Buy a pair of shoes from the mall',
    'amount': '- RM 32',
    'dateTime': '28 Feb @ 07:30 PM',
    'color': Color(0xFFFFD8D1), // Light pink
  },{
    'icon': Icons.shopping_cart,           // Icon to display
    'iconColor': Color(0xffFCAC12),           // Color of the icon
    'category': 'Groceries',              // Transaction category
    'description': 'Buy some grocery items from the supermarket', // Details
    'amount': '- RM 120',                 // Transaction amount
    'dateTime': '28 Feb @ 10:00 AM',      // Date and time
    'color': Color(0xFFFCEED4),          // Background color of the card
  },{
    'icon': Icons.subscriptions,
    'iconColor': Color(0xff8B4513),
    'category': 'Subscription',
    'description': 'Disney+ Annual subscription renewal',
    'amount': '- RM 80',
    'dateTime': '28 Feb @ 03:30 PM',
    'color': Color(0xFFEADDCB), // Light beige
  },
  {
    'icon': Icons.fastfood,
    'iconColor': Color(0xff556B2F),
    'category': 'Food',
    'description': 'Buy a ramen from the local restaurant',
    'amount': '- RM 32',
    'dateTime': '28 Feb @ 07:30 PM',
    'color': Color(0xFFE1DEBC), // Light green
  },
  {
    'icon': Icons.shopping_bag,
    'iconColor': Color(0xffFF2D55),
    'category': 'Shopping',
    'description': 'Buy a pair of shoes from the mall',
    'amount': '- RM 32',
    'dateTime': '28 Feb @ 07:30 PM',
    'color': Color(0xFFFFD8D1), // Light pink
  },
];
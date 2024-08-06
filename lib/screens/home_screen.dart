import 'package:flutter/material.dart';
import 'gold_list_screen.dart';
import '../widgets/ad_banner.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gold Rate Manager'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Text(
                'Welcome to Gold Rate Manager',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GoldListScreen()),
              );
            },
            child: Text('View Gold Rates'),
          ),
          AdBanner(), // Placeholder for an advertisement
        ],
      ),
    );
  }
}

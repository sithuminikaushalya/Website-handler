import 'package:flutter/material.dart';
import 'add_edit_gold_screen.dart';
import '../services/api_service.dart';
import '../models/gold_rate.dart';
import '../widgets/gold_rate_tile.dart';

class GoldListScreen extends StatefulWidget {
  @override
  _GoldListScreenState createState() => _GoldListScreenState();
}

class _GoldListScreenState extends State<GoldListScreen> {
  late Future<List<GoldRate>> _goldRates;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _goldRates = _apiService.fetchGoldRates();
  }

  void _refresh() {
    setState(() {
      _goldRates = _apiService.fetchGoldRates();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gold Rates'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEditGoldScreen(),
                ),
              ).then((_) => _refresh());
            },
          ),
        ],
      ),
      body: FutureBuilder<List<GoldRate>>(
        future: _goldRates,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No gold rates available.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final goldRate = snapshot.data![index];
                return GoldRateTile(
                  goldRate: goldRate,
                  onEdit: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AddEditGoldScreen(goldRate: goldRate),
                      ),
                    );
                    _refresh();
                  },
                  onDelete: () async {
                    await _apiService.deleteGoldRate(goldRate.id);
                    _refresh();
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'api.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WP Table Editor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        hintColor: Colors.orange,
        textTheme: TextTheme(
          headline6: TextStyle(
              color: Colors.blueGrey[800], fontWeight: FontWeight.bold),
          bodyText2: TextStyle(color: Colors.blueGrey[700]),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.blue,
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: DataTableScreen(),
    );
  }
}

class DataTableScreen extends StatefulWidget {
  const DataTableScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DataTableScreenState createState() => _DataTableScreenState();
}

class _DataTableScreenState extends State<DataTableScreen> {
  List<Map<String, dynamic>> _details = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final details = await fetchDetails();
      setState(() {
        _details = details;
      });
    } catch (e) {
      _showMessage('Failed to load details: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showEditDialog(Map<String, dynamic>? detail) {
    final nameController = TextEditingController(text: detail?['name'] ?? '');
    final valueController = TextEditingController(text: detail?['value'] ?? '');
    final typeController = TextEditingController(text: detail?['type'] ?? '');
    final categoryController =
        TextEditingController(text: detail?['category'] ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(detail == null ? 'Add New Entry' : 'Edit Entry'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: typeController,
              decoration: const InputDecoration(labelText: 'Type'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: valueController,
              decoration: const InputDecoration(labelText: 'Value'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final detailData = {
                'type': typeController.text,
                'category': categoryController.text,
                'name': nameController.text,
                'value': valueController.text,
              };

              try {
                if (detail == null) {
                  await addDetail(detailData);
                  _showMessage('Data added successfully');
                } else {
                  // Ensure the ID is an integer
                  final id = int.tryParse(detail['id'].toString()) ?? 0;
                  await updateDetail(id, detailData);
                  _showMessage('Data updated successfully');
                }
                // ignore: use_build_context_synchronously
                Navigator.of(ctx).pop();
                _loadDetails();
              } catch (e) {
                _showMessage('Failed to save data: $e');
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteDetail(int id) async {
    try {
      await deleteDetail(id);
      _showMessage('Data deleted successfully');
      _loadDetails();
    } catch (e) {
      _showMessage('Failed to delete data: $e');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WP Table Editor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showEditDialog(null),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _details.length,
              itemBuilder: (ctx, index) {
                final detail = _details[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  elevation: 4,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      detail['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Type: ${detail['type']}, Category: ${detail['category']}, Value: ${detail['value']}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showEditDialog(detail),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteDetail(
                              int.tryParse(detail['id'].toString()) ?? 0),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

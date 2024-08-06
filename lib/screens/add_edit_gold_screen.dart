import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/gold_rate.dart';

class AddEditGoldScreen extends StatefulWidget {
  final GoldRate? goldRate;

  AddEditGoldScreen({this.goldRate});

  @override
  _AddEditGoldScreenState createState() => _AddEditGoldScreenState();
}

class _AddEditGoldScreenState extends State<AddEditGoldScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _itemSize;
  late String _price;
  String? _imagePath;

  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    if (widget.goldRate != null) {
      _itemSize = widget.goldRate!.itemSize;
      _price = widget.goldRate!.price;
      _imagePath = widget.goldRate!.imagePath;
    } else {
      _itemSize = '';
      _price = '';
    }
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      if (widget.goldRate != null) {
        await _apiService.updateGoldRate(
          GoldRate(
            id: widget.goldRate!.id,
            itemSize: _itemSize,
            price: _price,
            imagePath: _imagePath ?? '',
          ),
        );
      } else {
        await _apiService.addGoldRate(
          GoldRate(
            id: 0, // id will be auto-generated
            itemSize: _itemSize,
            price: _price,
            imagePath: _imagePath ?? '',
          ),
        );
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.goldRate == null ? 'Add Gold Rate' : 'Edit Gold Rate'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _itemSize,
                decoration: const InputDecoration(labelText: 'Item Size'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter item size' : null,
                onChanged: (value) => _itemSize = value,
              ),
              TextFormField(
                initialValue: _price,
                decoration: const InputDecoration(labelText: 'Price'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter price' : null,
                onChanged: (value) => _price = value,
              ),
              TextFormField(
                initialValue: _imagePath,
                decoration:
                    const InputDecoration(labelText: 'Image Path (Optional)'),
                onChanged: (value) => _imagePath = value,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _save,
                child: Text(widget.goldRate == null ? 'Add' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:user_inputs_and_forms/data/categories.dart';
// import 'package:user_inputs_and_forms/data/dummy_items.dart';
import 'package:user_inputs_and_forms/models/grocery_item.dart';
import 'package:user_inputs_and_forms/widgets/new_item.dart';
import 'package:http/http.dart' as http;

class GroceryItemList extends StatefulWidget {
  const GroceryItemList({super.key});

  @override
  State<GroceryItemList> createState() => _GroceryItemListState();
}

class _GroceryItemListState extends State<GroceryItemList> {
  List<GroceryItems> _groceryItems = [];

  //variable for circular loading
  var _isLoading = true;

  //variable for showing error
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https(
        'udemy-trail-default-rtdb.asia-southeast1.firebasedatabase.app',
        'shopping-list.json');
    final response = await http.get(url);

    //error handling
    if (response.statusCode >= 400) {
      setState(() {
        _error = 'Failed to load... Please try again';
      });
    }
    // print(response.body);
    final Map<String, dynamic> listData = json.decode(response.body);
    final List<GroceryItems> loadedItems = [];
    for (final item in listData.entries) {
      final category = categories.entries
          .firstWhere(
              (catItem) => catItem.value.title == item.value['category'])
          .value;
      loadedItems.add(
        GroceryItems(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category,
        ),
      );
    }
    setState(() {
      _groceryItems = loadedItems;
      _isLoading = false;
    });
  }

  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItems>(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );

    if (newItem == null) {
      return;
    }
    setState(() {
      _groceryItems.add(newItem);
    });
  }

  void _removeItems(GroceryItems item) {
    setState(() {
      _groceryItems.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text('No items to show'),
    );

    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (ctx, index) => Dismissible(
          onDismissed: (direction) {
            _removeItems(_groceryItems[index]);
          },
          key: ValueKey(_groceryItems[index].id),
          child: ListTile(
            title: Text(_groceryItems[index].name),
            leading: Container(
              height: 24,
              width: 24,
              color: _groceryItems[index].category.color,
            ),
            trailing: Text(
              _groceryItems[index].quantity.toString(),
            ),
          ),
        ),
      );
    }

    //error message
    if (_error != null) {
      content = Center(
        child: Text(_error!),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Groceries'),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: content,
    );
  }
}

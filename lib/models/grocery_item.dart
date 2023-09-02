import 'package:user_inputs_and_forms/models/category.dart';

class GroceryItems {
  const GroceryItems({
    required this.id,
    required this.name,
    required this.quantity,
    required this.category,
  });
  final String id;
  final String name;
  final int quantity;
  final Category category;
}

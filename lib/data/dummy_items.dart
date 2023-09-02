// import 'package:flutter/material.dart';
import 'package:user_inputs_and_forms/models/category.dart';
import 'package:user_inputs_and_forms/models/grocery_item.dart';
import 'categories.dart';

final groceryItems = [
  GroceryItems(
    id: 'a',
    name: 'Milk',
    quantity: 1,
    category: categories[Categories.dairy]!,
  ),
  GroceryItems(
    id: 'b',
    name: 'Bananas',
    quantity: 5,
    category: categories[Categories.fruit]!,
  ),
  GroceryItems(
    id: 'c',
    name: 'Mutton',
    quantity: 1,
    category: categories[Categories.meat]!,
  ),
];

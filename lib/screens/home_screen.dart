import 'package:flutter/material.dart';
import '../data/food_data.dart';
import '../simple_ar_kit/models/ar_item.dart';
import '../simple_ar_kit/screens/item_details_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AR Food Menu"),
      ),
      body: ListView.builder(
        itemCount: foodItems.length,
        itemBuilder: (context, index) {
          final foodItem = foodItems[index];
          // Convert FoodItem to ARItem adaptor
          final arItem = ARItem(
            id: foodItem.name, // Using name as ID for demo
            name: foodItem.name,
            description: foodItem.description,
            modelUrl: foodItem.modelUrl,
            metadata: {
              "Calories": foodItem.calories,
              "Ingredients": foodItem.ingredients,
            },
          );
          
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              contentPadding: const EdgeInsets.all(10),
              leading: const Icon(Icons.fastfood, size: 40),
              title: Text(arItem.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(arItem.description),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ItemDetailsScreen(item: arItem),
                  ),
                );
              },
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
          );
        },
      ),
    );
  }
}


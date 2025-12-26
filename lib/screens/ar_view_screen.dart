import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../widgets/ar_food_viewer.dart';

class ARViewScreen extends StatelessWidget {
  final FoodItem item;

  const ARViewScreen({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${item.name} in AR"),
      ),
      body: Stack(
        children: [
          ARFoodViewer(modelUrl: item.modelUrl),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Card(
              color: Colors.white.withOpacity(0.9),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text("Calories: ${item.calories}"),
                    Text("Ingredients: ${item.ingredients}"),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

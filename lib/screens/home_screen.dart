import 'package:flutter/material.dart';
import '../data/food_data.dart';
import '../models/food_item.dart';
import '../simple_ar_kit/models/ar_item.dart';
import '../simple_ar_kit/screens/item_details_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFB71C1C), // deep wine red
              Color(0xFFD32F2F), // classic red
              // Color(0xFFFFEBEE), // light contrast
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Text(
                "AR Food Menu",
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Expanded(child: Gridview()),
            ],
          ),
        ),
      ),
    );
  }
}

class Listview extends StatelessWidget {
  const Listview({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: foodItems.length,
      itemBuilder: (context, index) {
        final foodItem = foodItems[index];
        final arItem = ARItem(
          id: foodItem.name,
          name: foodItem.name,
          description: foodItem.description,
          modelUrl: foodItem.modelUrl,
          metadata: {"Calories": foodItem.calories, "Ingredients": foodItem.ingredients},
        );

        return Card(
          margin: const EdgeInsets.all(10),
          child: ListTile(
            contentPadding: const EdgeInsets.all(10),
            leading: const Icon(Icons.fastfood, size: 40),
            title: Text(arItem.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(arItem.description),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ItemDetailsScreen(item: arItem)));
            },
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
        );
      },
    );
  }
}

class Gridview extends StatelessWidget {
  const Gridview({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 items per row
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85, // adjust based on FoodCard height
      ),
      itemCount: foodItems.length,
      itemBuilder: (context, index) {
        final foodItem = foodItems[index];
        return FoodCard(foodItem: foodItem);
      },
    );
  }
}

class FoodCard extends StatelessWidget {
  const FoodCard({super.key, required this.foodItem});

  final FoodItem foodItem;

  @override
  Widget build(BuildContext context) {
    final arItem = ARItem(
      id: foodItem.name,
      name: foodItem.name,
      description: foodItem.description,
      modelUrl: foodItem.modelUrl,
      price: foodItem.price,
      rating: foodItem.rating,
      metadata: {"Calories": foodItem.calories, "Ingredients": foodItem.ingredients},
    );

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => ItemDetailsScreen(item: arItem)));
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// IMAGE (takes flexible height)
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  color: Colors.grey.shade300,
                ),
                child: const Center(child: Icon(Icons.image, size: 48, color: Colors.grey)),
              ),
            ),

            /// CONTENT
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(arItem.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyMedium),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${arItem.price.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Color(0xFFB71C1C), fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star, size: 14, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(arItem.rating.toString(), style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../widgets/model_viewer_widget.dart';
import 'ar_view_screen.dart';

class ModelPreviewScreen extends StatelessWidget {
  final FoodItem item;

  const ModelPreviewScreen({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: ModelViewerWidget(modelUrl: item.modelUrl, name: item.name),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    item.name,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text("Calories: ${item.calories}"),
                  Text("Ingredients: ${item.ingredients}"),
                  const SizedBox(height: 8),
                  Text(item.description),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                         Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ARViewScreen(item: item),
                          ),
                        );
                      },
                      icon: const Icon(Icons.view_in_ar),
                      label: const Text("View in AR"),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

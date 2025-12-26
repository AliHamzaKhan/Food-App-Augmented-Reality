import 'package:flutter/material.dart';
import '../models/ar_item.dart';
import '../widgets/preview_component.dart';
import 'ar_immersive_screen.dart';

class ItemDetailsScreen extends StatelessWidget {
  final ARItem item;

  const ItemDetailsScreen({Key? key, required this.item}) : super(key: key);

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
            child: PreviewComponent(modelUrl: item.modelUrl, altText: item.name),
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
                  if (item.metadata.isNotEmpty)
                      ...item.metadata.entries.map((e) => Text("${e.key}: ${e.value}")).toList(),
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
                            builder: (context) => ARImmersiveScreen(item: item),
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

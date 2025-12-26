import 'package:flutter/material.dart';
import '../models/ar_item.dart';
import '../widgets/ar_component.dart';

class ARImmersiveScreen extends StatelessWidget {
  final ARItem item;

  const ARImmersiveScreen({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
      ),
      body: Stack(
        children: [
          ARComponent(modelUrl: item.modelUrl),
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
                    const SizedBox(height: 8),
                    if (item.metadata.isNotEmpty)
                      ...item.metadata.entries.map((e) => Text("${e.key}: ${e.value}")).toList()
                     else
                      Text(item.description),
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

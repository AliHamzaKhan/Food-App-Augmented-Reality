import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class ModelViewerWidget extends StatelessWidget {
  final String modelUrl;
  final String name;

  const ModelViewerWidget({
    Key? key,
    required this.modelUrl,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ModelViewer(
      src: modelUrl,
      alt: "A 3D model of $name",
      ar: false, // We use a separate plugin for AR as requested
      autoRotate: true,
      cameraControls: true, // Enables rotate, zoom, pan
      backgroundColor: Colors.transparent,
      loading: Loading.eager,
    );
  }
}

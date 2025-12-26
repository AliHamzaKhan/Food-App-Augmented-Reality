import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:path_provider/path_provider.dart';

class PreviewComponent extends StatelessWidget {
  final String modelUrl;
  final String altText;

  const PreviewComponent({
    Key? key,
    required this.modelUrl,
    required this.altText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: loadModelFromAssets(modelUrl),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        // return ModelViewer(
        //   backgroundColor: Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
        //   src: 'https://modelviewer.dev/shared-assets/models/Astronaut.glb',
        //   alt: 'A 3D model of an astronaut',
        //   ar: true,
        //   autoRotate: true,
        //   iosSrc: 'https://modelviewer.dev/shared-assets/models/Astronaut.usdz',
        //   disableZoom: true,
        // );
        return ModelViewer(
          src: modelUrl, // local file path
          alt: altText,
          autoRotate: true,
          cameraControls: true,
          ar: true,
          backgroundColor: Colors.transparent,
          loading: Loading.eager,

        );
      },
    );
  }
}

Future<String> loadModelFromAssets(String assetPath) async {
  final byteData = await rootBundle.load(assetPath);

  final tempDir = await getTemporaryDirectory();
  final file = File('${tempDir.path}/${assetPath.split('/').last}');
  await file.writeAsBytes(byteData.buffer.asUint8List());

  return file.path;
}


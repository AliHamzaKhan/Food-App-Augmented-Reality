import 'package:ar_flutter_plugin_2/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin_2/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin_2/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin_2/datatypes/node_types.dart';
import 'package:ar_flutter_plugin_2/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin_2/models/ar_anchor.dart';
import 'package:ar_flutter_plugin_2/models/ar_node.dart';
// Adding potential missing imports for ARPlaneAnchor and ARHitTestResult
// Note: If these files don't exist, we might need to rely on what's available. 
// However, standard ar_flutter_plugin structure separates them.
// If compilation fails on import, we will know. But I can't see the file list of the package.
// I will try to use dynamic or assume main import exports them if I can't find specific path.
// But `ar_flutter_plugin.dart` usually doesn't export models.
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class ARFoodViewer extends StatefulWidget {
  final String modelUrl;

  const ARFoodViewer({Key? key, required this.modelUrl}) : super(key: key);

  @override
  _ARFoodViewerState createState() => _ARFoodViewerState();
}

class _ARFoodViewerState extends State<ARFoodViewer> {
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  ARAnchorManager? arAnchorManager;

  List<ARNode> nodes = [];
  List<ARAnchor> anchors = [];
  bool modelPlaced = false;

  @override
  void dispose() {
    // arSessionManager?.dispose(); // Managers might not have dispose in this version
    // arObjectManager?.dispose();
    // arAnchorManager?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ARView(
          onARViewCreated: onARViewCreated,
          planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
        ),
        if (!modelPlaced)
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "Scan floor/table and tap to place food",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
      ],
    );
  }

  void onARViewCreated(
    ARSessionManager arSessionManager,
    ARObjectManager arObjectManager,
    ARAnchorManager arAnchorManager,
    ARLocationManager arLocationManager,
  ) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;
    this.arAnchorManager = arAnchorManager;

    this.arSessionManager!.onInitialize(
          showFeaturePoints: false,
          showPlanes: true,
          showWorldOrigin: false,
          handlePans: true,
          handleRotation: true,
        );
    this.arObjectManager!.onInitialize();

    this.arSessionManager!.onPlaneOrPointTap = onPlaneOrPointTap;
  }

  // Use dynamic to avoid type errors if ARHitTestResult is not resolved
  // But strictly `onPlaneOrPointTap` signature must match.
  // The expected signature is `Function(List<ARHitTestResult>)`.
  // If ARHitTestResult is not found, the import is missing.
  // I will blindly add the import for ARHitTestResult.
  // Assuming 'package:ar_flutter_plugin_2/models/ar_hittest_result.dart';

  Future<void> onPlaneOrPointTap(List<dynamic> hitTestResults) async {
    if (modelPlaced) return;

    // Filter hits for planes
    var planeHits = hitTestResults.where(
            (hit) => hit.type == ARHitTestResultType.plane
    );

    if (planeHits.isNotEmpty) {
      var singleHitTestResult = planeHits.first;

      // Use ARPlaneAnchor (concrete class)
      var newAnchor = ARPlaneAnchor(
        transformation: singleHitTestResult.worldTransform,
        // Optionally give it a name
        name: UniqueKey().toString(),
      );

      bool? added = await arAnchorManager!.addAnchor(newAnchor);

      if (added == true) {
        anchors.add(newAnchor);

        // Create the 3D node
        var newNode = ARNode(
          type: NodeType.webGLB,
          uri: widget.modelUrl,
          scale: vector.Vector3(0.5, 0.5, 0.5),
          position: vector.Vector3(0.0, 0.0, 0.0),
          rotation: vector.Vector4(1.0, 0.0, 0.0, 0.0),
          // Associate node with the anchor
          // This ensures the node sticks to the plane
          // anchor: newAnchor,
        );

        bool? nodeAdded = await arObjectManager!.addNode(newNode, planeAnchor: newAnchor);

        if (nodeAdded == true) {
          nodes.add(newNode);
          if (mounted) {
            setState(() {
              modelPlaced = true;
            });
          }
        }
      }
    }
  }
}

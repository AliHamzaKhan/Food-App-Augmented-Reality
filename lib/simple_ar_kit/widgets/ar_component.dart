import 'dart:math' as math;

import 'package:ar_flutter_plugin_2/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin_2/datatypes/anchor_types.dart';
import 'package:ar_flutter_plugin_2/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin_2/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin_2/datatypes/node_types.dart';
import 'package:ar_flutter_plugin_2/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin_2/models/ar_anchor.dart';
import 'package:ar_flutter_plugin_2/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin_2/models/ar_node.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class ARComponent extends StatefulWidget {
  final String modelUrl;

  const ARComponent({Key? key, required this.modelUrl}) : super(key: key);

  @override
  _ARComponentState createState() => _ARComponentState();
}

class _ARComponentState extends State<ARComponent> {
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  ARAnchorManager? arAnchorManager;
  ARNode? _currentARNode;

  List<ARNode> nodes = [];
  List<ARAnchor> anchors = [];
  bool modelPlaced = false;

  double _modelScale = 0.2;
  double _rotationY = 0.0;
  double _lastScale = 0.2;

  @override
  void dispose() {
    // Remove all nodes & anchors
    removeAllNodes();
    arSessionManager?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          // onScaleStart: _handleScaleStart,
          // onScaleUpdate: _handleScaleUpdate,
          child: ARView(
              onARViewCreated: onARViewCreated,
              planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical
          ),
        ),
        if (!modelPlaced)
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(8)),
                child: const Text("Scan floor/table and tap to place item", style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
      ],
    );
  }

  void onARViewCreated(ARSessionManager arSessionManager, ARObjectManager arObjectManager, ARAnchorManager arAnchorManager, ARLocationManager arLocationManager) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;
    this.arAnchorManager = arAnchorManager;

    this.arSessionManager!.onInitialize(showFeaturePoints: false, showPlanes: true, showWorldOrigin: false, handlePans: true, handleRotation: true, handleTaps: true);
    this.arObjectManager!.onInitialize();

    this.arSessionManager!.onPlaneOrPointTap = onPlaneOrPointTap;
  }

  Future<void> onPlaneOrPointTap(List<ARHitTestResult> hitTestResults) async {
    if (modelPlaced) return;

    // Filter for plane hits
    var planeHits = hitTestResults.where(
      (hit) => hit.type == ARHitTestResultType.plane,
      // || hit.type == ARHitTestResultType.point,
    );

    if (planeHits.isNotEmpty) {
      var singleHitTestResult = planeHits.first;

      // Use concrete ARPlaneAnchor instead of abstract ARAnchor
      var newAnchor = ARPlaneAnchor(
        transformation: singleHitTestResult.worldTransform,
        name: UniqueKey().toString(), // optional
      );

      bool? added = await arAnchorManager!.addAnchor(newAnchor);
      if (added == true) {
        anchors.add(newAnchor);

        var newNode = ARNode(
          type: NodeType.localGLTF2,
          uri: widget.modelUrl,
          scale: vector.Vector3(0.5, 0.5, 0.5),
          position: vector.Vector3(0.0, 0.0, 0.0),
          rotation: vector.Vector4(1.0, 0.0, 0.0, 0.0),
        );

        bool? nodeAdded = await arObjectManager!.addNode(newNode, planeAnchor: newAnchor);

        if (nodeAdded == true) {
          _currentARNode = newNode;
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

  Future<void> _updateARObjectTransform() async {
    if (_currentARNode == null) return;

    try {
      // Save current node info
      final oldNode = _currentARNode!;

      // Remove old node
      await arObjectManager!.removeNode(oldNode);

      // Recreate node with updated transform
      final halfAngle = _rotationY / 2;
      final sinHalf = math.sin(halfAngle);
      final cosHalf = math.cos(halfAngle);

      final newNode = ARNode(
        type: oldNode.type,
        uri: oldNode.uri,
        position: oldNode.position,
        scale: vector.Vector3.all(_modelScale),
        rotation: vector.Vector4(0, sinHalf, 0, cosHalf),
      );

      final added = await arObjectManager!.addNode(newNode);
      if (added == true) {
        _currentARNode = newNode;
      }
    } catch (e) {
      print('Error updating AR object ${e.toString()}');
      // AppLogger.error('Error updating AR object', error: e);
    }
  }

  void _handleScaleStart(ScaleStartDetails details) {
    print('_handleScaleStart');
    _lastScale = _modelScale;
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    print('_handleScaleUpdate');
    setState(() {
      _modelScale = (_lastScale * details.scale).clamp(0.05, 0.5);
      _rotationY += details.rotation * 0.5;
    });

    _updateARObjectTransform();
  }


  // Future<void> onPlaneOrPointTap(List<ARHitTestResult> hitTestResults) async {
  //   if (modelPlaced || hitTestResults.isEmpty) return;
  //
  //   try {
  //     // Pick first valid hit
  //     final hit = hitTestResults.first;
  //
  //     // Create anchor
  //     final newAnchor = ARPlaneAnchor(
  //       transformation: hit.worldTransform,
  //       name: UniqueKey().toString(),
  //     );
  //
  //     final added = await arAnchorManager!.addAnchor(newAnchor);
  //     if (added != true) return;
  //
  //     // Wait a tiny bit to ensure anchor is ready
  //     await Future.delayed(const Duration(milliseconds: 50));
  //
  //     // Remove previous node/anchor to prevent memory overload
  //     if (nodes.isNotEmpty) {
  //       for (var node in nodes) {
  //         await arObjectManager!.removeNode(node);
  //       }
  //       nodes.clear();
  //     }
  //
  //     if (anchors.isNotEmpty) {
  //       for (var anchor in anchors) {
  //         await arAnchorManager!.removeAnchor(anchor);
  //       }
  //       anchors.clear();
  //     }
  //
  //     anchors.add(newAnchor);
  //
  //     // Create node
  //     final node = ARNode(
  //       type: NodeType.localGLTF2,
  //       uri: widget.modelUrl,
  //       scale: vector.Vector3(0.08, 0.08, 0.08),
  //       position: vector.Vector3(0, 0, 0),
  //       rotation: vector.Vector4(1, 0, 0, 0),
  //     );
  //
  //     final nodeAdded = await arObjectManager!.addNode(
  //       node,
  //       planeAnchor: newAnchor,
  //     );
  //
  //     if (nodeAdded == true && mounted) {
  //       nodes.add(node);
  //       setState(() => modelPlaced = true);
  //     }
  //   } catch (e, st) {
  //     print("AR Placement Error: $e\n$st");
  //   }
  // }

  Future<void> removeAllNodes() async {
    for (var node in nodes) {
      await arObjectManager!.removeNode(node);
    }
    nodes.clear();

    for (var anchor in anchors) {
      await arAnchorManager!.removeAnchor(anchor);
    }
    anchors.clear();

    setState(() => modelPlaced = false);
  }
}

class ARItem {
  final String id;
  final String name;
  final String description;
  final String modelUrl;
  final Map<String, String> metadata; // generic metadata like calories, ingredients

  const ARItem({
    required this.id,
    required this.name,
    required this.description,
    required this.modelUrl,
    this.metadata = const {},
  });
}

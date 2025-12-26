class ARItem {
  final String id;
  final String name;
  final String description;
  final String modelUrl;
  final double price;
  final double rating;
  final Map<String, String> metadata; // generic metadata like calories, ingredients

  const ARItem({
    required this.id,
    required this.name,
    required this.description,
    required this.modelUrl,
    this.price = 0.0,
    this.rating = 0.0,
    this.metadata = const {},
  });
}

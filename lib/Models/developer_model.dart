// models/developer_model.dart
class Developer {
  final String name;
  final String role;
  final String description;
  final String imageAsset; // Local asset path
  final String? linkedInUrl;
  final String? githubUrl;
  final List<String> contributions;

  Developer({
    required this.name,
    required this.role,
    required this.description,
    required this.imageAsset,
    this.linkedInUrl,
    this.githubUrl,
    required this.contributions,
  });
}
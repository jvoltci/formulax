class FormulaConcept {
  final String name;
  final String definition;

  FormulaConcept({required this.name, required this.definition});

  factory FormulaConcept.fromJson(Map<String, dynamic> json) {
    return FormulaConcept(
      name: json['name'] ?? '',
      definition: json['definition'] ?? '',
    );
  }
}

class Formula {
  final String id;
  final String subject;
  final String topic;
  final String title;
  final String description;
  final String? imagePath;
  final String visualType;
  final String visualData;

  // NEW FIELDS
  final String? derivation; // Nullable, as not all formulas might have one
  final List<FormulaConcept> relatedConcepts;

  Formula({
    required this.id,
    required this.subject,
    required this.topic,
    required this.title,
    required this.description,
    this.imagePath,
    required this.visualType,
    required this.visualData,
    this.derivation,
    required this.relatedConcepts,
  });

  factory Formula.fromJson(Map<String, dynamic> json) {
    return Formula(
      id: json['id'] ?? '',
      subject: json['subject'] ?? '',
      topic: json['topic'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imagePath: json['image_path'],
      visualType: json['visual_type'] ?? 'latex',
      visualData: json['visual_data'] ?? json['latex'] ?? '',

      // Mapping new fields
      derivation: json['derivation'],
      relatedConcepts: (json['related_concepts'] as List<dynamic>?)
              ?.map((e) => FormulaConcept.fromJson(e))
              .toList() ??
          [],
    );
  }

  String get latex => visualData;
}

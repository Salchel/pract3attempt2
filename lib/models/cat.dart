class Cat {
  final String name;
  final String origin;
  final String imageLink;
  final double length;
  final double minWeight;
  final double maxWeight;
  final double minLife;
  final double maxLife;
  final Map<String, int> ratings;

  static const ratingKeys = [
    'family_friendly',
    'children_friendly',
    'other_pets_friendly',
    'playfulness',
    'intelligence',
    'grooming',
    'shedding',
  ];

  const Cat({
    required this.name,
    required this.origin,
    required this.imageLink,
    required this.length,
    required this.minWeight,
    required this.maxWeight,
    required this.minLife,
    required this.maxLife,
    required this.ratings,
  });

  factory Cat.fromJson(Map<String, dynamic> j) {
    double d(dynamic v) => (v as num?)?.toDouble() ?? 0;
    return Cat(
      name: j['name'] ?? '',
      origin: j['origin'] ?? '',
      imageLink: j['image_link'] ?? '',
      length: d(j['length'] is String ? null : j['length']),
      minWeight: d(j['min_weight']),
      maxWeight: d(j['max_weight']),
      minLife: d(j['min_life_expectancy']),
      maxLife: d(j['max_life_expectancy']),
      ratings: {
        for (final k in ratingKeys) k: (j[k] as num?)?.toInt() ?? 0,
      },
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'origin': origin,
        'image_link': imageLink,
        'length': length,
        'min_weight': minWeight,
        'max_weight': maxWeight,
        'min_life_expectancy': minLife,
        'max_life_expectancy': maxLife,
        ...ratings,
      };
}
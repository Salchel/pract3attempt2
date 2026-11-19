import 'package:flutter/material.dart';
import '../controllers/cats_controller.dart';
import '../di.dart';
import '../models/cat.dart';

class DetailScreen extends StatelessWidget {
  final Cat cat;
  const DetailScreen({super.key, required this.cat});

  static const _labels = {
    'family_friendly': 'Дружелюбие к семье',
    'children_friendly': 'Дружелюбие к детям',
    'other_pets_friendly': 'Ладит с другими животными',
    'playfulness': 'Игривость',
    'intelligence': 'Интеллект',
    'grooming': 'Груминг',
    'shedding': 'Линька',
  };

  @override
  Widget build(BuildContext context) {
    final ctrl = getIt<CatsController>();
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            actions: [
              ListenableBuilder(
                listenable: ctrl,
                builder: (_, __) {
                  final fav = ctrl.isFavorite(cat);
                  return IconButton(
                    icon: Icon(fav ? Icons.favorite : Icons.favorite_border,
                        color: fav ? Colors.red : null),
                    onPressed: () => ctrl.toggleFavorite(cat),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(cat.name,
                  style: const TextStyle(
                      shadows: [Shadow(blurRadius: 8, color: Colors.black)])),
              background: Hero(
                tag: 'cat_${cat.name}',
                child: Image.network(cat.imageLink,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                        color: cs.primaryContainer,
                        child: const Icon(Icons.pets, size: 80))),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Row(
                  children: [
                    _InfoTile(Icons.public, 'Родина', cat.origin),
                    _InfoTile(Icons.monitor_weight_outlined, 'Вес, фунты',
                        '${cat.minWeight.toStringAsFixed(0)}–${cat.maxWeight.toStringAsFixed(0)}'),
                    _InfoTile(Icons.cake_outlined, 'Жизнь, лет',
                        '${cat.minLife.toStringAsFixed(0)}–${cat.maxLife.toStringAsFixed(0)}'),
                  ],
                ),
                const SizedBox(height: 24),
                Text('Характеристики',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                for (final e in _labels.entries)
                  _RatingRow(e.value, cat.ratings[e.key] ?? 0),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  const _InfoTile(this.icon, this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Icon(icon),
              const SizedBox(height: 4),
              Text(value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(title, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}

class _RatingRow extends StatelessWidget {
  final String label;
  final int value;
  const _RatingRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Expanded(child: Text(label)),
            Text('$value/5'),
          ]),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(value: value / 5, minHeight: 8),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../controllers/cats_controller.dart';
import '../di.dart';
import '../models/cat.dart';
import 'detail_screen.dart';

class CatCard extends StatelessWidget {
  final Cat cat;
  const CatCard({super.key, required this.cat});

  @override
  Widget build(BuildContext context) {
    final ctrl = getIt<CatsController>();
    final cs = Theme.of(context).colorScheme;

    return Card(
      color: cs.surfaceContainerHighest,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => DetailScreen(cat: cat))),
        child: Row(
          children: [
            Hero(
              tag: 'cat_${cat.name}',
              child: Image.network(
                cat.imageLink,
                width: 110,
                height: 110,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 110,
                  height: 110,
                  color: cs.primaryContainer,
                  child: const Icon(Icons.pets, size: 40),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cat.name,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Row(children: [
                    const Icon(Icons.public, size: 16),
                    const SizedBox(width: 4),
                    Flexible(child: Text(cat.origin)),
                  ]),
                  const SizedBox(height: 4),
                  Row(children: [
                    const Icon(Icons.favorite_outline, size: 16),
                    const SizedBox(width: 4),
                    Text('${cat.minLife.toStringAsFixed(0)}–'
                        '${cat.maxLife.toStringAsFixed(0)} лет'),
                  ]),
                ],
              ),
            ),
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
        ),
      ),
    );
  }
}
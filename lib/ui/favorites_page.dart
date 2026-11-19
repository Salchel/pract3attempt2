import 'package:flutter/material.dart';
import '../controllers/cats_controller.dart';
import '../di.dart';
import 'cat_card.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = getIt<CatsController>();

    return ListenableBuilder(
      listenable: ctrl,
      builder: (context, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text('❤️ Избранное',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: ctrl.favorites.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.favorite_border,
                              size: 64, color: Colors.grey),
                          SizedBox(height: 8),
                          Text('Пока пусто. Добавьте любимые породы!'),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: ctrl.favorites.length,
                      itemBuilder: (_, i) => CatCard(cat: ctrl.favorites[i]),
                    ),
            ),
          ],
        );
      },
    );
  }
}
import 'package:flutter/material.dart';
import '../controllers/cats_controller.dart';
import '../di.dart';
import 'cat_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _ctrl = getIt<CatsController>();
  final _text = TextEditingController();

  static const _suggestions = [
    'Abyssinian', 'Siamese', 'Bengal', 'Persian', 'Maine Coon', 'Sphynx',
    'British Shorthair', 'Ragdoll',
  ];

  void _search(String q) {
    _text.text = q;
    FocusScope.of(context).unfocus();
    _ctrl.search(q);
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ListenableBuilder(
      listenable: _ctrl,
      builder: (context, _) {
        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('🐱 Породы кошек',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    SearchBar(
                      controller: _text,
                      hintText: 'Название породы (англ.)',
                      leading: const Icon(Icons.search),
                      trailing: [
                        if (_text.text.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => setState(_text.clear),
                          ),
                      ],
                      onChanged: (_) => setState(() {}),
                      onSubmitted: _search,
                    ),
                  ],
                ),
              ),
            ),

            //последние поиски
            if (_ctrl.recent.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('Последние поиски',
                              style: Theme.of(context).textTheme.titleSmall),
                          const Spacer(),
                          TextButton(
                              onPressed: _ctrl.clearRecent,
                              child: const Text('Очистить')),
                        ],
                      ),
                      Wrap(
                        spacing: 8,
                        children: [
                          for (final r in _ctrl.recent)
                            InputChip(
                              avatar: const Icon(Icons.history, size: 18),
                              label: Text(r),
                              onPressed: () => _search(r),
                              onDeleted: () => _ctrl.removeRecent(r),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

            //подсказки
            if (!_ctrl.searched && !_ctrl.loading)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Популярные породы',
                          style: Theme.of(context).textTheme.titleSmall),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          for (final s in _suggestions)
                            ActionChip(label: Text(s), onPressed: () => _search(s)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 8)),

            if (_ctrl.loading)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_ctrl.error != null)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _Message(
                  icon: Icons.wifi_off,
                  text: _ctrl.error!,
                  color: cs.error,
                ),
              )
            else if (_ctrl.searched && _ctrl.results.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: _Message(
                    icon: Icons.pets, text: 'Ничего не найдено'),
              )
            else
              SliverList.builder(
                itemCount: _ctrl.results.length,
                itemBuilder: (_, i) => CatCard(cat: _ctrl.results[i]),
              ),
          ],
        );
      },
    );
  }
}

class _Message extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? color;
  const _Message({required this.icon, required this.text, this.color});

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: color ?? Colors.grey),
            const SizedBox(height: 8),
            Text(text, style: TextStyle(color: color)),
          ],
        ),
      );
}
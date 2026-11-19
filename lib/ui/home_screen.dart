import 'package:flutter/material.dart';
import '../di.dart';
import '../controllers/cats_controller.dart';
import 'favorites_page.dart';
import 'search_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
  final _ctrl = getIt<CatsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _index,
          children: const [SearchPage(), FavoritesPage()],
        ),
      ),
      bottomNavigationBar: ListenableBuilder(
        listenable: _ctrl,
        builder: (_, __) => NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: [
            const NavigationDestination(
                icon: Icon(Icons.search), label: 'Поиск'),
            NavigationDestination(
              icon: Badge(
                isLabelVisible: _ctrl.favorites.isNotEmpty,
                label: Text('${_ctrl.favorites.length}'),
                child: const Icon(Icons.favorite_border),
              ),
              selectedIcon: const Icon(Icons.favorite),
              label: 'Избранное',
            ),
          ],
        ),
      ),
    );
  }
}
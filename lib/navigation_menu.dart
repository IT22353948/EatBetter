import 'package:flutter/material.dart';
import 'package:eat_better/pages/home.dart';
import 'package:eat_better/pages/food_analysis.dart';
import 'package:eat_better/pages/recipe_search.dart';
import 'package:eat_better/pages/location_view.dart';
import 'package:eat_better/pages/saved_recipes.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  _NavigationMenuState createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    RecipeSearch(),
    FoodAnalysis(),
    LocationView(),
    SavedRecipes(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack keeps the state of pages
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: SizedBox(
        height: 80,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: const Color(0xFFF86A2E), //248, 246, 106, 46
          selectedItemColor: Color.fromARGB(255, 255, 255, 255),
          unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
          showUnselectedLabels: true,
          iconSize: 25,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_rounded),
              label: 'Menu',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_pizza_rounded),
              label: 'Recipe',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.analytics_outlined),
              label: 'Analytics',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.location_on_outlined),
              label: 'Location',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark),
              label: 'Saved',
            ),
          ],
        ),
      ),
    );
  }
}

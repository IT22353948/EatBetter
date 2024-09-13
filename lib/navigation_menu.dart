import 'package:flutter/material.dart';
import 'package:eat_better/pages/home.dart';
import 'package:eat_better/pages/food_analysis.dart';
import 'package:eat_better/pages/recipe_search.dart';
import 'package:eat_better/pages/hasara/location_view.dart';
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

  Future<bool> _onPop() async {
    if (_currentIndex != 0) {
      // If not on the Menu (index 0), navigate to Menu when back button is pressed
      setState(() {
        _currentIndex = 0;
      });
      return false; // Prevent default back button behavior
    } else {
      return true; // Allow the app to exit if already on Menu
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //this is depricated we have to use PopScope
      onWillPop: _onPop,
      child: Scaffold(
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
            selectedItemColor: Color.fromARGB(248, 246, 106, 46),
            unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
            showUnselectedLabels: true,
            iconSize: 30,
            items: const [
              BottomNavigationBarItem(
                icon: ImageIcon(AssetImage('assets/icons/menu.png')),
                label: 'Menu',
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(AssetImage('assets/icons/recipe.png')),
                label: 'Recipe',
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(AssetImage('assets/icons/analitics.png')),
                label: 'Analytics',
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(AssetImage('assets/icons/location.png')),
                label: 'Location',
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(AssetImage('assets/icons/saved.png')),
                label: 'Saved',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

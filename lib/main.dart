import 'package:flutter/material.dart';
import 'package:eat_better/consts.dart';
import 'package:eat_better/pages/prabashwara/Image_To_Text.dart';
import 'package:eat_better/pages/home.dart';
import 'package:eat_better/pages/food_analysis.dart';
import 'package:eat_better/pages/recipe_search.dart';
import 'package:eat_better/pages/hasara/location_view.dart';
import 'package:eat_better/pages/saved_recipes.dart';
import 'package:eat_better/navigation_menu.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:eat_better/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensures that all bindings are initialized

  Gemini.init(apiKey: GEMINI_API_KEY); //  initialization of Gemini

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/navigation': (context) => const NavigationMenu(),
        '/home': (context) => const HomePage(),
        '/recipe_search': (context) => const RecipeSearch(),
        '/food_analysis': (context) => const FoodAnalysis(),
        '/location_view': (context) => const LocationView(),
        '/saved_recipes': (context) => const SavedRecipes(),
        '/image_to_text': (context) => const ImageToText(),
      },
    ),
  );
}

import 'package:eat_better/services/food_api_service.dart';
import 'package:flutter/material.dart';
import 'package:eat_better/pages/widgets/recipe_card.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:eat_better/pages/recipe_in_detail.dart'; // Import the new screen

class RecipeSearch extends StatefulWidget {
  const RecipeSearch({super.key});

  @override
  State<RecipeSearch> createState() => _RecipeSearchState();
}

class _RecipeSearchState extends State<RecipeSearch> {
  List<Map<String, dynamic>> recipes = [];
  bool isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchRecipes('spaghetti'); // Default search query
  }

  Future<void> _searchRecipes(String query) async {
    setState(() {
      isLoading = true; // Show loading while fetching
    });
    recipes = await FoodService.getRecipeForCommons(query);
    setState(() {
      isLoading = false; // Hide loading after fetch
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(126, 248, 100, 37),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.restaurant_menu),
            SizedBox(width: 10),
            Text('Recipe Search'),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(126, 248, 100, 37), // Orange
              Colors.white, // White
            ],
          ),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width:
                    450, // Set the desired width here, or use MediaQuery for responsive width
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    hintText: 'Search for recipes...',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        _searchRecipes(_searchController.text);
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(30.0), // Round borders
                      borderSide: const BorderSide(
                        color:
                            Color.fromARGB(211, 246, 106, 46), // Border color
                        width: 2.0, // Border thickness
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          30.0), // Round borders when focused
                      borderSide: const BorderSide(
                        color: Color.fromARGB(
                            211, 246, 106, 46), // Border color when focused
                        width: 2.0, // Border thickness when focused
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15), // Padding inside the search bar
                  ),
                  onSubmitted: (query) {
                    _searchRecipes(query);
                  },
                ),
              ),
            ),
            isLoading
                ? const SpinKitFadingCircle(
                    color: Color.fromARGB(192, 187, 5, 5),
                    size: 50.0,
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: recipes.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            // Navigate to RecipeDetailScreen and pass the recipe ID or other data
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RecipeDetail(
                                  // recipe: {
                                  //   'id': '1',
                                  //   'title': recipes[index]['title'],
                                  //   'cookTime': '20 mins',
                                  //   'rating': '4.8',
                                  //   'image': recipes[index]['image'],
                                  // },
                                  recipeId: recipes[index]['id'],
                                  // recipeId: recipes[index],
                                  //     ['id'], // Pass the recipe ID
                                ),
                              ),
                            );
                          },
                          child: RecipeCard(
                            title: recipes[index]['title'],
                            cookTime: '30 mins',
                            rating: '4.5',
                            thumbnailUrl: recipes[index]['image'],
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

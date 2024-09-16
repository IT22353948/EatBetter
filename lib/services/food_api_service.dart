import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FoodService {
  // API key for Spoonacular API, rapid api. for limit the calls i have add an extra number to the end of the key
  //to get this fetch function to work. remove the last integer from the api key
  static String apiKey = '26e308d91dmsh73617d5e1036f24p15c7c4jsne600d99e48596';

  // Cache to store fetched recipes by name
  static Map<String, List<Map<String, dynamic>>> _cache = {};

  //this function is used to get the recipe for the food item.
  //when call this function have to pass the name of the food. it will fetch upto 3 items for the food item.
  //tochange the number of items to fetch change the number in the apiEndpointUrl
  //if the data is already cached it will return the cached data. if not it will fetch the data from the api and store it in the cache.
  //if the api call fails it will return an empty list.
  //the fetched data will be returned as a list of maps.
  //each map will contain the details of the recipe.
  //the details will contain the id, title, image, imageType;
  //the id is the id of the recipe.
  //the title is the title of the recipe.
  //the image is the image of the recipe.
  //the imageType is the type of the image.
  //to use this function call FoodService.getRecipeForCommons('food item name');
  //it will return a future of list of maps.
  //to get the data from the future use snapshot.data.
  //to et the data from the snapshot, use snapshot.data[index],
  //Map<String, dynamic> snap = snapshot.data![index];
  //String title = snap['title'];
  //int id = snap['id'];
  //String image = snap['image'];
  //String imageType = snap['imageType'];
  //see the example in the HomeTabBarView class in the common_tab.dart file.
  static Future<List<Map<String, dynamic>>> getRecipeForCommons(
      String name) async {
    // Check if the data for the recipe name is already cached
    if (_cache.containsKey(name)) {
      // Return cached data
      return _cache[name]!;
    }

    // If data is not cached, proceed with the API call
    String apiEndpointUrl =
        'https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/complexSearch?query=$name&number=3';
    List<Map<String, dynamic>> recipes = [];

    final response = await http.get(
      Uri.parse(apiEndpointUrl),
      headers: {
        'x-rapidapi-key': apiKey,
        'x-rapidapi-host':
            'spoonacular-recipe-food-nutrition-v1.p.rapidapi.com',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['results'] != null) {
        for (var result in data['results']) {
          recipes.add(result);
        }
      }

      // Store the fetched data in the cache for future use
      _cache[name] = recipes;

      //console log recipe
      print('$recipes');
      // Return the fetched data
      return recipes;
    }

    //console log recipe
    print('$recipes');
    // Return an empty list if the API call fails
    return recipes;
  }
}

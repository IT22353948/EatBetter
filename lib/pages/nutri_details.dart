import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vector_math/vector_math_64.dart' as math;
import 'package:eat_better/services/food_api_service.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:eat_better/pages/nutri_details_charts.dart';
import 'package:eat_better/pages/nutriProgressCardWidget.dart';

Map<String, dynamic> response = {}; // Nutritional data storage

class NutriDetails extends StatefulWidget {
  final String name;
  final int id;
  final String imageUrl;

  const NutriDetails(
      {super.key,
      required this.name,
      required this.id,
      required this.imageUrl});

  @override
  State<NutriDetails> createState() => _NutriDetailsState();
}

class _NutriDetailsState extends State<NutriDetails> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNutritionData(widget.id);
  }

  Future<void> fetchNutritionData(int recipeId) async {
    setState(() {
      _isLoading = true;
    });

    var data = await FoodService.getNutritionData(recipeId);

    setState(() {
      response = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(126, 248, 100, 37),
        leading: IconButton(
          iconSize: 30,
          icon: Image.asset('assets/icons/BackButton.png'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
          padding: const EdgeInsets.all(5),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(126, 248, 100, 37),
                Colors.white,
              ],
            ),
          ),
          child: ListView(
            children: [
              Stack(
                children: [
                  Container(
                    height: h,
                    width: w,
                    color: const Color.fromARGB(0, 194, 3, 3),
                  ),
                  Positioned(
                    top: 95,
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(45.0),
                          topRight: Radius.circular(45.0),
                        ),
                        color: Colors.white,
                      ),
                      height: h,
                      width: w,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: w * .18,
                    child: Hero(
                      tag: widget.name,
                      child: Container(
                        height: 250,
                        width: 250,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(widget.imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Add Row below the circle image
                  Positioned(
                    top: 255,
                    left: 20,
                    right: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left-aligned food name
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.name,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        // Right-aligned text
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: _isLoading
                                ? const Text(
                                    'Loading...',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                : Text(
                                    '${response['weightPerServing']['amount']}${response['weightPerServing']['unit']}\nserving',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                      top: 350,
                      left: 2,
                      right: 2,
                      child: GestureDetector(
                        onTap: () {
                          // Navigate to another page when clicked
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NutriDetailsCharts(
                                response: response,
                                name: widget.name,
                                id: widget.id,
                              ),
                            ),
                          );
                        },
                        child: NutriProgressCard(
                          height: h,
                          width: w,
                          data: response,
                          isLoading: _isLoading,
                        ),
                      )),
                  // Container for the two cards
                  Positioned(
                    top: 610,
                    left: 10,
                    right: 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            // onTap: () => Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => RecipeDetailsScreen(
                            //       recipeId: widget.id,
                            //     ),
                            //   ),
                            // ),
                            child: Card(
                              elevation: 5,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: Stack(
                                children: [
                                  // Image filling the card
                                  Container(
                                    height: 120,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: const DecorationImage(
                                        image: AssetImage(
                                            'assets/images/image.png'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  // Overlay text
                                  Positioned(
                                    top: 35,
                                    left: 10,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: const Text(
                                        'View Recipe',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            // Add onTap event to navigate to another page
                            // onTap: () {
                            //   Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (context) => VideoThumbnailScreen(
                            //         id: widget.id,
                            //         name: widget.name,
                            //       ),
                            //     ),
                            //   );
                            // },
                            child: Card(
                              elevation: 5,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: Stack(
                                children: [
                                  // Image filling the card
                                  Container(
                                    height: 120,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/image_1.png'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  // Overlay text
                                  Positioned(
                                    top: 35,
                                    left: 10,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: const Text(
                                        'Cap Calories',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}

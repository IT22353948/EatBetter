import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as math;
import 'package:eat_better/services/food_api_service.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:eat_better/pages/nutri_details_charts.dart';

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

  void fetchNutritionData(int recipeId) async {
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
        // title: const Text('Nutritional Details'),
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 100,
                backgroundImage: NetworkImage(widget.imageUrl),
              ),
              const SizedBox(height: 20),
              Text(
                'Nutritional Details ${widget.name} for ID: ${widget.id}',
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),

              // Make the card clickable using InkWell
              SizedBox(
                height: h * .3,
                width: w,
                child: InkWell(
                  onTap: () {
                    // Navigate to another page when clicked
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NutriDetailsCharts(
                          name: widget.name,
                          nutriData: response,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(101, 248, 100, 37),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _RadialProgress(
                                value: double.parse(response['calories']
                                    .toString()
                                    .replaceAll('kCal', '')
                                    .trim()),
                                width: w * .39,
                                height: h * .19,
                                progress: getNormalizedValue(
                                    double.parse(response['calories']
                                        .toString()
                                        .replaceAll('kCal', '')
                                        .trim()),
                                    1500),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  _IngredientProgress(
                                    ingredient: "Protein",
                                    progress: getNormalizedValue(
                                        double.parse(response['protein']
                                            .toString()
                                            .replaceAll('g', '')
                                            .trim()),
                                        50),
                                    progressColor: Colors.green,
                                    Amount: double.parse(response['protein']
                                        .toString()
                                        .replaceAll('g', '')
                                        .trim()),
                                    width: w * 0.39,
                                    MaxDaily: 50,
                                  ),
                                  const SizedBox(height: 5),
                                  _IngredientProgress(
                                      ingredient: "Carbs",
                                      progress: getNormalizedValue(
                                          double.parse(response['carbs']
                                              .toString()
                                              .replaceAll('g', '')
                                              .trim()),
                                          300),
                                      progressColor: Colors.red,
                                      Amount: double.parse(response['carbs']
                                          .toString()
                                          .replaceAll('g', '')
                                          .trim()),
                                      width: w * 0.39,
                                      MaxDaily: 300),
                                  const SizedBox(height: 5),
                                  _IngredientProgress(
                                      ingredient: "Fat",
                                      progress: getNormalizedValue(
                                          double.parse(response['fat']
                                              .toString()
                                              .replaceAll('g', '')
                                              .trim()),
                                          70),
                                      progressColor: Colors.pink,
                                      Amount: double.parse(response['fat']
                                          .toString()
                                          .replaceAll('g', '')
                                          .trim()),
                                      width: w * 0.39,
                                      MaxDaily: 70),
                                ],
                              )
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IngredientProgress extends StatelessWidget {
  final String ingredient;
  final double Amount;
  final double progress, width, MaxDaily;
  final Color progressColor;

  const _IngredientProgress(
      {super.key,
      required this.MaxDaily,
      required this.ingredient,
      required this.Amount,
      required this.progress,
      required this.width,
      required this.progressColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          ingredient,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 15,
                  width: width,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.black12,
                  ),
                ),
                Container(
                  height: 15,
                  width: width * progress,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: progressColor,
                  ),
                )
              ],
            ),
            Text("${Amount.ceil()}g/${MaxDaily.ceil()}g"),
          ],
        ),
      ],
    );
  }
}

class _NutrientInfo extends StatelessWidget {
  final String nutrient, value;
  const _NutrientInfo({super.key, required this.nutrient, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          nutrient,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            foreground: Paint()
              ..shader = const LinearGradient(
                colors: [
                  Color.fromARGB(192, 187, 5, 5), // Start color
                  Color.fromARGB(255, 255, 102, 0), // End color
                ],
              ).createShader(Rect.fromLTWH(0, 0, 100, 50)),
          ),
        ),
      ],
    );
  }
}

class _RadialProgress extends StatelessWidget {
  final double width, height, progress, value;
  const _RadialProgress(
      {super.key,
      required this.value,
      required this.width,
      required this.height,
      required this.progress});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RadialPainter(
        progress: progress,
      ),
      child: Container(
        height: height,
        width: width,
        child: Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: value.toString(),
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w700,
                    foreground: Paint()
                      ..shader = const LinearGradient(
                        colors: [
                          Color.fromARGB(192, 187, 5, 5), // Start color
                          Color.fromARGB(255, 255, 102, 0), // End color
                        ],
                      ).createShader(Rect.fromLTWH(0, 0, 100, 50)),
                  ),
                ),
                const TextSpan(text: "\n"),
                TextSpan(
                  text: "KCal",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    foreground: Paint()
                      ..shader = const LinearGradient(
                        colors: [
                          Color.fromARGB(192, 187, 5, 5), // Start color
                          Color.fromARGB(255, 255, 102, 0), // End color
                        ],
                      ).createShader(Rect.fromLTWH(0, 0, 100, 50)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RadialPainter extends CustomPainter {
  final double progress;

  const _RadialPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeWidth = 10
      ..shader = const LinearGradient(
        colors: [
          Color.fromARGB(192, 187, 5, 5), // Start color
          Color.fromARGB(255, 255, 102, 0), // End color
        ],
      ).createShader(Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: size.width / 2))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);
    double relativeProgress = 360 * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: size.width / 2),
      math.radians(-90),
      math.radians(-relativeProgress),
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

double getNormalizedValue(double value, double maxValue) {
  return value / maxValue;
}

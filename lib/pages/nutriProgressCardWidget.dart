import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; // Make sure to import the SpinKit package
import 'package:eat_better/pages/nutriProgressCardWidget.dart'; // Replace with the correct path to your _RadialProgress widget file
import 'package:vector_math/vector_math_64.dart' as math;

class NutriProgressCard extends StatelessWidget {
  final double height;
  final double width;
  final Map<String, dynamic> data;
  final bool isLoading; // You may want to pass this as a parameter

  NutriProgressCard({
    Key? key,
    required this.height,
    required this.width,
    required this.data,
    required this.isLoading, // Include isLoading in the constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height * .3,
      width: width,
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Color.fromARGB(101, 248, 100, 37),
          borderRadius: BorderRadius.circular(20),
        ),
        child: isLoading
            ? const Center(
                child: SpinKitRing(
                  color: Colors.orange,
                  size: 50.0,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _RadialProgress(
                    value: double.parse(data['calories']
                        .toString()
                        .replaceAll('kCal', '')
                        .trim()),
                    width: width * .39,
                    height: height * .19,
                    progress: getNormalizedValue(
                        double.parse(data['calories']
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
                            double.parse(data['protein']
                                .toString()
                                .replaceAll('g', '')
                                .trim()),
                            50),
                        progressColor: const Color.fromARGB(255, 0, 255, 8),
                        Amount: double.parse(data['protein']
                            .toString()
                            .replaceAll('g', '')
                            .trim()),
                        width: width * 0.39,
                        MaxDaily: 50,
                      ),
                      const SizedBox(height: 10),
                      _IngredientProgress(
                          ingredient: "Carbs",
                          progress: getNormalizedValue(
                              double.parse(data['carbs']
                                  .toString()
                                  .replaceAll('g', '')
                                  .trim()),
                              300),
                          progressColor: Color.fromARGB(255, 255, 251, 0),
                          Amount: double.parse(data['carbs']
                              .toString()
                              .replaceAll('g', '')
                              .trim()),
                          width: width * 0.39,
                          MaxDaily: 300),
                      const SizedBox(height: 10),
                      _IngredientProgress(
                          ingredient: "Fat",
                          progress: getNormalizedValue(
                              double.parse(data['fat']
                                  .toString()
                                  .replaceAll('g', '')
                                  .trim()),
                              70),
                          progressColor: Color.fromARGB(255, 255, 0, 0),
                          Amount: double.parse(data['fat']
                              .toString()
                              .replaceAll('g', '')
                              .trim()),
                          width: width * 0.39,
                          MaxDaily: 70),
                    ],
                  )
                ],
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
        // Ingredient name
        Text(
          ingredient,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Progress bar with border color
            Stack(
              children: <Widget>[
                Container(
                  height: 16,
                  width: width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: progressColor
                        .withOpacity(0.2), // Background color with opacity
                    border: Border.all(
                      // Add border here
                      color: progressColor, // Border width
                    ),
                  ),
                ),
                Container(
                  height: 16,
                  width: width * progress, // Progress width based on value
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: progressColor, // Progress color
                  ),
                ),
              ],
            ),
            // Display amount and max daily value
            Text("${Amount.ceil()}g/${MaxDaily.ceil()}g"),
          ],
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
      ..strokeWidth = 16
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

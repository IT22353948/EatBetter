import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CommonTab extends StatelessWidget {
  const CommonTab({super.key});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: w * .09,
            child: TabBar(
              unselectedLabelColor: Color.fromARGB(248, 246, 106, 46),
              labelColor: Color.fromARGB(248, 255, 255, 255),
              indicator: BoxDecoration(
                color: const Color.fromARGB(248, 246, 106, 46),
                borderRadius: BorderRadius.circular(10),
              ),
              labelPadding: EdgeInsets.symmetric(horizontal: w * .012),
              tabs: const [
                TabItem(title: 'Rices'),
                TabItem(title: 'Pastas'),
                TabItem(title: 'Breads'),
                TabItem(title: 'Cereals'),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // TabBarView
          SizedBox(
            height: h * .3,
            child: const TabBarView(
              children: [
                Text('Rices'),
                Text('Pastas'),
                Text('Breads'),
                Text('Cereals'),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class TabItem extends StatelessWidget {
  final String title;
  const TabItem({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(fontSize: 9.8),
            ),
          )),
    );
  }
}

class HomeTabBarView extends StatelessWidget {
  final String recipe;
  const HomeTabBarView({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return SizedBox(
      height: h * 28,
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {},
          separatorBuilder: (context, index) {
            return const SizedBox(height: 10);
          },
          itemCount: 4),
    );
  }
}

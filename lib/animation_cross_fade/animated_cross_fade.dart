import 'package:flutter/material.dart';


class AnimatedCrossFadeTest extends StatefulWidget {
  const AnimatedCrossFadeTest({super.key});

  @override
  State<AnimatedCrossFadeTest> createState() => _AnimatedCrossFadeTestState();
}

class _AnimatedCrossFadeTestState extends State<AnimatedCrossFadeTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                ElevatedButton(onPressed: (){}, child: Text('Button 1'),),
                ElevatedButton(onPressed: (){}, child: Text('Button 1'),),
              ],
            )
          ],
        ),
      ),
    );
  }
}

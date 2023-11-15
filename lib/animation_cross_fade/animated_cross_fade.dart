import 'package:flutter/material.dart';

class AnimatedCrossFadeTest extends StatefulWidget {
  const AnimatedCrossFadeTest({super.key});

  @override
  State<AnimatedCrossFadeTest> createState() => _AnimatedCrossFadeTestState();
}

class _AnimatedCrossFadeTestState extends State<AnimatedCrossFadeTest> {
  int selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedIndex = 1;
                    });
                  },
                  child: const Text('Button 1'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedIndex = 2;
                    });
                  },
                  child: const Text('Button 1'),
                ),
              ],
            ),
            AnimatedCrossFade(
                firstChild: const Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Chip(
                      label: Text('Text 1'),
                      backgroundColor: Colors.green,
                    ),
                  ],
                ),
                secondChild: const Column(
                  children: [
                    Chip(
                      label: Text('Text 2'),
                      backgroundColor: Colors.red,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
                firstCurve: Curves.linear,
                secondCurve: Curves.linearToEaseOut,
                crossFadeState: selectedIndex == 1 ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                duration: const Duration(microseconds: 900)),
            // const Chip(
            //   label: Text('Text 1'),
            //   backgroundColor: Colors.green,
            // ),
            // const Chip(
            //   label: Text('Text 2'),
            //   backgroundColor: Colors.red,
            // ),
          ],
        ),
      ),
    );
  }
}

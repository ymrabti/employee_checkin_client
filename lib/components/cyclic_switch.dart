import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SwitchScreen(),
    );
  }
}

class SwitchScreen extends StatefulWidget {
  const SwitchScreen({super.key});

  @override
  State<SwitchScreen> createState() => _SwitchScreenState();
}

class _SwitchScreenState extends State<SwitchScreen> {
  bool switch1 = false;
  bool switch2 = false;
  bool switch3 = false;

  void toggleSwitch1(int switchNumber) {
    setState(() {
      if (switchNumber == 1) {
        switch1 = !switch1;
        if (switch1 && switch2 && switch3) switch2 = false;
      } else if (switchNumber == 2) {
        switch2 = !switch2;
        if (switch1 && switch2 && switch3) switch3 = false;
      } else if (switchNumber == 3) {
        switch3 = !switch3;
        if (switch1 && switch2 && switch3) switch1 = false;
      }
    });
  }

  void toggleSwitch(int switchNumber) {
    setState(() {
      if (switchNumber == 1) {
        switch1 = !switch1;
      } else if (switchNumber == 2) {
        switch2 = !switch2;
      } else if (switchNumber == 3) {
        switch3 = !switch3;
      }

      // If all are on, turn off the switch that was just toggled
      if (switch1 && switch2 && switch3) {
        if (switchNumber == 1) {
          switch3 = false;
        } else if (switchNumber == 2) {
          switch1 = false;
        } else if (switchNumber == 3) {
          switch2 = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Switch Logic")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SwitchListTile(
              title: Text("Switch 1"),
              value: switch1,
              onChanged: (bool value) => toggleSwitch(1),
            ),
            SwitchListTile(
              title: Text("Switch 2"),
              value: switch2,
              onChanged: (bool value) => toggleSwitch(2),
            ),
            SwitchListTile(
              title: Text("Switch 3"),
              value: switch3,
              onChanged: (bool value) => toggleSwitch(3),
            ),
          ],
        ),
      ),
    );
  }
}

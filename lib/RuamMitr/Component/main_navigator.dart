import 'package:flutter/material.dart';
import 'dart:math';

class MainNavigator extends StatelessWidget {
  MainNavigator({super.key});
  String _selectedPage = "home";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ThemeData theme = Theme.of(context);

    return Container(
      height: [size.width * 0.4, 100.0].reduce(min),
      width: size.width,
      color: Colors.grey[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(
            child: RawMaterialButton(
              shape: const CircleBorder(),
              constraints: BoxConstraints.tight(
                Size(
                  [size.width * 0.3, 90.0].reduce(min),
                  [size.width * 0.3, 90.0].reduce(min),
                ),
              ),
              onPressed: () {
                _selectedPage = "profile";
              },
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person,
                    size: 30,
                  ),
                  Text(
                    "Profile",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            child: RawMaterialButton(
              shape: CircleBorder(
                side: BorderSide(
                  color: Colors.red[700] ?? const Color.fromRGBO(211, 47, 47, 1),
                  width: 5,
                ),
              ),
              fillColor: Colors.red,
              constraints: BoxConstraints.tight(
                Size(
                  [size.width * 0.3, 90.0].reduce(min),
                  [size.width * 0.3, 90.0].reduce(min),
                ),
              ),
              onPressed: () {
                _selectedPage = "home";
              },
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.home,
                    size: 30,
                    color: Colors.white,
                  ),
                  Text(
                    "Home",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            child: RawMaterialButton(
              shape: const CircleBorder(),
              constraints: BoxConstraints.tight(
                Size(
                  [size.width * 0.3, 90.0].reduce(min),
                  [size.width * 0.3, 90.0].reduce(min),
                ),
              ),
              onPressed: () {
                _selectedPage = "settings";
              },
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.settings,
                    size: 30,
                  ),
                  Text(
                    "Settings",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

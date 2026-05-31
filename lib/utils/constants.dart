import 'package:flutter/material.dart';

Color primarycolor = Color(0xfffc3b77);

void goTo(BuildContext context, Widget nextScreen){
     Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  nextScreen,
                            ),
                          );
}
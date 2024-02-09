import 'dart:async';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:utente/home_page_view.dart';
import 'package:utente/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  int _tempo = 4;
  bool _animazione = false;
  bool _animazione1 = false;
  bool _animazione2 = false;
  bool _animazione3 = false;
  bool _animazione4 = false;
  bool _animazione5 = false;
  bool _animazione6 = false;
  bool _animazione7 = false;
  bool _animazione8 = false;
  bool _animazione9 = false;
  bool _animazione10 = false;

  _timer() {
    Timer(Duration(seconds: _tempo), () async {
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.fade, child: const HomePageView()));
    });
  }

  @override
  void initState() {
    super.initState();
    _timer();

    Future.delayed(const Duration(milliseconds: 1000),
        (() => mounted ? setState(() => _animazione = true) : null));
    Future.delayed(const Duration(milliseconds: 1200),
        (() => mounted ? setState(() => _animazione1 = true) : null));
    Future.delayed(const Duration(milliseconds: 1650),
        (() => mounted ? setState(() => _animazione2 = true) : null));
    Future.delayed(const Duration(milliseconds: 1450),
        (() => mounted ? setState(() => _animazione3 = true) : null));
    Future.delayed(const Duration(milliseconds: 1950),
        (() => mounted ? setState(() => _animazione4 = true) : null));
    Future.delayed(const Duration(milliseconds: 2150),
        (() => mounted ? setState(() => _animazione5 = true) : null));
    Future.delayed(const Duration(milliseconds: 2450),
        (() => mounted ? setState(() => _animazione6 = true) : null));
    Future.delayed(const Duration(milliseconds: 2250),
        (() => mounted ? setState(() => _animazione7 = true) : null));
    Future.delayed(const Duration(milliseconds: 3000),
        (() => mounted ? setState(() => _animazione8 = true) : null));
    Future.delayed(const Duration(milliseconds: 3300),
        (() => mounted ? setState(() => _animazione9 = true) : null));
    Future.delayed(const Duration(milliseconds: 900),
        (() => mounted ? setState(() => _animazione10 = true) : null));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: AnimatedContainer(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: RadialGradient(
                center: Alignment.bottomCenter,
                radius: 0.8,
                colors: [
                  !_animazione ? Colors.brown : const Color(0xFF87b837),
                  !_animazione ? Colors.grey : Colors.blue,
                ],
                stops: const [
                  0.99,
                  1
                ]),
          ),
          duration: Duration(seconds: _tempo),
          child: Stack(children: [
            Positioned(
              left: MediaQuery.of(context).size.width - 370,
              bottom: 275,
              child: Image.asset(
                'assets/trunk.png',
                filterQuality: FilterQuality.high,
                fit: BoxFit.none,
                scale: 1.5,
              ),
            ),
            Positioned(
              left: MediaQuery.of(context).size.width - 335,
              bottom: 400,
              child: Container(
                width: 125,
                height: 125,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topRight,
                    radius: 1.5,
                    colors: [
                      !_animazione1 ? Colors.transparent : Colors.white,
                      !_animazione1
                          ? Colors.transparent
                          : const Color(0xFF87b837)
                    ],
                  ),
                  borderRadius: BorderRadius.circular(125),
                  boxShadow: [
                    BoxShadow(
                        color:
                            !_animazione1 ? Colors.transparent : Colors.black38,
                        spreadRadius: 0,
                        blurRadius: 10),
                  ],
                ),
              ),
            ),
            Positioned(
              left: MediaQuery.of(context).size.width - 360,
              bottom: 525,
              child: Container(
                width: 125,
                height: 125,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topRight,
                    radius: 1.5,
                    colors: [
                      !_animazione2 ? Colors.transparent : Colors.white,
                      !_animazione2
                          ? Colors.transparent
                          : const Color(0xFF87b837)
                    ],
                  ),
                  borderRadius: BorderRadius.circular(125),
                  boxShadow: [
                    BoxShadow(
                        color:
                            !_animazione2 ? Colors.transparent : Colors.black38,
                        spreadRadius: 0,
                        blurRadius: 10),
                  ],
                ),
              ),
            ),
            Positioned(
              left: MediaQuery.of(context).size.width - 260,
              bottom: 585,
              child: Container(
                width: 125,
                height: 125,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topRight,
                    radius: 1.5,
                    colors: [
                      !_animazione3 ? Colors.transparent : Colors.white,
                      !_animazione3
                          ? Colors.transparent
                          : const Color(0xFF87b837)
                    ],
                  ),
                  borderRadius: BorderRadius.circular(125),
                  boxShadow: [
                    BoxShadow(
                        color:
                            !_animazione3 ? Colors.transparent : Colors.black38,
                        spreadRadius: 0,
                        blurRadius: 10),
                  ],
                ),
              ),
            ),
            Positioned(
              left: MediaQuery.of(context).size.width - 155,
              bottom: 525,
              child: Container(
                width: 125,
                height: 125,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topRight,
                    radius: 1.5,
                    colors: [
                      !_animazione4 ? Colors.transparent : Colors.white,
                      !_animazione4
                          ? Colors.transparent
                          : const Color(0xFF87b837)
                    ],
                  ),
                  borderRadius: BorderRadius.circular(125),
                  boxShadow: [
                    BoxShadow(
                        color:
                            !_animazione4 ? Colors.transparent : Colors.black38,
                        spreadRadius: 0,
                        blurRadius: 10),
                  ],
                ),
              ),
            ),
            Positioned(
              left: MediaQuery.of(context).size.width - 170,
              bottom: 400,
              child: Container(
                width: 125,
                height: 125,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topRight,
                    radius: 1.5,
                    colors: [
                      !_animazione5 ? Colors.transparent : Colors.white,
                      !_animazione5
                          ? Colors.transparent
                          : const Color(0xFF87b837)
                    ],
                  ),
                  borderRadius: BorderRadius.circular(125),
                  boxShadow: [
                    BoxShadow(
                        color:
                            !_animazione5 ? Colors.transparent : Colors.black38,
                        spreadRadius: 0,
                        blurRadius: 10),
                  ],
                ),
              ),
            ),
            Positioned(
              left: MediaQuery.of(context).size.width - 380,
              bottom: 460,
              child: Container(
                width: 125,
                height: 125,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topRight,
                    radius: 1.5,
                    colors: [
                      !_animazione6 ? Colors.transparent : Colors.white,
                      !_animazione6
                          ? Colors.transparent
                          : const Color(0xFF87b837)
                    ],
                  ),
                  borderRadius: BorderRadius.circular(125),
                  boxShadow: [
                    BoxShadow(
                        color:
                            !_animazione6 ? Colors.transparent : Colors.black38,
                        spreadRadius: 0,
                        blurRadius: 10),
                  ],
                ),
              ),
            ),
            Positioned(
              left: MediaQuery.of(context).size.width - 310,
              bottom: 550,
              child: Container(
                width: 125,
                height: 125,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topRight,
                    radius: 1.5,
                    colors: [
                      !_animazione7 ? Colors.transparent : Colors.white,
                      !_animazione7
                          ? Colors.transparent
                          : const Color(0xFF87b837)
                    ],
                  ),
                  borderRadius: BorderRadius.circular(125),
                  boxShadow: [
                    BoxShadow(
                        color:
                            !_animazione7 ? Colors.transparent : Colors.black38,
                        spreadRadius: 0,
                        blurRadius: 10),
                  ],
                ),
              ),
            ),
            Positioned(
              left: MediaQuery.of(context).size.width - 200,
              bottom: 540,
              child: Container(
                width: 125,
                height: 125,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topRight,
                    radius: 1.5,
                    colors: [
                      !_animazione8 ? Colors.transparent : Colors.white,
                      !_animazione8
                          ? Colors.transparent
                          : const Color(0xFF87b837)
                    ],
                  ),
                  borderRadius: BorderRadius.circular(125),
                  boxShadow: [
                    BoxShadow(
                        color:
                            !_animazione8 ? Colors.transparent : Colors.black38,
                        spreadRadius: 0,
                        blurRadius: 10),
                  ],
                ),
              ),
            ),
            Positioned(
              left: MediaQuery.of(context).size.width - 140,
              bottom: 455,
              child: Container(
                width: 125,
                height: 125,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topRight,
                    radius: 1.5,
                    colors: [
                      !_animazione9 ? Colors.transparent : Colors.white,
                      !_animazione9
                          ? Colors.transparent
                          : const Color(0xFF87b837)
                    ],
                  ),
                  borderRadius: BorderRadius.circular(125),
                  boxShadow: [
                    BoxShadow(
                        color:
                            !_animazione9 ? Colors.transparent : Colors.black38,
                        spreadRadius: 0,
                        blurRadius: 10),
                  ],
                ),
              ),
            ),
            Positioned(
              left: MediaQuery.of(context).size.width - 260,
              bottom: 460,
              child: Container(
                width: 125,
                height: 125,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topRight,
                    radius: 1.5,
                    colors: [
                      !_animazione10 ? Colors.transparent : Colors.white,
                      !_animazione10
                          ? Colors.transparent
                          : const Color(0xFF87b837)
                    ],
                  ),
                  borderRadius: BorderRadius.circular(125),
                  boxShadow: [
                    BoxShadow(
                        color: !_animazione10
                            ? Colors.transparent
                            : Colors.black38,
                        spreadRadius: 0,
                        blurRadius: 10),
                  ],
                ),
              ),
            ),
          ])),
    );
  }
}

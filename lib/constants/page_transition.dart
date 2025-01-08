import 'package:flutter/material.dart';

class RightToLeftTransition<T> extends PageRouteBuilder<T> {
  final Widget page;

  RightToLeftTransition({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Define the animation curve and offsets for both incoming and outgoing pages
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            // Animation for the incoming page (slide in from the right)
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            // Animation for the outgoing page (slide out to the left)
            var beginExit = Offset.zero;
            var endExit = const Offset(
                -0.1, 0.0); // Slightly reduce the exit offset for smoother feel
            var tweenExit = Tween(begin: beginExit, end: endExit)
                .chain(CurveTween(curve: curve));
            var offsetAnimationExit = secondaryAnimation.drive(tweenExit);

            return Stack(
              children: [
                // Outgoing page with slight fade out and delay
                SlideTransition(
                  position: offsetAnimationExit,
                  child: FadeTransition(
                    opacity: secondaryAnimation,
                    child: Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: context
                              .findAncestorWidgetOfExactType<MaterialApp>()
                              ?.home ??
                          const SizedBox.shrink(),
                    ),
                  ),
                ),
                // Incoming page with opacity fade and smooth transition
                SlideTransition(
                  position: offsetAnimation,
                  child: FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                ),
              ],
            );
          },
          transitionDuration: const Duration(
              milliseconds:
                  500), // Increased duration for a smoother transition
          reverseTransitionDuration:
              const Duration(milliseconds: 500), // Matching reverse duration
        );
}
